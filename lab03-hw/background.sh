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

# ── Download/view helper (serves the HW dir over the Killercoda traffic port) ─
cat > /home/student/view-reports.sh << 'EOF'
#!/bin/bash
pkill -f "http.server 8080" 2>/dev/null || true
cd ~/labs/lab03/HW || exit 1
python3 -m http.server 8080 >/dev/null 2>&1 &
echo "Files served. Open the link shown in the step instructions (port 8080)."
EOF
chmod +x /home/student/view-reports.sh
chown student:student /home/student/view-reports.sh

touch /tmp/setup_done
