#ifndef Card_HPP_
#define Card_HPP_

#include <src/Application/applicationuibase.hpp>
#include <bb/data/JsonDataAccess>
#include <bb/system/InvokeRequest>
#include <bb/system/InvokeManager>

#include <bb/cascades/QmlDocument>
#include <bb/cascades/NavigationPane>
#include <bb/cascades/Page>
#include <bb/cascades/Container>

using namespace bb::cascades;

namespace bb
{
    namespace system
    {
        class InvokeManager;
        class InvokeRequest;
    }
}

class Card: public ApplicationUIBase
{
    Q_OBJECT

public:

    Card(bb::system::InvokeManager* invokeManager);
    virtual ~Card() {}

    void startHeadless();
    Q_INVOKABLE void pushPageFromCard(bb::cascades::Page* page);
    Q_INVOKABLE void navigationPanePop();

private slots:

    void on_invoked(const bb::system::InvokeRequest& request);
    void card_pooled(const bb::system::CardDoneMessage& doneMessage);
    void card_resize_requested(const bb::system::CardResizeMessage& resizeMessage);
    void close_card();

private:

    QmlDocument* _qml;
    NavigationPane* _navigation_pane;
    Page* _page;

};

#endif /* Card_HPP_ */
