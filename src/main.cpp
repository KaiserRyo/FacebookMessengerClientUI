#include "Application/applicationui.hpp"
#include <bb/cascades/Application>
#include <QLocale>
#include <QTranslator>
#include <Qt/qdeclarativedebug.h>
#include "WebImageView/WebImageView.hpp"
#include <src/NemLocation/NemLocation.hpp>
#include <src/ParseAPI/ParseAPI.hpp>
#include <src/PictureEditor/PictureEditor.h>
#include <src/PictureViewer/PictureViewer.h>
#include <src/Utilities/Utilities.hpp>
#include <src/VirtualKeyboardHandler/VirtualKeyboardHandler.hpp>
#include <bb/ApplicationInfo>
#include "Card/Card.hpp"
#include <bb/system/InvokeManager>

#include <Flurry.h>
#include <src/NemAPI/NemAPI.hpp>
#include <src/TrialAPI/TrialAPI.hpp>
#include <src/WallpaperAPI/WallpaperAPI.hpp>
#include <src/WallpaperImage/WallpaperImage.hpp>

using namespace bb::system;
using namespace bb::cascades;

Q_DECL_EXPORT int main(int argc, char **argv)
{
    #if !defined(QT_NO_DEBUG)
        Flurry::Analytics::SetDebugLogEnabled(false);
    #endif

    Flurry::Analytics::SetAppVersion(bb::ApplicationInfo().version());
    Flurry::Analytics::SetSecureTransportEnabled(true);
    Flurry::Analytics::StartSession("3YTCY2BB44PG6YXF5JM3");

    qputenv("CASCADES_THEME", Utilities::get_setting("application_theme", "bright").toUtf8());

    qmlRegisterType<ParseAPI>("nemory.ParseAPI", 1, 0, "ParseAPI");
    qmlRegisterType<TrialAPI>("nemory.TrialAPI", 1, 0, "TrialAPI");
    qmlRegisterType<WallpaperAPI>("nemory.WallpaperAPI", 1, 0, "WallpaperAPI");
    qmlRegisterType<NemAPI>("nemory.NemAPI", 1, 0, "NemAPI");
    qmlRegisterType<VirtualKeyboardHandler>("com.knobtviker.Helpers", 1, 0, "VirtualKeyboardHandler");
    qmlRegisterType<NemLocation>("nemory.NemLocation", 1, 0, "NemLocation");
    qmlRegisterType<WebImageView>("nemory.WebImageView", 1, 0, "WebImageView");
    qmlRegisterType<WallpaperImage>("nemory.WallpaperImage", 1, 0, "WallpaperImage");
    qmlRegisterType<PictureEditor>("nemory.PictureEditor", 1, 0, "PictureEditor");
    qmlRegisterType<PictureViewer>("nemory.PictureViewer", 1, 0, "PictureViewer");

    Application app(argc, argv);

    InvokeManager invokeManager;

    QObject *appui = 0;

    qDebug() << "*** MAIN.CPP - " << invokeManager.startupMode();

    if (invokeManager.startupMode() == ApplicationStartupMode::InvokeCard)
    {
        appui = new Card(&invokeManager);
    }
    else if (invokeManager.startupMode() == ApplicationStartupMode::InvokeViewer)
    {
        appui = new ApplicationUI(&invokeManager);
    }
    else if (invokeManager.startupMode() == ApplicationStartupMode::InvokeApplication)
    {
        appui = new ApplicationUI(&invokeManager);
    }
    else  if (invokeManager.startupMode() == ApplicationStartupMode::LaunchApplication)
    {
        appui = new ApplicationUI(&invokeManager);
    }

    int ret = Application::exec();

    invokeManager.closeChildCard();
    delete appui;

    return ret;
}
