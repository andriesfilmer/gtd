- [Ubuntu tips en truuks (NL)](#ubuntu-tips-en-truuks-nl)
  * [LibreOffice](#libreoffice)
    + [LibreOffice en PDF](#libreoffice-en-pdf)
    + [LibreOffice en Microsoft Office gebruikers](#libreoffice-en-microsoft-office-gebruikers)
  * [Speciale tekens](#speciale-tekens)
  * [Sneltoetsen](#sneltoetsen)
  * [Automatisch aanmelden aanzetten](#automatisch-aanmelden-aanzetten)
  * [Hoge Resolutie schermen](#hoge-resolutie-schermen)
    + [Display scalling](#display-scalling)
    + [Firefox](#firefox)
    + [Thunderbird](#thunderbird)
    + [Spotify](#spotify)
  * [Tools niet standaard geïnstalleerd](#tools-niet-standaard-geinstalleerd)
    + [Spotify](#spotify-1)
    + [Bestanden down- en uploaden via FTP, FTPS, SFTP](#bestanden-down--en-uploaden-via-ftp-ftps-sftp)
    + [Afbeeldingen of foto's aanmaken en bewerken](#afbeeldingen-of-fotos-aanmaken-en-bewerken)
    + [Fotoboek maken](#fotoboek-maken)
    + [CD's rippen of omzetten naar ogg of mp3](#cds-rippen-of-omzetten-naar-ogg-of-mp3)
    + [Diagrammen maken](#diagrammen-maken)
    + [Webcam](#webcam)

<!-- END TOC -->

# Ubuntu tips en truuks (NL)

## LibreOffice

### LibreOffice en PDF

LibreOffice slaat standaard de documenten op als 'open document formaat' (odf). Omdat niet iedereen odf gebruikt is het verstandig om het document op te slaan als PDF voordat u deze uitwissel via b.v. e-mail of een USB-stick. Dit heeft tevens als voordeel dat het document niet gewijzigd kan worden. Door op het 'pdf' icoontje in de menu balk te klikken kunt u deze eenvoudig opslaan als PDF.

### LibreOffice en Microsoft Office gebruikers

Mocht u juist wel willen dat de ontvanger het document kan aanpassen en hij/zij gebruikt niet het 'open document formaat' dan is het verstandig om het document op te slaan als b.v. 'Microsoft Word 2007/2010' waardoor het document als '.doc' wordt opgeslagen. LibreOffice doet dit niet standaard omdat een .doc document een gesloten formaat is dat eigendom is van Microsoft.

Als u altijd uw documenten met LibreOffice wilt opslaan als .doc, dan kunt u dat instellen bij de tekstverwerker.
Ga naar 'Opties -> Laden/Opslaan -> Algemeen -> Altijd opslaan als -> Microsoft Word 97/2000/XP/2003'

## Speciale tekens

Een standaard querty-toetsenbord heeft te weinig toetsen voor alle karakters. Daarom zijn er trucjes nodig om speciale karakters te krijgen. De meeste eenvoudige is de toepassing 'Tekens en symbolen' te openen. Daarna het gewenste karakter te zoeken en deze te kopiëren en daarna weer in uw tekst te plakken.

Als u veel gebruik maakt van speciale karakters zijn de volgende oplossingen wellicht beter geschikt voor u.

Toetsenboord layout 'Engels (USA, international AltGR dode toetsen)'
U kunt uw toestenbord indeling wijzigen in 'Engels (USA, international AltGr dode toetsen)'. Hierdoor kunt u snel en makkelijk meerdere bijzondere karakters gebruiken. Door de toets 'Alt Gr' in gedrukt te houden (rechts naast de spatiebalk) en eventueel in combinatie met de 'Shift' toets, kunt u bijzondere karakters in uw tekst zetten. Op de afbeelding van de toestenbord lay-out (hieronder) ziet u waar de letters zich bevinden.

![Keyboard USA-International (AltGr-dead-keys)](http://content.filmer.net/pim/posts/547c605c98787f50d5aef1bd/Keyboard_USA-International_(AltGr-dead-keys).png)

**Keyboard USA International (AltGr-dead-keys)**

U kunt deze toetsenbord-indeling instellen door de toepassing 'toetsenbord-indeling' te openen. Daarna ziet u linksonder een +(plusje) waarmee u deze indeling kunt toevoegen (zoeken op: engels internationaal).

Als u karakters wilt gebruiken die niet op deze toetsenbord indeling staan kunt u met 'unicodes' alle denkbare karakters gebruiken. Zoals altcodes onder windows.

;Unicodes cq Altcodes
Op Ubuntu (en Linux in het algemeen) heeft u geen Alt-codes. In plaats daarvan kunt u werken met Unicodes, welke veel meer karakters aanbiedt. Met de toepassing "Tekens en symbolen" kunt u alle karakters vinden. Door in deze toepassing op een karakter te klikken ziet u linksonder de 'unicode' staan. U kunt de Unicode in de tekst krijgen door tergelijkertijd op "CTRL+SHIFT+u" te drukken. U ziet nu een u in uw tekst verschijnen. Type daarna de unicode in en druk op enter. U ziet daarna de u veranderen in de speciale karakter. Voorbeelden:


    'CTRL+SHIFT+u' + 00ef (voor de letter ï) en daarna 'Enter'
    'CTRL+SHIFT+u' + 00C9 (voor de letter É) en daarna 'Enter'
    'CTRL+SHIFT+u' + 00e9 (voor de letter é) en daarna 'Enter'
    'CTRL+SHIFT+u' + 00d6 (voor de letter Ö) en daarna 'Enter'
    'CTRL+SHIFT+u' + 00cb (voor de letter Ë) en daarna 'Enter'
    'CTRL+SHIFT+u' + 00eb (voor de letter ë) en daarna 'Enter'

Kijk hier voor de volledige lijst Latin Unicodes

## Sneltoetsen

Er is zijn veel sneltoetsen onder Ubuntu beschikbaar. Een sneltoets is een toetsencombinatie waar een bepaalde actie aan is verbonden, zoals het openen van uw persoonlijke map. Door de 'Super toets' (windowstoets) in gedrukt te houden zie u de meest handige sneltoetsen.

## Automatisch aanmelden aanzetten

Sommige gebruikers vinden het prettiger om automatisch aan te melden. Ik adviseer dat alleen te doen op een Desktop die privé gebruikt wordt. Dat kan eenvoudig ingesteld worden.

Via systeeminstellingen (icoon rechtsboven).
- Kies 'Gebruikersaccounts'.
- Kies 'Ontgrendelen' rechts boven.
- Kies 'Automatisch aanmelden' aanzetten.

Als er automatisch aanmelden is gekozen, dan gaat het systeem nog wel op schermbeveiliging (standaard na 10 minuten). Het is dan logisch om deze vergendeling uit te zetten. Dit doet u als volgt:

Via systeeminstellingen (icoon rechtsboven).
- Kies 'Scherm'.
- Dan 'Vergrendelen' uitzetten.


## Hoge Resolutie schermen

### Display scalling
Settings -> Display: Scale for menu and title bars: 1.25

### Firefox
about:config

set `layout.css.devPixelsPerPx: 1.25`

### Thunderbird
Prefrences -> Advanced -> Config Editor:

set `layout.css.devPixelsPerPx: 1.25`

### Spotify
Create a alias in .bashrc

    alias spotify="/usr/bin/spotify --force-device-scale-factor=1.5"

## Tools niet standaard geïnstalleerd

### Spotify
Installeer Spotify

    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2C19886
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update
    sudo apt-get install spotify-client

Als je de nieuwe (test) versie wilt, zo als ik.

    echo deb http://repository.spotify.com testing non-free | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update
    sudo apt-get install spotify-client


### Bestanden down- en uploaden via FTP, FTPS, SFTP

Een compleet FTP programma met een eenvoudige gebruikersinterface is 'FileZilla'.
Oproepen via het softwarecentrum en zoeken op: FileZilla.

### Afbeeldingen of foto's aanmaken en bewerken

U kunt eenvoudig foto's kleiner maken of foto's draaien met Nautilus (de bestanden-verkenner voor ubuntu) door in het softwarecentrum het progamma "Nautilus-image-converter" te installeren. Na het installeren eerst uit- en inloggen en u heeft dan extra opties met de rechtermuisknop ('Afbeeldingen schalen' en "Afbeeldingen draaien') als u één of meerdere afbeeldingen selecteerd.

'''Darktable''' is een fotografie toepassing die ook voor de RAW ontwikkelaar geschikt is. U kunt de foto's bekijken door middel van een zoombare lichttafel en u kunt daarmee RAW-beelden verbeteren zonder de originele foto aan te passen. Installeren via het softwarecentrum en zoeken op: Darktable.

'''Gimp'''﻿ is een geavanceerd fotobewerkingsprogramma die u kunt het gebruiken voor het bewerken, vergroten en retoucheren van foto's en scans. Installeren via het softwarecentrum en zoeken op: Gimp.

### Fotoboek maken

Niet alle programma's om fotoboeken te maken zijn geschikt voor Linux. Hieronder staan een paar mogelijkheden om fotoboeken te maken.

* Albelli en de Hema hebben een online fotoboek service waarbij je alleen een webbrowser nodig hebt.(Let hierbij op dat de foto extenties kleine letters zijn, dus .jpg ipv .JPG)
* Webprint is ook een gebruikersvriendelijk website om foto op verschillende manieren af te drukken.
* Pixum heeft software die je op linux kan installeren.
* Fotoalbum heeft software die je op linux kan installeren.
* Kruidvat heeft software die je op linux kan installeren.
* Digitale audiowerkplek
* 'Ardour'. is een multikanaal recorder naar de hardeschijf en digitaal audio werkstation (DAW). Oproepen via het softwarecentrum en zoeken op: ardour.

### CD's rippen of omzetten naar ogg of mp3

U kunt CD's rippen en eventueel omzetten naar ogg of mp3 met de toepassing 'Sound-juicer'.
Sound-juicer heeft ook CDDB waarmee u automatische de titels van de nummers mee ophaalt.
Oproepen via het softwarecentrum en zoeken op: Sound juicer.

### Diagrammen maken

Met 'Dia' kunt u diagrammen, organogrammen en schema's maken waar u met de verschillende objecten relaties kunt leggen. Installeren via het softwarecentrum en zoeken op: Dia.

### Webcam

Om uw webcam te testen of foto's mee te maken kunt u de toepassing 'Cheese' hiervoor installeren.
Installeren via het softwarecentrum en zoeken op: Cheese webcamstudio.
