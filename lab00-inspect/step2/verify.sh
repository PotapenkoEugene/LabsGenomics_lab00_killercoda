#!/bin/bash
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver '
  test -f /home/student/lab00/inspect/GCF_000005845.2_ASM584v2_genomic.fna.gz && \
  test -f /home/student/lab00/inspect/fasta_header.txt && \
  test -s /home/student/lab00/inspect/fasta_header.txt
'
