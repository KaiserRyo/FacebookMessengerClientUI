#ifndef TRIALAPI_H_
#define TRIALAPI_H_

#include <QtCore/QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtCore/QVariant>

class TrialAPI : public QObject
{
    Q_OBJECT

public:
    TrialAPI(QObject* parent = 0);

    Q_INVOKABLE void get(QVariant params);
    Q_INVOKABLE void post(QVariant params);

Q_SIGNALS:

    void complete(QString response, QString httpcode, QString endpoint);

public slots:

	void onComplete();

private :

    QNetworkAccessManager networkAccessManager;
};

#endif /* TRIALAPI_H_ */

