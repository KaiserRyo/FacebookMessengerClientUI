/****************************************************************************
** Meta object code from reading C++ file 'NemLocation.hpp'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.5)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/NemLocation/NemLocation.hpp"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'NemLocation.hpp' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.5. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_NemLocation[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      32,   13,   12,   12, 0x05,

 // slots: signature, parameters, type, tag, flags
      63,   59,   12,   12, 0x08,

 // methods: signature, parameters, type, tag, flags
      93,   12,   12,   12, 0x02,

       0        // eod
};

static const char qt_meta_stringdata_NemLocation[] = {
    "NemLocation\0\0latitude,longitude\0"
    "gotLocation(double,double)\0pos\0"
    "gotPosition(QGeoPositionInfo)\0"
    "getLocation()\0"
};

void NemLocation::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        NemLocation *_t = static_cast<NemLocation *>(_o);
        switch (_id) {
        case 0: _t->gotLocation((*reinterpret_cast< double(*)>(_a[1])),(*reinterpret_cast< double(*)>(_a[2]))); break;
        case 1: _t->gotPosition((*reinterpret_cast< const QGeoPositionInfo(*)>(_a[1]))); break;
        case 2: _t->getLocation(); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData NemLocation::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject NemLocation::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_NemLocation,
      qt_meta_data_NemLocation, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &NemLocation::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *NemLocation::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *NemLocation::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_NemLocation))
        return static_cast<void*>(const_cast< NemLocation*>(this));
    return QObject::qt_metacast(_clname);
}

int NemLocation::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    }
    return _id;
}

// SIGNAL 0
void NemLocation::gotLocation(double _t1, double _t2)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_END_MOC_NAMESPACE
