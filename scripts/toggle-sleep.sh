#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Toggle Sleep
# @raycast.mode compact
# @raycast.icon ☕️
#
# macOS only. Keeps the machine awake with the lid closed (unlike caffeinate).
# Needs passwordless sudo because Raycast has no TTY for a password prompt.
# Setup (once per machine): sudo visudo -f /etc/sudoers.d/pmset and add:
#   kazuki ALL=(root) NOPASSWD: /usr/bin/pmset -a disablesleep 0, /usr/bin/pmset -a disablesleep 1
if pmset -g | grep -q 'SleepDisabled.*1'; then
  sudo pmset -a disablesleep 0
  echo "💤 sleep 復帰"
else
  sudo pmset -a disablesleep 1
  echo "☕️ sleep 無効"
fi
