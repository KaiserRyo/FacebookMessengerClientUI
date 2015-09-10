#include "applicationui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

#include <bb/system/CardDoneMessage>
#include <bb/system/InvokeManager>

#include <bb/cascades/LocaleHandler>
#include <bb/platform/Notification>
#include <bb/PackageInfo>
#include <bb/system/SystemDialog>
#include <src/ActiveFrame/ActiveFrameCover.h>
#include <bb/device/DisplayInfo>
#include <bb/system/Clipboard>
#include <bb/data/JsonDataAccess>

#include <libexif/exif-data.h>
#include <libexif/exif-tag.h>
#include <screen/screen.h>
#include <bb/cascades/Window>

using namespace bb::cascades;
using namespace bb::system;
using bb::data::JsonDataAccess;
using bb::platform::Notification;
using bb::PackageInfo;
using bb::device::DisplayInfo;

ApplicationUI::ApplicationUI(InvokeManager *invokeManager) :
        ApplicationUIBase(invokeManager)
{
    connect(_invoke_manager, SIGNAL(invoked(const bb::system::InvokeRequest&)), this, SLOT(on_invoked(const bb::system::InvokeRequest&)));

    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("_app", this);

    ActiveFrameCover *activeFrame = new ActiveFrameCover();
    Application::instance()->setCover(activeFrame);
    qml->setContextProperty("_activeFrame", activeFrame);

    AbstractPane *root = qml->createRootObject<AbstractPane>();
    Application::instance()->setScene(root);

    m_context = new bb::platform::bbm::Context(QUuid("9eafac47-90a9-40a1-9a03-6bf4a55123df"));

    if (m_context->registrationState() != bb::platform::bbm::RegistrationState::Allowed)
    {
        connect(m_context, SIGNAL(registrationStateUpdated (bb::platform::bbm::RegistrationState::Type)), this, SLOT(registrationStateUpdated (bb::platform::bbm::RegistrationState::Type)));
        m_context->requestRegisterApplication();
    }

    set_is_card(false);

    Notification::clearEffectsForAll();
    Notification::deleteAllFromInbox();
}

void ApplicationUI::on_invoked(const bb::system::InvokeRequest& request)
{
    bb::system::InvokeSource source = request.source();

    QString action = request.action();
    QString target = request.target();
    QString uri    = request.uri().toString();
    QString data   = QString::fromUtf8(request.data());

    if(action == "bb.action.OPEN")
    {

    }
    else if(action == "bb.action.SEARCH.EXTENDED")
    {

    }
    else if(action == "bb.action.VIEW")
    {

    }
}

void ApplicationUI::invite_to_download_from_bbm()
{
    if (m_context->registrationState() == bb::platform::bbm::RegistrationState::Allowed)
    {
        m_messageService->sendDownloadInvitation();
    }
    else
    {
        SystemDialog *bbmDialog = new SystemDialog("OK");
        bbmDialog->setTitle("BBM Connection Error");
        bbmDialog->setBody("BBM is not currently connected. Please setup / sign-in to BBM to remove this message.");
        connect(bbmDialog, SIGNAL(finished(bb::system::SystemUiResult::Type)), this, SLOT(dialogFinished(bb::system::SystemUiResult::Type)));
        bbmDialog->show();
        return;
    }
}

void ApplicationUI::update_bbm_message(const QString &message)
{
    if (m_context->registrationState() == bb::platform::bbm::RegistrationState::Allowed)
    {
        m_userProfile->requestUpdatePersonalMessage(message);
    }
    else
    {
        SystemDialog *bbmDialog = new SystemDialog("OK");
        bbmDialog->setTitle("BBM Connection Error");
        bbmDialog->setBody("BBM is not currently connected. Please setup / sign-in to BBM to remove this message.");
        connect(bbmDialog, SIGNAL(finished(bb::system::SystemUiResult::Type)), this, SLOT(dialogFinished(bb::system::SystemUiResult::Type)));
        bbmDialog->show();
        return;
    }
}

void ApplicationUI::registrationStateUpdated(bb::platform::bbm::RegistrationState::Type state)
{
    if (state == bb::platform::bbm::RegistrationState::Allowed)
    {
        m_messageService = new bb::platform::bbm::MessageService(m_context,this);
        m_userProfile = new bb::platform::bbm::UserProfile(m_context, this);
    }
    else if (state == bb::platform::bbm::RegistrationState::Unregistered)
    {
        m_context->requestRegisterApplication();
    }
}

void ApplicationUI::write_bitmap_header(int nbytes, QByteArray& ba, const int size[])
{
        char header[54];

        /* Set standard bitmap header */
        header[0] = 'B';
        header[1] = 'M';
        header[2] = nbytes & 0xff;
        header[3] = (nbytes >> 8) & 0xff;
        header[4] = (nbytes >> 16) & 0xff;
        header[5] = (nbytes >> 24) & 0xff;
        header[6] = 0;
        header[7] = 0;
        header[8] = 0;
        header[9] = 0;
        header[10] = 54;
        header[11] = 0;
        header[12] = 0;
        header[13] = 0;
        header[14] = 40;
        header[15] = 0;
        header[16] = 0;
        header[17] = 0;
        header[18] = size[0] & 0xff;
        header[19] = (size[0] >> 8) & 0xff;
        header[20] = (size[0] >> 16) & 0xff;
        header[21] = (size[0] >> 24) & 0xff;
        header[22] = -size[1] & 0xff;
        header[23] = (-size[1] >> 8) & 0xff;
        header[24] = (-size[1] >> 16) & 0xff;
        header[25] = (-size[1] >> 24) & 0xff;
        header[26] = 1;
        header[27] = 0;
        header[28] = 32;
        header[29] = 0;
        header[30] = 0;
        header[31] = 0;
        header[32] = 0;
        header[33] = 0;
        header[34] = 0; /* image size*/
        header[35] = 0;
        header[36] = 0;
        header[37] = 0;
        header[38] = 0x9;
        header[39] = 0x88;
        header[40] = 0;
        header[41] = 0;
        header[42] = 0x9l;
        header[43] = 0x88;
        header[44] = 0;
        header[45] = 0;
        header[46] = 0;
        header[47] = 0;
        header[48] = 0;
        header[49] = 0;
        header[50] = 0;
        header[51] = 0;
        header[52] = 0;
        header[53] = 0;

        ba.append(header, sizeof(header));
}

void ApplicationUI::capture_screen(int orientation, int tempID)
{
    int width = get_display_width();
    int height = get_display_height();

    if(orientation == 1) // landscape
    {
        height = get_display_width();
        width = get_display_height();
    }

    screen_pixmap_t screen_pix;
    screen_buffer_t screenshot_buf;
    screen_context_t context;
    screen_create_context(&context, 0);

    char *screenshot_ptr = NULL;
    int screenshot_stride = 0;

    int usage, format;
    int size[2];

    screen_create_pixmap(&screen_pix, context);

    usage = SCREEN_USAGE_READ | SCREEN_USAGE_NATIVE;
    screen_set_pixmap_property_iv(screen_pix, SCREEN_PROPERTY_USAGE, &usage);

    format = SCREEN_FORMAT_RGBA8888;
    screen_set_pixmap_property_iv(screen_pix, SCREEN_PROPERTY_FORMAT, &format);

    size[0] = width;
    size[1] = height;
    screen_set_pixmap_property_iv(screen_pix, SCREEN_PROPERTY_BUFFER_SIZE, size);

    screen_create_pixmap_buffer(screen_pix);
    screen_get_pixmap_property_pv(screen_pix, SCREEN_PROPERTY_RENDER_BUFFERS,
                                  (void**)&screenshot_buf);
    screen_get_buffer_property_pv(screenshot_buf, SCREEN_PROPERTY_POINTER,
                                  (void**)&screenshot_ptr);
    screen_get_buffer_property_iv(screenshot_buf, SCREEN_PROPERTY_STRIDE,
                                  &screenshot_stride);

    screen_read_window(Application::instance()->mainWindow()->handle(), screenshot_buf, 0, NULL ,0);

    QByteArray array;

    int nbytes = size[0] * size[1] * 4;
    write_bitmap_header(nbytes, array, size);

    for (int i = 0; i < size[1]; i++)
    {
        array.append(screenshot_ptr + i * screenshot_stride, size[0] * 4);
    }

    QImage image = QImage::fromData(array, "BMP");
    QFile outFile(QDir::tempPath() + "/captured" + QString::number(tempID) + ".jpg");
    outFile.open(QIODevice::WriteOnly);
    image.save(&outFile, "JPEG");
    outFile.close();

    screen_destroy_pixmap(screen_pix);
}
