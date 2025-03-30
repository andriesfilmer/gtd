# https://doc.dovecot.org/2.3/configuration_manual/sieve/examples/
#
# location /var/vmail/domain/user/.dovecot.sieve
#
require ["fileinto","imap4flags", "vnd.dovecot.execute"];

if header :contains "X-Spam-Flag" "YES" {
  fileinto "Spam";
  addflag "\\Seen";
  # Stop here so that we do not reply on spams
  stop;
}

if address :is "to" "admin@linuxcomputers.nl" {
  execute :pipe "signup-handler.sh";
}

