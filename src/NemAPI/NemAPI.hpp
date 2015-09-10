#ifndef NEMAPI_H_
#define NEMAPI_H_

#include <QtCore/QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtCore/QVariant>
#include <QtCore/QFile>
#include <QtCore/QtCore>

#include "../qxmpp/client/QXmppClient.h"

class QXmppVCardIq;

class NemAPI : public QObject
{
    Q_OBJECT

    Q_PROPERTY (bool _connected READ getConnected WRITE setConnected NOTIFY connectedChanged)

public:
    NemAPI(QObject* parent = 0);

    Q_INVOKABLE void login_natively(QString username, QString password);
    Q_INVOKABLE void login(QString access_token);
    Q_INVOKABLE void logout();
    Q_INVOKABLE void sendMessage(QString from, QString to, QString message);
    Q_INVOKABLE QString timeSince(qint64 time);

    Q_INVOKABLE void getFacebook(QVariant params);
    Q_INVOKABLE void postFacebook(QVariant params);

    bool getConnected();
    void setConnected(bool value);

Q_SIGNALS:

    void connectedChanged(bool);
    void connected();
    void disconnected();
    void error(QXmppClient::Error error, QString errorMessage);
    void messageReceivedSignal(QVariant messageObject);
    void messageAcknowledgeSignal(QVariant messageObject);
    void startedTypingSignal(QString fromID);
    void stoppedTypingSignal(QString fromID);

    void complete(QString response, QString httpcode, QString endpoint, QString identifier);

public slots:

    void onComplete();
    void messageReceived(const QXmppMessage&);
    void messageAcknowledged(const QXmppMessage&, const bool value);
    void onError(QXmppClient::Error);
    void clientConnected();
    void clientDisconnected();

private :

	QXmppClient* client;

	bool _connected;

    QNetworkAccessManager networkAccessManager;
    QString _last_username;
};

#endif /* NEMAPI_H_ */

