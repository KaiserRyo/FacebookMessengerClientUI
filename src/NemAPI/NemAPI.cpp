#include <QtCore/qobject.h>
#include "NemAPI.hpp"

#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QtNetwork/QtNetwork>
#include <QtCore/QtCore>
#include <bb/data/JsonDataAccess>
#include <src/Utilities/Utilities.hpp>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>

#include <iostream>
#include <QBuffer>
#include <QDir>
#include <QFile>
#include <QXmlStreamWriter>

#include "src/qxmpp/client/QXmppRosterManager.h"
#include "src/qxmpp/base/QXmppVCardIq.h"
#include "src/qxmpp/client/QXmppVCardManager.h"
#include "src/qxmpp/client/QXmppClient.h"
#include "src/qxmpp/base/QXmppLogger.h"
#include "src/qxmpp/base/QXmppMessage.h"
#include "src/qxmpp/client/QXmppConfiguration.h"

using bb::data::JsonDataAccess;

#define ARRAY_SIZE(arr) ((sizeof(arr))/(sizeof(arr[0])))

const QString _ANDROID_ID       = "882a8490361da98702bf97a021ddc14d";
const QString _BLACKBERRY_ID    = "2254487659";
const QString _IPHONE_ID        = "3e7c78e35a76a9299309885393b02d97";
const QString _IPAD_ID          = "350939045778";
const QString _IPOD_ID          = "4df3200f360533d57e0353bed01109d8";

NemAPI::NemAPI(QObject* parent) : QObject(parent)
{
    client = new QXmppClient(this);

    connect(client, SIGNAL(messageReceived(QXmppMessage)), SLOT(messageReceived(QXmppMessage)));
    connect(client, SIGNAL(connected()), SLOT(clientConnected()));
    connect(client, SIGNAL(disconnected()), SLOT(clientDisconnected()));
    connect(client, SIGNAL(error(QXmppClient::Error)), SLOT(onError(QXmppClient::Error)));
}

void NemAPI::logout()
{
    if(client != NULL)
    {
        qDebug() << "*** LOGGING OUT ***";

        client->disconnectFromServer();
    }
}

void NemAPI::login_natively(QString username, QString password)
{
    qDebug() << "*** LOGIN NATIVELY: username" << username << ", password: " << password << " ***";


    QXmppConfiguration configuration;
    //configuration.setFacebookAccessToken(access_token);
    configuration.setUser(username);
    configuration.setPassword(password);
    configuration.setDomain("chat.facebook.com");
    configuration.setHost("chat.facebook.com");
    configuration.setAutoReconnectionEnabled(true);
    //configuration.setFacebookAppId(Utilities::fb_app_id());
    configuration.setFacebookAppId(_ANDROID_ID);

    QXmppPresence presence;
    client->connectToServer(configuration, presence);
}

void NemAPI::login(QString access_token)
{
    qDebug() << "*** LOGGING IN: access_token" << access_token << " ***";

    QXmppConfiguration configuration;
    configuration.setFacebookAccessToken(access_token);
    configuration.setDomain("chat.facebook.com");
    configuration.setHost("chat.facebook.com");
    configuration.setFacebookAppId(Utilities::fb_app_id());
    configuration.setAutoReconnectionEnabled(true);
    //configuration.setFacebookAppId(_ANDROID_ID);

    QXmppPresence presence;
    client->connectToServer(configuration, presence);
}

void NemAPI::sendMessage(QString from, QString to, QString message)
{
    qDebug() << "*** SENDING MESSAGE: message: " << message << ", to: " << to << " ***";

    client->sendPacket(QXmppMessage("-" + from + "@chat.facebook.com", "-" + to + "@chat.facebook.com", message));
}

void NemAPI::clientConnected()
{
    qDebug() << "*** CONNECTED *** access_token: " << client->configuration().facebookAccessToken() << ", APP ID: " << client->configuration().facebookAppId() << ", user: " << client->configuration().user();

    setConnected(true);
    emit connected();
}

void NemAPI::clientDisconnected()
{
    qDebug() << "*** DISCONNECTED ***";

    setConnected(false);
    emit disconnected();
}

void NemAPI::onError(QXmppClient::Error errorObject)
{
    QString errorMessage = "";

    if (errorObject == QXmppClient::XmppStreamError && client->xmppStreamError() == QXmppStanza::Error::NotAuthorized)
    {
        errorMessage = "* Authentication Failed *\n- Please make sure you allowed the 'Send and Receive Messages (xmpp_login)' Permission. If this is the case, just re-login your accounts.\n\n===== OR =====\n\n- If you're new to version 5.0.400 and above, we've implemented new things so we need to require you to Uninstall and Reinstall this app. \n\nThank you very much and we apologize for the hassle.";
    }

    qDebug() << "*** ERROR " << errorObject << ", xmpp_stream_error: " << client->xmppStreamError() << " ***";

    //emit error(errorObject, errorMessage);
}

void NemAPI::messageAcknowledged(const QXmppMessage& xmppmessage, const bool value)
{
    qDebug() << "*** messageAcknowledged, value: " << value;
}

void NemAPI::messageReceived(const QXmppMessage& xmppmessage)
{
    QString id                      = xmppmessage.id();
    QString from                    = xmppmessage.from();
    QString message                 = xmppmessage.body();
    QString from_id                 = Utilities::regex(from, "-(.*)@chat.facebook.com", 1);

    if(xmppmessage.state() == 4)
    {
        emit startedTypingSignal(from_id);
    }
    else if(xmppmessage.state() == 5 || xmppmessage.state() == 2 || xmppmessage.state() == 3)
    {
        emit stoppedTypingSignal(from_id);
    }

    if(xmppmessage.type() == 3)
    {
        qDebug() << "*** GROUP CHAT MESSAGE RECEIVED ***";
    }

    if(xmppmessage.body().length() > 0)
    {
        QVariantMap fromObject;
        fromObject["id"]                = from_id;
        fromObject["name"]              = "";

        QVariantMap messageObject;
        messageObject["id"]             = id;
        messageObject["from"]           = fromObject;
        messageObject["message"]        = message;
        messageObject["created_time"]   = QDateTime::currentMSecsSinceEpoch();

        emit messageReceivedSignal(messageObject);

        qDebug() << "*** MESSAGE RECEIVED: from: " << xmppmessage.from() << ", from_id: " << from_id << ", body: " << xmppmessage.body() << " ***";
    }
}

QString NemAPI::timeSince(qint64 time)
{
   QString periods[] = {"s", "m", "h", "d", "w", "mo", "y", "dec"};

   int lengths[] = {60, 60, 24, 7, 4.35, 12, 10};

   qint64 now = QDateTime::currentMSecsSinceEpoch() / 1000;

   qint64 difference     = now - (time / 1000);
   QString tense         = "ago";

   int j = 0;

   for(j = 0; difference >= lengths[j] && j < ARRAY_SIZE(lengths) - 1; j++)
   {
       difference /= lengths[j];
   }

   difference = qRound(difference);

   return QString::number(difference) + "" + periods[j] + " " + tense;
}

bool NemAPI::getConnected()
{
    return _connected;
}

void NemAPI::setConnected(bool value)
{
    _connected = value;
    emit connectedChanged(_connected);
}

void NemAPI::getFacebook(QVariant params)
{
    QVariantMap paramsMap   = params.toMap();

    QString theurl          = paramsMap.value("url").toString();
    QString endpoint        = paramsMap.value("endpoint").toString();
    QString access_token    = paramsMap.value("access_token").toString();

    QNetworkRequest request;

    QUrl dataToSend;
    dataToSend.addQueryItem("access_token", access_token);
    dataToSend.addQueryItem("date_format", "U");

    if(theurl.length() == 0)
    {
        request.setUrl(QUrl("https://graph.facebook.com" + endpoint + dataToSend.encodedQuery()));
    }
    else
    {
        request.setUrl(QUrl(theurl + "&" + dataToSend.encodedQuery()));
    }

    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    QNetworkReply* reply = networkAccessManager.get(request);
    reply->setProperty("endpoint", endpoint);
    connect (reply, SIGNAL(finished()), this, SLOT(onComplete()));

    qDebug() << "NEM API: " << theurl;
}

void NemAPI::postFacebook(QVariant params)
{
    QVariantMap paramsMap   = params.toMap();

    QString theurl          = paramsMap.value("url").toString();
    QString endpoint        = paramsMap.value("endpoint").toString();
    QString object          = paramsMap.value("object").toString();
    QString access_token    = paramsMap.value("access_token").toString();

    QString content_type    = "application/x-www-form-urlencoded";

    QNetworkRequest request;
    request.setUrl(QUrl(theurl));
    request.setHeader(QNetworkRequest::ContentTypeHeader, content_type);

    QUrl dataToSend;
    dataToSend.addQueryItem("object", object);
    dataToSend.addQueryItem("access_token", access_token);

    qDebug() << dataToSend;

    QNetworkReply* reply = networkAccessManager.post(request, dataToSend.encodedQuery());
    reply->setProperty("endpoint", endpoint);
    connect (reply, SIGNAL(finished()), this, SLOT(onComplete()));

    qDebug() << "URL: " << theurl;
    qDebug() << "DATA: " << object;
}

void NemAPI::onComplete()
{
    QNetworkReply* reply        = qobject_cast<QNetworkReply*>(sender());
    QString status              = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toString();
    QString reason              = reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute).toString();
    QString contentTypeHeader   = reply->rawHeader("Content-Type");
    QString endpoint            = reply->property("endpoint").toString();
    QString identifier          = reply->property("identifier").toString();
    QString username            = reply->property("username").toString();
    QString register_username   = reply->property("register_username").toString();
    QUrl theurl                 = reply->request().url();
    QVariant cookieVariant      = reply->header(QNetworkRequest::SetCookieHeader);

    QString response;

    if (reply)
    {
        const int available = reply->bytesAvailable();

        if (available > 0)
        {
            const QByteArray buffer(reply->readAll());
            response = QString::fromUtf8(buffer);
        }

        reply->deleteLater();
    }

    if (response.trimmed().isEmpty())
    {
        response = "empty response error";
    }

    if(status == "200")
    {
        response = ((response.length() > 0 && response != "error") ? response : status);
    }

    emit complete(response, status, endpoint, identifier);
}
