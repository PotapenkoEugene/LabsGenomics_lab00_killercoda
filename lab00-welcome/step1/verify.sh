#!/bin/bash
# Pass if the student created iwashere on labserver AND iwasheretoo on controlplane.
# Uses a dedicated verify key (not root's id_rsa) so students still get a password prompt.
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'test -f /home/student/iwashere' && \
  test -f /root/iwasheretoo
