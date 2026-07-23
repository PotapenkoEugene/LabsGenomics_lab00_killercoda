#!/bin/bash
set -e

# ── Install micromamba ───────────────────────────────────────────────────────
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \
  | tar -xj bin/micromamba
mv bin/micromamba /usr/local/bin/micromamba && rmdir bin
chmod +x /usr/local/bin/micromamba

export MAMBA_ROOT_PREFIX=/opt/micromamba
mkdir -p /opt/micromamba/envs

# ── Base env: tools the HW calls with no `conda activate` ──────────────────
micromamba create -y -n bio -c conda-forge -c bioconda --strict-channel-priority \
  fastqc seqkit fastp megahit 2>&1 | tail -3

# ── Named envs — HW literally does `conda activate quast|busco|prokka` ─────
micromamba create -y -n quast -c conda-forge -c bioconda --strict-channel-priority \
  quast 2>&1 | tail -3
micromamba create -y -n busco -c conda-forge -c bioconda --strict-channel-priority \
  'busco>=5.4' 2>&1 | tail -3
micromamba create -y -n prokka -c conda-forge -c bioconda --strict-channel-priority \
  'prokka=1.14.6' 2>&1 | tail -3
# abricate is NOT created here — HW Part 7 has the student create it live.

micromamba clean -a -y

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
cd ~/labs/lab08/HW 2>/dev/null || true
EOF

chown student:student /home/student/.bashrc /home/student/.bash_profile

# ── Workspace + pre-staged BUSCO lineage (reads are NOT staged — HW downloads
#    them live from ENA in Part 2A, so we leave that step exactly as written) ─
mkdir -p /home/student/labs/lab08/HW
( cd /home/student/labs/lab08/HW && micromamba run -n busco busco --download bacteria_odb10 2>&1 | tail -5 )
chown -R student:student /home/student/labs

# ── Download/view helper (serves the HW dir over the Killercoda traffic port) ─
cat > /home/student/view-reports.sh << 'EOF'
#!/bin/bash
pkill -f "http.server 8080" 2>/dev/null || true
cd ~/labs/lab08/HW || exit 1
python3 -m http.server 8080 >/dev/null 2>&1 &
echo "Files served. Open the link shown in the step instructions (port 8080)."
EOF
chmod +x /home/student/view-reports.sh
chown student:student /home/student/view-reports.sh

# ── Let the student write into the mamba prefix live (HW Part 7: conda create
#    -n abricate) — without this, the student's live env creation fails ──────
chown -R student:student /opt/micromamba

touch /tmp/setup_done
