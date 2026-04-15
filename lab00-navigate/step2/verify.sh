#!/bin/bash
# Pass if the student copied the largest file (>1 MB) into ~/lab00/ on labserver.
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'find /home/student/lab00 -type f -size +1M 2>/dev/null | grep -q .'
