## Citrix Client op Ubuntu

Als je voor je werk met een Citrix-client een connectie wilt maken wordt er, via het adres waar je moet inloggen, een 'Citrix-Client ter download aangeboden (linuxx86-11.xxx.xxx.tar.gz. Dit bestand moet je eerst uitpakken en installeren.

## De Citrix-client installeren.

Open een terminal en ga naar de directorie waar je deze hebt uitgepakt. Bijvoorbeeld:
    cd $USER/Downloads/

Voor daarna het onderstaande commando uit en volg de instructies in het scherm om de client te installeren.
    ./setupwfc

Als je dan met Firefox een connectie maakt kan het zijn dat je de volgende error krjigt:<br>''(let op dat deze niet op de achtergrond staat)''

## You have not chosen to trust "addTrust external CA Root", the issuer of the server's security certificate (SSL error 61)


Open dan een terminal en voer het volgende commando uit.

    sudo cp /usr/share/ca-certificates/mozilla/* /home/''path-to-application''/ICAClient/linuxx86/keystore/cacerts/ 

## x86 client - requires OpenMotif v.2.3.1

    sudo apt-get install libmotif3

Daarna kon ik wel een verbinden maken.
