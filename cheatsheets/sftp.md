# SFTP on Ubuntu

## Configure sshd

Edit your /etc/ssh/sshd_config file

    Subsystem sftp internal-sftp -f AUTH -l VERBOSE
    Match group sftp
    ChrootDirectory %h
    ForceCommand internal-sftp
    AllowTcpForwarding no
    ForceCommand internal-sftp

Restart OpenSSH:

    service ssh restart

### Modify User Accounts

Remove shell access for sftp user and give `/bin/false` to the user

Add user to the `sftp` group

For ChrootDirectory the 'root' user need to be the owner!

    chown root:root /path/to/homedir

These user will now be unable to create files in their home directories, since these directories are owned by the root user.
Create new directorie for full access.

    cd /path/to/homedir
    mkdir public_html
    chown username:sftp *

Your users should now be able to log into their accounts via SFTP and transfer files to and from their assigned subdirectories, but they shouldn’t be able to see the rest of your filesystem.
