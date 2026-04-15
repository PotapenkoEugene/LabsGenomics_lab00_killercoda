#!/bin/bash
# Pass if the student created a file named 'banana' in their home directory on labserver.
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'test -f /home/student/banana'
