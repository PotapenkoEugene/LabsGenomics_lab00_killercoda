#!/bin/bash
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver '
  test -f /home/student/lab00/ecoli/GCF_000005845.2_ASM584v2_assembly_stats.txt && \
  test -f /home/student/lab00/ecoli/GCF_000005845.2_ASM584v2_genomic.fna.gz
'
