#include "PictureViewer.h"

#include <QDebug>
#include <bb/system/CardDoneMessage>

PictureViewer::PictureViewer(QObject* parent)
    : QObject(parent)
{
	invokeManager = new InvokeManager();
}

void PictureViewer::invokePictureViewer(QString filePath)
{
	bb::system::InvokeRequest request;
	request.setTarget("sys.pictures.card.previewer");
	request.setAction("bb.action.VIEW");
	request.setUri(filePath);
	//request.setFileTransferMode(bb::system::FileTransferMode::CopyReadWrite);

	QString mimeType = "image/jpeg";

	if(filePath.contains("jpg", Qt::CaseInsensitive))
	{
	    mimeType = "image/jpg";
	}
	else if(filePath.contains("png", Qt::CaseInsensitive))
	{
	    mimeType = "image/png";
	}

	request.setMimeType(mimeType);

	invokeManager->invoke(request);

	bool connected = connect(invokeManager, SIGNAL(childCardDone(const bb::system::CardDoneMessage&)),
	this, SLOT(onChildCardDone(const bb::system::CardDoneMessage&)));

	if(connected)
	{
		qDebug() << "CONNECTED: " << filePath;
	}
}

void PictureViewer::onChildCardDone(const bb::system::CardDoneMessage &message)
{
	if(message.reason() != "Canceled")
	{
		emit complete(message.data());
	}
	else
	{
		emit canceled();
	}
}
