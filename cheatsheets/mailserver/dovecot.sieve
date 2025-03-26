# https://doc.dovecot.org/2.3/configuration_manual/sieve/examples/
#
# location /var/vmail/domain/user/.dovecot.sieve
#
require ["fileinto", "variables"];

# Move spam to spam folder
if header :contains "X-Spam-Flag" "YES" {
  fileinto "Spam";
  # Stop here so that we do not reply on spams
  stop;
}

