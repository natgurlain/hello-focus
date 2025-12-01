#!/bin/bash

# Default times (will be overridden by arguments or interactive input)
DEFAULT_START=8
DEFAULT_END=18

# Helper: pad single digit with zero → 9 becomes 09
pad() { printf "%02d" "$1"; }

# ——— Parse command-line arguments ———
START_HOUR="$DEFAULT_START"
END_HOUR="$DEFAULT_END"

if [[ $# -eq 2 ]] && [[ "$1" =~ ^[0-9]+$ ]] && [[ "$2" =~ ^[0-9]+$ ]]; then
    START_HOUR="$1"
    END_HOUR="$2"
elif [[ $# -eq 1 ]] || [[ $# -gt 2 ]]; then
    echo "Usage: $0 [start_hour end_hour]   (e.g. $0 9 17)"
    echo "       If no arguments → interactive mode"
    echo
fi

# ——— Interactive mode if no valid args ———
if [[ $# -ne 2 ]]; then
    echo "=============================================================="
    echo "  Mac Website Blocker – Configurable Hours (Ultra-Safe)"
    echo "=============================================================="
    echo
    read -p "Start blocking at hour (0–23, default $DEFAULT_START): " input_start
    read -p "Stop blocking at hour  (0–23, default $DEFAULT_END): " input_end

    START_HOUR=${input_start:-$DEFAULT_START}
    END_HOUR=${input_end:-$DEFAULT_END}
fi

# Validate
if ! [[ "$START_HOUR" =~ ^[0-9]+$ ]] || ! (( START_HOUR >= 0 && START_HOUR <= 23 )); then
    echo "Invalid start hour. Using default 08:00"
    START_HOUR=$DEFAULT_START
fi
if ! [[ "$END_HOUR" =~ ^[0-9]+$ ]] || ! (( END_HOUR >= 0 && END_HOUR <= 23 )); then
    echo "Invalid end hour. Using default 18:00"
    END_HOUR=$DEFAULT_END
fi

START_PAD=$(pad "$START_HOUR")
END_PAD=$(pad "$END_HOUR")

echo "Configuration → Blocking every day from ${START_PAD}:00 to ${END_PAD}:00"

# ——— Save config for future reference ———
echo "START_HOUR=$START_HOUR"   | sudo tee /etc/website-blocker.conf >/dev/null
echo "END_HOUR=$END_HOUR"     | sudo tee -a /etc/website-blocker.conf >/dev/null

# ——— Install files (same safe logic as before) ———
[ ! -f /etc/hosts.original-backup ] && sudo cp /etc/hosts /etc/hosts.original-backup && echo "Backup created → /etc/hosts.original-backup"

sudo cp blocked-sites.txt /etc/blocked-sites.txt
sudo cp block-websites.sh /usr/local/bin/block-websites
sudo cp unblock-websites.sh /usr/local/bin/unblock-websites
sudo chmod +x /usr/local/bin/block-websites /usr/local/bin/unblock-websites

/usr/local/bin/unblock-websites >/dev/null 2>&1

# ——— Schedule with the chosen hours ———
(crontab -l 2>/dev/null | grep -v "/usr/local/bin/block-websites";   echo "0 $START_HOUR * * * /usr/local/bin/block-websites")   | crontab -
(crontab -l 2>/dev/null | grep -v "/usr/local/bin/unblock-websites"; echo "0 $END_HOUR * * * /usr/local/bin/unblock-websites") | crontab -

echo "Cron scheduled → 0 $START_HOUR * * *  block   |   0 $END_HOUR * * *  unblock"

# ——— Immediate blocking if we are currently inside the window ———
CURRENT=$(date +%H%M | sed 's/^0*//')
START_NUM=$((10#$START_HOUR * 100))
END_NUM=$((10#$END_HOUR * 100))

if (( CURRENT >= START_NUM && CURRENT < END_NUM )); then
    echo "Current time $(date +%H:%M) is inside ${START_PAD}:00–${END_PAD}:00 → BLOCKING NOW!"
    /usr/local/bin/block-websites
else
    echo "Outside blocking window → first block tomorrow at ${START_PAD}:00"
fi

echo
echo "ALL DONE! Blocking active ${START_PAD}:00 → ${END_PAD}:00 every day"
echo "• Change hours later → run this installer again with new times"
echo "• Edit sites → sudo nano /etc/blocked-sites.txt"
echo "• Config stored in /etc/website-blocker.conf"
echo "• Uninstall → ./2-uninstall-blocker.sh"
echo