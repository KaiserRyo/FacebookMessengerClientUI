/****************************************************************************
** Meta object code from reading C++ file 'NemAPI.hpp'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.5)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/NemAPI/NemAPI.hpp"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'NemAPI.hpp' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.5. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_NemAPI[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
      22,   14, // methods
       1,  124, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       9,       // signalCount

 // signals: signature, parameters, type, tag, flags
       8,    7,    7,    7, 0x05,
      31,    7,    7,    7, 0x05,
      43,    7,    7,    7, 0x05,
      77,   58,    7,    7, 0x05,
     125,  111,    7,    7, 0x05,
     157,  111,    7,    7, 0x05,
     199,  192,    7,    7, 0x05,
     228,  192,    7,    7, 0x05,
     295,  257,    7,    7, 0x05,

 // slots: signature, parameters, type, tag, flags
     337,    7,    7,    7, 0x0a,
     350,    7,    7,    7, 0x0a,
     387,  380,    7,    7, 0x0a,
     426,    7,    7,    7, 0x0a,
     454,    7,    7,    7, 0x0a,
     472,    7,    7,    7, 0x0a,

 // methods: signature, parameters, type, tag, flags
     511,  493,    7,    7, 0x02,
     556,  543,    7,    7, 0x02,
     571,    7,    7,    7, 0x02,
     596,  580,    7,    7, 0x02,
     646,  641,  633,    7, 0x02,
     671,  664,    7,    7, 0x02,
     693,  664,    7,    7, 0x02,

 // properties: name, type, flags
     721,  716, 0x01495003,

 // properties: notify_signal_id
       0,

       0        // eod
};

static const char qt_meta_stringdata_NemAPI[] = {
    "NemAPI\0\0connectedChanged(bool)\0"
    "connected()\0disconnected()\0"
    "error,errorMessage\0error(QXmppClient::Error,QString)\0"
    "messageObject\0messageReceivedSignal(QVariant)\0"
    "messageAcknowledgeSignal(QVariant)\0"
    "fromID\0startedTypingSignal(QString)\0"
    "stoppedTypingSignal(QString)\0"
    "response,httpcode,endpoint,identifier\0"
    "complete(QString,QString,QString,QString)\0"
    "onComplete()\0messageReceived(QXmppMessage)\0"
    ",value\0messageAcknowledged(QXmppMessage,bool)\0"
    "onError(QXmppClient::Error)\0"
    "clientConnected()\0clientDisconnected()\0"
    "username,password\0login_natively(QString,QString)\0"
    "access_token\0login(QString)\0logout()\0"
    "from,to,message\0sendMessage(QString,QString,QString)\0"
    "QString\0time\0timeSince(qint64)\0params\0"
    "getFacebook(QVariant)\0postFacebook(QVariant)\0"
    "bool\0_connected\0"
};

void NemAPI::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        NemAPI *_t = static_cast<NemAPI *>(_o);
        switch (_id) {
        case 0: _t->connectedChanged((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 1: _t->connected(); break;
        case 2: _t->disconnected(); break;
        case 3: _t->error((*reinterpret_cast< QXmppClient::Error(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 4: _t->messageReceivedSignal((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 5: _t->messageAcknowledgeSignal((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 6: _t->startedTypingSignal((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 7: _t->stoppedTypingSignal((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 8: _t->complete((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])),(*reinterpret_cast< QString(*)>(_a[3])),(*reinterpret_cast< QString(*)>(_a[4]))); break;
        case 9: _t->onComplete(); break;
        case 10: _t->messageReceived((*reinterpret_cast< const QXmppMessage(*)>(_a[1]))); break;
        case 11: _t->messageAcknowledged((*reinterpret_cast< const QXmppMessage(*)>(_a[1])),(*reinterpret_cast< const bool(*)>(_a[2]))); break;
        case 12: _t->onError((*reinterpret_cast< QXmppClient::Error(*)>(_a[1]))); break;
        case 13: _t->clientConnected(); break;
        case 14: _t->clientDisconnected(); break;
        case 15: _t->login_natively((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 16: _t->login((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 17: _t->logout(); break;
        case 18: _t->sendMessage((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])),(*reinterpret_cast< QString(*)>(_a[3]))); break;
        case 19: { QString _r = _t->timeSince((*reinterpret_cast< qint64(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 20: _t->getFacebook((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 21: _t->postFacebook((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData NemAPI::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject NemAPI::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_NemAPI,
      qt_meta_data_NemAPI, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &NemAPI::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *NemAPI::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *NemAPI::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_NemAPI))
        return static_cast<void*>(const_cast< NemAPI*>(this));
    return QObject::qt_metacast(_clname);
}

int NemAPI::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 22)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 22;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< bool*>(_v) = getConnected(); break;
        }
        _id -= 1;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setConnected(*reinterpret_cast< bool*>(_v)); break;
        }
        _id -= 1;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 1;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void NemAPI::connectedChanged(bool _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void NemAPI::connected()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void NemAPI::disconnected()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}

// SIGNAL 3
void NemAPI::error(QXmppClient::Error _t1, QString _t2)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}

// SIGNAL 4
void NemAPI::messageReceivedSignal(QVariant _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 4, _a);
}

// SIGNAL 5
void NemAPI::messageAcknowledgeSignal(QVariant _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 5, _a);
}

// SIGNAL 6
void NemAPI::startedTypingSignal(QString _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 6, _a);
}

// SIGNAL 7
void NemAPI::stoppedTypingSignal(QString _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 7, _a);
}

// SIGNAL 8
void NemAPI::complete(QString _t1, QString _t2, QString _t3, QString _t4)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)), const_cast<void*>(reinterpret_cast<const void*>(&_t4)) };
    QMetaObject::activate(this, &staticMetaObject, 8, _a);
}
QT_END_MOC_NAMESPACE
