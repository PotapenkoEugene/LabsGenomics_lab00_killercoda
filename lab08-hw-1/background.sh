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

# ── Live solve for just the 4 light tools this part needs. The original
#    combined lab08-hw env (8 tools: this + quast/busco/prokka/abricate) got
#    OOM-killed mid-solve on this VM's ~1.9GB RAM (see lab08-hw-2/background.sh
#    for the @EXPLICIT-lock fix that part still needs). A 4-package solve is
#    the same size class as lab06-multiqc's proven 5-tool live solve, so no
#    lock file needed here. ──────────────────────────────────────────────────
micromamba create -y -n tools -c bioconda -c conda-forge \
  fastqc fastp seqkit megahit 2>&1 | tail -10
micromamba clean -a -y

if [ ! -d /opt/micromamba/envs/tools ]; then
  echo "== tools env: FAILED TO CREATE — see log above ==" >&2
fi

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

# ── No pre-staged workspace: student builds ~/labs/lab08/HW themselves via
#    `mkdir -p` + `cd`, exactly as the HW's Pre-Task says. ─────────────────

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
# Runs Part 1 of the HW pipeline (download -> QC -> trim -> assemble) in an
# isolated scratch dir to confirm the environment actually works. Takes
# 5-10 min (megahit is the only slow step here). Run after boot: ~/.verify-hw.sh
cat > /home/student/.verify-hw.sh << 'SELFTEST'
#!/bin/bash
# Instructor self-test — NOT part of the homework, not mentioned to students.
# Runs Part 1 of the Lab 08 HW pipeline (download -> QC -> trim -> assemble)
# in an isolated scratch dir to confirm the environment actually works.
# Run manually: ~/.verify-hw.sh
set -uo pipefail
D=~/.selftest/lab08
rm -rf "$D"; mkdir -p "$D"; cd "$D" || exit 1

FAIL=0
check() { if [ "$1" -eq 0 ]; then echo "  OK  $2"; else echo "FAIL  $2"; FAIL=1; fi; }

echo "SELFTEST" > answers_1.txt

echo "[1/4] downloading reads from ENA..."
wget -q https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR128/006/SRR12823506/SRR12823506_1.fastq.gz -O reads_R1.fastq.gz
wget -q https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR128/006/SRR12823506/SRR12823506_2.fastq.gz -O reads_R2.fastq.gz
check $? "wget ENA reads"
ls -lh reads_R1.fastq.gz | awk '{print $5}' >> answers_1.txt

echo "[2/4] fastqc..."
fastqc reads_R1.fastq.gz reads_R2.fastq.gz >/dev/null 2>&1
check $? "fastqc"

echo "[3/4] fastp trim..."
BEFORE=$(seqkit stats -aT reads_R1.fastq.gz | awk 'NR==2{print $4}')
fastp -i reads_R1.fastq.gz -I reads_R2.fastq.gz -o clean_R1.fastq.gz -O clean_R2.fastq.gz >/dev/null 2>&1
check $? "fastp"
AFTER=$(seqkit stats -aT clean_R1.fastq.gz | awk 'NR==2{print $4}')
echo "${BEFORE},${AFTER}" >> answers_1.txt

echo "[4/4] megahit assembly (3-6 min)..."
rm -rf assembly
megahit -1 clean_R1.fastq.gz -2 clean_R2.fastq.gz -o assembly -t 4 >/dev/null 2>&1
check $? "megahit"
[ -f assembly/final.contigs.fa ]; check $? "assembly/final.contigs.fa exists"

LINES=$(wc -l < answers_1.txt)
[ "$LINES" -ge 3 ]; check $? "answers_1.txt >= 3 lines (got $LINES)"

echo "--- answers_1.txt ---"
cat answers_1.txt
echo "----------------------"
echo "(Note: this ran in $D, not ~/labs/lab08/HW — it proves the pipeline"
echo " and every tool actually work, it is not the same check as"
echo " Killercoda's Check button. Compare values against"
echo " labs/lab08/solutions/homework_answer_key.md.)"
[ "$FAIL" -eq 0 ] && echo "=== SELFTEST PASSED ===" || echo "=== SELFTEST FAILED ==="
SELFTEST
chmod 700 /home/student/.verify-hw.sh
chown student:student /home/student/.verify-hw.sh

touch /tmp/setup_done
