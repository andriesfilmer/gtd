# Ubuntu maintenance

## Read log journal

    journalctl -r                                   # Show log reverse, io last messages
    journalctl --since "1 hour ago"
    journalctl -n 20                                # Show last 20 messages
    journalctl -f                                   # Follow the messages
    journalctl --list-boots
    journalctl -b                                   # Displaying Logs from the Current Boot
    journalctl -b -1                                # previous boot
    journalctl -b caf0524a1d394ce0bdbcff75b94444fe  # From boot ID
    journalctl -u spamassassin.service -f           # Follow only spamd
    journalctl -u postfix@-.service -f              # Follow only postfix
    journalctl -u postfix@-.service --since -10m    # Only last 10 minutes
    journalctl -u spamassassin.service -u postfix@-.service -u opendkim.service --since -30m
    journalctl -u nginx.service --since today
    journalctl -u ssh.service --since today
    journalctl /bin/sh --since today
    journalctl _PID=8088                            # Specifying the _PID field.
    journalctl _UID=33 --since today                # Get id: `id -u www-data`
    journalctl -k                                   # Kernel messages

Clear journal

    du -hs /var/log/journal                         # How mutch space
    journalctl --vacuum-size=2G                     # Keep 2GB worth of logs, or...
    journalctl --vacuum-time=10d                    # Clearing everything older than say 10 days

* <https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs>

## Check unattended-upgrade logfiles

    tail /var/log/unattended-upgrades/unattended-upgrades*.log

## Ubuntu upgrade

Check versions

    lsb_release -a
    uname -a

    apt update
    apt upgrade
    apt dist-upgrade
    reboot
    apt install update-manager-core ubuntu-release-upgrader-core
    do-release-upgrade -d # the ‘d’ denoting ‘development’
    do-release-upgrade
    reboot
    apt --purge autoremove

 ## Ubuntu downgrade

Sometimes a upgrade is broken and you want to go back to a older version. See example:

    apt list -a libmysqlclient21
    apt install libmysqlclient21=8.0.28-0ubuntu4
    apt-mark hold libmysqlclient21

When that has been fixed, you can undo the above with:

    apt-mark unhold libmysqlclient21
    apt update
    apt upgrade

### How to Re-Enable Third-Party Repositories

Third-party repositories are defined in the .list files under /etc/apt/sources.list.d/ directory. First, re-enable third-party repositories with the following command, which will remove the # character in lines that begin with deb.

    sudo sed -i '/deb/s/^#//g' /etc/apt/sources.list.d/*.list

Then change all instances of bionic to focal.

    sudo sed -i 's/bionic/focal/g' /etc/apt/sources.list.d/*.list

Update package repository index.

sudo apt update

