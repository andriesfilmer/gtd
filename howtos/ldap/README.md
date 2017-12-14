## Installation LDAP Sever

    apt-get install ldap-utils slapd

## Configuration

We want to be able to use the attibute type authorizedService for logins. The ldapns schema provides this attributetype, but it's not included with OpenLDAP anymore. We create it by hand in /etc/ldap/schema/ldapns.schema
    # $Id: ldapns.schema,v 1.3 2003/05/29 12:57:29 lukeh Exp $
    
    # LDAP Name Service Additional Schema
    
    # http://www.iana.org/assignments/gssapi-service-names
    
    attributetype ( 1.3.6.1.4.1.5322.17.2.1 NAME 'authorizedService'
  DESC 'IANA GSS-API authorized service name'
  EQUALITY caseIgnoreMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )
    
objectclass ( 1.3.6.1.4.1.5322.17.1.1 NAME 'authorizedServiceObject'
  DESC 'Auxiliary object class for adding authorizedService attribute'
  SUP top
  AUXILIARY
  MAY authorizedService )
    
objectclass ( 1.3.6.1.4.1.5322.17.1.2 NAME 'hostObject'
  DESC 'Auxiliary object class for adding host attribute'
  SUP top
  AUXILIARY
  MAY host )

Include this schema in slapd.conf, together with the samba schema

    include         /etc/ldap/schema/ldapns.schema
    include         /etc/ldap/schema/samba.schema

Other essenstial (non-default) entries in slapd.conf are

    # The maximum number of entries that is returned for a search operation
    # unlimited hard limit for replication
    sizelimit unlimited
    
    suffix          "dc=filmer,dc=nl"
    
    rootdn          "cn=admin,dc=filmer,dc=nl"
    #rootpw          "XXXXXXX" # can be enabled for maintenance
    
    # Save the time that the entry gets modified, for database #1
    lastmod         on
    
    # Indexing options for database #1
    index objectClass eq
    index entryCSN,entryUUID eq
    index uidNumber eq
    index uid eq
    index uniqueMember eq
    index memberUid eq
    index cn eq
    
    # for replication
    moduleload syncprov
    overlay syncprov
    syncprov-checkpoint 100 10
    syncprov-sessionlog 200
    
    # Where to store the replica logs for database #1
    # replogfile    /var/lib/ldap/replog
    
    # These access lines apply to database #1 only
    access to attrs=userPassword,shadowLastChange
           by tls_ssf=128 ssf=128 group/groupofuniquenames/uniquemember="cn=administrators,dc=filmer,dc=nl" write
           by tls_ssf=128 ssf=128 dn.exact="uid=replication,ou=account,dc=filmer,dc=nl" read
           by anonymous auth
           by * none
    
    # samba (and replication) must be able to read samba passwords
    access to attrs=sambaLMPassword,sambaNTPassword,sambaSID
           by tls_ssf=128 ssf=128 dn.exact="uid=samba,ou=account,dc=filmer,dc=nl" read
           by dn.exact="uid=replication,ou=account,dc=filmer,dc=nl" read
           by * none
    
    # samba and nss_pam can read account info, administrators and accountadmin can also write
    access to dn.subtree="ou=account,dc=filmer,dc=nl"
           by tls_ssf=128 ssf=128 group/groupofuniquenames/uniquemember="cn=administrators,dc=filmer,dc=nl" write
           by tls_ssf=128 ssf=128 dn.exact="uid=accountadmin,ou=account,dc=filmer,dc=nl" write
           by tls_ssf=128 ssf=128 dn.exact="uid=samba,ou=account,dc=filmer,dc=nl" read
           by dn.exact="uid=nss_pam,ou=account,dc=filmer,dc=nl" read
           by tls_ssf=128 ssf=128 dn.exact="uid=replication,ou=account,dc=filmer,dc=nl" read
           by tls_ssf=128 ssf=128 self read
           by tls_ssf=128 ssf=128 * none
    
    # samba, nss_pam and replication can read group info, administrators can also write
    access to dn.subtree="ou=group,dc=filmer,dc=nl"
           by tls_ssf=128 ssf=128 group/groupofuniquenames/uniquemember="cn=administrators,dc=filmer,dc=nl" write
           by tls_ssf=128 ssf=128 dn.exact="uid=samba,ou=account,dc=filmer,dc=nl" read
           by tls_ssf=128 ssf=128 dn.exact="uid=nss_pam,ou=account,dc=filmer,dc=nl" read
           by tls_ssf=128 ssf=128 dn.exact="uid=replication,ou=account,dc=filmer,dc=nl" read
           by tls_ssf=128 ssf=128 * none
    
    # Ensure read access to the base for things like
    # supportedSASLMechanisms.  Without this you may
    # have problems with SASL not knowing what
    # mechanisms are available and the like.
    # Note that this is covered by the 'access to *'
    # ACL below too but if you change that as people
    # are wont to do you'll still need this if you
    # want SASL (and possible other things) to work
    # happily.
    access to dn.base="" by tls_ssf=128 ssf=128 * read
    
    # administrators and replication can read the whole tree
    access to *
           by tls_ssf=128 ssf=128 group/groupofuniquenames/uniquemember="cn=administrators,dc=filmer,dc=nl" read
           by tls_ssf=128 ssf=128 dn.exact="uid=replication,ou=account,dc=filmer,dc=nl" read
           by tls_ssf=128 ssf=128 * none
    
    # Enable ssl encryption
    TLSCACertificateFile /etc/ldap/certs/DigiCertCA.crt
    TLSCertificateFile /etc/ldap/certs/star_filmer_nl.crt
    TLSCertificateKeyFile /etc/ldap/certs/star_filmer_nl.key
    TLSCipherSuite HIGH

Copy the certificate files mentioned above to /etc/ldap/certs/. When downloading the certificate from DigiCert use the one for ldap.filmer.nl, although there are more wildcard certificates this one has been created for the LDAP service.

Restart slapd

    /etc/init.d/slapd restart

## Populate database  

Create a file base.ldif with the base tree:

    dn: dc=filmer, dc=nl
    objectclass: dcObject
    objectclass: organization
    o: filmer Internet bv
    dc: filmer
    
    dn: ou=account,dc=filmer,dc=nl
    ou: account
    objectClass: top
    objectClass: organizationalUnit
    description: Unix accounts
    
    dn: ou=group,dc=filmer,dc=nl
    objectClass: top
    objectClass: organizationalUnit
    ou: group
    description: Unix groups
    
    dn: ou=host,dc=filmer,dc=nl
    ou: host
    objectClass: top
    objectClass: organizationalUnit
    description: Hosts not in DNS
    
    dn: cn=administrators,dc=filmer,dc=nl
    objectClass: groupOfUniqueNames
    cn: administrators
    uniqueMember: uid=mark,ou=account,dc=filmer,dc=nl
    uniqueMember: uid=andries,ou=account,dc=filmer,dc=nl
    uniqueMember: uid=jaapjan,ou=account,dc=filmer,dc=nl
    description: System administators
    
    dn: uid=samba,ou=account,dc=filmer,dc=nl
    objectClass: person
    objectClass: uidObject
    uid: samba
    description: Account used by Samba servers to access user passwords
    cn: samba
    sn: samba
    userPassword: {SSHA}secret
    
    dn: uid=nss_pam,ou=account,dc=filmer,dc=nl
    objectClass: person
    objectClass: uidObject
    uid: nss_pam
    description: Account used by NSS and PAM servers to access user passwords
    cn: nss_pam
    sn: nss_pam
    userPassword: {SSHA}secret
    
    dn: uid=accountadmin,ou=account,dc=filmer,dc=nl
    objectClass: person
    objectClass: uidObject
    uid: accountadmin
    description: Account used by script that adds/removes accounts
    cn: accountadmin
    sn: accountadmin
    userPassword: {SSHA}secret
    
    dn: uid=replication,ou=account,dc=filmer,dc=nl
    objectClass: person
    objectClass: uidObject
    uid: replication
    description: Account used for replication
    cn: replication
    sn: replication
    userPassword: {SSHA}
    
    dn: cn=files.local.filmer.nl,ou=host,dc=filmer,dc=nl
    objectClass: top
    objectClass: ipHost
    objectClass: device
    ipHostNumber: 192.168.2.4
    cn: files.local.filmer.nl
    cn: files.local

The passwords can be created using this command:

    slappasswd -s secret

Populate the LDAP directory using this command (replace rootpw with the rootpw defined in slapd.conf)

    ldapadd  -x -D "cn=admin,dc=filmer,dc=nl" -W -f base.ldif -c -Z

In the same way create the groups

    dn: cn=staff,ou=group,dc=filmer,dc=nl
    objectClass: posixGroup
    cn: staff
    gidNumber: 50
    
    dn: cn=sales,ou=group,dc=filmer,dc=nl
    objectClass: posixGroup
    cn: sales
    gidNumber: 501
    memberUid: andries
    memberUid: anja

If you want to change te group (add or remove a sales member) you have to delete the cn for sales (use rootpw password)

    ldapdelete -x -D "cn=admin,dc=filmer,dc=nl" -W "cn=sales,ou=group,dc=filmer,dc=nl" -Z

When everything works disable rootpw in /etc/ldap/slapd.conf and restart slapd.

## Replica server 
On a replica server copy the slapd.conf of the provider (master), remove

    # for replication
    moduleload syncprov
    overlay syncprov
    syncprov-checkpoint 100 10
    syncprov-sessionlog 200

And add

    syncrepl rid=1
           provider=ldap://ldap.filmer.nl
           type=refreshAndPersist
           searchbase="dc=filmer,dc=nl"
           filter="(objectClass=*)"
           sizelimit=unlimited
           retry="60 10 300 10"
           scope=sub
           schemachecking=off
           bindmethod=simple
           binddn="uid=replication,ou=account,dc=filmer,dc=nl"
           credentials="rW8dn4Ancopw"
           starttls=critical

Make sure /etc/ssl/certs/TrustedRoot.crt exists and that it is defined in /etc/ldap/ldap.conf:

    TLS_CACERT /etc/ssl/certs/TrustedRoot.crt
    TLS_REQCERT demand


## Ubuntu >=8.04 & Debian >=Lenny  

Newer Debian (-based) releases have openldap compiled against gnutls instead of openssl. Some important changes:

*You have to remove 'TLSCipherSuite HIGH' from slapd.conf, gnutls doesn't support cipher suites like HIGH, LOW and MEDIUM.
*Remove the TLSCACertificateFile line from slapd.conf, and add the contents of DigiCertCA.crt to star_filmer_nl.crt (after the original certificate, on a new line). If you also have a file DigiCertCA2.crt also add this to star_filmer_nl.crt, below the contents of DigiCertCA.crt. The certificate in DigiCertCA2.crt, together with DigiCertCA.crt is used for Digicert's 2048 bits root certificate. According to DigiCert these two certificates are not merged to retain compatibility with old browsers that only know their 1024 bits root certificate.
*When using dc=filmer,dc=nl as base (and we do that) you'll have to add the acl

    access to dn.base="dc=filmer,dc=nl"
  by tls_ssf=128 ssf=128 * read

Bug https://bugs.launchpad.net/ubuntu/hardy/+source/openldap2.3/+bug/244925. Gnutls returns the key strength in bytes, slapd expects it in bits. The ssf reported by slapd is thus a factor 8 too low (usually 32 instead of 256). This breaks the acl's using 'tls_ssf=128 ssf=128'. Changing this to 'tls_ssf=32 ssf=32' solves the problem, but a bug fix is on it's way in Ubuntu 8.04. At the moment of writing you can install slapd from the 'proposed' repository:
**Add '#deb http://archive.ubuntu.com/ubuntu/ hardy-proposed restricted main universe' to /etc/apt/sources.list
**apt-get install slapd
**comment the hardy-proposed line in /etc/apt/sources.list
* It's nice to put the certificates in /etc/ssl/certs/ and /etc/ssl/private. But openldap must be able to read /etc/ssl/private/star_filmer_nl.key:

    apt-get install ssl-cert # this will create the directories with the right permissions, and it creates the group ssl-cert
    adduser openldap ssl-cert
    chown root:ssl-cert private

Place star_filmer_nl.key in /etc/ssl/private and star_filmer_nl.crt in /etc/ssl/certs. Then do
    chown openldap:openldap /etc/ssl/private/star_filmer_nl.key

## Samba server 

Add to smb.conf
    security = user
    passdb backend = ldapsam:ldap://ldap.filmer.nl
    ldap ssl = start tls
    ldap suffix = dc=filmer,dc=nl
    ldap user suffix = ou=account
    ldap group suffix = ou=group
    # FYI, the password for this user is stored in
    # /etc/samba/secrets.tdb.  It is created by running
    # 'smbpasswd -w passwd'
    ldap admin dn = uid=samba,ou=account,dc=filmer,dc=nl

And provide samba with it's password using this command

    smbpasswd -w passwd

To ldap.conf add this info, it seems like there is no other way to provide Samba with the TLS cacert:

    BASE    dc=filmer,dc=nl
    URI     ldap://ldap.filmer.nl
    
    TLS_CACERT /etc/ssl/certs/TrustedRoot.crt
    TLS_REQCERT demand


## Tips  

ACL's must not contain comments! They will break! Also be careful with newlines, tabs, comments, etc. in LDIF. [create_ldap_accounts.pl](create ldap accounts.pl) will only add and update accounts, it doesn't delete them. You have to do this manually.
