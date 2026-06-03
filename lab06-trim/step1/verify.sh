#!/bin/bash
test -f /root/labs/lab06/sample1_clean.fastq.gz \
  && test -f /root/labs/lab06/sample2_clean.fastq.gz \
  && test -f /root/labs/lab06/sample1_clean_fastqc.html \
  && test -f /root/labs/lab06/sample2_clean_fastqc.html
