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

touch /tmp/setup_done
