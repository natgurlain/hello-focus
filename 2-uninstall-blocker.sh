#!/bin/bash
echo "Uninstalling Mac Website Blocker..."

sudo /usr/local/bin/unblock-websites 2>/dev/null || true

(crontab -l 2>/dev/null | grep -v "/usr/local/bin/block-websites") | crontab -
(crontab -l 2>/dev/null | grep -v "/usr/local/bin/unblock-websites") | crontab -

sudo rm -f /etc/blocked-sites.txt /etc/website-blocker.conf \
           /usr/local/bin/block-websites /usr/local/bin/unblock-websites

echo "Fully removed. Your system is exactly as before."
echo "Original hosts backup remains at /etc/hosts.original-backup"