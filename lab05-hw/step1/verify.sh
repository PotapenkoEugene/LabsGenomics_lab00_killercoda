#!/bin/bash
D=/home/student/labs/lab05/HW
LINES=$(wc -l < "$D/answers.txt" 2>/dev/null || echo 0)
[ "$LINES" -ge 5 ] \
  && test -f "$D/sample1.fastq.gz" && test -f "$D/sample2.fastq.gz" \
  && test -f "$D/sample3.fastq.gz" && test -f "$D/sample4.fastq.gz" \
  && test -f "$D/sample1_fastqc.html" && test -f "$D/sample2_fastqc.html" \
  && test -f "$D/sample3_fastqc.html" && test -f "$D/sample4_fastqc.html"
