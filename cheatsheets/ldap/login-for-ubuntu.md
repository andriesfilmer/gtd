
## LDAP modules install

    sudo apt-get install libpam-ldap libnss-ldap nscd

Volg de instructies:

* LDAP server Uniform Resource Identifier: '''''ldap://ldap.filmer.nl ldap://ldap-replica.filmer.nl'''''
* Distinguished name of the search base: '''''ou=accounts,dc=filmer,dc=nl'''''
* LDAP version to use: '''''3'''''
* Make local root Database admin: '''''No'''''
* Does the LDAP database require login? '''''Yes'''''
* Unprivileged database user: '''''cn=accountread,dc=filmer,dc=nl'''''
* Password for database login account: ''Deze moet je van de systeembeheerder krijgen''

## Server of PC configuration

Create or change ''/etc/nsswitch.conf''

Open een terminal en pas het volgende bestand aan:

    sudo nano /etc/nsswitch.conf

Behind compat -> '''ldap'''

    passwd:compatldap
       group:compatldap
    shadow:compatldap

## Control

Controleer of ldap werkt en geeft een ''username'' op die niet lokaal bestaat.

    id ''username''

Of je vraagt alle gebruikers en groupen op:

    getent passwd

    getent group

Al de systeembeheerder je login nog niet gemaakt had of hij past het een en ander aan dan kan het nodig zijn dat je de ''nscd'' service opnieuw moet starten. Open een terminal een voer het volgende commando uit:

    /etc/init.d/nscd restart

;Als je op een PC wilt inloggen met een andere gebruiker moet je de PC opnieuw starten. Omdat ''gdm'' de configuratie van ''nsswitch.conf'' alleen leest met opstarten.

## Links
* [LDAP Client Authentication](https://help.ubuntu.com/community/LDAPClientAuthentication)

