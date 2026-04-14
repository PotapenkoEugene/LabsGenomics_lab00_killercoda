#!/bin/bash
# Pass if the student created iwashere on node01 AND iwasheretoo on controlplane.
ssh -o StrictHostKeyChecking=no student@node01 'test -f /home/student/iwashere' && \
  test -f /root/iwasheretoo
