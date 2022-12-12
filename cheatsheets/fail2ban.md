# Fail2ban

Fail2ban scans log files like `/var/log/pwdfail` or `/var/log/apache/error_log` and bans IP that makes too many password failures. It updates firewall rules to reject the IP address.
Fail2ban scans log files like `/var/log/mail.log` and bans any IP address that makes too many password (or other) failures. It updates firewall rules to reject the IP address.

## Installation

    apt-get install fail2ban

## Configuration

Default configuration after install for ssh is already up and running ;)

The fail2ban configuration files are in `/etc/fail2ban/`. After installation there are only .conf which shouldn't be edited. Create .local files instead. Settings in .local files will overrule settings in .conf files.

The configuration of one 'jail' mainly consists of:

*a filter: a regular expression that matches a failed login in a log file. Filters are in `/etc/fail2ban/filter.d`
*one or more actions: things to do when the filter has matched too many times for an IP address. Actions are in /etc/fail2ban/action.d

In the file `/etc/fail2ban/jail.conf` (and jail.local) jails are defined. Important settings here are

*filter: the name of the filter we want to use. The filter must exits in /etc/fail2ban/filter.d
*logpath: The log file to check
*maxretry: How often the filter must be matched before we take action
*action: The action(s) to take after the filter is matched [maxretry] times. The action(s) must exist in /etc/fail2ban/action.d
*bantime: Duration of the ban in seconds. Defaults to 600.
*findtime: The counter is set to zero if no match is found within "findtime" seconds. Defaults to 600.

jail.conf may also have a [DEFAULT] section where default actions etc can be defined (will be overruled by the per-jail configuration). Default actions may use variables, which can be set globally or per-jail:

    [DEFAULT]
    destemail = notice@netexpo.nl
    action = iptables[name=%(__name__)s, port=%(port)s]
           sendmail-whois[name=%(__name__)s, dest=%(destemail)s]

    # destemail is set globally (but can be overruled in each jail)
    # port is the port to block in the firewall for attacker IP addresses, this will be different for each jail.
    # %(__name__)s will be replaced with the jail name by fail2ban

The often used sendmail-whois action also sends an email when fail2ban is stopped or started. Annoying. Disable this behaviour by creating /etc/fail2ban/action.d/sendmail-whois.local
    [Definition]
    actionstart
    actionstop

## Configuration example for ssh only

Edit `/etc/fail2ban/jail.local`

    [DEFAULT]
    destemail = notice@netexpo.nl
    action = iptables[name=%(__name__)s, port=%(port)s]
            sendmail-whois[name=%(__name__)s, dest=%(destemail)s]


Edit `/etc/fail2ban/action.d/sendmail-whois.local`
    [Definition]
    actionstart
    actionstop

That's all, the ssh jail is enabled by default in jail.conf

## Configuration example proftp,ssh and http

Create `/etc/fail2ban/jail.local`

    [DEFAULT]
    destemail = andries@filmer.nl
    action = iptables[name=%(__name__)s, port=%(port)s]
            sendmail-whois[name=%(__name__)s, dest=%(destemail)s]

    [ssh]
    enabled = true
    filter  = sshd
    action = sendmail-whois[name=%(__name__)s, dest=%(destemail)s]
    logpath  = /var/log/auth.log
    maxretry = 6

    [ssh-http]
    enabled = true
    filter  = sshd
    action = sendmail-whois[name=%(__name__)s, dest=%(destemail)s]
    logpath  = /var/log/auth.log
    maxretry = 6

    [proftpd-wrongpassword]
    enabled  = true
    port     = ftp
    filter   = proftpd-wrongpassword
    logpath  = /var/lib/vservers/http03/var/log/proftpd/proftpd.log
    maxretry = 6

    [proftpd]
    enabled  = true
    port     = ftp
    filter   = proftpd
    logpath  = /var/log/proftpd/proftpd.log
    maxretry = 10


Create /etc/fail2ban/filter.d/proftpd-wrongpassword.local
    [Definition]

    failregex = [<HOST>]): USER S+ (Login failed): Incorrect password.
    ignoreregex

Restart fail2ban

    /etc/init.d/fail2ban restart

## Configuration example pop3, imap and smtpauth

Before doing this make sure the option
    auth_verbose = yes

is set in dovecot.conf. Otherwise the log rules we check for are not written!

Also understand that syslog aggregates identical log messages ("last message repeated xx times"). Obviously fail2ban doesn't match aggregated log messages. You may want to install syslog-ng which doesn't aggregate messages.

Create /etc/fail2ban/jail.local
    [DEFAULT]
    destemail = notice@netexpo.nl
    action = iptables[name=%(__name__)s, port=%(port)s]
            sendmail-whois[name=%(__name__)s, dest=%(destemail)s]

    [imap]
    enabled = true
    port    = imap
    filter  = imap
    logpath  = /var/log/mail.log
    maxretry = 10

    [pop3]
    enabled = true
    port    = pop3
    filter  = pop3
    logpath  = /var/log/mail.log
    maxretry = 10

    [smtpauth]
    enabled = true
    port    = smtp
    filter  = smtpauth
    logpath  = /var/log/mail.log
    maxretry = 20

Create `/etc/fail2ban/filter.d/smtpauth.local`

    [Definition]
    failregex = vchkpw-smtp: (vpopmail user not found|password fail).*:<HOST>

Create /etc/fail2ban/filter.d/imap.local

    [Definition]
    failregex = dovecot: auth(default): vpopmail(.*,<HOST>): unknown user
                dovecot: auth(default): vpopmail(.*,<HOST>): Password mismatch

Create /etc/fail2ban/filter.d/pop3.local

    [Definition]
    failregex = dovecot: auth(default): vpopmail(.*,<HOST>): unknown user
                dovecot: auth(default): vpopmail(.*,<HOST>): Password mismatch

Note that the imap en pop3 filters are the same. This may seem a bit strange, the reason is that dovecot doesn't differentiate between pop3 and imap in it's auth log messages. Also note that for each login attempt, either successful of unsuccessful the string 'unknown user' is printed in the logs. This is strange dovecot behaviour. Only the combination with 'vpopmail' ensures this is really an unsuccessful login attempt.

Restart fail2ban

    /etc/init.d/fail2ban restart

## Ban IP manually on the command line by jail-name (sshd)

  fail2ban-client  set sshd banip 81.204.211.58

## External links

[www/fail2ban.org](http://www.fail2ban.org)
