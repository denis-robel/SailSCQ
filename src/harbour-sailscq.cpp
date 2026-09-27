// SPDX-FileCopyrightText: 2026 Denis Robel
// SPDX-License-Identifier: GPL-3.0-or-later
#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

#include <QDir>
#include <QFile>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickView>
#include <QScopedPointer>
#include <QStandardPaths>

#include "bluetoothdevices.h"
#include "openscq30cli.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    // Must match [X-Sailjail] in the .desktop file, otherwise the sandbox
    // does not allow writing to the data directory.
    app->setOrganizationName(QStringLiteral("org.sailscq"));
    app->setApplicationName(QStringLiteral("sailscq"));

    const QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dataDir);

    // The CLI is shipped inside the app's share directory. For development it
    // can be overridden with OPENSCQ30_CLI=/path/to/openscq30.
    QString binary = QString::fromLocal8Bit(qgetenv("OPENSCQ30_CLI"));
    if (binary.isEmpty())
        binary = SailfishApp::pathTo(QStringLiteral("bin/openscq30")).toLocalFile();

    OpenSCQ30Cli cli(binary, dataDir + QStringLiteral("/database.sqlite"));
    BluetoothDevices bluetooth;

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->rootContext()->setContextProperty(QStringLiteral("openscq30"), &cli);
    view->rootContext()->setContextProperty(QStringLiteral("bluetooth"), &bluetooth);

    // For the About page
#ifndef APP_VERSION
#define APP_VERSION "0.0-0"
#endif
    view->rootContext()->setContextProperty(QStringLiteral("appVersion"), QStringLiteral(APP_VERSION));
    QString licenseText;
    QFile licenseFile(SailfishApp::pathTo(QStringLiteral("LICENSE")).toLocalFile());
    if (licenseFile.open(QIODevice::ReadOnly | QIODevice::Text))
        licenseText = QString::fromUtf8(licenseFile.readAll());
    view->rootContext()->setContextProperty(QStringLiteral("licenseText"), licenseText);
    view->setSource(SailfishApp::pathToMainQml());
    view->show();

    return app->exec();
}
