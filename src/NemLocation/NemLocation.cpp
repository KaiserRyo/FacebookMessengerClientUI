#include "NemLocation.hpp"

#include <QtCore/QtCore>

#include <bb/platform/geo/GeoLocation>
#include <QtLocationSubset/QGeoPositionInfo>
#include <QtLocationSubset/QGeoPositionInfoSource>

using bb::platform::geo::GeoLocation;
using namespace QtMobilitySubset;

NemLocation::NemLocation(QObject* parent) : QObject(parent)
{

}

void NemLocation::getLocation()
{
    QGeoPositionInfoSource *src = QGeoPositionInfoSource::createDefaultSource(this);

    bool positionUpdatedConnected = connect(src, SIGNAL(positionUpdated(const QGeoPositionInfo &)), this, SLOT(gotPosition(const QGeoPositionInfo &)));

    if (positionUpdatedConnected)
    {
        src->requestUpdate();
    }
}

void NemLocation::gotPosition(const QGeoPositionInfo & pos)
{
    emit gotLocation(pos.coordinate().latitude(), pos.coordinate().longitude());
}
