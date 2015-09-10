#include "WebImageView.hpp"
#include <QNetworkReply>

using namespace bb::cascades;

QNetworkAccessManager * WebImageView::_network_access_manager = new QNetworkAccessManager;

WebImageView::WebImageView(bb::cascades::Container *parent)
{
	_default_image  = "";
	_ready 			= false;
	_loading 		= 0.0;
	_folder		    = "";

	setReady(false);
}

const QUrl& WebImageView::url() const
{
	return _url;
}

const QString& WebImageView::folder() const
{
	return _folder;
}

void WebImageView::setFolder(const QString folder)
{
    _folder = folder;
	emit folderChanged(_folder);
}

void WebImageView::setUrl(const QUrl url)
{
	if(url != _url)
	{
		this->resetImage();
		_url = url;
		QString temp_name = url.path().mid(url.path().lastIndexOf("/"));

		if(_folder.length() > 0)
		{
		    _cache_folder = QDesktopServices::storageLocation(QDesktopServices::CacheLocation) + "/images_" + _folder;
		}
		else
		{
		    _cache_folder = QDesktopServices::storageLocation(QDesktopServices::CacheLocation) + "/images";
		}

        QDir cache_directory(_cache_folder);

        if (!cache_directory.exists())
        {
            cache_directory.mkpath(".");
        }

		QFile file(_cache_folder + temp_name);

		if(file.exists())
		{
			this->setImageSource("file://" + file.fileName());
			_loading = 1;
			emit loadingChanged();

			this->setReady(true);
		}
		else
		{
			_loading = 0.01;
			emit loadingChanged();
			if(_default_image != QUrl("")) setImage(Image(_default_image));
			_urls.push_back(url);
			_replys.push_back(_network_access_manager->get(QNetworkRequest(url)));
			connect(_replys.back(),SIGNAL(finished()), this, SLOT(imageLoaded()));
			connect(_replys.back(),SIGNAL(downloadProgress ( qint64 , qint64  )), this, SLOT(downloadProgressed(qint64,qint64)));
		}

		emit urlChanged();
	}
}

double WebImageView::loading() const
{
	return _loading;
}

void WebImageView::setLoading(const float loading)
{
	_loading = loading;
}

void WebImageView::imageLoaded()
{
	QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());

	if (reply->error() == QNetworkReply::NoError)
	{
		QVariant _replystatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
		int i = _replys.indexOf(reply);

		// HANDLES REDIRECTIONS
		if (_replystatus == 301 || _replystatus == 302)
		{
			QString redirectUrl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toString();
			_replys[i]= _network_access_manager->get(QNetworkRequest(redirectUrl));
			connect(_replys[i],SIGNAL(finished()), this, SLOT(imageLoaded()));
			connect(_replys[i],SIGNAL(downloadProgress ( qint64 , qint64  )), this, SLOT(downloadProgressed(qint64,qint64)));
		}
		else
		{
			if(_urls.at(i) == _url)
			{
				QString temp_name = _url.path().mid(_url.path().lastIndexOf("/"));

				if(_folder.length() > 0)
                {
                    _cache_folder = QDesktopServices::storageLocation(QDesktopServices::CacheLocation) + "/images_" + _folder;
                }
                else
                {
                    _cache_folder = QDesktopServices::storageLocation(QDesktopServices::CacheLocation) + "/images";
                }

                QDir cache_directory(_cache_folder);

                if (!cache_directory.exists())
                {
                    cache_directory.mkpath(".");
                }

				QFile file(_cache_folder + temp_name);
				file.open(QIODevice::WriteOnly);
				file.write(reply->readAll());
				file.close();
				this->setImageSource("file://" + file.fileName());

				this->setReady(true);
			}

			_urls.removeAt(i);
			_replys.removeAt(i);
		}
	}

	_loading = 1;
	emit loadingChanged();
	reply->deleteLater();

	emit theImageLoaded();
}

void WebImageView::downloadProgressed(qint64 bytes,qint64 total)
{
	QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());

	if(reply == _replys.back())
	{
		_loading =  double(bytes)/double(total);
		emit loadingChanged();
	}
}

const QUrl& WebImageView::defaultImage() const
{
	return _default_image;
}

void WebImageView::setDefaultImage(const QUrl url)
{
	_default_image = url;
	if(_default_image!= QUrl("")) setImage(Image(_default_image));
	emit defaultImageChanged();
}

bool WebImageView::ready()
{
	return _ready;
}

void WebImageView::setReady(bool ready)
{
	_ready = ready;
	emit this->readyChanged();
}
