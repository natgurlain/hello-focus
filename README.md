# Mac Website Blocker – Configurable Hours (Ultra-Safe Edition)

**Free • No apps • Instant • Fully configurable • 100% reversible**

Automatically blocks distracting websites on your Mac **every day during the hours you choose** and unblocks them automatically when work is over.

Perfect for deep work, parental control, or digital wellbeing — without installing any software.

### Features
- Fully configurable start & end times (e.g. 09:00–17:00, 10:00–19:00, etc.)
- Blocks at system level → works in **all browsers and apps**
- Instant blocking the moment you install (if inside work hours)
- Never damages your original `/etc/hosts` — automatic permanent backup
- Unique timestamp markers → zero risk of conflicts
- One-file block list — easy to edit anytime
- Clean installer + full uninstaller
- Optional Monday–Friday mode
- Detailed log file
- 100% open source, local-only, no tracking

### Files
| File                     | Purpose                                                                 |
|--------------------------|-------------------------------------------------------------------------|
| `README.md`              | This file                                                               |
| `blocked-sites.txt`      | Edit this to add/remove websites (one per line)                         |
| `block-websites.sh`      | Internal — runs at your chosen start hour                               |
| `unblock-websites.sh`    | Internal — runs at your chosen end hour                                 |
| `1-install-blocker.sh`   | Run this once (or again to change hours)                                |
| `2-uninstall-blocker.sh` | Completely remove everything and restore original state                 |

### Installation & Configuration (30 seconds)

```bash
# 1. Go into the folder
cd /path/to/hello-focus

# 2. Run the installer — two ways:

# Interactive mode (recommended first time)
./1-install-blocker.sh
# → Just type your desired hours when asked

# OR direct mode (great for scripts or quick change)
./1-install-blocker.sh 9 17        # 09:00 – 17:00
./1-install-blocker.sh 10 20       # 10:00 – 20:00
```

You will be asked for your password once (needed for system files).

**Done!**  
If you install during your work window → sites are blocked instantly.  
Outside hours → blocking starts automatically tomorrow.

### Change blocking hours later
Just re-run the installer with new times:

```bash
./1-install-blocker.sh 9 30 17 30   # Example: 09:30 – 17:30
# or simply run without arguments for interactive mode
./1-install-blocker.sh
```

### Edit blocked websites anytime
```bash
sudo nano /etc/blocked-sites.txt
```
Add lines like:
```
127.0.0.1 linkedin.com
127.0.0.1 www.netflix.com
```
Save with **Ctrl+O → Enter → Ctrl+X**

Changes take effect at the next scheduled block.

### Only Monday–Friday (skip weekends)
After installation, run this once:

```bash
# Disable daily jobs and add weekday-only ones
(crontab -l | sed '/block-websites\|unblock-websites/s/^/#DISABLED /' ) | crontab -
(crontab -l 2>/dev/null; echo "0 $(cat /etc/website-blocker.conf | grep START_HOUR | cut -d= -f2) * * 1-5 /usr/local/bin/block-websites") | crontab -
(crontab -l 2>/dev/null; echo "0 $(cat /etc/website-blocker.conf | grep END_HOUR | cut -d= -f2) * * 1-5 /usr/local/bin/unblock-websites") | crontab -
echo "Now active only Monday–Friday!"
```

### Full uninstall (everything goes back to exactly how it was)
```bash
./2-uninstall-blocker.sh
```
- Removes cron jobs  
- Removes blocked entries from hosts file  
- Deletes all installed files  
- Leaves your pristine backup at `/etc/hosts.original-backup`

### Safety & Recovery
- Your original `/etc/hosts` is backed up forever at:  
  `/etc/hosts.original-backup`
- Restore it anytime with:
```bash
sudo cp /etc/hosts.original-backup /etc/hosts
```

### Logs
All actions are logged to:  
`/var/log/website-block.log`

### Tested On
- macOS Ventura • Sonoma • Sequoia  
- Intel & Apple Silicon  
- Survives reboots, updates, Homebrew, Docker, VPNs

### Example use cases
```bash
./1-install-blocker.sh 9 17     # Classic 9-to-5
./1-install-blocker.sh 7 22     # Early bird + night owl protection
./1-install-blocker.sh 0 0      # 24/7 blocking (yes, it works!)
```

Enjoy laser-focused workdays — completely under your control.

Made with love for humans who want to do great work  
Open source • Forever free • No strings attached
