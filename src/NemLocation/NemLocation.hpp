#ifndef NEMLOCATION_H_
#define NEMLOCATION_H_

#include <QtCore/QObject>

#include <bb/platform/geo/GeoLocation>

#include <QtLocationSubset/QGeoPositionInfo>
#include <QtLocationSubset/QGeoPositionInfoSource>
#include <QtLocationSubset/QGeoSatelliteInfo>
#include <QtLocationSubset/QGeoSatelliteInfoSource>

using namespace QtMobilitySubset;

class NemLocation : public QObject
{
    Q_OBJECT

public:
    NemLocation(QObject* parent = 0);

    Q_INVOKABLE void getLocation();

Q_SIGNALS:

    void gotLocation(double latitude, double longitude);

private Q_SLOTS:

    void gotPosition(const QGeoPositionInfo & pos);

private :


};

#endif /* NEMLOCATION_H_ */

