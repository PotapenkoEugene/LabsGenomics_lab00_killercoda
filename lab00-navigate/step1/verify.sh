#!/bin/bash
# Pass if the student touched iwashere in the target directory on labserver.
ssh -o StrictHostKeyChecking=no -i /root/.ssh/verify_key student@labserver \
  'test -f /shared/lab00/the_place_where_files_go/almost_exactly_here/and_right_here/iwashere'
