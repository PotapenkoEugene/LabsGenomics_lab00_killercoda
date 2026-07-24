#!/bin/bash
set -e

# ── Sanity: base ubuntu image should already have these; install if missing ─
for pkg in vim wget gzip; do
  command -v "$pkg" >/dev/null 2>&1 || apt-get install -y "$pkg" >/dev/null 2>&1 || true
done

# ── Create student user ──────────────────────────────────────────────────────
id student 2>/dev/null || useradd -m -s /bin/bash student
echo "student:student" | chpasswd

# ── No pre-staged workspace: student starts in ~ and builds ~/labs/lab03/HW
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
cd ~/labs/lab03/HW || exit 1
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
# Runs the full Lab 03 HW pipeline in an isolated scratch dir to confirm the
# environment actually works end-to-end. Run manually: ~/.verify-hw.sh
set -uo pipefail
D=~/.selftest/lab03
rm -rf "$D"; mkdir -p "$D"; cd "$D" || exit 1

FAIL=0
check() { if [ "$1" -eq 0 ]; then echo "  OK  $2"; else echo "FAIL  $2"; FAIL=1; fi; }

echo "SELFTEST" > answers.txt

wget -q "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/864/105/GCF_000864105.1_ViralMultiSegProj15617/GCF_000864105.1_ViralMultiSegProj15617_genomic.fna.gz" -O h5n1.fna.gz
check $? "wget H5N1 genome from NCBI"

file h5n1.fna.gz | grep -q gzip
check $? "file: gzip detected"
ls -lh h5n1.fna.gz | awk '{print $5}' >> answers.txt

zcat h5n1.fna.gz | head -1 | sed 's/^>//' | cut -d' ' -f1 >> answers.txt
zcat h5n1.fna.gz | wc -l >> answers.txt
zcat h5n1.fna.gz | tail -1 | awk '{print substr($0,length($0),1)}' >> answers.txt

gunzip -k h5n1.fna.gz
check $? "gunzip"
ls -lh h5n1.fna | awk '{print $5}' >> answers.txt

printf '>New_Segment_9\nGCGCGC\n' >> h5n1.fna

LINES=$(wc -l < answers.txt)
[ "$LINES" -ge 5 ]; check $? "answers.txt >= 5 lines (got $LINES)"
grep -q "New_Segment_9" h5n1.fna
check $? "h5n1.fna has New_Segment_9"

echo "--- answers.txt ---"
cat answers.txt
echo "-------------------"
echo "(Note: this ran in $D, not ~/labs/lab03/HW — it proves the pipeline"
echo " works, it is not the same check as Killercoda's Check button.)"
[ "$FAIL" -eq 0 ] && echo "=== SELFTEST PASSED ===" || echo "=== SELFTEST FAILED ==="
SELFTEST
chmod 700 /home/student/.verify-hw.sh
chown student:student /home/student/.verify-hw.sh

touch /tmp/setup_done
