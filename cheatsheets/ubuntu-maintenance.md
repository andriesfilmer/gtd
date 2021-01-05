# Ubuntu maintenance

## Read log journal

    journalctl
    journalctl --list-boots
    journalctl -b                                   # Displaying Logs from the Current Boot
    journalctl -b -1                                # previous boot
    journalctl -b caf0524a1d394ce0bdbcff75b94444fe  # From boot ID
    journalctl -n 20                                # Show last 20 messages
    journalctl -f                                   # Follow the messages
    journalctl -u postfix@-.service                 # Follow only postfix
    journalctl -u postfix@-.service --since -10m    # Only last 10 minutes
    journalctl -u nginx.service --since today
    journalctl -u nginx.service -u php-fpm.service --since today
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

### How to Re-Enable Third-Party Repositories

Third-party repositories are defined in the .list files under /etc/apt/sources.list.d/ directory. First, re-enable third-party repositories with the following command, which will remove the # character in lines that begin with deb.

    sudo sed -i '/deb/s/^#//g' /etc/apt/sources.list.d/*.list

Then change all instances of bionic to focal.

    sudo sed -i 's/bionic/focal/g' /etc/apt/sources.list.d/*.list

Update package repository index.

sudo apt update

