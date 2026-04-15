#!/bin/bash
# Pass if the student copied a file larger than 1 MB into ~/lab00/ on labserver.
# The giant is 5 MB at a random index — checking by size is robust regardless of name.
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'find /home/student/lab00 -type f -size +1M 2>/dev/null | grep -q .'
