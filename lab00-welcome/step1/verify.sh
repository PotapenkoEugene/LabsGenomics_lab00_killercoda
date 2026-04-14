#!/bin/bash
# Pass if the student created ~/iwasthere on node01.
ssh -o StrictHostKeyChecking=no student@node01 'test -f /home/student/iwasthere'
