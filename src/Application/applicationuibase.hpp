#ifndef APPLICATIONUIBASE_H_
#define APPLICATIONUIBASE_H_

#include <QObject>

#include <qt4/QtCore/qurl.h>

#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>
#include <bb/system/InvokeTargetReply>
#include <QFileSystemWatcher>
#include <bb/PpsObject>
#include <bb/cascades/multimedia/Camera>

using namespace bb::cascades::multimedia;
using namespace bb::system;

namespace bb
{
    namespace platform
    {
        class Notification;
    }

    namespace system
    {
      class InvokeManager;
    }

    namespace cascades
    {
      class LocaleHandler;
    }
}

class QTranslator;

class ApplicationUIBase : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool _is_passport READ get_is_passport WRITE set_is_passport NOTIFY is_passport_changed)
    Q_PROPERTY(bool _is_typing READ get_is_typing WRITE set_is_typing NOTIFY is_typing_changed)
    Q_PROPERTY(bool _connected READ get_connected WRITE set_connected NOTIFY connected_changed)
    Q_PROPERTY(bool _dark_theme READ get_dark_theme WRITE set_dark_theme NOTIFY dark_theme_changed)
    Q_PROPERTY(bool _show_rate_us READ get_show_rate_us WRITE set_show_rate_us NOTIFY show_rate_us_changed)
    Q_PROPERTY(QString _wallpaper READ get_wallpaper WRITE set_wallpaper NOTIFY wallpaper_changed)
    Q_PROPERTY(QString _color_scheme READ get_color_scheme WRITE set_color_scheme NOTIFY color_scheme_changed)
    Q_PROPERTY(bool _notification_badge READ getNotificationBadge WRITE setNotificationBadge NOTIFY notificationBadgeChanged)
    Q_PROPERTY(bool _notification_tooltip READ getNotificationTooltip WRITE setNotificationTooltip NOTIFY notificationTooltipChanged)

public:

    ApplicationUIBase(bb::system::InvokeManager* invokeManager);
    virtual ~ApplicationUIBase();

    bool get_is_passport();
    void set_is_passport(bool value);

    bool get_is_typing();
    void set_is_typing(bool value);

    bool get_connected();
    void set_connected(bool value);

    bool get_dark_theme();
    void set_dark_theme(bool value);

    bool get_show_rate_us();
    void set_show_rate_us(bool value);

    QString get_wallpaper();
    void set_wallpaper(QString value);

    QString get_color_scheme();
    void set_color_scheme(QString value);

    bool getNotificationBadge();
    void setNotificationBadge(bool value);

    bool getNotificationTooltip();
   void setNotificationTooltip(bool value);


    Q_INVOKABLE void invoke_bbworld(QString uri);
    Q_INVOKABLE void invoke_browser(QString url);
    Q_INVOKABLE void invoke_sms_compose(QString to, QString body, bool send);

    Q_INVOKABLE void invoke_media_player(QString uri);
    Q_INVOKABLE bool is_card();
    Q_INVOKABLE bool is_beta();
    Q_INVOKABLE void set_is_card(bool value);

    Q_INVOKABLE QString fb_app_id();
    Q_INVOKABLE QString app_version();
    Q_INVOKABLE QString app_name();
    Q_INVOKABLE QString app_hashtag();
    Q_INVOKABLE QString os_version();
    Q_INVOKABLE QString device();

    Q_INVOKABLE void start_headless();
    Q_INVOKABLE void command_headless(QString command);

    Q_INVOKABLE void clear_notification_effects();
    Q_INVOKABLE void clear_notifications();
    Q_INVOKABLE void notify_regular(QString title, QString message);

    Q_INVOKABLE qreal get_image_rotation(QUrl url);
    Q_INVOKABLE void pre_process(QString image_path, bool mirror);
    Q_INVOKABLE void correct_rotation(QString image_path);
    Q_INVOKABLE void mirror_photo(QString file_path);
    Q_INVOKABLE void resize_photo(QString file_path);
    Q_INVOKABLE void convert_to_jpeg(QString file_path, QString new_path);

    Q_INVOKABLE void wipe_folder_contents(QString folder);
    Q_INVOKABLE void wipe_folder(QString folder);
    Q_INVOKABLE void copy_file(QString from, QString to);
    Q_INVOKABLE void copy_and_remove_file(QString from, QString to);
    Q_INVOKABLE void delete_file(QString fileName);
    Q_INVOKABLE qint64 get_cache_size();
    Q_INVOKABLE qint64 get_folder_size(QString folder_path);

    Q_INVOKABLE int get_display_height();
    Q_INVOKABLE int get_display_width();

    Q_INVOKABLE void set_string_to_file(QString log, QString file_name);
    Q_INVOKABLE QString get_string_from_file(QString file_name);

    Q_INVOKABLE QString get_setting(QString key, QString value);
    Q_INVOKABLE void set_setting(QString key, QString value);

    Q_INVOKABLE void copy_to_clipboard(QByteArray data);
    Q_INVOKABLE bool contains(QString text, QString find);
    Q_INVOKABLE void set_aspect_ratio(bb::cascades::multimedia::Camera *camera, const float aspect);
    Q_INVOKABLE QString regex(QString text, QString expression, int index);

    Q_INVOKABLE void flurrySetUserID(QString value);
    Q_INVOKABLE void flurryLogError(QString value);
    Q_INVOKABLE void flurryLogEvent(QString value);

signals:

    void is_passport_changed(bool);
    void is_typing_changed(bool);
    void connected_changed(bool);

    void notificationBadgeChanged(bool);
    void notificationTooltipChanged(bool);

    void dark_theme_changed(bool);
    void show_rate_us_changed(bool);
    void wallpaper_changed(QString);
    void color_scheme_changed(QString);

    void load_configuration();
    void initialize_card();
    void closed_card();
    void opened_item(QVariant attributes, QString data);

    void view_user(QString data);
    void view_media(QString data);
    void view_messages(QVariant data);
    void view_profile(QString data);
    void view_hashtag(QString data);

    void open_uri(QString uri);
    void open_extended_search(QString data);
    void open_compose();

private slots:

    void on_system_language_changed();

protected:

    bb::system::InvokeManager* _invoke_manager;

private:

    bool _is_passport;
    bool _is_typing;
    bool _connected;
    bool _dark_theme;
    bool _is_card;
    bool _show_rate_us;
    bool _notification_badge;
    bool _notification_tooltip;

    QString _wallpaper;
    QString _color_scheme;

    QSettings* _settings;
    QTranslator* _translator;
    bb::cascades::LocaleHandler* _locale_handler;

    QNetworkAccessManager network_access_manager;

};

#endif /* APPLICATIONUIBASE_H_ */
