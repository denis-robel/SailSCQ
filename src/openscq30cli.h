// SPDX-FileCopyrightText: 2026 Denis Robel
// SPDX-License-Identifier: GPL-3.0-or-later
#ifndef OPENSCQ30CLI_H
#define OPENSCQ30CLI_H

#include <QObject>
#include <QProcess>
#include <QQueue>
#include <QStringList>
#include <QTimer>
#include <QVariant>

// Runs the openscq30 command line tool asynchronously.
//
// Every call of the CLI opens its own Bluetooth (RFCOMM) connection to the
// headphones. Two parallel connections to the same device fail, so all
// requests are queued and executed strictly one after another.
class OpenSCQ30Cli : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)
    Q_PROPERTY(QString binaryPath READ binaryPath CONSTANT)
    Q_PROPERTY(bool binaryAvailable READ binaryAvailable CONSTANT)

public:
    explicit OpenSCQ30Cli(const QString &binaryPath, const QString &databasePath,
                          QObject *parent = nullptr);

    bool busy() const;
    QString binaryPath() const { return m_binaryPath; }
    bool binaryAvailable() const;

    // Queues a CLI call. Returns a request id that is passed to finished().
    Q_INVOKABLE int run(const QStringList &args, int timeoutMs = 45000);

    // Removes a queued request. A request that is already running is not
    // killed (it might be writing to the device), only its result is dropped.
    Q_INVOKABLE void cancel(int requestId);

    // Kills a running request (used for "cancel connecting").
    Q_INVOKABLE void abort(int requestId);

    // Small persistent key/value store (e.g. the last opened device), kept in
    // ~/.config/org.sailscq/sailscq/settings.ini inside the sandbox.
    Q_INVOKABLE QVariant loadSetting(const QString &key, const QVariant &defaultValue = QVariant()) const;
    Q_INVOKABLE void saveSetting(const QString &key, const QVariant &value);

signals:
    void busyChanged();
    // json: parsed stdout (QVariantList / QVariantMap) or null if stdout was
    // not JSON. openscq30 also prints partial JSON results on failure, so json
    // may be set even if success is false.
    void finished(int requestId, bool success, const QVariant &json,
                  const QString &output, const QString &errorOutput);

private slots:
    void onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void onProcessError(QProcess::ProcessError error);
    void onTimeout();
    void startNext();

private:
    struct Request {
        int id;
        QStringList args;
        int timeoutMs;
    };

    void finishCurrent(bool success, const QString &extraError);

    QString m_binaryPath;
    QString m_databasePath;
    QString m_settingsPath;
    QQueue<Request> m_queue;
    QProcess *m_process = nullptr;
    QTimer m_timeout;
    int m_currentId = -1;
    bool m_currentCancelled = false;
    bool m_timedOut = false;
    int m_nextId = 1;
};

#endif // OPENSCQ30CLI_H
