#ifndef ApplicationUI_HPP_
#define ApplicationUI_HPP_

#include <QObject>
#include <bb/platform/bbm/Context>
#include <bb/platform/bbm/MessageService>
#include <bb/platform/bbm/UserProfile>
#include "applicationuibase.hpp"

using namespace bb::cascades;
using namespace bb::cascades::multimedia;
using namespace bb::system;

namespace bb
{
    namespace cascades
    {
        class LocaleHandler;
    }

    namespace system
    {
        class CardDoneMessage;
    }
}

class ApplicationUI : public ApplicationUIBase
{
    Q_OBJECT

public:

    ApplicationUI(bb::system::InvokeManager* invokeManager);
    virtual ~ApplicationUI() {}

    Q_INVOKABLE void invite_to_download_from_bbm();
    Q_INVOKABLE void update_bbm_message(const QString &message);

    Q_INVOKABLE void capture_screen(int orientation, int tempID);
    Q_INVOKABLE void write_bitmap_header(int nbytes, QByteArray& ba, const int size[]);

private slots:

    void on_invoked(const bb::system::InvokeRequest& request);

private:

    bb::platform::bbm::UserProfile * m_userProfile;
    bb::platform::bbm::Context *m_context;
    bb::platform::bbm::MessageService *m_messageService;
    Q_SLOT void registrationStateUpdated(bb::platform::bbm::RegistrationState::Type state);
};

#endif /* ApplicationUI_HPP_ */
