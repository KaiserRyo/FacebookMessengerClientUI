#ifndef PARSEAPI_H_
#define PARSEAPI_H_

#include <QtCore/QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtCore/QVariant>

class ParseAPI : public QObject
{
    Q_OBJECT

public:
    ParseAPI(QObject* parent = 0);

    Q_INVOKABLE void get(QVariant params);
    Q_INVOKABLE void post(QVariant params);

Q_SIGNALS:

    void complete(QString response, QString httpcode, QString endpoint, QString next_endpoint, QString next_method);

public slots:

	void onComplete();

private :

    QNetworkAccessManager networkAccessManager;
};

#endif /* ParseAPI_H_ */

