#include "WallpaperImage.hpp"
#include <QNetworkReply>

using namespace bb::cascades;

QNetworkAccessManager * WallpaperImage::mNetManager = new QNetworkAccessManager;

WallpaperImage::WallpaperImage(bb::cascades::Container *parent)
{
	cacheLocation = QDesktopServices::storageLocation(QDesktopServices::CacheLocation) + "/wallpapers";
	QDir cacheDir(cacheLocation);

	if (!cacheDir.exists())
	{
		cacheDir.mkpath(".");
	}

	defaultImageUrl = "";
	mReady 			= false;
	mLoading 		= 0.0;
	mImageID		= "";

	setReady(false);
}

const QUrl& WallpaperImage::url() const
{
	return mUrl;
}

const QString& WallpaperImage::imageID() const
{
	return mImageID;
}

void WallpaperImage::setImageID(const QString imageID)
{
	mImageID = imageID;
	emit imageIDChanged(mImageID);
}

void WallpaperImage::setUrl(const QUrl url)
{
	if(url != mUrl)
	{
		this->resetImage();
		mUrl = url;
		QString tempName = url.path().mid(url.path().lastIndexOf("/"));

		QFile file(cacheLocation + tempName);

		if(file.exists())
		{
			this->setImageSource("file://" + file.fileName());
			mLoading = 1;
			emit loadingChanged();
		}
		else
		{
			mLoading = 0.01;
			emit loadingChanged();
			if(defaultImageUrl != QUrl("")) setImage(Image(defaultImageUrl));
			urls.push_back(url);
			replys.push_back(mNetManager->get(QNetworkRequest(url)));
			connect(replys.back(),SIGNAL(finished()), this, SLOT(imageLoaded()));
			connect(replys.back(),SIGNAL(downloadProgress ( qint64 , qint64  )), this, SLOT(downloadProgressed(qint64,qint64)));
		}

		emit urlChanged();
	}
}

double WallpaperImage::loading() const
{
	return mLoading;
}

void WallpaperImage::setLoading(const float loading)
{
	mLoading = loading;
}

void WallpaperImage::imageLoaded()
{
	QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());

	if (reply->error() == QNetworkReply::NoError)
	{
		QVariant replyStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
		int i = replys.indexOf(reply);

		// HANDLES REDIRECTIONS
		if (replyStatus == 301 || replyStatus == 302)
		{
			QString redirectUrl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toString();
			replys[i]= mNetManager->get(QNetworkRequest(redirectUrl));
			connect(replys[i],SIGNAL(finished()), this, SLOT(imageLoaded()));
			connect(replys[i],SIGNAL(downloadProgress ( qint64 , qint64  )), this, SLOT(downloadProgressed(qint64,qint64)));
		}
		else
		{
			if(urls.at(i)==mUrl)
			{
				QString tempName = mUrl.path().mid(mUrl.path().lastIndexOf("/"));

				if(mImageID.length() > 0)
				{
				    tempName = mImageID;
				}

				QFile file(cacheLocation + tempName);
				file.open(QIODevice::WriteOnly);
				file.write(reply->readAll());
				file.close();
				this->setImageSource("file://" + file.fileName());

				this->setReady(true);
			}

			urls.removeAt(i);
			replys.removeAt(i);
		}
	}

	mLoading = 1;
	emit loadingChanged();
	reply->deleteLater();
}

void WallpaperImage::downloadProgressed(qint64 bytes,qint64 total)
{
	QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());

	if(reply==replys.back())
	{
		mLoading =  double(bytes)/double(total);
		emit loadingChanged();
	}
}

const QUrl& WallpaperImage::defaultImage() const
{
	return defaultImageUrl;
}

void WallpaperImage::setDefaultImage(const QUrl url)
{
	defaultImageUrl=url;
	if(defaultImageUrl!=QUrl("")) setImage(Image(defaultImageUrl));
	emit defaultImageChanged();
}

bool WallpaperImage::ready()
{
	return mReady;
}

void WallpaperImage::setReady(bool ready)
{
	mReady = ready;
	emit this->readyChanged();
}
