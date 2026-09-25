// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
#ifndef BLUETOOTHDEVICES_H
#define BLUETOOTHDEVICES_H

#include <QObject>
#include <QVariantList>

// Reads the Bluetooth devices that are already paired with the phone from
// BlueZ (org.bluez on the system bus), so the user can pick the headphones
// from a list instead of typing the MAC address.
class BluetoothDevices : public QObject
{
    Q_OBJECT
public:
    explicit BluetoothDevices(QObject *parent = nullptr);

    // Returns [{ address, name, connected, paired }], connected devices first.
    Q_INVOKABLE QVariantList pairedDevices() const;
};

#endif // BLUETOOTHDEVICES_H
