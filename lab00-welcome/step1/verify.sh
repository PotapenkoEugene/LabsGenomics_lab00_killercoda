#!/bin/bash
# Pass if the student created iwashere on labserver AND iwasheretoo on controlplane.
# Uses root's SSH key (set up by background.sh) — no password needed.
ssh -o StrictHostKeyChecking=no student@labserver 'test -f /home/student/iwashere' && \
  test -f /root/iwasheretoo
