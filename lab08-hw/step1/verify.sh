#!/bin/bash
D=/home/student/labs/lab08/HW
LINES=$(wc -l < "$D/answers.txt" 2>/dev/null || echo 0)
[ "$LINES" -ge 8 ] \
  && test -f "$D/reads_R1.fastq.gz" && test -f "$D/reads_R2.fastq.gz" \
  && test -f "$D/assembly/final.contigs.fa" \
  && test -f "$D/annotation/typhi.gff" \
  && test -f "$D/resistance.tsv"
