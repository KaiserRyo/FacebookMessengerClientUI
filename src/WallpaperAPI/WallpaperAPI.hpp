#ifndef WALLPAPERAPI_H_
#define WALLPAPERAPI_H_

#include <QtCore/QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtCore/QVariant>

class WallpaperAPI : public QObject
{
    Q_OBJECT

public:
    WallpaperAPI(QObject* parent = 0);

    Q_INVOKABLE void get(QVariant params);
    Q_INVOKABLE void post(QVariant params);

Q_SIGNALS:

    void complete(QString response, QString httpcode, QString endpoint);

public slots:

	void onComplete();

private :

    QNetworkAccessManager networkAccessManager;
};

#endif /* WALLPAPERAPI_H_ */

