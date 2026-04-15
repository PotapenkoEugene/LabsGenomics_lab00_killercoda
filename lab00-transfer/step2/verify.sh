#!/bin/bash
test -f /root/ecoli_stats.txt && \
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'test -f /home/student/lab00/ecoli_stats.txt'
