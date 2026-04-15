#!/bin/bash
# Pass if both target files exist in the student's home directory on labserver.
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'test -f /home/student/the_giant_file_you_are_looking_for.dat &&
   test -f /home/student/freshly_baked_this_morning.log'
