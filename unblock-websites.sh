#!/bin/bash
LOG="/var/log/website-block.log"

echo "$(date): Removing block" >> "$LOG"

# Remove ALL blocker sections safely
sudo sed -i '' '/# === MAC-WEBSITE-BLOCKER START.*$/,/# === MAC-WEBSITE-BLOCKER END ===/d' /etc/hosts 2>/dev/null || true

echo "$(date): Unblocked" >> "$LOG"