/****************************************************************************
** Meta object code from reading C++ file 'WebImageView.hpp'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.5)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/WebImageView/WebImageView.hpp"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'WebImageView.hpp' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.5. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_WebImageView[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
      13,   14, // methods
       5,   79, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       6,       // signalCount

 // signals: signature, parameters, type, tag, flags
      14,   13,   13,   13, 0x05,
      34,   27,   13,   13, 0x05,
      57,   13,   13,   13, 0x05,
      79,   13,   13,   13, 0x05,
      96,   13,   13,   13, 0x05,
     111,   13,   13,   13, 0x05,

 // slots: signature, parameters, type, tag, flags
     132,  128,   13,   13, 0x0a,
     145,   27,   13,   13, 0x0a,
     164,  128,   13,   13, 0x0a,
     194,  186,   13,   13, 0x0a,
     212,   13,   13,   13, 0x08,
     228,  226,   13,   13, 0x08,
     268,  262,   13,   13, 0x08,

 // properties: name, type, flags
     128,  283, 0x11495103,
      27,  288, 0x0a495103,
     186,  296, 0x87495103,
     302,  283, 0x11495103,
     262,  315, 0x01495103,

 // properties: notify_signal_id
       0,
       1,
       3,
       2,
       4,

       0        // eod
};

static const char qt_meta_stringdata_WebImageView[] = {
    "WebImageView\0\0urlChanged()\0folder\0"
    "folderChanged(QString)\0defaultImageChanged()\0"
    "loadingChanged()\0readyChanged()\0"
    "theImageLoaded()\0url\0setUrl(QUrl)\0"
    "setFolder(QString)\0setDefaultImage(QUrl)\0"
    "loading\0setLoading(float)\0imageLoaded()\0"
    ",\0downloadProgressed(qint64,qint64)\0"
    "ready\0setReady(bool)\0QUrl\0QString\0"
    "float\0defaultImage\0bool\0"
};

void WebImageView::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        WebImageView *_t = static_cast<WebImageView *>(_o);
        switch (_id) {
        case 0: _t->urlChanged(); break;
        case 1: _t->folderChanged((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 2: _t->defaultImageChanged(); break;
        case 3: _t->loadingChanged(); break;
        case 4: _t->readyChanged(); break;
        case 5: _t->theImageLoaded(); break;
        case 6: _t->setUrl((*reinterpret_cast< const QUrl(*)>(_a[1]))); break;
        case 7: _t->setFolder((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 8: _t->setDefaultImage((*reinterpret_cast< const QUrl(*)>(_a[1]))); break;
        case 9: _t->setLoading((*reinterpret_cast< const float(*)>(_a[1]))); break;
        case 10: _t->imageLoaded(); break;
        case 11: _t->downloadProgressed((*reinterpret_cast< qint64(*)>(_a[1])),(*reinterpret_cast< qint64(*)>(_a[2]))); break;
        case 12: _t->setReady((*reinterpret_cast< bool(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData WebImageView::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject WebImageView::staticMetaObject = {
    { &bb::cascades::ImageView::staticMetaObject, qt_meta_stringdata_WebImageView,
      qt_meta_data_WebImageView, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &WebImageView::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *WebImageView::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *WebImageView::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_WebImageView))
        return static_cast<void*>(const_cast< WebImageView*>(this));
    typedef bb::cascades::ImageView QMocSuperClass;
    return QMocSuperClass::qt_metacast(_clname);
}

int WebImageView::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    typedef bb::cascades::ImageView QMocSuperClass;
    _id = QMocSuperClass::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 13)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 13;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QUrl*>(_v) = url(); break;
        case 1: *reinterpret_cast< QString*>(_v) = folder(); break;
        case 2: *reinterpret_cast< float*>(_v) = loading(); break;
        case 3: *reinterpret_cast< QUrl*>(_v) = defaultImage(); break;
        case 4: *reinterpret_cast< bool*>(_v) = ready(); break;
        }
        _id -= 5;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setUrl(*reinterpret_cast< QUrl*>(_v)); break;
        case 1: setFolder(*reinterpret_cast< QString*>(_v)); break;
        case 2: setLoading(*reinterpret_cast< float*>(_v)); break;
        case 3: setDefaultImage(*reinterpret_cast< QUrl*>(_v)); break;
        case 4: setReady(*reinterpret_cast< bool*>(_v)); break;
        }
        _id -= 5;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 5;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void WebImageView::urlChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void WebImageView::folderChanged(QString _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void WebImageView::defaultImageChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}

// SIGNAL 3
void WebImageView::loadingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, 0);
}

// SIGNAL 4
void WebImageView::readyChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, 0);
}

// SIGNAL 5
void WebImageView::theImageLoaded()
{
    QMetaObject::activate(this, &staticMetaObject, 5, 0);
}
QT_END_MOC_NAMESPACE
