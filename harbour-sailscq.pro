TARGET = harbour-sailscq

CONFIG += sailfishapp
QT += dbus

# App version, passed in by the .spec file (%qmake5 VERSION=... RELEASE=...)
isEmpty(VERSION): VERSION = 0.0
isEmpty(RELEASE): RELEASE = 0
DEFINES += APP_VERSION=\\\"$${VERSION}-$${RELEASE}\\\"

SOURCES += \
    src/harbour-sailscq.cpp \
    src/openscq30cli.cpp \
    src/bluetoothdevices.cpp

HEADERS += \
    src/openscq30cli.h \
    src/bluetoothdevices.h

DISTFILES += \
    qml/harbour-sailscq.qml \
    qml/cover/CoverPage.qml \
    qml/components/*.qml \
    qml/components/Strings.js \
    qml/pages/*.qml \
    rpm/harbour-sailscq.changes.in \
    rpm/harbour-sailscq.changes.run.in \
    rpm/harbour-sailscq.spec \
    translations/*.ts \
    harbour-sailscq.desktop \
    README.md \
    LICENSE \
    tools/update-cli.sh

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-sailscq-de.ts

# The openscq30 CLI (prebuilt Rust binary) is installed by the .spec file to
# /usr/share/harbour-sailscq/bin/openscq30, see rpm/harbour-sailscq.spec.

# Device illustrations (white, tinted with the ambience color in QML)
images.files = images
images.path = /usr/share/$${TARGET}
INSTALLS += images

# License text, shown on the About page
license.files = LICENSE
license.path = /usr/share/$${TARGET}
INSTALLS += license
