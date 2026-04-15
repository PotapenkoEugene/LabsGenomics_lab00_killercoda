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

DEEP_DIR="very_long_directory_name_that_nobody_wants_to_type/keep_going_you_are_almost_there/one_more_level_promise"

ssh -o StrictHostKeyChecking=no node01 "
  set -e

  # Create the nested directory tree
  mkdir -p /shared/lab00/\$DEEP_DIR

  # ── Haystack: ~300 files with varied random sizes (up to ~50 KB each)
  for i in \$(seq -w 1 300); do
    dd if=/dev/urandom bs=1 count=\$((RANDOM % 51200 + 512)) \
       of=/shared/lab00/\$DEEP_DIR/file_\${i}.dat 2>/dev/null
  done

  # ── Deliberate biggest file: 5 MB — clearly dominates ls -lhS
  dd if=/dev/urandom bs=1M count=5 \
     of=/shared/lab00/\$DEEP_DIR/the_giant_file_you_are_looking_for.dat 2>/dev/null

  # ── Deliberate newest file: touch last so ls -lt puts it first
  sleep 1
  touch /shared/lab00/\$DEEP_DIR/freshly_baked_this_morning.log

  # ── Ugly-named text file for step 1 Tab practice; contains the secret word
  echo 'banana' > '/shared/lab00/\$DEEP_DIR/the_file_whose_name_is_so_long_you_really_really_want_to_hit_tab_instead.txt'

  # ── World-readable so student can read without sudo
  chmod -R a+rX /shared/lab00
"
