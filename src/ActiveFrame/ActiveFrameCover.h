
#ifndef ACTIVEFRAMECOVER_H_
#define ACTIVEFRAMECOVER_H_

#include <QObject>
#include <bb/cascades/SceneCover>

using namespace ::bb::cascades;

class ActiveFrameCover: public SceneCover
{
    Q_OBJECT

public:
    ActiveFrameCover(QObject *parent=0);
    virtual ~ActiveFrameCover() { }

    Q_INVOKABLE void sync(QVariant data);
    Q_INVOKABLE QString get_string_from_file(QString fileName);

signals:
    void load(QVariant data);


private:

    QSettings* _settings;

};

#endif /* ACTIVEFRAMECOVER_H_ */

