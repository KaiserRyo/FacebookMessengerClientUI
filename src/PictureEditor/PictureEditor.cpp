#include "PictureEditor.h"

#include <QDebug>
#include <bb/system/CardDoneMessage>
#include <bb/PpsObject>

PictureEditor::PictureEditor(QObject* parent)
    : QObject(parent)
{
	invokeManager = new InvokeManager();
}

void PictureEditor::invokePictureEditor(QString filePath, bool crop, QString dimensions)
{
	bb::system::InvokeRequest request;
	request.setTarget("sys.pictureeditor.cardeditor");
	request.setAction("bb.action.EDIT");
	request.setUri(filePath);
	request.setFileTransferMode(bb::system::FileTransferMode::CopyReadWrite);
	request.setMimeType("image/jpeg");

	if(crop)
	{
	    bool up_scale = false;

	    QVariantMap data = QVariantMap();
        data["size"]     = dimensions;
        data["upScale"]  = QString(up_scale);
        bool ok;
        QByteArray encData = bb::PpsObject::encode(data, &ok);
        request.setData(encData);
	}

	invokeManager->invoke(request);

	bool connected = connect(invokeManager, SIGNAL(childCardDone(const bb::system::CardDoneMessage&)),
	this, SLOT(onChildCardDone(const bb::system::CardDoneMessage&)));

	if(connected)
	{
		qDebug() << "CONNECTED";
	}
}

void PictureEditor::onChildCardDone(const bb::system::CardDoneMessage &message)
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
