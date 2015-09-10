/****************************************************************************
** Meta object code from reading C++ file 'Card.hpp'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.5)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/Card/Card.hpp"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'Card.hpp' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.5. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_Card[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      14,    6,    5,    5, 0x08,
      64,   52,    5,    5, 0x08,
     119,  105,    5,    5, 0x08,
     172,    5,    5,    5, 0x08,

 // methods: signature, parameters, type, tag, flags
     190,  185,    5,    5, 0x02,
     228,    5,    5,    5, 0x02,

       0        // eod
};

static const char qt_meta_stringdata_Card[] = {
    "Card\0\0request\0on_invoked(bb::system::InvokeRequest)\0"
    "doneMessage\0card_pooled(bb::system::CardDoneMessage)\0"
    "resizeMessage\0"
    "card_resize_requested(bb::system::CardResizeMessage)\0"
    "close_card()\0page\0"
    "pushPageFromCard(bb::cascades::Page*)\0"
    "navigationPanePop()\0"
};

void Card::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        Card *_t = static_cast<Card *>(_o);
        switch (_id) {
        case 0: _t->on_invoked((*reinterpret_cast< const bb::system::InvokeRequest(*)>(_a[1]))); break;
        case 1: _t->card_pooled((*reinterpret_cast< const bb::system::CardDoneMessage(*)>(_a[1]))); break;
        case 2: _t->card_resize_requested((*reinterpret_cast< const bb::system::CardResizeMessage(*)>(_a[1]))); break;
        case 3: _t->close_card(); break;
        case 4: _t->pushPageFromCard((*reinterpret_cast< bb::cascades::Page*(*)>(_a[1]))); break;
        case 5: _t->navigationPanePop(); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData Card::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject Card::staticMetaObject = {
    { &ApplicationUIBase::staticMetaObject, qt_meta_stringdata_Card,
      qt_meta_data_Card, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &Card::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *Card::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *Card::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Card))
        return static_cast<void*>(const_cast< Card*>(this));
    return ApplicationUIBase::qt_metacast(_clname);
}

int Card::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = ApplicationUIBase::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
