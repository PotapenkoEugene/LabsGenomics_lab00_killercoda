#!/bin/bash
# Runs on controlplane at scenario boot (invisible to student).
# Goal: provision a 'student' user on node01 with SSH access from root@controlplane.

set -e

# Wait for node01 to be reachable (kubeadm-2nodes can take a moment to fully boot)
until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 node01 'true' 2>/dev/null; do
  sleep 3
done

# Create the 'student' user on node01 if not already present
ssh -o StrictHostKeyChecking=no node01 '
  id student 2>/dev/null || useradd -m -s /bin/bash student
  mkdir -p /home/student/.ssh
  chmod 700 /home/student/.ssh
'

# Grant root@controlplane passwordless SSH into student@node01
scp -o StrictHostKeyChecking=no /root/.ssh/authorized_keys node01:/tmp/root_authkeys
ssh -o StrictHostKeyChecking=no node01 '
  cp /tmp/root_authkeys /home/student/.ssh/authorized_keys
  chown -R student:student /home/student/.ssh
  chmod 600 /home/student/.ssh/authorized_keys
  rm /tmp/root_authkeys
'
