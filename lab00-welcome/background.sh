#!/bin/bash
# Runs on controlplane at scenario boot (invisible to student).
# Creates 'student' user on node01 with password-based SSH access.

set -e

# Wait for node01 to be reachable
until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 node01 'true' 2>/dev/null; do
  sleep 3
done

# Create 'student' user with password "student"
ssh -o StrictHostKeyChecking=no node01 '
  id student 2>/dev/null || useradd -m -s /bin/bash student
  echo "student:student" | chpasswd
'

# Enable password authentication in sshd on node01
ssh -o StrictHostKeyChecking=no node01 '
  sed -i "s/^#*PasswordAuthentication.*/PasswordAuthentication yes/" /etc/ssh/sshd_config
  systemctl restart sshd
'
