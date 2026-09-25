# SailSCQ

SailSCQ (Paket `harbour-sailscq`) ist eine Sailfish-OS-App für
Soundcore-Kopfhörer, -Earbuds und -Lautsprecher: Geräuschunterdrückung,
Equalizer, Tastenbelegung, Akkustände, Lautstärkebegrenzung und mehr.

SailSCQ ist eine inoffizielle Oberfläche für das Kommandozeilenprogramm
[OpenSCQ30](https://github.com/Oppzippy/OpenSCQ30), das mit der App
ausgeliefert wird. Nicht mit Anker oder Soundcore verbunden.

## Lizenz

SailSCQ steht unter der **GNU General Public License v3.0 oder später**
(GPL-3.0-or-later), siehe [LICENSE](LICENSE).

Mitgelieferte Fremdbestandteile:

- `bin/aarch64/openscq30`: OpenSCQ30-CLI von Kyle Scheuing,
  GPL-3.0-or-later, unveränderte Binärdatei aus den offiziellen Releases
  (Version in `bin/aarch64/VERSION`). Quellcode:
  https://github.com/Oppzippy/OpenSCQ30
- `qml/components/Strings.js`: Namen der Einstellungen, erzeugt aus den
  Übersetzungsdateien von OpenSCQ30 (`lib/i18n`), GPL-3.0-or-later.

## Umstieg von harbour-openscq30

Bis Version 0.10 hieß die App `harbour-openscq30`. Das neue Paket ersetzt das
alte bei der Installation automatisch. Weil sich der Datenordner ändert
(`org.openscq30/openscq30` → `org.sailscq/sailscq`), sind die gekoppelten
Geräte danach nicht mehr eingetragen. Entweder neu hinzufügen oder die
Datenbank übernehmen, bevor SailSCQ das erste Mal startet:

```
mkdir -p ~/.local/share/org.sailscq/sailscq
cp ~/.local/share/org.openscq30/openscq30/database.sqlite \
   ~/.local/share/org.sailscq/sailscq/
```

## Aufbau

Die App benutzt die offizielle `openscq30`-CLI (v2.12.0, Rust) als Backend und
ruft sie für jede Aktion mit `--json` auf.

```
src/
  harbour-sailscq.cpp   main(), registriert "openscq30" und "bluetooth" im QML-Kontext
  openscq30cli.*          startet die CLI per QProcess, Warteschlange, Timeout, JSON-Parsing
  bluetoothdevices.*      liest gekoppelte Geräte aus BlueZ (D-Bus)
qml/
  harbour-sailscq.qml   ApplicationWindow
  pages/
    DeviceSelectionPage   openscq30 paired-devices list
    AddDevicePage         Bluetooth-Gerät oder MAC wählen, Demo-Modus
    ModelSelectionPage    openscq30 list-models / paired-devices add
    SupportedDevicesPage  alle unterstützten Modelle, nach Bauform gruppiert
    AboutPage / LicensePage  Info-Seite und vollständiger Lizenztext
    DevicePage            Verbinden, Kategorien anzeigen
    CategoryPage          Einstellungen einer Kategorie
  components/
    DeviceSession         Zustand eines Geräts (Struktur, Werte, Schreibvorgänge)
    SettingItem           passendes Silica-Element je Einstellungstyp
    EqualizerEditor       Schieberegler je Band + "Übernehmen"
    CliRunner             einzelner CLI-Aufruf aus QML
    DeviceTile            Gerätezeichnung je Bauform (In-Ear, Hülle, Over-Ear, Lautsprecher)
    BatteryRow            Akkustand links/rechts/Hülle
    Strings.js            Namen der Einstellungen (en/de, aus OpenSCQ30-i18n)
images/                   Gerätezeichnungen (farbig, Glas-Look aus dem Mockup)
bin/aarch64/openscq30     offizielle CLI aus den OpenSCQ30-Releases (siehe VERSION)
tools/update-cli.sh       lädt ein neues CLI-Release herunter und prüft es
```

Die Seiten sind generisch: `openscq30 device -a MAC list-settings --json`
liefert alle Einstellungen samt Typ (`toggle`, `select`, `optionalSelect`,
`modifiableSelect`, `multiSelect`, `i32Range`, `equalizer`, `information`,
`importString`, `action`), daraus wird die Oberfläche gebaut. Neue Modelle in
künftigen CLI-Versionen funktionieren daher ohne Änderungen am QML.

Jeder CLI-Aufruf baut eine eigene Bluetooth-Verbindung auf (einige Sekunden).
Deshalb werden alle Aufrufe nacheinander ausgeführt, und nach jedem `--set`
werden im selben Aufruf alle Werte per `--get` neu gelesen.

## Bauen

Die OpenSCQ30-CLI liegt nicht im Git-Repository. Nach dem Klonen einmal
herunterladen (Version aus `bin/aarch64/VERSION`, Signatur wird geprüft):

```
tools/update-cli.sh "$(cat bin/aarch64/VERSION)"
```

Dann bauen:

```
sfdk config target=SailfishOS-5.1.0.11-aarch64
sfdk build
sfdk deploy --sdk          # oder das RPM aus RPMS/ auf das Gerät kopieren
```

Nur aarch64: Die mitgelieferte CLI ist eine aarch64-Binary (`ExclusiveArch`
in der Spec). Für armv7hl oder den i486-Emulator muss die CLI für diese
Architektur gebaut und nach `bin/<arch>/openscq30` gelegt werden, danach die
Architektur in `ExclusiveArch` ergänzen.

CLI aktualisieren: Die CLI stammt aus den offiziellen Releases
(https://github.com/Oppzippy/OpenSCQ30/releases, Datei
`openscq30-cli-linux-arm64`). Das Skript

```
tools/update-cli.sh           # neuestes Release
tools/update-cli.sh v2.12.0   # bestimmtes Release
```

lädt sie herunter, prüft die GPG-Signatur des Entwicklers (Schlüssel
58A1 B3E7 0481 7B87 78CB B86B 72CE 2DDC DA12 B906, wie auf den Release-Seiten
angegeben) und legt sie nach `bin/aarch64/openscq30` (Version steht in
`bin/aarch64/VERSION`). Benötigt `curl` und `gpg`, nicht die GitHub-API.
Danach Version in der Spec erhöhen und neu bauen. Die CLI benötigt
glibc ≥ 2.34 und libdbus-1.

## Testen

1. Kopfhörer in den Sailfish-Bluetooth-Einstellungen koppeln und verbinden.
2. App öffnen → nach unten ziehen → „Gerät hinzufügen“ → Gerät wählen → Modell wählen.
3. Gerät antippen.

Ohne Kopfhörer: beim Hinzufügen „Demo-Modus“ einschalten, beliebige MAC
eingeben (z. B. `00:00:00:00:00:01`).

Logs ansehen:

```
devel-su journalctl -f | grep -i openscq30
```

Die CLI lässt sich auch direkt auf dem Gerät testen:

```
OPENSCQ30_DATABASE_PATH=~/.local/share/org.sailscq/sailscq/database.sqlite \
  /usr/share/harbour-sailscq/bin/openscq30 paired-devices list --json
```

Für die Entwicklung kann per `OPENSCQ30_CLI=/pfad/zu/openscq30` eine andere
CLI verwendet werden.

## Start

Beim Start öffnet die App direkt das zuletzt benutzte Gerät. Ist es nicht
erreichbar, wechselt sie zur Geräteverwaltung und zeigt dort einen Hinweis.

## Akkustände

Viele Soundcore-Geräte melden den Akku nur in 5 Stufen (z. B. die Liberty 4 NC:
0, 20, 40, 60, 80, 100 %). Die Akkuleiste zeigt deshalb Segmente. Die App
liest die Werte alle 2 Minuten neu, solange sie offen ist, und sofort, wenn
man in die App zurückkehrt; im Hintergrund übernimmt das Cover (höchstens
einmal pro Minute, nur wenn es sichtbar ist).

## Cover

Das Cover zeigt Gerät, Sound-Modus und Akkustände und hat zwei Aktionen:
Aktualisieren und nächster Sound-Modus. Es nutzt das Gerät der offenen
Geräteseite oder, wenn keine offen ist, das zuletzt geöffnete Gerät
(gespeichert in `~/.config/org.sailscq/sailscq/settings.ini`). Die
Verbindung wird erst aufgebaut, wenn das Cover sichtbar ist, danach werden
die Werte höchstens einmal pro Minute gelesen.

## Sandbox (Sailjail)

`harbour-sailscq.desktop` fordert `Permissions=Bluetooth` an. Die Datenbank
liegt in `~/.local/share/org.sailscq/sailscq/`.

Falls „Verbindung fehlgeschlagen“ erscheint, obwohl die CLI direkt im
Terminal funktioniert, blockiert vermutlich die Sandbox die RFCOMM-Verbindung
(die CLI registriert ein Bluetooth-Profil bei BlueZ). Zum Test in der
`.desktop`-Datei unter `[X-Sailjail]` `Sandboxing=Disabled` setzen.

## Harbour / Jolla Store

Die App ist eher für OpenRepos oder Chum gedacht. Eine separat ausgelieferte
Binary und der direkte Bluetooth-Zugriff sind im Jolla Store problematisch.
