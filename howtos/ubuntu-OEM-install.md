## Ubuntu OEM install

Als je Ubuntu wilt installeren voor iemand anders en hij is niet bij de installatie aanwezig. Dan weet je meestal ook zijn gewenste '''gebruikersnaam, login, wachtwoord, taal en toetsenbord voorkeur''' niet. Je kan dan een OEM installatie doen.

Na een OEM installatie krijgt de nieuwe gebruiker een wizzard te zien en die hoeft dan maar een paar vragen beantwoorden, zoals:

- **In het 'Welkom' scherm***
 - Kies uw taal (Standaard: Nederlands)
- **In het scherm 'Waar bevindt u zich**
 - Kies uw lokatie (Standaard: Amsterdam)
- '''In het scherm 'Toetsenbordindeling''''
 - Kies uw toetsenbordindeling (Standaard: Engels - internationaal met dode toetsen)
- **In het scherm 'Wie bent u?**
 - Uw naam
 - De naam voor uw computer
 - Kies een gebruikersnaam
 - Kies een wachtwoord
 - Wachtwoord herhalen
 - Automatische aanmelden
 - Mijn wachtwoord vragen om aan te melden (Standaard: aan)
 - Mijn persoonlijke map versleutelen
- **In het scherm 'Kies een afbeelding'**
 - Hier mag de gebruiker een icoon kiezen voor het inlog scherm.

Daarna wordt alles opgeruimd (dit kan even duren) en is de computer klaar voor gebruik. Erg gebruikers vriendelijk!

## Een OEM installatie voorbereiden 
Boot de computer van een Ubuntu installatie medium (cd of usb). Bij het onderstaande '''Splash screen''' druk je op F4.
![Ubuntu Splash screen](http://content.filmer.net/pim/posts/79/ubuntu-12.04-boot-splashscreen.png)

Daarna selecteer je de 'OEM install' en kies je met de pijltjes 'install Ubuntu' en drukt op enter.

![Ubuntu OEM options](http://content.filmer.net/pim/posts/79/ubuntu-12.04-oem-option.png)

Na het opstarten krijg je een '''welkom''' scherm (zie hieronder). Daar kies je bijvoorbeeld 'Nederlands' en vul je een naam in ''(jouw naam of een bedrijfsnaam)'' en doe je de verdere installatie.

![Ubuntu OEM informatie](http://content.filmer.net/pim/posts/79/ubuntu-12.04-OEM-install.png)

Bij het scherm '''Wie bent u?''' vul je een tijdelijk wachtwoord in ''(even onthouden voor later)''.

![Ubuntu OEM wachtwoord](http://content.filmer.net/pim/posts/79/ubuntu-12.04-OEM-who.png)

## Prepare for shipment to end user

Na het installeren en een reboot kan je de gewenste aanpassingen maken en extra pakketten installeren.

Daarna klik je op de icon "prepare for shipment to end user" die op het bureaublad staat of via de terminal ''sudo oem-config-prepare'' en de computer is klaar voor de eindgebruiker

Meer info:

* http://www.logicsupply.com/blog/2012/03/21/how-to-create-a-custom-ubuntu-12-04-installation-image/
* http://ubuntuforums.org/showthread.php?t=1884055

