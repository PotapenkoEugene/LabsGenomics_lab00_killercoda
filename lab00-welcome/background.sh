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

# Restart sshd in a separate call — it kills the connection, so use || true
ssh -o StrictHostKeyChecking=no node01 'systemctl restart sshd' || true
sleep 2

# Add labserver to /etc/hosts so students can ssh student@labserver
NODE01_IP=$(ssh -o StrictHostKeyChecking=no node01 'hostname -I' | awk '{print $1}')
echo "$NODE01_IP labserver" >> /etc/hosts
