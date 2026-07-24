#!/bin/bash
until [ -f /tmp/setup_done ]; do sleep 2; done
exec su - student
