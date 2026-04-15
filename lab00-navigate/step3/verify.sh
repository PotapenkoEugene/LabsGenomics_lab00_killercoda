#!/bin/bash
# Pass if the student created ~/lab00/projects/ecoli/ready on labserver.
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'test -f /home/student/lab00/projects/ecoli/ready'
