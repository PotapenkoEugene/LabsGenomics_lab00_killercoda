#!/bin/bash
D=/home/student/labs/lab08/HW
test -s "$D/answers_2.txt" \
  && test -f "$D/quast_out/report.tsv" \
  && test -d "$D/busco_out" \
  && test -f "$D/annotation/typhi.gff" \
  && test -f "$D/resistance.tsv"
