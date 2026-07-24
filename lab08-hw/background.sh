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

# ── One combined env for all 8 tools instead of 4 separate ones + a live
#    student-side install. Measured locally: 5.97 GB unique bytes for all 8
#    together (one shared python/perl runtime, hardlinked deps) vs ~9.4 GB
#    for 4 separate envs + abricate created live — plus it removes the two
#    failure points hit on a real run: quast/busco/prokka silently missing
#    (disk exhaustion mid-sequence, masked by `| tail`) and the student's own
#    `conda create -n abricate -c bioconda abricate` failing to solve
#    (libgcc-ng/unzip unresolvable — micromamba has no implicit conda-forge
#    fallback the way real conda does). ──────────────────────────────────────
micromamba create -y -n tools -c conda-forge -c bioconda --strict-channel-priority \
  fastqc seqkit fastp megahit quast 'busco>=5.4' 'prokka=1.14.6' abricate 2>&1 | tail -10
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
