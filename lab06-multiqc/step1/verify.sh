#!/bin/bash
test -f /root/labs/lab06/sample1_clean.stats.txt \
  && test -f /root/labs/lab06/sample2_clean.stats.txt \
  && test -f /root/labs/lab06/multiqc_report.html
