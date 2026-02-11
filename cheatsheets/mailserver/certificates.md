
## Certificates

Get an [ACME Shell script](https://github.com/acmesh-official/acme.sh)

    wget -O -  https://get.acme.sh | sh -s email=andries@filmer.nl  # reload your shell so the alias `acme.sh` is available.

Use the automatic DNS API integration, for example: [Transip](https://github.com/acmesh-official/acme.sh/wiki/dnsapi2#dns_transip)

Create a key pair - [Transip](https://www.transip.nl/cp/account/api/) and **add your ipnr to the whitelist**

Save the private key in `/etc/ssl/private/transip-private.key`

Default variables are stored in `/root/.acme.sh/account.conf` after running acme.sh
Add the next for transip.

````
SAVED_TRANSIP_Username='andriesf'
SAVED_TRANSIP_Key_File='/etc/ssl/private/transip-private.key'
SAVED_TRANSIP_Token_Global_Key=''
````

Register account

    .acme.sh/acme.sh --register-account -m my@example.com
    .acme.sh/acme.sh --issue --dns dns_transip --dnssleep 100 -d domain.org -d *.domain.org

    mkdir -p /etc/letsencrypt/live/server05.igroupware.org

    acme.sh --issue --dns dns_transip --dnssleep 100 -d server05.igroupware.org

    acme.sh --install-cert -d server05.igroupware.org \
      --fullchain-file /etc/letsencrypt/live/server05.igroupware.org/fullchain.pem \
      --key-file /etc/letsencrypt/live/server05.igroupware.org/privkey.pem \
      --cert-file /etc/letsencrypt/live/server05.igroupware.org/cert.pem

Also put a [crontab](https://crontab.guru/) to renew the certificattes each month. For example:

    # Check if acme.sh has installed a crontab.
    0 0 1 * * /root/.acme.sh/acme.sh --cron --home /root/.acme.sh > /dev/null

## Switch to Let's Encrypt instead of ZeroSSL

To see all your certificates and CA servers

    acme.sh --list

To switch your existing certificates to Let's Encrypt, you need to re-issue them:

    acme.sh --renew -d yourdomain.com --server letsencrypt --force

or

    acme.sh --renew -d igroupware.org --server letsencrypt --force --dnssleep 120

To switch all certificates at once:

````
for domain in $(acme.sh --list | grep -oP '(?<=Main_Domain=)[^ ]+'); do
  acme.sh --renew -d "$domain" --server letsencrypt --force
done
````
## Chained certificates

When you renewed with acme.sh, it updated the certificates:
Tell acme.sh to deploy the renewed certificate to where Postfix expects it:

````
acme.sh --install-cert -d server07.igroupware.org \
  --cert-file /etc/letsencrypt/live/server07.igroupware.org/cert.pem \
  --key-file /etc/letsencrypt/live/server07.igroupware.org/privkey.pem \
  --fullchain-file /etc/letsencrypt/live/server07.igroupware.org/fullchain.pem \
  --reloadcmd "postmap -F hash:/etc/postfix/vmail_ssl.map && systemctl restart postfix"
````

## Debug

Check the certificate dates in the location Postfix uses

    openssl x509 -in /etc/letsencrypt/live/server07.igroupware.org/fullchain.pem -noout -dates

Check what certificate Postfix is actually presenting

    openssl s_client -connect server07.igroupware.org:587 -starttls smtp -showcerts 2>/dev/null | openssl x509 -noout -dates

