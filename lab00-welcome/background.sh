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
NODE01_IP=$(getent hosts node01 | awk '{print $1}')
echo "$NODE01_IP labserver" >> /etc/hosts
