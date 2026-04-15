#!/bin/bash
# Runs on controlplane at scenario boot (invisible to student).

set -e

# ── Part 1: standard two-VM setup (identical in every lab00 scenario) ─────────

# Wait for node01 to be reachable
until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 node01 'true' 2>/dev/null; do
  sleep 3
done

# Set up student user, hostname, and sshd config on node01
ssh -o StrictHostKeyChecking=no node01 '
  hostnamectl set-hostname labserver
  id student 2>/dev/null || useradd -m -s /bin/bash student
  echo "student:student" | chpasswd
  sed -i "s/^#*PasswordAuthentication.*/PasswordAuthentication yes/" /etc/ssh/sshd_config
'

# Generate a dedicated key pair for verify.sh only (not root's default id_rsa)
ssh-keygen -t rsa -f /root/.ssh/verify_key -N "" -q

# Install only the verify key in student's authorized_keys
ssh -o StrictHostKeyChecking=no node01 '
  mkdir -p /home/student/.ssh
  chmod 700 /home/student/.ssh
  chown student:student /home/student/.ssh
'
cat /root/.ssh/verify_key.pub | ssh -o StrictHostKeyChecking=no node01 \
  'cat >> /home/student/.ssh/authorized_keys
   chown student:student /home/student/.ssh/authorized_keys
   chmod 600 /home/student/.ssh/authorized_keys'

# Restart sshd in a separate call — it kills the connection, so use || true
ssh -o StrictHostKeyChecking=no node01 'systemctl restart sshd' || true
sleep 2

# Add labserver to /etc/hosts so students can ssh student@labserver
NODE01_IP=$(ssh -o StrictHostKeyChecking=no node01 'hostname -I' | awk '{print $1}')
echo "$NODE01_IP labserver" >> /etc/hosts

# ── Part 2: seed navigation data on labserver ─────────────────────────────────
# Pipe the entire setup script via heredoc — avoids all variable-scoping issues
# between the local shell and the remote shell.

ssh -o StrictHostKeyChecking=no node01 bash << 'ENDSSH'
set -e

DEEP="/shared/lab00/samples_2024/raw_reads/batch_01_results"

# ── Three dirs with a common prefix — Tab shows all three options at first level
mkdir -p "$DEEP"
mkdir -p /shared/lab00/samples_2025
mkdir -p /shared/lab00/samples_archive

# Decoy content so the other dirs exist but are clearly not the target
echo "No data collected yet." > /shared/lab00/samples_2025/README.txt
echo "Archived. See samples_2024 for current data." > /shared/lab00/samples_archive/README.txt

# ── Haystack: 1000 files with varied sizes (1–50 KB) — impossible to spot by eye
for i in $(seq -w 1 1000); do
  size=$(( (RANDOM % 50) + 1 ))
  dd if=/dev/urandom bs=1024 count=$size of="$DEEP/file_${i}.dat" 2>/dev/null
done

# ── Giant file: 5 MB — clearly wins ls -lhS
dd if=/dev/urandom bs=1M count=5 \
   of="$DEEP/the_giant_file_you_are_looking_for.dat" 2>/dev/null

# ── World-readable throughout; deepest dir is also writable so student can touch
chmod -R a+rX /shared/lab00
chmod a+rwx "$DEEP"
ENDSSH
