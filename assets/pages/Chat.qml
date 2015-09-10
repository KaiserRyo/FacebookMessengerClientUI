import bb.cascades 1.0
import nemory.NemAPI 1.0
import nemory.WebImageView 1.0
import QtQuick 1.0

import "../components"
import "../dialogs"
import "../sheets"

Page 
{
    id: the_page
    actionBarVisibility: ChromeVisibility.Hidden
    
    property variant params_data : new Object();
    
    function scrollReady()
    {
        if (_app._is_passport) 
        {
            listView.requestFocus();
        }
    }
    
    function append(message_object)
    {
        dataModel.append(message_object);
        
        listView.scrollToBottom();
    }
    
    function load(params)
    {
        params_data = params.data;
        
        titleBar.label_title.text = params_data.display_name.toUpperCase();
        
        dataModel.clear();
        
        if(params_data.comments && params_data.comments.data)
        {
            dataModel.insert(0, params_data.comments.data);
        }
        
        if(params_data.to && params_data.to.data && params_data.to.data.length > 2)
        {
            titleBar.image_right.visible = false;
        }
        
        scroll_timer.start();
        
        Qt.current_recipient_id = params_data.recipient_id;
        
        if(dataModel.size() == 0)
        {
            zeroResults.visible = true;
        }
    }
    
    attachedObjects: 
    [
        Timer
        {
            id: scroll_timer
            repeat: false
            interval: 500
            
            onTriggered: 
            {
                listView.scrollToBottom();
                emojiTextBox.requestFocus();
            }
        },
        Timer
        {
            id: messages_page_reload_timer
            repeat: false
            interval: 2000
            
            onTriggered: 
            {
                Qt.pageMessages.reload();
            }
        }
    ]
    
    titleBar: CustomTitleBar 
    {
        id: titleBar
        label_title.text: "CHAT";
        label_title.translationX: -20
        image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"
        image_right.defaultImageSource: "asset:///media/images/instagram/nav_person.png"
        
        onLabelTitleClicked: 
        {
            listView.scrollToTop();
        }
        
        onLeftButtonClicked: 
        {
            Qt.navigationPane.pop();
        }
        
        onRightButtonClicked: 
        {
            var the_url = "https://m.facebook.com/" + params_data.recipient_id + "/";

            var page = Qt.browserComponent.createObject();
            var params = new Object();
            params.url = the_url;
            page.load(params);
            Qt.navigationPane.push(page);
        }
    }
    
    Container 
    {
        id: mainContainer
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        layout: DockLayout {}
        
        ImageView 
        {
            id: wallpaper
            imageSource: _app._wallpaper
            scalingMethod: ScalingMethod.AspectFill
            opacity: 0.5
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
        }  
        
        Container 
        {
            id: content
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            bottomPadding: 100
            
            RateUs 
            {
                id: rate_us
            }
            
            PullToRefreshListView 
            {
                id: listView
                horizontalAlignment: HorizontalAlignment.Fill
                snapMode: ( (_app.get_setting("leading_edge_scrolling", "false") == "true") ? SnapMode.LeadingEdge : SnapMode.Default)
                pullToRefresh: true
                
                dataModel: ArrayDataModel
                {
                    id: dataModel
                }
                
                listItemComponents: 
                [
                    ListItemComponent 
                    {
                        content: MessageItem 
                        {
                            id: rootMessage
                        }
                    }
                ]
                
                onScrolledDown: 
                {
                    titleBar.fadeOut();
                    //bottomBar.fadeOut();
                }
                
                onScrolledUp: 
                {
                    titleBar.fadeIn();
                    //bottomBar.fadeIn();
                }
            }
        }
        
        Container 
        {
            id: bottomBar
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Bottom
            
            Divider 
            {
                bottomMargin: 0
                topMargin: 0
            }
            
            Label 
            {
                id: lbl_is_typing
                visible: false;
                text: params_data.display_name + " is typing..."
                textStyle.color: Color.Gray
                textStyle.fontSize: FontSize.XSmall
                textStyle.fontStyle: FontStyle.Italic
                horizontalAlignment: HorizontalAlignment.Center
            }
            
            EmojiTextBox 
            {
                id: emojiTextBox
                
                onScrollToBottom:
                {
                    listView.scrollToBottom();
                }

                onSubmit: 
                {
                    if(_app._connected)
                    {
                        Qt.nemAPI.sendMessage(Qt.configuration.settings.active_user.id, params_data.recipient_id, text);
                        
                        var created_timestamp       = (new Date().getTime()) / 1000;
                        
                        var message_object          = new Object();
                        message_object.id           = "sent_id";
                        message_object.from         = { id: Qt.configuration.settings.active_user.id, name: Qt.configuration.settings.active_user.name };
                        message_object.message      = text;
                        message_object.created_time = created_timestamp;
                        
                        dataModel.append(message_object);
                        
                        listView.scrollToBottom();
                        
                        emojiTextBox.clear();
                        
                        Qt.mediaPlayer.send();
                        
                        // ----- UPDATE ------ //
                        
                        var exists = false;
                        
                        for(var i = 0; i < Qt.pageMessages.data_model_messages.size(); i++)
                        {
                            var conversation = Qt.pageMessages.data_model_messages.value(i);
                            
                            if(conversation.recipient_id == params_data.recipient_id)
                            {
                                conversation.display_message = message_object.message;
                                conversation.unread          = false;
                                conversation.time_ago        = Qt.nemAPI.timeSince(created_timestamp * 1000);
                                conversation.last_sender_status_image = "asset:///media/images/icons/checkDark.png";
                                
                                Qt.pageMessages.data_model_messages.replace(i, conversation);
                                Qt.pageMessages.data_model_messages.swap(i, 0);
                                
                                exists = true;
                                
                                break;
                            }
                        }
                        
                        if(!exists)
                        {
                            console.log("NEW CHAT DOESN'T EXISTS");
                            
                            messages_page_reload_timer.start();
                        }
                        else 
                        {
                            console.log("CHAT EXISTS, CONVERSATION DISPLAY MESSAGE UPDATED");
                        }
                        
                        zeroResults.visible = false;
                    }
                    else 
                    {
                        Qt.dialog.pop("Error", "Cannot send message because we're still trying to connect. Please try to wait a few more or restart the app, or logout then relogin. Thank you");
                    }
                }
            }
        }
        
        Container 
        {
            background: Color.create("#ff8a00")
            preferredHeight: 30
            horizontalAlignment: HorizontalAlignment.Fill
            visible: !_app._connected
            
            Label
            {
                text: "Connecting..."
                textStyle.fontSize: FontSize.XXSmall
                textStyle.color: Color.White
                horizontalAlignment: HorizontalAlignment.Center
            }
        }
        
        ActivityIndicator 
        {
            id: loadingIndicator
            visible: listView.refreshing    
            running: visible
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
        
        Label 
        {
            id: zeroResults
            visible: false
            text: "Say hi to your friend..."
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.fontSize: FontSize.XXSmall
        }
    }
    
    shortcuts: 
    [
        SystemShortcut 
        {
            type: SystemShortcuts.JumpToBottom // BOTTOM
            
            onTriggered: 
            {
                listView.scrollToBottom();
            }
        },
        SystemShortcut 
        {
            type: SystemShortcuts.JumpToTop // TOP
            
            onTriggered: 
            {
                listView.scrollToTop();
            }
        },
        SystemShortcut 
        {
            type: SystemShortcuts.Forward // FILTER
            
            onTriggered: 
            {
            
            }
        },
        SystemShortcut 
        {
            type: SystemShortcuts.Reply // REFRESH
            
            onTriggered: 
            {
            
            }
        }
    ]
}