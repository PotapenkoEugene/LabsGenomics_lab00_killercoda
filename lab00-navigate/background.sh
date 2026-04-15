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
# Heredoc with single-quoted delimiter — body goes to node01 verbatim,
# variables and loops evaluated by bash on the remote host.

ssh -o StrictHostKeyChecking=no node01 bash << 'ENDSSH'
set -e

ENTRY="/shared/lab00/the_place_where_files_go"
TARGET="$ENTRY/almost_exactly_here/and_right_here"

# ── Three dirs sharing the "almost_" prefix — Tab shows all three on double-Tab
mkdir -p "$TARGET"
mkdir -p "$ENTRY/almost_here"
mkdir -p "$ENTRY/almost_there"

# Decoy content so the other dirs look occupied
echo "Nothing useful here." > "$ENTRY/almost_here/readme.txt"
echo "Nope, keep looking."  > "$ENTRY/almost_there/readme.txt"

# ── Haystack: 1000 files all named amithebiggest_N with random small sizes (1–50 KB)
for i in $(seq -w 1 1000); do
  size=$(( (RANDOM % 50) + 1 ))
  dd if=/dev/urandom bs=1024 count=$size of="$TARGET/amithebiggest_${i}.dat" 2>/dev/null
done

# ── The actual giant: 5 MB, placed at a random position — only ls -lhS reveals it
GIANT=$(( (RANDOM % 1000) + 1 ))
printf -v GIANT_PADDED "%04d" "$GIANT"
dd if=/dev/urandom bs=1M count=5 of="$TARGET/amithebiggest_${GIANT_PADDED}.dat" 2>/dev/null

# ── Permissions: readable throughout; deepest dir writable so student can touch
chmod -R a+rX /shared/lab00
chmod a+rwx "$TARGET"
ENDSSH
