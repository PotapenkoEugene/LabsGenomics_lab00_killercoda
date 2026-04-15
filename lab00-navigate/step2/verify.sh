#!/bin/bash
# Pass if the student copied any file larger than 1 MB into their home directory.
# The giant file is 5 MB and randomly named — checking by size is more robust
# than hardcoding a specific filename.
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'find /home/student -maxdepth 1 -type f -size +1M | grep -q .'
