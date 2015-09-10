#include "ActiveFrameCover.h"

#include <bb/cascades/SceneCover>
#include <bb/cascades/Container>
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>

using namespace bb::cascades;

ActiveFrameCover::ActiveFrameCover(QObject *parent)
    : SceneCover(parent)
{
    QmlDocument *qml = QmlDocument::create("asset:///activeframes/ActiveFrameCover.qml").parent(parent);
    qml->setContextProperty("_frame", this);
    Container *mainContainer = qml->createRootObject<Container>();
    setContent(mainContainer);
}

void ActiveFrameCover::sync(QVariant data)
{
    emit load(data);
}

QString ActiveFrameCover::get_string_from_file(QString fileName)
{
    QFile theFile(fileName);
    theFile.open(QIODevice::ReadOnly);
    QTextStream fileBytes(&theFile);
    QString fileString = fileBytes.readAll();
    theFile.close();

    return fileString;
}
