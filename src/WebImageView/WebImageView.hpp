#ifndef WEBIMAGEVIEW_HPP_
#define WEBIMAGEVIEW_HPP_

#include <bb/cascades/ImageView>
#include <qt4/QtNetwork/QNetworkAccessManager>
#include <qt4/QtCore/qurl.h>
#include <qt4/QtCore/qobject.h>

using namespace bb::cascades;

class WebImageView: public bb::cascades::ImageView
{
	Q_OBJECT
	Q_PROPERTY (QUrl url READ url WRITE setUrl NOTIFY urlChanged)
	Q_PROPERTY (QString folder READ folder WRITE setFolder NOTIFY folderChanged)
	Q_PROPERTY (float loading READ loading WRITE setLoading NOTIFY loadingChanged)
	Q_PROPERTY (QUrl defaultImage READ defaultImage WRITE setDefaultImage NOTIFY defaultImageChanged)
	Q_PROPERTY (bool ready READ ready WRITE setReady NOTIFY readyChanged)

public:

	WebImageView(bb::cascades::Container *parent = 0);
	const QUrl& url() const;
	const QString& folder() const;
	const QUrl& defaultImage() const;
	double loading() const;
	bool ready();

public slots:

	void setUrl(const QUrl url);
	void setFolder(const QString folder);
	void setDefaultImage(const QUrl url);
	void setLoading(const float loading);

private slots:

	void imageLoaded();
	void downloadProgressed(qint64, qint64);
	void setReady(bool ready);

signals:

	void urlChanged();
	void folderChanged(QString folder);
	void defaultImageChanged();
	void loadingChanged();
	void readyChanged();
	void theImageLoaded();

private:

	static QNetworkAccessManager * _network_access_manager;
	QUrl _url;
	QString _folder;
	QList<QUrl> _urls;
	QList<QNetworkReply* > _replys;
	QUrl _default_image;
	float _loading;
	bool _ready;
	QString _cache_folder;
};

Q_DECLARE_METATYPE(WebImageView *);

#endif
