TARGET = harbour-sailscq

CONFIG += sailfishapp
QT += dbus

# App version, passed in by the .spec file (%qmake5 VERSION=... RELEASE=...).
# It is written to a generated header instead of a -D compiler flag: make does
# not notice changed flags, so incremental builds (sfdk build) kept showing the
# old version. The header is only rewritten when the version changes.
isEmpty(VERSION): VERSION = 0.0
isEmpty(RELEASE): RELEASE = 0
VERSION_HEADER = $$OUT_PWD/version.h
VERSION_LINE = "$${LITERAL_HASH}define APP_VERSION \"$${VERSION}-$${RELEASE}\""
!equals(VERSION_LINE, $$cat($$VERSION_HEADER, blob)) {
    write_file($$VERSION_HEADER, VERSION_LINE)|error("Could not write $$VERSION_HEADER")
}
INCLUDEPATH += $$OUT_PWD
HEADERS += $$VERSION_HEADER

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
TRANSLATIONS += \
    translations/harbour-sailscq-bg.ts \
    translations/harbour-sailscq-bn.ts \
    translations/harbour-sailscq-cs.ts \
    translations/harbour-sailscq-da.ts \
    translations/harbour-sailscq-de.ts \
    translations/harbour-sailscq-el.ts \
    translations/harbour-sailscq-es.ts \
    translations/harbour-sailscq-et.ts \
    translations/harbour-sailscq-fi.ts \
    translations/harbour-sailscq-fr.ts \
    translations/harbour-sailscq-gu.ts \
    translations/harbour-sailscq-hi.ts \
    translations/harbour-sailscq-hu.ts \
    translations/harbour-sailscq-it.ts \
    translations/harbour-sailscq-kn.ts \
    translations/harbour-sailscq-lt.ts \
    translations/harbour-sailscq-lv.ts \
    translations/harbour-sailscq-ml.ts \
    translations/harbour-sailscq-mr.ts \
    translations/harbour-sailscq-nb.ts \
    translations/harbour-sailscq-nl.ts \
    translations/harbour-sailscq-pa.ts \
    translations/harbour-sailscq-pl.ts \
    translations/harbour-sailscq-pt.ts \
    translations/harbour-sailscq-pt_BR.ts \
    translations/harbour-sailscq-ro.ts \
    translations/harbour-sailscq-ru.ts \
    translations/harbour-sailscq-sk.ts \
    translations/harbour-sailscq-sl.ts \
    translations/harbour-sailscq-sv.ts \
    translations/harbour-sailscq-ta.ts \
    translations/harbour-sailscq-te.ts \
    translations/harbour-sailscq-tr.ts \
    translations/harbour-sailscq-tt.ts \
    translations/harbour-sailscq-uk.ts \
    translations/harbour-sailscq-vi.ts \
    translations/harbour-sailscq-zh_CN.ts \
    translations/harbour-sailscq-zh_HK.ts \
    translations/harbour-sailscq-zh_TW.ts

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
