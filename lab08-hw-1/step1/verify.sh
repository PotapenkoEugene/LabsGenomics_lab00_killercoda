#!/bin/bash
D=/home/student/labs/lab08/HW
test -s "$D/answers_1.txt" \
  && test -f "$D/reads_R1.fastq.gz" && test -f "$D/reads_R2.fastq.gz" \
  && test -f "$D/clean_R1.fastq.gz" \
  && test -f "$D/assembly/final.contigs.fa"
