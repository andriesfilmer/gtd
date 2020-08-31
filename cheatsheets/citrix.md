## Citrix Client op Ubuntu

Download Tarball for [Citrix Workspace for Linux](https://www.citrix.com/nl-nl/downloads/workspace-app/linux/workspace-app-for-linux-latest.html)

   cd ./Downloads
   tar -xzf linuxx64-xx.xxx.tar.gz .
   sudo ./setupwfc

Installation Directory `/opt/Citrix/ICAClient`

## Certificates

If you make a connection with your browser you might get the following error: ''(make sure it's not in the background)''

You have not chosen to trust "addTrust external CA Root", the issuer of the server's security certificate (SSL error 61)
The Citrix client complains about some missing certificates.

    cp /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/

## x86 client - requires OpenMotif

    sudo apt-get install libmotif3

