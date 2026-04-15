#!/bin/bash
# Pass if the student copied the giant file to their home directory on labserver.
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'test -f /home/student/the_giant_file_you_are_looking_for.dat'
