# XML Starlet - XMLStarlet

## Define shortcut for parsing HTML pages

    wx() { wget -q -O - "${1}" | xmlstarlet fo -Q -H; }

## KNMI
Verwachting Vandaag & morgen

    wget -q -O - http://www.knmi.nl/nederland-nu/weer/verwachtingen
    | xmlstarlet fo -o -Q -H -D
    | awk '/<body/,/</body>/'
    | xmlstarlet sel -t -m  '//div[@class="weather__text media__body"]'
    -v 'p[2]' -o $'
    ' -v 'p[3]' -o $'
    ' -v 'p[4]'

Or

    wget -q -O - http://www.knmi.nl/nederland-nu/weer/verwachtingen
    | xmlstarlet fo -o -Q -H
    | xmlstarlet fo -o --recover
    | xmlstarlet sel -t -m  '//div[@class="weather__text media__body"]' -v 'p[2]'

Or with defined shortcut

    wx http://www.knmi.nl/nederland-nu/weer/verwachtingen
    | xmlstarlet fo -o --recover
    | xmlstarlet sel -t -m  '//div[@class="weather__text media__body"]' -v 'p[2]'

## Nos nieuws

Get news title and paragraph

    wx http://nos.nl/nieuws/
    | xmlstarlet sel -t -m '//div[@class="list-left-content link-reset "]'
    -v 'h3' -o $'
    ' -v 'p' -o $'

## Documentation

[XmlStarlet Command Line XML Toolkit User's Guide](http://xmlstar.sourceforge.net/doc/UG/xmlstarlet-ug.html)


