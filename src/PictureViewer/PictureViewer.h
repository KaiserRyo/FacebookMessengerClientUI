
#ifndef PICTUREVIEWER_H_
#define PICTUREVIEWER_H_

#include <QtCore/QObject>
#include <bb/system/CardDoneMessage>
#include <bb/system/InvokeManager>

using bb::system::InvokeManager;

namespace bb
{
    namespace cascades
    {
        namespace system
		{
			class InvokeManager;
		}
    }
}

class PictureViewer : public QObject
{
    Q_OBJECT

public:
    PictureViewer(QObject* parent = 0);

    Q_INVOKABLE void invokePictureViewer(QString filePath);

Q_SIGNALS:
    void complete(QString imageSource);
    void canceled();

private Q_SLOTS:
    void onChildCardDone(const bb::system::CardDoneMessage &message);

private:
    InvokeManager* invokeManager;

};

#endif
