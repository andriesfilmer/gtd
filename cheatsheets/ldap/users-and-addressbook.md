# LDAP Server - Users and Addressbook

This article explains howto create a LDAP Server which can be used for users (accounts) to login and as addressbook (Thunderbird, Evolution, etc). The accounts and addressbook are seperate organisation units (ou). It is installed on Ubuntu server (Intrepid 8.10). We use the new style config format (cn=config) instead of ''slapd.conf''. In this article we use ''filmer.nl'' as domainname, so change this to your domainname.

## Install openldap 
    apt-get install openldap

    sudo dpkg-reconfigure slapd

Aswer the following questions:

* Omit OpenLDAP server configuration? -> '''''No'''''
* DNS domain name: -> '''''filmer.nl'''''
* Organization name: -> '''''people'''''
* Database backend to use: -> '''''hdb'''''
* Do you want the database to be removed when slapd is purged? -> '''''Yes'''''
* Move old database? -> '''''Yes'''''
* Administrator password: -> '''''secretpassword'''''
* Allow LDAPv2 protocol? -> '''''Yes'''''

You have configured a entry which you can see with:
    ldapsearch -xLLL -b "dc=filmer,dc=nl"

Output:

    dn: dc=filmer,dc=nl
    objectClass: top
    objectClass: dcObject
    objectClass: organization
    o: people
    dc: filmer
    
    dn: cn=admin,dc=filmer,dc=nl
    objectClass: simpleSecurityObject
    objectClass: organizationalRole
    cn: admin
    description: LDAP administrator

## Add the base tree 
Create a file ''base.ldif' as base tree. The ''contacts Organisation Unit (ou)'' can be used for addressbook and the ''accounts Organisation Unit (ou)'' for unix users.

    dn: ou=contacts,dc=filmer,dc=nl
    objectClass: organizationalUnit
    ou: contacts
    
    dn: ou=accounts,dc=filmer,dc=nl
    objectClass: organizationalUnit
    ou: accounts
    
    dn: cn=contactadmin,dc=filmer,dc=nl
    objectClass: simpleSecurityObject
    objectClass: organizationalRole
    cn: contactadmin
    description: Account used by script that add/modify/removes contacts
    userPassword: {SSHA}V9aHVzB7eekUL6OCUlRUHzYL8Qv42zrb
    
    dn: cn=contactread,dc=filmer,dc=nl
    objectClass: simpleSecurityObject
    objectClass: organizationalRole
    cn: contactread
    description: Account that can be used for addressbook
    userPassword: {SSHA}MSKYx7tdPf5hP6Yk5LjVxrNmTjdt3uu6
    
    dn: cn=accountadmin,dc=filmer,dc=nl
    objectClass: simpleSecurityObject
    objectClass: organizationalRole
    cn: accountadmin
    description: Account used by script that add/modify/removes accounts
    userPassword: {SSHA}fWy/8BLobxtyL6FzruMMGBvCA40bkBtg
    
    dn: cn=accountread,dc=filmer,dc=nl
    objectClass: simpleSecurityObject
    objectClass: organizationalRole
    cn: accountread
    description: Account used by NSS and PAM servers to access user passwords
    userPassword: {SSHA}pCHBQO/F7h2H004M+zJylgR7yv9wio58

Note: You can create SSHA passwords with ''slappasswd -s secretpassword''.

To add the base tree to the LDAP directory use the ldapadd utility:

    ldapadd -x -D cn=admin,dc=filmer,dc=nl -W -f base.ldif 


## Access Control List (ACL) 
To view the Access Control List (ACL), use the ldapsearch utility: 
    ldapsearch -xLLL -b cn=config -D cn=admin,cn=config -W olcDatabase=hdb olcAccess

Create a acl.ldif file:

    dn: olcDatabase={1}hdb,cn=config
    changetype: modify
    delete: olcAccess
    olcAccess: to * by dn="cn=admin,dc=filmer,dc=nl" write by * read
    -
    # Acl's on contacts
    add: olcAccess
    olcAccess: to dn.subtree="ou=contacts,dc=filmer,dc=nl"
      by dn="cn=admin,dc=filmer,dc=nl" write
      by dn="cn=contactadmin,dc=filmer,dc=nl" write
      by dn="cn=contactread,dc=filmer,dc=nl" read
      by * none
    # Acl's for accounts
    olcAccess: to dn.subtree="ou=accounts,dc=filmer,dc=nl"
      by dn="cn=admin,dc=filmer,dc=nl" write
      by dn="cn=accountadmin,dc=filmer,dc=nl" write
      by dn="cn=accountread,dc=filmer,dc=nl" read
      by anonymous auth
      by self write
      by * none
    # Acl's for write for admin and search tree for others
    olcAccess: to * by dn="cn=admin,dc=filmer,dc=nl" write 
      by dn="cn=contactadmin,dc=filmer,dc=nl" search
      by dn="cn=contactread,dc=filmer,dc=nl" search
      by dn="cn=accountadmin,dc=filmer,dc=nl" search
      by dn="cn=accountread,dc=filmer,dc=nl" search
      by * none

Add the ACL to ldap config:

    ldapmodify -v -x -D cn=admin,cn=config -W -f acl.ldif

## Add a unix account 

Create a file ''piet.account.filmer.nl.ldif'. This is a example account.

    dn: uid=piet,ou=accounts,dc=filmer,dc=nl
    objectClass: inetOrgPerson
    objectClass: posixAccount
    objectClass: shadowAccount
    uid: piet
    sn: Filmer
    givenName: Piet
    cn: Andries Filmer
    displayName: Andries Filmer
    uidNumber: 1000
    gidNumber: 100
    userPassword: {SSHA}H96ohERwA+SMLk8LA6qU2PSazDcaqsSb
    loginShell: /bin/bash
    homeDirectory: /home/piet
    mail: piet@filmer.nl

To add this account to the LDAP directory:

    ldapadd -x -D cn=accountadmin,dc=filmer,dc=nl -W -f andries.contacts.filmer.nl.ldif 


## Add a contact 
Create a file ''andries.account.filmer.nl.ldif'. This is a example contact.

    dn: cn=andries,ou=contacts,dc=filmer,dc=nl
    objectClass: inetOrgPerson
    objectclass: evolutionPerson
    sn: Filmer
    givenName: Andries
    cn: Andries
    displayName: Andries Filmer
    mail: andries@filmer.nl
    postalAddress: Brederodestraat 132
    postalCode: 2042 NB
    l: Zandvoort
    o: iGroupware
    mobile: +31 (0)6 xx xx xx xx
    homePhone: +31 (0)6 xx xx xx xx
    title: System Administrator
    initials: AF
    
To add this contact to the LDAP directory:

    ldapadd -x -D cn=contactsadmin,dc=filmer,dc=nl -W -f andries.account.filmer.nl.ldif 

## Add Schema for Evolution 

If you want to use evolution -> ''contacts'' wich you can '''read and write''' you need to add a additional schema, slapd new style format requires the schema to be converted to LDIF format. Fortunately, the slapd program can be used to automate the conversion. The following example will create ldif format schema's. We create all schema's but we only add the evolutionperson.schema because the are already in the config tree.

Create a conversion schema_convert.conf file containing the following lines:
    include /etc/ldap/schema/core.schema
    include /etc/ldap/schema/collective.schema
    include /etc/ldap/schema/corba.schema
    include /etc/ldap/schema/cosine.schema
    include /etc/ldap/schema/duaconf.schema
    include /etc/ldap/schema/dyngroup.schema
    include /etc/ldap/schema/inetorgperson.schema
    include /etc/ldap/schema/java.schema
    include /etc/ldap/schema/misc.schema
    include /etc/ldap/schema/nis.schema
    include /etc/ldap/schema/openldap.schema
    include /etc/ldap/schema/ppolicy.schema
    include [/etc/ldap/schema/evolutionperson.schema](/pub/scripts/ldap/evolutionperson.schema)

Next, create a temporary directory to hold the output:
     mkdir /tmp/ldif_output

Now using slaptest convert the schema files to LDIF:
    slaptest -f schema_convert.conf -F /tmp/ldif_output

Adjust the configuration file name and temporary directory names if yours are different. Also, it may be worthwhile to keep the ldif_output directory around in case you want to add additional schemas in the future.

Edit the /tmp/ldif_output/cn=config/cn=schema/cn={12}evolutionperson.ldif file, changing the following attributes:

    dn: cn=evolution,cn=schema,cn=config
    ...
    cn: misc

And remove the following lines from the bottom of the file:

    structuralObjectClass: olcSchemaConfig
    entryUUID: 10dae0ea-0760-102d-80d3-f9366b7f7757
    creatorsName: cn=config
    createTimestamp: 20080826021140Z
    entryCSN: 20080826021140.791425Z#000000#000#000000
    modifiersName: cn=config
    modifyTimestamp: 20080826021140Z

''[Note] The attribute values will vary, just be sure the attributes are removed''.

Finally, using the ldapadd utility, add the new schema to the directory:

     ldapadd -x -D cn=admin,cn=config -W -f [/tmp/ldif_output/cn=config/cn=schema/cn={12}evolutionperson.ldif](/pub/scripts/ldap/evolutionperson.ldif)

''There should now be a dn: cn={12}evolutionperson,cn=schema,cn=config entry in the cn=config tree''.

## Usage 

To view and modify the ldapserver with a LDAP GUI client you can install '''Luna'''

    sudo apt-get install luna

### ldapsearch 

View the ldap config
    ldapsearch -xLLL -b cn=config -D cn=admin,cn=config -W olcDatabase={1}hdb

Search all accounts
    ldapsearch -xLLL -b "ou=accounts,dc=filmer,dc=nl" -D "cn=accountread,dc=filmer,dc=nl" -W 

Search and view uid andries commonname
    ldapsearch -xLLL -b "ou=accounts,dc=filmer,dc=nl" -D "cn=accountread,dc=filmer,dc=nl" -W uid=andries cn

### ldapmodify 
;Example to modify ''contact'' andries

Create a file andries.contact.filmer.nl-modify.ldif

    dn: uid=andries,ou=contacts,dc=filmer,dc=nl
    changetype: modify
    replace: postalCode
    postalCode: 2042 BK
    -
    replace: l
    l: Zandvoort aan Zee
    -
    replace: o
    o: Internet Groupware
    -
    replace: mobile
    mobile: +31 (0)6 54621734

    ldapmodify -x -D cn=contactadmin,dc=filmer,dc=nl -W -f andries.contacts.filmer-modified.ldif 

### ldapdelete 

;Delete account piet

    ldapdelete -x -h ldap.filmer.nl -D cn=contactadmin,dc=filmer,dc=nl -W "cn=piet,ou=accounts,dc=filmer,dc=nl"

;Delete all accounts 
First create file with all DistinguishedNames (dn). ''With sed we cut off 'dn:' ''

    ldapsearch -xLLL -s one -b "ou=accounts,dc=filmer,dc=nl" -D cn=accountadmin,dc=filmer,dc=nl -W 
     dn | sed 's/....(.*)/1/' > /tmp/accounts-to-delete.ldif

Then delete the accounts 
    ldapdelete -x -c -D cn=accountadmin,dc=filmer,dc=nl  -W -f /tmp/accounts-to-delete.ldif

### ldapadd 

    ldapadd -x -D cn=accountadmin,dc=filmer,dc=nl -W -f accounts.ldif 

## Resources 

* [Intro to LDAP - brief explain off ldap](http://www.ldapman.org/articles/intro_to_ldap.html)
* [Configuring slapd](http://www.openldap.org/doc/admin24/slapdconf2.html)
* [Object Classes and Attributes](http://www.zytrax.com/books/ldap/ape/)
* [mappings](http://docs.sun.com/source/806-4251-10/mapping.htm)
* [main source for this article](https://help.ubuntu.com/8.10/serverguide/C/openldap-server.html)
