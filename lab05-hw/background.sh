#!/bin/bash
set -e

RAW=https://raw.githubusercontent.com/PotapenkoEugene/LabsGenomics_lab00_killercoda/main/lab05-data

# ── Install micromamba ───────────────────────────────────────────────────────
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \
  | tar -xj bin/micromamba
mv bin/micromamba /usr/local/bin/micromamba && rmdir bin
chmod +x /usr/local/bin/micromamba

export MAMBA_ROOT_PREFIX=/opt/micromamba

# ── Create bio environment ───────────────────────────────────────────────────
micromamba create -y -n bio -c bioconda -c conda-forge \
  seqkit fastqc 2>&1 | tail -3

# ── Create student user ──────────────────────────────────────────────────────
id student 2>/dev/null || useradd -m -s /bin/bash student
echo "student:student" | chpasswd

# ── Student shell setup ──────────────────────────────────────────────────────
cat >> /home/student/.bashrc << 'EOF'
export MAMBA_ROOT_PREFIX=/opt/micromamba
eval "$(micromamba shell hook -s bash)"
micromamba activate bio
EOF

cat > /home/student/.bash_profile << 'EOF'
[ -f ~/.bashrc ] && source ~/.bashrc
EOF

chown student:student /home/student/.bashrc /home/student/.bash_profile

# ── Stage source files at the HW's literal `cp` path ────────────────────────
# HW Task A: cp /home/evgenip/labs/lab05/HW/sample* ~/labs/lab05/HW/
mkdir -p /home/evgenip/labs/lab05/HW
for f in sample1 sample2 sample3 sample4; do
  wget -q "$RAW/${f}.fastq.gz" -O "/home/evgenip/labs/lab05/HW/${f}.fastq.gz"
done
chmod -R a+rX /home/evgenip

# ── No pre-staged workspace: student starts in ~ and builds ~/labs/lab05/HW
#    themselves via `mkdir -p` + `cd`, exactly as the HW's Pre-Task says. ───────

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
cd ~/labs/lab05/HW || exit 1
python3 ~/.dl_server.py 8080 >/dev/null 2>&1 &
echo "Files served. Open the link shown in the step instructions (port 8080) — files download; .html reports open in the browser."
EOF
chmod +x /home/student/view-reports.sh
chown student:student /home/student/view-reports.sh

# ── Instructor self-test (hidden dotfile, not mentioned to students) ───────
# Runs the full HW pipeline in an isolated scratch dir to confirm the
# environment actually works. Run manually after boot: ~/.verify-hw.sh
cat > /home/student/.verify-hw.sh << 'SELFTEST'
#!/bin/bash
# Instructor self-test — NOT part of the homework, not mentioned to students.
# Runs the full Lab 05 HW pipeline in an isolated scratch dir to confirm the
# environment actually works end-to-end. Run manually: ~/.verify-hw.sh
set -uo pipefail
D=~/.selftest/lab05
rm -rf "$D"; mkdir -p "$D"; cd "$D" || exit 1

FAIL=0
check() { if [ "$1" -eq 0 ]; then echo "  OK  $2"; else echo "FAIL  $2"; FAIL=1; fi; }

echo "SELFTEST" > answers.txt

cp /home/evgenip/labs/lab05/HW/sample* .
check $? "cp staged samples from /home/evgenip/..."

fastqc sample* >/dev/null 2>&1
check $? "fastqc"

for i in 1 2 3 4; do
  SZ=$(ls -lh "sample${i}.fastq.gz" 2>/dev/null | awk '{print $5}')
  STATS=$(seqkit stats -aT "sample${i}.fastq.gz" 2>/dev/null | awk 'NR==2{print $4","$18}')
  echo "sample${i},${SZ},${STATS},PASS" >> answers.txt
done

LINES=$(wc -l < answers.txt)
[ "$LINES" -ge 5 ]; check $? "answers.txt >= 5 lines (got $LINES)"
for i in 1 2 3 4; do
  [ -f "sample${i}.fastq.gz" ]; check $? "sample${i}.fastq.gz exists"
  [ -f "sample${i}_fastqc.html" ]; check $? "sample${i}_fastqc.html exists"
done

echo "--- answers.txt ---"
cat answers.txt
echo "-------------------"
echo "(Note: this ran in $D, not ~/labs/lab05/HW — it proves the pipeline"
echo " works, it is not the same check as Killercoda's Check button. GC%"
echo " field is auto-filled from seqkit, VERDICT is hardcoded PASS — read"
echo " the actual FastQC HTML for the real Per-base-quality verdict.)"
[ "$FAIL" -eq 0 ] && echo "=== SELFTEST PASSED ===" || echo "=== SELFTEST FAILED ==="
SELFTEST
chmod 700 /home/student/.verify-hw.sh
chown student:student /home/student/.verify-hw.sh

touch /tmp/setup_done
