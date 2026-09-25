// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
#include "bluetoothdevices.h"

#include <QDBusArgument>
#include <QDBusConnection>
#include <QDBusMessage>
#include <QDBusMetaType>
#include <QDBusObjectPath>
#include <QDBusReply>
#include <QDebug>
#include <QMap>
#include <algorithm>

typedef QMap<QString, QVariantMap> InterfaceList;
typedef QMap<QDBusObjectPath, InterfaceList> ManagedObjectList;
Q_DECLARE_METATYPE(InterfaceList)
Q_DECLARE_METATYPE(ManagedObjectList)

BluetoothDevices::BluetoothDevices(QObject *parent)
    : QObject(parent)
{
    qDBusRegisterMetaType<InterfaceList>();
    qDBusRegisterMetaType<ManagedObjectList>();
}

QVariantList BluetoothDevices::pairedDevices() const
{
    QVariantList result;

    QDBusMessage call = QDBusMessage::createMethodCall(
        QStringLiteral("org.bluez"), QStringLiteral("/"),
        QStringLiteral("org.freedesktop.DBus.ObjectManager"),
        QStringLiteral("GetManagedObjects"));
    QDBusReply<ManagedObjectList> reply = QDBusConnection::systemBus().call(call, QDBus::Block, 5000);
    if (!reply.isValid()) {
        qWarning() << "Could not read Bluetooth devices from BlueZ:" << reply.error().message();
        return result;
    }

    const ManagedObjectList objects = reply.value();
    for (auto it = objects.constBegin(); it != objects.constEnd(); ++it) {
        const InterfaceList &interfaces = it.value();
        auto device = interfaces.constFind(QStringLiteral("org.bluez.Device1"));
        if (device == interfaces.constEnd())
            continue;
        const QVariantMap &props = device.value();
        if (!props.value(QStringLiteral("Paired")).toBool())
            continue;

        QString name = props.value(QStringLiteral("Alias")).toString();
        if (name.isEmpty())
            name = props.value(QStringLiteral("Name")).toString();

        QVariantMap entry;
        entry.insert(QStringLiteral("address"), props.value(QStringLiteral("Address")).toString().toUpper());
        entry.insert(QStringLiteral("name"), name);
        entry.insert(QStringLiteral("connected"), props.value(QStringLiteral("Connected")).toBool());
        entry.insert(QStringLiteral("paired"), true);
        result.append(entry);
    }

    std::sort(result.begin(), result.end(), [](const QVariant &a, const QVariant &b) {
        const QVariantMap ma = a.toMap();
        const QVariantMap mb = b.toMap();
        const bool ca = ma.value(QStringLiteral("connected")).toBool();
        const bool cb = mb.value(QStringLiteral("connected")).toBool();
        if (ca != cb)
            return ca;
        return ma.value(QStringLiteral("name")).toString().localeAwareCompare(
                   mb.value(QStringLiteral("name")).toString()) < 0;
    });
    return result;
}
