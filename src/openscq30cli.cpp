// SPDX-FileCopyrightText: 2026 Denis Robel
// SPDX-License-Identifier: GPL-3.0-or-later
#include "openscq30cli.h"

#include <QDebug>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonParseError>
#include <QDir>
#include <QProcessEnvironment>
#include <QSettings>
#include <QStandardPaths>

OpenSCQ30Cli::OpenSCQ30Cli(const QString &binaryPath, const QString &databasePath,
                           QObject *parent)
    : QObject(parent)
    , m_binaryPath(binaryPath)
    , m_databasePath(databasePath)
{
    const QString configDir = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    QDir().mkpath(configDir);
    m_settingsPath = configDir + QStringLiteral("/settings.ini");

    m_timeout.setSingleShot(true);
    connect(&m_timeout, &QTimer::timeout, this, &OpenSCQ30Cli::onTimeout);
}

bool OpenSCQ30Cli::busy() const
{
    return m_process != nullptr || !m_queue.isEmpty();
}

bool OpenSCQ30Cli::binaryAvailable() const
{
    QFileInfo info(m_binaryPath);
    return info.exists() && info.isExecutable();
}

int OpenSCQ30Cli::run(const QStringList &args, int timeoutMs)
{
    const bool wasBusy = busy();
    Request request;
    request.id = m_nextId++;
    request.args = args;
    request.timeoutMs = timeoutMs > 0 ? timeoutMs : 45000;
    m_queue.enqueue(request);
    if (!wasBusy)
        emit busyChanged();
    // Start asynchronously so the caller can store the id before any result arrives.
    QMetaObject::invokeMethod(this, "startNext", Qt::QueuedConnection);
    return request.id;
}

void OpenSCQ30Cli::cancel(int requestId)
{
    for (int i = 0; i < m_queue.size(); ++i) {
        if (m_queue.at(i).id == requestId) {
            m_queue.removeAt(i);
            if (!busy())
                emit busyChanged();
            return;
        }
    }
    if (requestId == m_currentId)
        m_currentCancelled = true;
}

void OpenSCQ30Cli::abort(int requestId)
{
    cancel(requestId);
    if (requestId == m_currentId && m_process) {
        m_currentCancelled = true;
        m_process->kill();
    }
}

void OpenSCQ30Cli::startNext()
{
    if (m_process || m_queue.isEmpty())
        return;

    const Request request = m_queue.dequeue();
    m_currentId = request.id;
    m_currentCancelled = false;
    m_timedOut = false;

    m_process = new QProcess(this);
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    // Keep the database inside the app's (sandbox-accessible) data directory.
    env.insert(QStringLiteral("OPENSCQ30_DATABASE_PATH"), m_databasePath);
    m_process->setProcessEnvironment(env);

    connect(m_process,
            static_cast<void (QProcess::*)(int, QProcess::ExitStatus)>(&QProcess::finished),
            this, &OpenSCQ30Cli::onProcessFinished);
    connect(m_process, &QProcess::errorOccurred, this, &OpenSCQ30Cli::onProcessError);

    qDebug() << "openscq30" << request.args;
    m_timeout.start(request.timeoutMs);
    m_process->start(m_binaryPath, request.args);
}

void OpenSCQ30Cli::onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    QString extra;
    if (m_timedOut)
        extra = tr("Timeout: the device did not respond.");
    else if (exitStatus == QProcess::CrashExit && !m_currentCancelled)
        extra = tr("openscq30 crashed.");
    finishCurrent(exitStatus == QProcess::NormalExit && exitCode == 0, extra);
}

void OpenSCQ30Cli::onProcessError(QProcess::ProcessError error)
{
    // For all other errors QProcess also emits finished().
    if (error == QProcess::FailedToStart)
        finishCurrent(false, tr("Could not start %1").arg(m_binaryPath));
}

void OpenSCQ30Cli::onTimeout()
{
    if (m_process) {
        m_timedOut = true;
        m_process->kill();
    }
}

void OpenSCQ30Cli::finishCurrent(bool success, const QString &extraError)
{
    if (!m_process)
        return;
    m_timeout.stop();

    const QByteArray stdoutData = m_process->readAllStandardOutput();
    QString errorOutput = QString::fromUtf8(m_process->readAllStandardError()).trimmed();
    if (!extraError.isEmpty())
        errorOutput = errorOutput.isEmpty() ? extraError : extraError + "\n" + errorOutput;

    QVariant json;
    QJsonParseError parseError;
    const QJsonDocument doc = QJsonDocument::fromJson(stdoutData, &parseError);
    if (parseError.error == QJsonParseError::NoError && !doc.isNull())
        json = doc.toVariant();

    const int id = m_currentId;
    const bool cancelled = m_currentCancelled;

    m_process->disconnect(this);
    m_process->deleteLater();
    m_process = nullptr;
    m_currentId = -1;

    if (!success)
        qWarning() << "openscq30 request" << id << "failed:" << errorOutput;

    if (!cancelled)
        emit finished(id, success, json, QString::fromUtf8(stdoutData), errorOutput);

    if (m_queue.isEmpty())
        emit busyChanged();
    else
        startNext();
}

QVariant OpenSCQ30Cli::loadSetting(const QString &key, const QVariant &defaultValue) const
{
    QSettings settings(m_settingsPath, QSettings::IniFormat);
    return settings.value(key, defaultValue);
}

void OpenSCQ30Cli::saveSetting(const QString &key, const QVariant &value)
{
    QSettings settings(m_settingsPath, QSettings::IniFormat);
    if (value.isNull() || (value.type() == QVariant::String && value.toString().isEmpty()))
        settings.remove(key);
    else
        settings.setValue(key, value);
}
