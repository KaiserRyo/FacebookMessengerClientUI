#include <src/Utilities/Utilities.hpp>
#include "ParseAPI.hpp"
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QtNetwork/QtNetwork>
#include <bb/PackageInfo>

using bb::PackageInfo;

// ------------------------------------- CONSTANTS ------------------------------------- //

const QString APP_KEY 			    = "";
const QString CLIENT_KEY 		    = "";
const QString RESTAPI_KEY           = "";
const QString MASTER_KEY            = "";

const QString HTTP_PROTOCOL 		= "http://";
const QString HTTPS_PROTOCOL 		= "https://";

const QString API_VERSION           = "1";
const QString API_HOST              = "api.parse.com";
const QString API_URL               = HTTPS_PROTOCOL + API_HOST + "/" + API_VERSION + "/";

const QString CONTENT_TYPE_JSON     = "application/json";
const QString CONTENT_TYPE_FORM     = "application/x-www-form-urlencoded";

const QString HEADER_APPLICATION_ID = "X-Parse-Application-Id";
const QString HEADER_API_KEY        = "X-Parse-REST-API-Key";
const QString HEADER_CONTENT_TYPE   = "Content-Type";

const QString APP_PLATFORM          = "BlackBerry";

QString APP_VERSION_                 = "";

// ------------------------------------- CONSTANTS ------------------------------------- //

ParseAPI::ParseAPI(QObject* parent) : QObject(parent)
{
    PackageInfo packageInfo;
    APP_VERSION_ = packageInfo.version();
}

void ParseAPI::get(QVariant params)
{
	QVariantMap paramsMap 	= params.toMap();

	QString data            = paramsMap.value("data").toString();
	QString endpoint		= paramsMap.value("endpoint").toString();
	QString appDetails      = "?platform=BlackBerry&version=" + APP_VERSION_;

	QString fullURL         = API_URL + endpoint + appDetails + data;

	QNetworkRequest request;
	request.setUrl(QUrl(fullURL));
	request.setRawHeader(HEADER_API_KEY.toUtf8(), RESTAPI_KEY.toUtf8());
    request.setRawHeader(HEADER_APPLICATION_ID.toUtf8(), APP_KEY.toUtf8());
    request.setRawHeader(HEADER_CONTENT_TYPE.toUtf8(), CONTENT_TYPE_JSON.toUtf8());

	QNetworkReply* reply = networkAccessManager.get(request);
	reply->setProperty("endpoint", endpoint);
	connect (reply, SIGNAL(finished()), this, SLOT(onComplete()));
}

void ParseAPI::post(QVariant params)
{
	QVariantMap paramsMap 	= params.toMap();

	QString data            = paramsMap.value("data").toString();
	QString endpoint		= paramsMap.value("endpoint").toString();
	QString next_endpoint   = paramsMap.value("next_endpoint").toString();
	QString next_method     = paramsMap.value("next_method").toString();
	QString appDetails      = "?platform=BlackBerry&version=" + APP_VERSION_;

    QString fullURL         = API_URL + endpoint;

	QNetworkRequest request;
	request.setUrl(QUrl(fullURL));
	request.setRawHeader(HEADER_API_KEY.toUtf8(), RESTAPI_KEY.toUtf8());
    request.setRawHeader(HEADER_APPLICATION_ID.toUtf8(), APP_KEY.toUtf8());
    request.setRawHeader(HEADER_CONTENT_TYPE.toUtf8(), CONTENT_TYPE_JSON.toUtf8());

	QNetworkReply* reply = networkAccessManager.post(request, data.toAscii());
	reply->setProperty("endpoint", endpoint);
	reply->setProperty("next_endpoint", next_endpoint);
	reply->setProperty("next_method", next_method);
	connect (reply, SIGNAL(finished()), this, SLOT(onComplete()));
}

void ParseAPI::onComplete()
{
	QNetworkReply* reply 	    = qobject_cast<QNetworkReply*>(sender());
	QString httpcode 			= reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toString();
	QString reason 			    = reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute).toString();
	QString setCookieHeader     = reply->rawHeader("Set-Cookie");
	QString contentTypeHeader   = reply->rawHeader("Content-Type");
	QString endpoint            = reply->property("endpoint").toString();
	QString next_endpoint       = reply->property("next_endpoint").toString();
	QString next_method         = reply->property("next_method").toString();

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

	if(httpcode == "200")
	{
		response = ((response.length() > 0 && response != "error") ? response : httpcode);
	}

	emit complete(response, httpcode, endpoint, next_endpoint, next_method);
}
