#!/bin/bash
# Runs in the terminal while background.sh sets up the environment.
# Blocks the terminal until setup is done, then prompts the student to reload.
until [ -f /tmp/setup_done ]; do
  sleep 1
done
echo ""
echo "Setup complete. Run the command below to apply your shell settings:"
echo ""
echo "  exec bash"
echo ""
