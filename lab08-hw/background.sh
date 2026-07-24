#!/bin/bash
set -e

# ── Install micromamba ───────────────────────────────────────────────────────
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \
  | tar -xj bin/micromamba
mv bin/micromamba /usr/local/bin/micromamba && rmdir bin
chmod +x /usr/local/bin/micromamba

export MAMBA_ROOT_PREFIX=/opt/micromamba
mkdir -p /opt/micromamba/envs

# ── Env creation: clean the package cache after EACH env (not just at the
#    end) to keep peak disk usage down — this VM's disk is tight and a failed
#    solve here is otherwise masked by `| tail`. Verify each env actually
#    landed on disk so a failure is at least visible in the boot log instead
#    of silently vanishing (this is exactly what happened before: bio was
#    created, quast/busco/prokka silently were not). ─────────────────────────
create_env() {
  local name="$1"; shift
  micromamba create -y -n "$name" -c conda-forge -c bioconda --strict-channel-priority "$@" 2>&1 | tail -5
  micromamba clean -a -y >/dev/null 2>&1
  if [ -d "/opt/micromamba/envs/$name" ]; then
    echo "== env $name: OK =="
  else
    echo "== env $name: FAILED TO CREATE — see log above ==" >&2
  fi
}

create_env bio fastqc seqkit fastp megahit
create_env quast quast
create_env busco 'busco>=5.4'
create_env prokka 'prokka=1.14.6'
# abricate is NOT created here — HW Part 7 has the student create it live.

# ── Smoke test / DB index (prokka ships its DBs, just needs indexing) ──────
micromamba run -n prokka prokka --setupdb 2>&1 | tail -5

# ── Create student user ──────────────────────────────────────────────────────
id student 2>/dev/null || useradd -m -s /bin/bash student
echo "student:student" | chpasswd

# ── Student shell setup ──────────────────────────────────────────────────────
cat >> /home/student/.bashrc << 'EOF'
export MAMBA_ROOT_PREFIX=/opt/micromamba
eval "$(micromamba shell hook -s bash)"
conda() { micromamba "$@"; }
micromamba activate bio
EOF

cat > /home/student/.bash_profile << 'EOF'
[ -f ~/.bashrc ] && source ~/.bashrc
EOF

chown student:student /home/student/.bashrc /home/student/.bash_profile

# ── Default channels for the student's own live `conda create` (HW Part 7:
#    conda create -n abricate -c bioconda abricate). Without conda-forge as
#    an implicit fallback channel, abricate's libgcc-ng/unzip deps don't
#    resolve — this mirrors how the real teaching server's condarc is set up,
#    which is why the HW's literal single-channel command works there. ─────
cat > /home/student/.condarc << 'EOF'
channels:
  - conda-forge
  - bioconda
EOF
chown student:student /home/student/.condarc

# ── Pre-staged BUSCO lineage only (reads are NOT staged — HW downloads them
#    live from ENA in Part 2A, so that step stays exactly as written). The
#    student still builds ~/labs/lab08/HW themselves via mkdir -p / cd, same
#    as the HW's Pre-Task — this only pre-seeds busco_downloads/ inside it,
#    so the terminal does NOT start already positioned there. ──────────────
mkdir -p /home/student/labs/lab08/HW
( cd /home/student/labs/lab08/HW && micromamba run -n busco busco --download bacteria_odb10 2>&1 | tail -5 )
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

# ── Let the student write into the mamba prefix live (HW Part 7: conda create
#    -n abricate) — without this, the student's live env creation fails ──────
chown -R student:student /opt/micromamba

touch /tmp/setup_done
