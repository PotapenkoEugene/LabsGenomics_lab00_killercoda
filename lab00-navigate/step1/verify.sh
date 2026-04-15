#!/bin/bash
# Pass if the student touched iwashere in the deepest directory on labserver.
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'test -f /shared/lab00/samples_2024/raw_reads/batch_01_results/iwashere'
