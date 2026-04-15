#!/bin/bash
# Runs on controlplane at scenario boot (invisible to student).

set -e

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

# --- step 2 scp source file ---
# Place the file outside $HOME so students must use the absolute path
mkdir -p /root/lab00_local
cp "$(dirname "$0")/assets/genome.fasta" /root/lab00_local/genome.fasta
