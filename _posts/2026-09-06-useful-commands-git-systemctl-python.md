# Useful git commands, systemctl commands, and a python snippet

Just sharing some things I found useful recently.

## Useful Git commands for working with ignored files and troubleshooting `.gitignore`

### List all ignored files

```bash
git ls-files --others --ignored --exclude-standard
```

### Determine why a file is ignored

For example, I wanted to know why `.env.314` was being automatically ignored when I only explicitly added an entry for `.env` to the top-level `.gitignore` file. 

I was able to find the answer using Git's `git check-ignore` command.

Note: the command requires a file, as git always ignores directories, so I used a file within the directory (`.env.314/pyvenv.cfg`).

Findings: The contents of the directory are automatically ignored because `venv` generates a `.gitignore` file within the virtual environment containing `*` (ignore all).

```bash
$ git check-ignore -v .env.314/pyvenv.cfg
.env.314/.gitignore:2:*	.env.314/pyvenv.cfg
$ cat .env.314/.gitignore 
# Created by venv; see https://docs.python.org/3/library/venv.html
*
```

### Temporarily ignore a file without adding it to `.gitignore`

I have found this useful when I would rather not modify `.gitignore`, e.g. when I have some sort of temporary local modifications that I want to avoid committing (such as enabling debug logging). If such changes are not ignored, they may be accidentally committed, however modifying `.gitignore` in such cases introduces the risk of accidentially committing changes to `.gitignore` that were only intended for the local developer environment. Solution: Use `git update-index --assume-unchanged` to temporarily ignore files.

- Ignore local changes to a file

```bash
git update-index --assume-unchanged <file-path>
```

- Start tracking changes again 

```bash
git update-index --no-assume-unchanged <file-path>
```

- List all files marked as _assume unchanged_

```bash
git ls-files -v | grep "^[a-z]"
```

## Useful Systemctl commands

Here's some useful `systemctl` commands I've recently learned:

### `systemctl status` without arguments outputs a tree view of all running services

You may be used to running `systemctl status` for a given service, but did you know if you run it without arguments it outputs a spectacular tree view of all running services?

```bash
● moongas-ubuntu-s-1vcpu-512mb-10gb-nyc1
    State: running
    Units: 441 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 0 units
    Since: Sun 2026-09-06 23:15:44 UTC; 1h 14min ago
  systemd: 255.4-1ubuntu8.17
   CGroup: /
           ├─init.scope
           │ └─1 /usr/lib/systemd/systemd --system --deserialize=61
           ├─system.slice
           │ ├─ModemManager.service
           │ │ └─26193 /usr/sbin/ModemManager
           │ ├─cron.service
           │ │ └─26161 /usr/sbin/cron -f -P
           │ ├─dbus.service
           │ │ └─825 @dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
           │ ├─droplet-agent.service
           │ │ └─7103 /opt/digitalocean/bin/droplet-agent
           │ ├─multipathd.service
           │ │ └─16930 /sbin/multipathd -d -s
           │ ├─nginx.service
           │ │ ├─28077 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
           │ │ └─28078 "nginx: worker process"
           │ ├─polkit.service
           │ │ └─26175 /usr/lib/polkit-1/polkitd --no-debug
           │ ├─rsyslog.service
           │ │ └─11499 /usr/sbin/rsyslogd -n -iNONE
           │ ├─ssh.service
           │ │ └─26246 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
           │ ├─system-getty.slice
           │ │ └─getty@tty1.service
           │ │   └─968 /sbin/agetty -o "-p -- \\u" --noclear - linux
lines 1-33

```


### Show contents of systemD unit file with `systemctl cat {servicename}`

```bash
(env) root@ubuntu-s-1vcpu-512mb-10gb-nyc1:/var/www/moongas/moongas-py-mediaserver# systemctl cat mediaserver
# /etc/systemd/system/mediaserver.service
[Unit]
Description=mediaserver
After=network.target

[Service]
User=root
Group=root
WorkingDirectory=/var/www/moongas/moongas-py-mediaserver
ExecStart=/home/brett/Git/bretttolbert/moongas/env/bin/python run.py mediaserver-config.yaml
Restart=always
RestartSec=30s
Type=simple

[Install]
WantedBy=multi-user.target

```


## Useful Python snippet

### Useful Python script to list all console entry points of every installed python package (in the active environment)

```python
import importlib.metadata

"""
List all console entry points (command line scripts) in every installed python package
in the active interpretor
"""

# Select only command line scripts
cli_scripts = importlib.metadata.entry_points().select(group='console_scripts')

for script in cli_scripts:
    print(f"Command: {script.name} -> Calls: {script.value}")

```
