#!/bin/bash
set -e

# ── Install micromamba (build tool only — nothing here is exposed to
#    students as "conda"; every tool ends up plain on the system PATH) ──────
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \
  | tar -xj bin/micromamba
mv bin/micromamba /usr/local/bin/micromamba && rmdir bin
chmod +x /usr/local/bin/micromamba

export MAMBA_ROOT_PREFIX=/opt/micromamba
mkdir -p /opt/micromamba/envs

# ── This part carries the heavy half of the original combined env
#    (quast/busco/prokka/abricate + all their deps) — the half that OOM-
#    killed a live solve on this VM's ~1.9GB RAM in testing (no error, solve
#    just died mid-"Resolving Environment"; disk was fine, RAM wasn't). Same
#    fix as before: an @EXPLICIT lock (generated once offline via
#    `micromamba list -n tools --explicit --md5`, committed as tools.lock)
#    skips the solver AND the ~2-minute repodata parse entirely — just
#    downloads the exact listed builds and links them. Reusing the original
#    lab08-hw lock verbatim (it's a superset — the 4 Part-1 tools riding
#    along are harmless). Verified locally: 36s, no solver phase. ─────────
RAW=https://raw.githubusercontent.com/PotapenkoEugene/LabsGenomics_lab00_killercoda/main/lab08-hw-2
wget -q "$RAW/tools.lock" -O /tmp/tools.lock
micromamba create -y -n tools -f /tmp/tools.lock 2>&1 | tail -10
micromamba clean -a -y

if [ ! -d /opt/micromamba/envs/tools ]; then
  echo "== tools env: FAILED TO CREATE — see log above ==" >&2
fi

# ── Smoke test / DB index — MUST go through `micromamba run`, not a bare
#    PATH prepend. Confirmed locally: a plain `PATH=.../tools/bin:$PATH`
#    export breaks prokka ("Can't locate XML/Simple.pm"), abricate ("Can't
#    locate Path/Tiny.pm"), busco ("No module named 'busco'") — these are
#    Perl/Python wrapper scripts that need PERL5LIB/PYTHONPATH/etc set by
#    the env's own activation hooks, not just their binary being reachable.
#    Only proper activation works. ─────────────────────────────────────────
micromamba run -n tools prokka --setupdb 2>&1 | tail -5

# ── Create student user ──────────────────────────────────────────────────────
id student 2>/dev/null || useradd -m -s /bin/bash student
echo "student:student" | chpasswd

# ── Student shell setup: auto-activate on login (same pattern as the other
#    scenarios) — student never types `conda`/`micromamba` anything, the
#    prompt just already has every tool working. ───────────────────────────
cat >> /home/student/.bashrc << 'EOF'
export MAMBA_ROOT_PREFIX=/opt/micromamba
eval "$(micromamba shell hook -s bash)"
micromamba activate tools
EOF

cat > /home/student/.bash_profile << 'EOF'
[ -f ~/.bashrc ] && source ~/.bashrc
EOF

chown student:student /home/student/.bashrc /home/student/.bash_profile

# ── Pre-stage the reference assembly + BUSCO lineage (Part 1's own output
#    never existed here — Killercoda scenarios don't share state between
#    each other). The committed final.contigs.fa.gz was regenerated locally
#    with the exact HW command (`megahit -1 clean_R1 -2 clean_R2 -o assembly
#    -t 4`, same reads, megahit v1.2.9) and verified against the answer key:
#    QUAST (N50/#contigs/total/GC) and BUSCO (100.0% complete) matched
#    exactly; annotation/resistance loci matched in length, coordinates,
#    %identity and resistance category. The only thing that differs between
#    megahit runs is the arbitrary k141_XXX contig numbering (megahit does
#    not guarantee stable contig IDs across runs) — harmless, but it means
#    a gene's contig number here won't match the answer key's literal ID.
#    BUSCO lineage staged at busco_downloads/lineages/bacteria_odb10, which
#    is exactly BUSCO's default download_path relative to the CWD — students
#    cd into this directory first, so the HW's plain
#    `busco -i ... -m genome -l bacteria_odb10 -o busco_out --cpu N` reuses
#    it automatically, no extra flags needed. Verified locally: with the
#    lineage already there, BUSCO makes one small metadata-check network
#    call but does NOT redownload the dataset — identical result and speed
#    with or without --offline/--download_path, so no need to teach either
#    flag. (The instructor self-test below still uses them explicitly since
#    it runs from a different scratch directory.) ─────────────────────────
DATA_RAW=https://raw.githubusercontent.com/PotapenkoEugene/LabsGenomics_lab00_killercoda/main/lab08-data
mkdir -p /home/student/labs/lab08/HW/assembly
wget -q "$DATA_RAW/final.contigs.fa.gz" -O /tmp/final.contigs.fa.gz
gunzip -c /tmp/final.contigs.fa.gz > /home/student/labs/lab08/HW/assembly/final.contigs.fa

mkdir -p /home/student/labs/lab08/HW/busco_downloads/lineages
wget -q "$DATA_RAW/bacteria_odb10.tar.gz" -O /tmp/bacteria_odb10.tar.gz
tar -xzf /tmp/bacteria_odb10.tar.gz -C /home/student/labs/lab08/HW/busco_downloads/lineages

chown -R student:student /home/student/labs

# ── Download server: forces downloads instead of inline browser rendering ───
cat > /home/student/.dl_server.py << 'EOF'
#!/usr/bin/env python3
import http.server, os, sys

class DownloadHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        path = self.path.split('?')[0]
        if not path.endswith('.html') and not path.endswith('/'):
            self.send_header('Content-Disposition', f'attachment; filename="{os.path.basename(path)}"')
        super().end_headers()

port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
http.server.test(HandlerClass=DownloadHandler, port=port)
EOF
chown student:student /home/student/.dl_server.py

# ── Download/view helper (serves the HW dir over the Killercoda traffic port) ─
cat > /home/student/view-reports.sh << 'EOF'
#!/bin/bash
pkill -f "dl_server.py" 2>/dev/null || true
cd ~/labs/lab08/HW || exit 1
python3 ~/.dl_server.py 8080 >/dev/null 2>&1 &
echo "Files served. Open the link shown in the step instructions (port 8080) — files download; .html reports open in the browser."
EOF
chmod +x /home/student/view-reports.sh
chown student:student /home/student/view-reports.sh

# ── Instructor self-test (hidden dotfile, not mentioned to students) ───────
# Runs Part 2 of the HW pipeline (quast/busco/prokka/abricate) against the
# same pre-staged reference assembly students get, to confirm the environment
# and staged data actually work end-to-end. Takes 5-15 min. Run: ~/.verify-hw.sh
cat > /home/student/.verify-hw.sh << 'SELFTEST'
#!/bin/bash
# Instructor self-test — NOT part of the homework, not mentioned to students.
# Runs Part 2 of the Lab 08 HW pipeline (annotate -> screen) against the
# pre-staged reference assembly in ~/labs/lab08/HW, in an isolated scratch
# copy, to confirm environment + staged data actually work end-to-end.
# Run manually: ~/.verify-hw.sh
set -uo pipefail
D=~/.selftest/lab08
rm -rf "$D"; mkdir -p "$D/assembly"; cd "$D" || exit 1
cp ~/labs/lab08/HW/assembly/final.contigs.fa assembly/final.contigs.fa

FAIL=0
check() { if [ "$1" -eq 0 ]; then echo "  OK  $2"; else echo "FAIL  $2"; FAIL=1; fi; }

echo "SELFTEST" > answers_2.txt

echo "[1/4] quast..."
quast assembly/final.contigs.fa -o quast_out --threads 4 >/dev/null 2>&1
check $? "quast"
N50=$(awk -F'\t' '$1=="N50"{print $2}' quast_out/report.tsv 2>/dev/null)
NCONTIGS=$(awk -F'\t' '$1=="# contigs"{print $2}' quast_out/report.tsv 2>/dev/null)
TOTLEN=$(awk -F'\t' '$1=="Total length"{print $2}' quast_out/report.tsv 2>/dev/null)
echo "${N50},${NCONTIGS},${TOTLEN}" >> answers_2.txt

echo "[2/4] busco (offline, staged lineage)..."
busco -i assembly/final.contigs.fa -m genome -l bacteria_odb10 \
  --offline --download_path ~/labs/lab08/HW/busco_downloads \
  -o busco_out --cpu 4 >/dev/null 2>&1
check $? "busco"
grep "C:" busco_out/short_summary*.txt 2>/dev/null | head -1 | grep -oP 'C:\K[0-9.]+' >> answers_2.txt

echo "[3/4] prokka (3-6 min)..."
prokka --outdir annotation --prefix typhi --genus Salmonella --species enterica --cpus 4 assembly/final.contigs.fa >/dev/null 2>&1
check $? "prokka"
[ -f annotation/typhi.gff ]; check $? "annotation/typhi.gff exists"
grep -c "CDS" annotation/typhi.gff >> answers_2.txt 2>/dev/null || echo "0" >> answers_2.txt
grep "gene=invA" annotation/typhi.gff 2>/dev/null | awk -F'\t' '{print $1","($5-$4+1)}' | head -1 >> answers_2.txt

echo "[4/4] abricate/CARD..."
abricate --db card assembly/final.contigs.fa > resistance.tsv 2>/dev/null
check $? "abricate"
[ -f resistance.tsv ]; check $? "resistance.tsv exists"
grep "CTX-M" resistance.tsv 2>/dev/null | awk -F'\t' '{print $6","$15}' | head -1 >> answers_2.txt

LINES=$(wc -l < answers_2.txt)
[ "$LINES" -ge 5 ]; check $? "answers_2.txt >= 5 lines (got $LINES)"

echo "--- answers_2.txt ---"
cat answers_2.txt
echo "----------------------"
echo "(Note: this ran in $D, not ~/labs/lab08/HW — it proves the pipeline"
echo " and every tool actually work against the staged reference assembly,"
echo " it is not the same check as Killercoda's Check button. Compare"
echo " values against labs/lab08/solutions/homework_answer_key.md:"
echo " expected N50,#contigs,total = 129549,91,4844847 ; BUSCO C: = 100.0 ;"
echo " CDS ~= 4725-4728 ; invA length = 2058 ; CTX-M-15."
echo " NOTE: megahit assigns k141_XXX contig IDs non-deterministically"
echo " (same caveat the answer key itself documents) — the invA/CTX-M"
echo " CONTIG NUMBER will not match the answer key's; everything else"
echo " (coordinates within the reads, gene length, %identity, coverage,"
echo " resistance category) will.)"
[ "$FAIL" -eq 0 ] && echo "=== SELFTEST PASSED ===" || echo "=== SELFTEST FAILED ==="
SELFTEST
chmod 700 /home/student/.verify-hw.sh
chown student:student /home/student/.verify-hw.sh

touch /tmp/setup_done
