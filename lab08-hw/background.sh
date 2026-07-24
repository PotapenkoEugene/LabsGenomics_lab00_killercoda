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

# ── One combined env for all 8 tools, built from a pre-resolved @EXPLICIT
#    lock file — NOT a live solve. A real run's background log
#    (/var/log/killercoda/background0_stdout.log) showed the live solve
#    dying silently mid-"Resolving Environment" (no Transaction finished,
#    no error — a bare `df -h` on that same VM showed 13GB free, ruling out
#    disk; /dev/shm at ~950MB implies only ~1.9GB RAM, so a combined 8-
#    package cross-channel solve under --strict-channel-priority almost
#    certainly got OOM-killed by the kernel). An @EXPLICIT lock (generated
#    once offline via `micromamba list -n tools --explicit --md5`, committed
#    as tools.lock) skips the solver AND the ~2-minute repodata parse
#    entirely — just downloads the exact listed builds and links them.
#    Verified locally: 36s, no solver phase, all 8 tools still work. ───────
RAW=https://raw.githubusercontent.com/PotapenkoEugene/LabsGenomics_lab00_killercoda/main/lab08-hw
wget -q "$RAW/tools.lock" -O /tmp/tools.lock
micromamba create -y -n tools -f /tmp/tools.lock 2>&1 | tail -10
micromamba clean -a -y

if [ ! -d /opt/micromamba/envs/tools ]; then
  echo "== tools env: FAILED TO CREATE — see log above ==" >&2
fi

# ── Smoke test / DB index — MUST go through `micromamba run`, not a bare
#    PATH prepend. Confirmed locally: a plain `PATH=.../tools/bin:$PATH`
#    export breaks prokka ("Can't locate XML/Simple.pm"), abricate ("Can't
#    locate Path/Tiny.pm"), busco ("No module named 'busco'"), and even
#    fastqc ("Can't exec java") — these are Perl/Python wrapper scripts that
#    need PERL5LIB/PYTHONPATH/etc set by the env's own activation hooks, not
#    just their binary being reachable. Only proper activation works. ──────
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

# ── No pre-staged workspace or BUSCO lineage: student builds ~/labs/lab08/HW
#    themselves via `mkdir -p` + `cd`, exactly as the HW's Pre-Task says, and
#    BUSCO downloads bacteria_odb10 live during Part 4B — same as the HW. ──

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
# Runs the full HW pipeline in an isolated scratch dir to confirm the
# environment actually works. Takes 15-30 min. Run after boot: ~/.verify-hw.sh
cat > /home/student/.verify-hw.sh << 'SELFTEST'
#!/bin/bash
# Instructor self-test — NOT part of the homework, not mentioned to students.
# Runs the full Lab 08 HW pipeline (assemble -> annotate -> screen) in an
# isolated scratch dir to confirm the environment actually works end-to-end.
# Takes 15-30 minutes (megahit/busco/prokka are each a few minutes).
# Run manually: ~/.verify-hw.sh
set -uo pipefail
D=~/.selftest/lab08
rm -rf "$D"; mkdir -p "$D"; cd "$D" || exit 1

FAIL=0
check() { if [ "$1" -eq 0 ]; then echo "  OK  $2"; else echo "FAIL  $2"; FAIL=1; fi; }

echo "SELFTEST" > answers.txt

echo "[1/8] downloading reads from ENA..."
wget -q https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR128/006/SRR12823506/SRR12823506_1.fastq.gz -O reads_R1.fastq.gz
wget -q https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR128/006/SRR12823506/SRR12823506_2.fastq.gz -O reads_R2.fastq.gz
check $? "wget ENA reads"
ls -lh reads_R1.fastq.gz | awk '{print $5}' >> answers.txt

echo "[2/8] fastqc..."
fastqc reads_R1.fastq.gz reads_R2.fastq.gz >/dev/null 2>&1
check $? "fastqc"

echo "[3/8] fastp trim..."
BEFORE=$(seqkit stats -aT reads_R1.fastq.gz | awk 'NR==2{print $4}')
fastp -i reads_R1.fastq.gz -I reads_R2.fastq.gz -o clean_R1.fastq.gz -O clean_R2.fastq.gz >/dev/null 2>&1
check $? "fastp"
AFTER=$(seqkit stats -aT clean_R1.fastq.gz | awk 'NR==2{print $4}')
echo "${BEFORE},${AFTER}" >> answers.txt

echo "[4/8] megahit assembly (3-6 min)..."
rm -rf assembly
megahit -1 clean_R1.fastq.gz -2 clean_R2.fastq.gz -o assembly -t 4 >/dev/null 2>&1
check $? "megahit"
[ -f assembly/final.contigs.fa ]; check $? "assembly/final.contigs.fa exists"

echo "[5/8] quast..."
quast assembly/final.contigs.fa -o quast_out --threads 4 >/dev/null 2>&1
check $? "quast"
N50=$(awk -F'\t' '$1=="N50"{print $2}' quast_out/report.tsv 2>/dev/null)
NCONTIGS=$(awk -F'\t' '$1=="# contigs"{print $2}' quast_out/report.tsv 2>/dev/null)
TOTLEN=$(awk -F'\t' '$1=="Total length"{print $2}' quast_out/report.tsv 2>/dev/null)
echo "${N50},${NCONTIGS},${TOTLEN}" >> answers.txt

echo "[6/8] busco (3-8 min, downloads bacteria_odb10 live)..."
busco -i assembly/final.contigs.fa -m genome -l bacteria_odb10 -o busco_out --cpu 4 >/dev/null 2>&1
check $? "busco"
grep "C:" busco_out/short_summary*.txt 2>/dev/null | head -1 | grep -oP 'C:\K[0-9.]+' >> answers.txt

echo "[7/8] prokka (3-6 min)..."
prokka --outdir annotation --prefix typhi --genus Salmonella --species enterica --cpus 4 assembly/final.contigs.fa >/dev/null 2>&1
check $? "prokka"
[ -f annotation/typhi.gff ]; check $? "annotation/typhi.gff exists"
grep -c "CDS" annotation/typhi.gff >> answers.txt 2>/dev/null || echo "0" >> answers.txt
grep "gene=invA" annotation/typhi.gff 2>/dev/null | awk -F'\t' '{print $1","($5-$4+1)}' | head -1 >> answers.txt

echo "[8/8] abricate/CARD..."
abricate --db card assembly/final.contigs.fa > resistance.tsv 2>/dev/null
check $? "abricate"
[ -f resistance.tsv ]; check $? "resistance.tsv exists"
grep "CTX-M" resistance.tsv 2>/dev/null | awk -F'\t' '{print $6","$15}' | head -1 >> answers.txt

LINES=$(wc -l < answers.txt)
[ "$LINES" -ge 8 ]; check $? "answers.txt >= 8 lines (got $LINES)"

echo "--- answers.txt ---"
cat answers.txt
echo "-------------------"
echo "(Note: this ran in $D, not ~/labs/lab08/HW — it proves the pipeline"
echo " and every tool actually work, it is not the same check as"
echo " Killercoda's Check button. Compare values against"
echo " labs/lab08/solutions/homework_answer_key.md.)"
[ "$FAIL" -eq 0 ] && echo "=== SELFTEST PASSED ===" || echo "=== SELFTEST FAILED ==="
SELFTEST
chmod 700 /home/student/.verify-hw.sh
chown student:student /home/student/.verify-hw.sh

touch /tmp/setup_done
