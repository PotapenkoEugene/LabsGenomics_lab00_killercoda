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

# ── Pre-staged BUSCO lineage only (reads are NOT staged — HW downloads them
#    live from ENA in Part 2A, so that step stays exactly as written). The
#    student still builds ~/labs/lab08/HW themselves via mkdir -p / cd, same
#    as the HW's Pre-Task — this only pre-seeds busco_downloads/ inside it,
#    so the terminal does NOT start already positioned there. ──────────────
mkdir -p /home/student/labs/lab08/HW
( cd /home/student/labs/lab08/HW && micromamba run -n tools busco --download bacteria_odb10 2>&1 | tail -5 )
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

touch /tmp/setup_done
