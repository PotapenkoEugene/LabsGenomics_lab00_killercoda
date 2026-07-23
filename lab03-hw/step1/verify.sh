#!/bin/bash
D=/home/student/labs/lab03/HW
LINES=$(wc -l < "$D/answers.txt" 2>/dev/null || echo 0)
[ "$LINES" -ge 5 ] \
  && test -f "$D/h5n1.fna" \
  && grep -q "New_Segment_9" "$D/h5n1.fna"
