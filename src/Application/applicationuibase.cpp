#include <libexif/exif-data.h>
#include "ApplicationUIBase.hpp"

#include <bb/cascades/LocaleHandler>
#include <bb/system/InvokeManager>
#include <bb/platform/Notification>
#include <bb/PackageInfo>
#include <bb/device/DisplayInfo>
#include <bb/system/Clipboard>
#include <bb/data/JsonDataAccess>
#include <bb/PpsObject>
#include <bb/platform/NotificationDefaultApplicationSettings>
#include <bb/platform/PlatformInfo>

#include <src/Utilities/Utilities.hpp>
#include <src/ActiveFrame/ActiveFrameCover.h>
#include <bb/cascades/multimedia/Camera>
#include <bb/cascades/multimedia/CameraSettings>

#include <Flurry.h>

using namespace bb::cascades;
using namespace bb::system;
using namespace bb::cascades;
using namespace bb::platform;

using bb::data::JsonDataAccess;
using bb::platform::Notification;
using bb::PackageInfo;
using bb::device::DisplayInfo;
using bb::PpsObject;

bool IS_BETA = false;

ApplicationUIBase::ApplicationUIBase(InvokeManager *invokeManager) :
        _invoke_manager(invokeManager)
{
    set_dark_theme((get_setting("application_theme", "bright") == "dark"));
    set_show_rate_us(false);
    set_connected(false);
    set_is_typing(false);
    setNotificationBadge(false);
    setNotificationTooltip(false);

    set_is_passport((device() == "passport"));

    _settings = new QSettings(Utilities::author_name(), Utilities::app_name());

    _translator = new QTranslator(this);
    _locale_handler = new LocaleHandler(this);

    connect(_locale_handler, SIGNAL(systemLanguageChanged()), this, SLOT(on_system_language_changed()));

    on_system_language_changed();

    NotificationDefaultApplicationSettings notification_settings;
    notification_settings.setPreview(NotificationPriorityPolicy::Allow);
    notification_settings.apply();

    _wallpaper           = get_setting("wallpaper", "");
    set_wallpaper(_wallpaper);

    _color_scheme        = get_setting("color_scheme", "#29777a");
    set_color_scheme(_color_scheme);

    if(contains(os_version(), "10.3.0"))
    {
        set_setting("hub_integration", "false");
        Utilities::set_string_to_file("false", "data/hub_integration.json");
    }
}

ApplicationUIBase::~ApplicationUIBase()
{

}

QString ApplicationUIBase::fb_app_id()
{
    return Utilities::fb_app_id();
}

bool ApplicationUIBase::is_beta()
{
    return IS_BETA;
}

QString ApplicationUIBase::os_version()
{
    PlatformInfo info;

    return info.osVersion();
}

QString ApplicationUIBase::app_name()
{
    return Utilities::app_name();
}

QString ApplicationUIBase::app_hashtag()
{
    return "#" + app_name();
}

QString ApplicationUIBase::app_version()
{
    PackageInfo info;

    return info.version();
}

bool ApplicationUIBase::get_dark_theme()
{
    return _dark_theme;
}

void ApplicationUIBase::set_dark_theme(bool value)
{
    _dark_theme = value;
    dark_theme_changed(_dark_theme);
}

bool ApplicationUIBase::is_card()
{
    return _is_card;
}

void ApplicationUIBase::set_is_card(bool value)
{
    _is_card = value;
}

void ApplicationUIBase::start_headless()
{
    bb::system::InvokeRequest request;
    request.setTarget(Utilities::headless_target_id());
    request.setAction("bb.action.START");
    request.setMimeType("text/plain");

    QString command = "start_headless";
    request.setData(command.toAscii());

    bb::system::InvokeTargetReply *reply = _invoke_manager->invoke(request);

    if (!reply)
    {
        qDebug() << "**** FAILED start_headless(): " << reply->errorCode();
        reply->deleteLater();
    }
    else
    {
        qDebug() << "**** SUCCESS start_headless()";
    }
}

void ApplicationUIBase::command_headless(QString command)
{
    bb::system::InvokeRequest request;
    request.setTarget(Utilities::headless_target_id());
    request.setAction("bb.action.COMMAND");
    request.setMimeType("text/plain");
    request.setData(command.toAscii());

    bb::system::InvokeTargetReply *reply = _invoke_manager->invoke(request);

    if (!reply)
    {
       qDebug() << "**** FAILED command_headless(): " << reply->errorCode();
       reply->deleteLater();
    }
    else
    {
       qDebug() << "**** SUCCESS command_headless()";
    }
}

void ApplicationUIBase::clear_notification_effects()
{
    Utilities::clear_notification_effects();
}

void ApplicationUIBase::clear_notifications()
{
    Utilities::clear_notifications();
}

QString ApplicationUIBase::get_string_from_file(QString file_name)
{
    return Utilities::get_string_from_file(file_name);
}

bool ApplicationUIBase::get_connected()
{
    return _connected;
}

void ApplicationUIBase::set_connected(bool value)
{
    _connected = value;
    emit connected_changed(value);
}

bool ApplicationUIBase::get_is_typing()
{
    return _is_typing;
}

void ApplicationUIBase::set_is_typing(bool value)
{
    _is_typing = value;
    emit is_typing_changed(value);
}

bool ApplicationUIBase::get_is_passport()
{
    return _is_typing;
}

void ApplicationUIBase::set_is_passport(bool value)
{
    _is_passport = value;
    emit is_passport_changed(value);
}

bool ApplicationUIBase::get_show_rate_us()
{
    return _show_rate_us;
}

void ApplicationUIBase::set_show_rate_us(bool value)
{
    _show_rate_us = value;
    emit show_rate_us_changed(value);
}

void ApplicationUIBase::notify_regular(QString title, QString message)
{
    Utilities::notify_regular(title, message);
}

qint64 ApplicationUIBase::get_folder_size(QString folder_path)
{
    return Utilities::get_folder_size(folder_path);
}

qint64 ApplicationUIBase::get_cache_size()
{
    return Utilities::get_cache_size();
}

void ApplicationUIBase::set_string_to_file(QString log, QString file_name)
{
    Utilities::set_string_to_file(log, file_name);
}

bool ApplicationUIBase::contains(QString text, QString find)
{
    return Utilities::contains(text, find);
}

QString ApplicationUIBase::get_setting(QString key, QString value)
{
    return Utilities::get_setting(key, value);
}

void ApplicationUIBase::set_setting(QString key, QString value)
{
    Utilities::set_setting(key, value);
}

void ApplicationUIBase::wipe_folder_contents(QString folder)
{
    Utilities::wipe_folder_contents(folder);
}

void ApplicationUIBase::wipe_folder(QString folder)
{
    Utilities::wipe_folder(folder);
}

QString ApplicationUIBase::regex(QString text, QString expression, int index)
{
    return Utilities::regex(text, expression, index);
}

void ApplicationUIBase::delete_file(QString file_name)
{
    Utilities::delete_file(file_name);
}

int ApplicationUIBase::get_display_height()
{
    DisplayInfo displayInfo;
    return displayInfo.pixelSize().height();
}

int ApplicationUIBase::get_display_width()
{
    DisplayInfo displayInfo;
    return displayInfo.pixelSize().width();
}

void ApplicationUIBase::copy_file(QString from, QString to)
{
    Utilities::copy_file(from, to);
}

void ApplicationUIBase::copy_and_remove_file(QString from, QString to)
{
    Utilities::copy_and_remove_file(from, to);
}

void ApplicationUIBase::copy_to_clipboard(QByteArray data)
{
    bb::system::Clipboard clipboard;
    clipboard.clear();
    clipboard.insert("text/plain", data);
}

void ApplicationUIBase::on_system_language_changed()
{
    QCoreApplication::instance()->removeTranslator(_translator);
    QString locale_string = QLocale().name();
    QString file_name = QString("Card_%1").arg(locale_string);

    if (_translator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(_translator);
    }
    else
    {
        //qWarning() << tr("cannot load language file '%1").arg(file_name);
    }
}

void ApplicationUIBase::pre_process(QString imagePath, bool mirror)
{
    QImage image = QImage(imagePath);

    QTransform transform;
    transform.rotate(90);
    image = image.transformed(transform);
    image.save(imagePath, "JPG");

    bool test = mirror;

    mirror = false;
}

void ApplicationUIBase::correct_rotation(QString imagePath)
{
    QImage image = QImage(imagePath);

    QTransform transform;
    transform.rotate(get_image_rotation(QUrl(imagePath)));

    image = image.transformed(transform);

    image.save(imagePath, "JPG");
}

qreal ApplicationUIBase::get_image_rotation(QUrl _url)
{
    qreal rotation = -1;
    QString url = _url.toLocalFile();

    if (url.endsWith("jpg", Qt::CaseInsensitive) || url.endsWith("png", Qt::CaseInsensitive))
    {
        QByteArray ba = url.toLocal8Bit();
        ExifData* exifData = exif_data_new_from_file(ba.constData());

        if (exifData != NULL)
        {
            ExifEntry* exifEntry = exif_content_get_entry(exifData->ifd[EXIF_IFD_0], EXIF_TAG_ORIENTATION);

            if (exifEntry != NULL)
            {
                char value[256] = { 0, };
                memset(value, 0, sizeof(value));
                exif_entry_get_value(exifEntry, value, sizeof(value));

                QString orient = QString::fromLocal8Bit(value);

                if (orient.compare("bottom-right", Qt::CaseInsensitive) == 0)
                {
                    rotation = 180.0;
                }
                else if (orient.compare("right-top", Qt::CaseInsensitive) == 0)
                {
                    rotation = 90.0;
                }
                else if (orient.compare("left-bottom", Qt::CaseInsensitive) == 0)
                {
                    rotation = 270.0;
                }

                delete exifEntry;
            }

            delete exifData;
        }
    }

    return rotation;
}

QString ApplicationUIBase::get_color_scheme()
{
    return _color_scheme;
}

void ApplicationUIBase::set_color_scheme(QString value)
{
    _color_scheme = value;
    emit color_scheme_changed(value);
}

QString ApplicationUIBase::get_wallpaper()
{
    return _wallpaper;
}

void ApplicationUIBase::set_wallpaper(QString value)
{
    _wallpaper = value;
    emit wallpaper_changed(value);
}

void ApplicationUIBase::invoke_bbworld(QString uri)
{
    InvokeRequest request;
    request.setMimeType("application/x-bb-appworld");
    request.setAction("bb.action.OPEN");
    request.setUri(uri);
    _invoke_manager->invoke(request);
}

void ApplicationUIBase::invoke_browser(QString url)
{
    InvokeRequest request;
    request.setTarget("sys.browser");
    request.setAction("bb.action.OPEN");
    request.setUri(url);
    _invoke_manager->invoke(request);
}

QString ApplicationUIBase::device()
{
    QString device = "";

    if(get_display_height() == 1440 && get_display_width() == 1440)
    {
        device = "passport";
    }
    else if(get_display_height() == 720 && get_display_width() == 720)
    {
        device = "q10";
    }
    else if(get_display_height() == 1280 && get_display_width() == 768)
    {
        device = "z10";
    }
    else if(get_display_height() == 1280 && get_display_width() == 720)
    {
        device = "z30";
    }

    return device;
}

void ApplicationUIBase::set_aspect_ratio(bb::cascades::multimedia::Camera *camera, const float aspect)
{
    #define DELTA(x, y) (x>y?(x-y):(y-x))
    CameraSettings camsettings;
    camera->getSettings(&camsettings);
    QVariantList reslist = camera->supportedCaptureResolutions(CameraMode::Photo);

    for (int i=0; i<reslist.count(); i++)
    {
        QSize res = reslist[i].toSize();
        qDebug() << "supported resolution: " << res.width() << "x" << res.height();
        // check for w:h or h:w within 5px margin of error...
        if ((DELTA(res.width() * aspect, res.height()) < 5) || (DELTA(res.width(), res.height() * aspect) < 5))
        {
            qDebug() << "picking resolution: " << res.width() << "x" << res.height();
            camsettings.setCaptureResolution(res);
        }
    }

    camera->applySettings(&camsettings);
}

void ApplicationUIBase::convert_to_jpeg(QString file_path, QString new_path)
{
    QImage image = QImage(file_path);
    image.save(new_path, "JPG");

    qDebug() << "CONVERTED TO JPG: file_path: " + file_path + ", new_path: " + new_path;
}

void ApplicationUIBase::resize_photo(QString file_path)
{
    QImage image = QImage(file_path);
    image = image.scaled(640, 640, Qt::IgnoreAspectRatio, Qt::SmoothTransformation);
    image.save(file_path, "JPG");

    qDebug() << "RESIZED: " + file_path;
}

void ApplicationUIBase::mirror_photo(QString file_path)
{
    QImage image = QImage(file_path);
    image = image.mirrored(true, false);
    image.save(file_path, "JPG");

    qDebug() << "MIRRORED: " + file_path;
}

void ApplicationUIBase::invoke_media_player(QString uri)
{
    InvokeRequest request;
    request.setTarget("sys.mediaplayer.previewer");
    request.setAction("bb.action.OPEN");
    request.setUri(uri);
    _invoke_manager->invoke(request);
}

void ApplicationUIBase::invoke_sms_compose(QString to, QString body, bool send)
{
    InvokeRequest request;
    request.setTarget("sys.pim.text_messaging.composer");
    request.setAction("bb.action.COMPOSE");

    QVariantMap map;
    map.insert("to", to);
    map.insert("body", body);
    map.insert("send", send);
    QByteArray requestData = PpsObject::encode(map, NULL);

    request.setData(requestData);
    _invoke_manager->invoke(request);
}

bool ApplicationUIBase::getNotificationBadge()
{
    return _notification_badge;
}

void ApplicationUIBase::setNotificationBadge(bool value)
{
    _notification_badge = value;
    emit notificationBadgeChanged(value);
}

bool ApplicationUIBase::getNotificationTooltip()
{
    return _notification_tooltip;
}

void ApplicationUIBase::setNotificationTooltip(bool value)
{
    _notification_tooltip = value;
    emit notificationTooltipChanged(value);
}

void ApplicationUIBase::flurrySetUserID(QString value)
{
    Flurry::Analytics::SetUserID(value);
}

void ApplicationUIBase::flurryLogError(QString value)
{
    Flurry::Analytics::LogError(value);
}

void ApplicationUIBase::flurryLogEvent(QString value)
{
    Flurry::Analytics::LogEvent(value);
}
