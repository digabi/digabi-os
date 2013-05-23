digabi livecd
================================
Sähköisen ylioppilastutkinnon päätelaiteasennuksen testialusta.

## Yhteystiedot
* http://digabi.fi/
* https://github.com/digabi/digabi-live
* email: digabi@ylioppilastutkinto.fi

## Vaatimukset
    apt-get install live-helper

Suositeltavaa käyttää esim. `apt-cacher-ng` -pakettivälimuistia, mikäli käännösoperaatioita on useita.

## Levyn kääntäminen
Versionumeron valintaan käytetään `git describe` -komentoa. Versionumero haetaan git:n tagista.
    make dist

### Uuden tagin luominen
    git tag -a 1.0 -m "Created tag for version 1.0"


## Sekalaista
Tällä hetkellä rakennusympäristöstä on seuraavat oletukset:
* virtuaalikone
* isäntäkoneelta jaettu hakemisto johon voidaan kirjoittaa, on mountattu /public ; tämän alta löytyy alihakemisto www, joka julkaistaan www-palvelimella

## Lisenssitiedot
Toteutus pohjautuu Debianin pakettikirjastoon, ja sisällytetyt ohjelmat käyttävät lukuisia erilaisia lisenssejä. Kaikki lisenssitiedot löydät osoitteesta [Debianin kotisivuilta](http://www.debian.org/legal/licenses/).
