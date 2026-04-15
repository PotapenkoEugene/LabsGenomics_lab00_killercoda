#!/bin/bash
# Pass if the student copied both files into ~/lab00/ on labserver:
# 1. The giant file (>1 MB, random name — checked by size)
# 2. freshly_arrived.dat (newest file, known name — checked by path)
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'find /home/student/lab00 -type f -size +1M 2>/dev/null | grep -q . &&
   test -f /home/student/lab00/freshly_arrived.dat'
