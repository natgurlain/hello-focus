#!/bin/bash
LOG="/var/log/website-block.log"
MARKER_START="# === MAC-WEBSITE-BLOCKER START $(date +%s) ==="
MARKER_END="# === MAC-WEBSITE-BLOCKER END ==="

echo "$(date): Activating block" >> "$LOG"

# Remove any old blocked section first
sudo sed -i '' "/# === MAC-WEBSITE-BLOCKER START.*/,/# === MAC-WEBSITE-BLOCKER END ===/d" /etc/hosts 2>/dev/null || true

# Add new one
sudo bash -c "echo '$MARKER_START' >> /etc/hosts"
sudo cat /etc/blocked-sites.txt >> /etc/hosts
sudo bash -c "echo '$MARKER_END' >> /etc/hosts"

echo "$(date): Blocking active" >> "$LOG"