#!/bin/bash
# Runs on controlplane at scenario boot (invisible to student).
# Sets up the desktop/server story: controlplane → mypc, node01 → labserver.

set -e

# Wait for node01 to be reachable
until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 node01 'true' 2>/dev/null; do
  sleep 3
done

# Rename this machine to mypc
hostnamectl set-hostname mypc

# Rename node01 to labserver + create student user with password auth
ssh -o StrictHostKeyChecking=no node01 '
  hostnamectl set-hostname labserver
  id student 2>/dev/null || useradd -m -s /bin/bash student
  echo "student:student" | chpasswd
  sed -i "s/^#*PasswordAuthentication.*/PasswordAuthentication yes/" /etc/ssh/sshd_config
  systemctl restart sshd
'

# Make "labserver" resolvable on mypc
# Use ssh to get node01's IP directly — more reliable than getent before DNS is ready
NODE01_IP=$(ssh -o StrictHostKeyChecking=no node01 'hostname -I' | awk '{print $1}')
echo "$NODE01_IP labserver" >> /etc/hosts

# Write custom prompt to system-wide profile (read by all new bash sessions)
cat > /etc/profile.d/99-prompt.sh << 'EOF'
export PS1='\[\033[01;32m\]gene_wizard@mypc\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
EOF

# Signal that setup is complete
touch /tmp/setup_done
