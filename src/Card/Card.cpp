#include <src/Utilities/Utilities.hpp>
#include "Card.hpp"
#include <bb/cascades/A11yRole>

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/NavigationPane>
#include <bb/cascades/Page>
#include <bb/cascades/Container>

#include <bb/data/JsonDataAccess>
#include <bb/system/CardDoneMessage>
#include <bb/system/CardResizeMessage>

using bb::data::JsonDataAccess;
using namespace bb::cascades;
using namespace bb::system;

Card::Card(bb::system::InvokeManager* invokeManager) :
                ApplicationUIBase(invokeManager)
{
    qDebug() << "==== Card::Card() ====";

    connect(_invoke_manager, SIGNAL(invoked(const bb::system::InvokeRequest&)), this, SLOT(onInvoked(const bb::system::InvokeRequest&)));
    connect(_invoke_manager, SIGNAL(cardPooled(const bb::system::CardDoneMessage&)), this, SLOT(cardPooled(const bb::system::CardDoneMessage&)));

    _qml = QmlDocument::create("asset:///cards/MainPane.qml").parent(this);
    _qml->setContextProperty("_app", this);
    _navigation_pane = _qml->createRootObject<NavigationPane>();

    set_is_card(true);

    clear_notification_effects();
}

void Card::pushPageFromCard(bb::cascades::Page* page)
{
    _navigation_pane->push(page);
}

void Card::navigationPanePop()
{
    _navigation_pane->pop();
}

void Card::on_invoked(const bb::system::InvokeRequest& request)
{
    qDebug() << "==== Card::onInvoked() START ====";

    emit load_configuration();

    QVariantMap metadata    = request.metadata();
    QString source          = request.source().installId() + " - " + request.source().groupId();
    QString listId          = QString::number(request.listId());
    QString action          = request.action();
    QString target          = request.target();
    QString uri             = request.uri().toString();
    QString data            = QString::fromUtf8(request.data());

    qDebug() << "==== Card::onInvoked(): action: " << action << data << ", uri: " << uri;

    if(action == "bb.action.VIEW")
    {
        JsonDataAccess jda;
        QVariantMap objectMap   = (jda.loadFromBuffer(data)).toMap();
        QVariantMap itemMap     = objectMap["attributes"].toMap();
        QString messageID1      = itemMap["messageid"].toString();
        QString sourceID1       = itemMap["sourceId"].toString();

        QString itemsFromJSON   = Utilities::get_string_from_file("data/hub_items.json");

        QVariantList itemsFromJSONList = jda.loadFromBuffer(itemsFromJSON).toList();

        qDebug() << "**** Card::onInvoked: itemsFromJSONList: " << itemsFromJSONList.size() << ", sourceId1: " << sourceID1 << ", messageID1: " << messageID1;

        for(int index = 0; index < itemsFromJSONList.size(); index++)
        {
            QVariantMap attributes    = itemsFromJSONList.at(index).toMap();
            QString pageName          = attributes["thePage"].toString();
            QString theData           = attributes["theData"].toString();
            QString sourceID2         = attributes["sourceId"].toString();

            qDebug() << "**** Card::onInvoked: thePage" << pageName << ", theData: " << theData << ", sourceId2: " << sourceID2;

            if (sourceID2 == messageID1 || sourceID2 == sourceID1)
            {
                InvokeRequest request2;
                request2.setTarget("com.nemory.Insta10HeadlessService");
                request2.setAction("bb.action.MARKREAD");
                request2.setMimeType("hub/item");
                request2.setUri(QUrl("pim:"));

                QByteArray bytes;
                jda.saveToBuffer(objectMap, &bytes);
                request2.setData(bytes);

                InvokeTargetReply *reply = _invoke_manager->invoke(request2);

                if (!reply)
                {
                    qDebug() << "**** FAILED Card::onInvoked: " << reply->errorCode();
                    reply->deleteLater();
                }

                QmlDocument *pageDocument  = QmlDocument::create("asset:///pages/" + pageName).parent(this);
                _page = pageDocument->createRootObject<Page>();
                _page->setProperty("is_card", true);
                //_page->setActionBarVisibility((getSetting("backButton", "false") == "false") ? ChromeVisibility::Hidden : ChromeVisibility::Default);
                _navigation_pane->push(_page);
                Application::instance()->setScene(_navigation_pane);

                emit initialize_card();

                emit opened_item(attributes, theData);

                break;
            }
        }

        jda.deleteLater();
    }
    else if(action == "bb.action.COMPOSE")
    {

    }
    else if(action == "bb.action.SHARE")
    {

        startHeadless();
    }
    else
    {
        startHeadless();
    }
}

void Card::startHeadless()
{
    qDebug() << "==== startHeadless() ====";

    bb::system::InvokeRequest request2;
    request2.setTarget(Utilities::headless_target_id());
    request2.setAction("bb.action.START");
    request2.setMimeType("text/plain");

    QString command = "card: start headless";
    request2.setData(command.toAscii());

    bb::system::InvokeTargetReply *reply = _invoke_manager->invoke(request2);

    if (!reply)
    {
        qDebug() << "**** FAILED Card::onInvoked: " << reply->errorCode();
        reply->deleteLater();
    }
}

void Card::card_pooled(const bb::system::CardDoneMessage& doneMessage)
{
    emit closed_card();
}

void Card::card_resize_requested(const bb::system::CardResizeMessage& resizeMessage)
{
    _invoke_manager->cardResized(resizeMessage);
}

void Card::close_card()
{
    CardDoneMessage message;
    message.setData(tr(""));
    message.setDataType("text/plain");
    message.setReason(tr("Success!"));

    _invoke_manager->sendCardDone(message);

    emit closed_card();
}
