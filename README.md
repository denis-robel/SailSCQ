# SailSCQ

**[English](#english) · [Deutsch](#deutsch)**

---

<a id="english"></a>
## English

SailSCQ (package `harbour-sailscq`) is a Sailfish OS app to control Soundcore
headphones, earbuds and speakers: noise canceling, equalizer, button
configuration, battery levels, volume limit and more.

SailSCQ is an unofficial user interface for the command line tool
[OpenSCQ30](https://github.com/Oppzippy/OpenSCQ30), which is bundled with the
app. Not affiliated with Anker or Soundcore.

### License

SailSCQ is licensed under the **GNU General Public License v3.0 or later**
(GPL-3.0-or-later), see [LICENSE](LICENSE).

Bundled third-party components:

- `bin/aarch64/openscq30`: OpenSCQ30 CLI by Kyle Scheuing, GPL-3.0-or-later,
  unmodified binary from the official releases (version in
  `bin/aarch64/VERSION`). Source code: https://github.com/Oppzippy/OpenSCQ30
- `qml/components/Strings.js`: setting names, generated from the OpenSCQ30
  translation files (`lib/i18n`), GPL-3.0-or-later.

### Structure

The app uses the official `openscq30` CLI (v2.12.0, Rust) as its backend and
calls it with `--json` for every action.

```
src/
  harbour-sailscq.cpp     main(), registers "openscq30" and "bluetooth" in the QML context
  openscq30cli.*          runs the CLI via QProcess: queue, timeout, JSON parsing, settings
  bluetoothdevices.*      reads paired devices from BlueZ (D-Bus)
qml/
  harbour-sailscq.qml     ApplicationWindow
  pages/
    DeviceSelectionPage   openscq30 paired-devices list
    AddDevicePage         choose a Bluetooth device or MAC address, demo mode
    ModelSelectionPage    openscq30 list-models / paired-devices add
    SupportedDevicesPage  all supported models, grouped by form factor
    AboutPage             about page, LicensePage: full license text
    DevicePage            connect, show categories
    CategoryPage          settings of one category
  components/
    DeviceSession         state of one device (structure, values, writes)
    SettingItem           matching Silica control for each setting type
    EqualizerEditor       one slider per band + "Apply"
    CliRunner             single CLI call from QML
    DeviceTile            illustration per form factor (in-ear, case, over-ear, speaker)
    BatteryRow            battery left/right/case
    BatteryIcon           battery graphic with segments and charging bolt
    Strings.js            setting names (en/de, from OpenSCQ30 i18n)
images/                   device illustrations
bin/aarch64/              official CLI from the OpenSCQ30 releases (see VERSION)
tools/update-cli.sh       downloads and verifies a new CLI release
```

The pages are generic: `openscq30 device -a MAC list-settings --json` returns
all settings with their type (`toggle`, `select`, `optionalSelect`,
`modifiableSelect`, `multiSelect`, `multiSelectWithRemove`, `i32Range`,
`equalizer`, `hueColorPicker`, `information`, `importString`, `action`), and
the UI is built from that. New models in future CLI versions therefore work
without changes to the QML.

Every CLI call opens its own Bluetooth connection (a few seconds). All calls
are therefore run one after another, and every `--set` re-reads all values
with `--get` in the same call.

### Building

The OpenSCQ30 CLI is not stored in the git repository. After cloning,
download it once (version from `bin/aarch64/VERSION`, the signature is
checked):

```
tools/update-cli.sh "$(cat bin/aarch64/VERSION)"
```

Then build:

```
sfdk config --global --push target SailfishOS-5.1.0.11-aarch64
sfdk build
sfdk deploy --sdk          # or copy the RPM from RPMS/ to the device
```

aarch64 only: the bundled CLI is an aarch64 binary (`ExclusiveArch` in the
spec). For armv7hl or the i486 emulator, build the CLI for that architecture,
put it into `bin/<arch>/openscq30` and add the architecture to
`ExclusiveArch`.

### Updating the CLI

The CLI comes from the official releases
(https://github.com/Oppzippy/OpenSCQ30/releases, file
`openscq30-cli-linux-arm64`). The script

```
tools/update-cli.sh            # latest release
tools/update-cli.sh v2.12.0    # specific release
```

downloads it, checks the developer's GPG signature (key
58A1 B3E7 0481 7B87 78CB B86B 72CE 2DDC DA12 B906, as shown on the release
pages) and puts it into `bin/aarch64/openscq30` (version in
`bin/aarch64/VERSION`). Requires `curl` and `gpg`, not the GitHub API.
Afterwards raise the version in the spec and rebuild. The CLI needs
glibc ≥ 2.34 and libdbus-1.

### Testing

1. Pair and connect the headphones in the Sailfish Bluetooth settings.
2. Open the app → pull down → "Add device" → choose the device → choose the model.
3. Tap the device.

Without headphones: switch on "Demo mode" when adding a device and enter any
MAC address (e.g. `00:00:00:00:00:01`).

Show logs:

```
devel-su journalctl -f | grep -i openscq30
```

The CLI can also be tested directly on the device:

```
OPENSCQ30_DATABASE_PATH=~/.local/share/org.sailscq/sailscq/database.sqlite \
  /usr/share/harbour-sailscq/bin/openscq30 paired-devices list --json
```

For development, `OPENSCQ30_CLI=/path/to/openscq30` selects a different CLI.

### Start

On start the app opens the last used device right away. If it cannot be
reached, the app switches to the device list and shows a hint there.

### Battery levels

Many Soundcore devices report the battery in only 5 steps (e.g. the
Liberty 4 NC: 0, 20, 40, 60, 80, 100 %), so the battery icon is split into
segments.
The charging state of each earbud is shown while it lies in the open case.
The app re-reads the values every 2 minutes while it is open and right away
when you return to it; in the background the cover does this (at most once
a minute, only while it is visible).

### Cover

The cover shows device, sound mode and battery levels and has two actions:
refresh and next sound mode. The button switches the ambient sound mode on
most models and the listening mode on the Sleep A30; the name of the switched
setting is shown above its value. Models without sound modes only get the
refresh action. It uses the device of the open device page or,
if none is open, the last opened device (stored in
`~/.config/org.sailscq/sailscq/settings.ini`). The connection is only made
while the cover is visible; afterwards the values are read at most once a
minute. If a device cannot be reached, the app stops these automatic attempts
until you reconnect by hand (pull down → "Reconnect") or restart the app.

### Sandbox (Sailjail)

`harbour-sailscq.desktop` requests `Permissions=Bluetooth`. The database is
stored in `~/.local/share/org.sailscq/sailscq/`.

If "Could not connect" appears although the CLI works directly in the
terminal, the sandbox probably blocks the RFCOMM connection (the CLI
registers a Bluetooth profile with BlueZ). To test, set
`Sandboxing=Disabled` under `[X-Sailjail]` in the `.desktop` file.

### Languages

SailSCQ follows the phone's language (Settings → System → Language). The
user interface is translated into all 39 Sailfish OS languages: Bulgarian,
Bengali, Czech, Danish, German, Greek, Spanish, Estonian, Finnish, French,
Gujarati, Hindi, Hungarian, Italian, Kannada, Lithuanian, Latvian, Malayalam,
Marathi, Norwegian, Dutch, Punjabi, Polish, Portuguese, Brazilian Portuguese,
Romanian, Russian, Slovak, Slovene, Swedish, Tamil, Telugu, Turkish, Tatar,
Ukrainian, Vietnamese and Chinese (simplified, Taiwan, Hong Kong).

Setting names and values come from OpenSCQ30's own translations
(`lib/i18n`: complete for German, Spanish, Brazilian Portuguese and Turkish,
partial for Italian, Ukrainian, Russian and others). The categories and sound
modes are translated by SailSCQ for every language; anything else falls back
to English. The openscq30 CLI always reports values in English, so the app
translates them itself (`Strings.translateText`).

Most translations were created with the help of an AI and have not been
reviewed by native speakers yet. Corrections are very welcome: edit
`translations/harbour-sailscq-<language>.ts` (e.g. with Qt Linguist) and open
a pull request.

### Harbour / Jolla Store

The app is meant for OpenRepos or Chum. A separately shipped binary and
direct Bluetooth access are problematic in the Jolla Store.

---

<a id="deutsch"></a>
## Deutsch

SailSCQ (Paket `harbour-sailscq`) ist eine Sailfish-OS-App für
Soundcore-Kopfhörer, -Earbuds und -Lautsprecher: Geräuschunterdrückung,
Equalizer, Tastenbelegung, Akkustände, Lautstärkebegrenzung und mehr.

SailSCQ ist eine inoffizielle Oberfläche für das Kommandozeilenprogramm
[OpenSCQ30](https://github.com/Oppzippy/OpenSCQ30), das mit der App
ausgeliefert wird. Nicht mit Anker oder Soundcore verbunden.

### Lizenz

SailSCQ steht unter der **GNU General Public License v3.0 oder später**
(GPL-3.0-or-later), siehe [LICENSE](LICENSE).

Mitgelieferte Fremdbestandteile:

- `bin/aarch64/openscq30`: OpenSCQ30-CLI von Kyle Scheuing,
  GPL-3.0-or-later, unveränderte Binärdatei aus den offiziellen Releases
  (Version in `bin/aarch64/VERSION`). Quellcode:
  https://github.com/Oppzippy/OpenSCQ30
- `qml/components/Strings.js`: Namen der Einstellungen, erzeugt aus den
  Übersetzungsdateien von OpenSCQ30 (`lib/i18n`), GPL-3.0-or-later.

### Aufbau

Die App benutzt die offizielle `openscq30`-CLI (v2.12.0, Rust) als Backend
und ruft sie für jede Aktion mit `--json` auf.

```
src/
  harbour-sailscq.cpp     main(), registriert "openscq30" und "bluetooth" im QML-Kontext
  openscq30cli.*          startet die CLI per QProcess: Warteschlange, Timeout, JSON, Einstellungen
  bluetoothdevices.*      liest gekoppelte Geräte aus BlueZ (D-Bus)
qml/
  harbour-sailscq.qml     ApplicationWindow
  pages/
    DeviceSelectionPage   openscq30 paired-devices list
    AddDevicePage         Bluetooth-Gerät oder MAC-Adresse wählen, Demo-Modus
    ModelSelectionPage    openscq30 list-models / paired-devices add
    SupportedDevicesPage  alle unterstützten Modelle, nach Bauform gruppiert
    AboutPage             Info-Seite, LicensePage: vollständiger Lizenztext
    DevicePage            verbinden, Kategorien anzeigen
    CategoryPage          Einstellungen einer Kategorie
  components/
    DeviceSession         Zustand eines Geräts (Struktur, Werte, Schreibvorgänge)
    SettingItem           passendes Silica-Element je Einstellungstyp
    EqualizerEditor       ein Schieberegler je Band + „Übernehmen“
    CliRunner             einzelner CLI-Aufruf aus QML
    DeviceTile            Zeichnung je Bauform (In-Ear, Hülle, Over-Ear, Lautsprecher)
    BatteryRow            Akkustand links/rechts/Hülle
    BatteryIcon           Batteriesymbol mit Segmenten und Lade-Blitz
    Strings.js            Namen der Einstellungen (en/de, aus OpenSCQ30-i18n)
images/                   Gerätezeichnungen
bin/aarch64/              offizielle CLI aus den OpenSCQ30-Releases (siehe VERSION)
tools/update-cli.sh       lädt ein neues CLI-Release herunter und prüft es
```

Die Seiten sind generisch: `openscq30 device -a MAC list-settings --json`
liefert alle Einstellungen samt Typ (`toggle`, `select`, `optionalSelect`,
`modifiableSelect`, `multiSelect`, `multiSelectWithRemove`, `i32Range`,
`equalizer`, `hueColorPicker`, `information`, `importString`, `action`),
daraus wird die Oberfläche gebaut. Neue
Modelle in künftigen CLI-Versionen funktionieren daher ohne Änderungen am QML.

Jeder CLI-Aufruf baut eine eigene Bluetooth-Verbindung auf (einige Sekunden).
Deshalb werden alle Aufrufe nacheinander ausgeführt, und nach jedem `--set`
werden im selben Aufruf alle Werte per `--get` neu gelesen.

### Bauen

Die OpenSCQ30-CLI liegt nicht im Git-Repository. Nach dem Klonen einmal
herunterladen (Version aus `bin/aarch64/VERSION`, Signatur wird geprüft):

```
tools/update-cli.sh "$(cat bin/aarch64/VERSION)"
```

Dann bauen:

```
sfdk config --global --push target SailfishOS-5.1.0.11-aarch64
sfdk build
sfdk deploy --sdk          # oder das RPM aus RPMS/ auf das Gerät kopieren
```

Nur aarch64: Die mitgelieferte CLI ist eine aarch64-Binärdatei
(`ExclusiveArch` in der Spec). Für armv7hl oder den i486-Emulator muss die
CLI für diese Architektur gebaut und nach `bin/<arch>/openscq30` gelegt
werden, danach die Architektur in `ExclusiveArch` ergänzen.

### CLI aktualisieren

Die CLI stammt aus den offiziellen Releases
(https://github.com/Oppzippy/OpenSCQ30/releases, Datei
`openscq30-cli-linux-arm64`). Das Skript

```
tools/update-cli.sh            # neuestes Release
tools/update-cli.sh v2.12.0    # bestimmtes Release
```

lädt sie herunter, prüft die GPG-Signatur des Entwicklers (Schlüssel
58A1 B3E7 0481 7B87 78CB B86B 72CE 2DDC DA12 B906, wie auf den Release-Seiten
angegeben) und legt sie nach `bin/aarch64/openscq30` (Version in
`bin/aarch64/VERSION`). Benötigt `curl` und `gpg`, nicht die GitHub-API.
Danach die Version in der Spec erhöhen und neu bauen. Die CLI benötigt
glibc ≥ 2.34 und libdbus-1.

### Testen

1. Kopfhörer in den Sailfish-Bluetooth-Einstellungen koppeln und verbinden.
2. App öffnen → nach unten ziehen → „Gerät hinzufügen“ → Gerät wählen → Modell wählen.
3. Gerät antippen.

Ohne Kopfhörer: beim Hinzufügen „Demo-Modus“ einschalten und eine beliebige
MAC-Adresse eingeben (z. B. `00:00:00:00:00:01`).

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

### Start

Beim Start öffnet die App direkt das zuletzt benutzte Gerät. Ist es nicht
erreichbar, wechselt sie zur Geräteverwaltung und zeigt dort einen Hinweis.

### Akkustände

Viele Soundcore-Geräte melden den Akku nur in 5 Stufen (z. B. die
Liberty 4 NC: 0, 20, 40, 60, 80, 100 %). Das Batteriesymbol ist deshalb
in Segmente geteilt. Der Ladezustand eines Ohrhörers wird angezeigt, solange er in der
offenen Hülle liegt. Die App liest die Werte alle 2 Minuten neu, solange sie
offen ist, und sofort, wenn man in die App zurückkehrt; im Hintergrund
übernimmt das Cover (höchstens einmal pro Minute, nur wenn es sichtbar ist).

### Cover

Das Cover zeigt Gerät, Sound-Modus und Akkustände und hat zwei Aktionen:
Aktualisieren und nächster Sound-Modus. Der Knopf schaltet bei den meisten
Modellen den Umgebungsgeräusch-Modus um, beim Sleep A30 den Hörmodus; über dem
Wert steht, welche Einstellung umgeschaltet wird. Modelle ohne Sound-Modi
haben nur die Aktualisieren-Aktion. Es nutzt das Gerät der offenen
Geräteseite oder, wenn keine offen ist, das zuletzt geöffnete Gerät
(gespeichert in `~/.config/org.sailscq/sailscq/settings.ini`). Die
Verbindung wird erst aufgebaut, wenn das Cover sichtbar ist, danach werden
die Werte höchstens einmal pro Minute gelesen. Ist ein Gerät nicht
erreichbar, stellt die App diese automatischen Versuche ein, bis man von Hand
neu verbindet (nach unten ziehen → „Neu verbinden“) oder die App neu startet.

### Sandbox (Sailjail)

`harbour-sailscq.desktop` fordert `Permissions=Bluetooth` an. Die Datenbank
liegt in `~/.local/share/org.sailscq/sailscq/`.

Falls „Verbindung fehlgeschlagen“ erscheint, obwohl die CLI direkt im
Terminal funktioniert, blockiert vermutlich die Sandbox die RFCOMM-Verbindung
(die CLI registriert ein Bluetooth-Profil bei BlueZ). Zum Test in der
`.desktop`-Datei unter `[X-Sailjail]` `Sandboxing=Disabled` setzen.

### Sprachen

SailSCQ folgt der Sprache des Telefons (Einstellungen → System → Sprache).
Die Oberfläche ist in alle 39 Sailfish-OS-Sprachen übersetzt (Liste im
englischen Teil).

Die Namen und Werte der Einstellungen stammen aus den Übersetzungen von
OpenSCQ30 (`lib/i18n`: vollständig für Deutsch, Spanisch, brasilianisches
Portugiesisch und Türkisch, teilweise für Italienisch, Ukrainisch, Russisch
und weitere). Kategorien und Sound-Modi übersetzt SailSCQ für jede Sprache
selbst; alles andere erscheint notfalls auf Englisch. Die openscq30-CLI
liefert Werte immer englisch, deshalb übersetzt die App sie selbst
(`Strings.translateText`).

Die meisten Übersetzungen wurden mithilfe einer KI erstellt und sind noch
nicht von Muttersprachlern geprüft. Korrekturen sind sehr willkommen:
`translations/harbour-sailscq-<sprache>.ts` bearbeiten (z. B. mit Qt
Linguist) und einen Pull Request stellen.

### Harbour / Jolla Store

Die App ist für OpenRepos oder Chum gedacht. Eine separat ausgelieferte
Binärdatei und der direkte Bluetooth-Zugriff sind im Jolla Store
problematisch.
