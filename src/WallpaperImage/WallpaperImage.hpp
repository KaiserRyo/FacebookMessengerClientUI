#ifndef WALLPAPERIMAGE_HPP_
#define WALLPAPERIMAGE_HPP_

#include <bb/cascades/ImageView>
#include <qt4/QtNetwork/QNetworkAccessManager>
#include <qt4/QtCore/qurl.h>
#include <qt4/QtCore/qobject.h>

using namespace bb::cascades;

class WallpaperImage: public bb::cascades::ImageView
{
	Q_OBJECT
	Q_PROPERTY (QUrl url READ url WRITE setUrl NOTIFY urlChanged)
	Q_PROPERTY (QString imageID READ imageID WRITE setImageID NOTIFY imageIDChanged)
	Q_PROPERTY (float loading READ loading WRITE setLoading NOTIFY loadingChanged)
	Q_PROPERTY (QUrl defaultImage READ defaultImage WRITE setDefaultImage NOTIFY defaultImageChanged)
	Q_PROPERTY (bool ready READ ready WRITE setReady NOTIFY readyChanged)

public:
	WallpaperImage(bb::cascades::Container *parent = 0);
	const QUrl& url() const;
	const QString& imageID() const;
	const QUrl& defaultImage() const;
	double loading() const;
	bool ready();

public slots:
	void setUrl(const QUrl url);
	void setImageID(const QString imageID);
	void setDefaultImage(const QUrl url);
	void setLoading(const float loading);

private slots:
	void imageLoaded();
	void downloadProgressed(qint64,qint64);
	void setReady(bool ready);

signals:
	void urlChanged();
	void imageIDChanged(QString imageID);
	void defaultImageChanged();
	void loadingChanged();
	void readyChanged();
	void theImageLoaded();

private:
	static QNetworkAccessManager * mNetManager;
	QUrl mUrl;
	QString mImageID;
	QList<QUrl> urls;
	QList<QNetworkReply* > replys;
	QUrl defaultImageUrl;
	float mLoading;
	bool mReady;
	QString cacheLocation;
};

Q_DECLARE_METATYPE(WallpaperImage *);

#endif
