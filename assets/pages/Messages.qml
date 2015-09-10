import bb.cascades 1.0
import nemory.NemAPI 1.0
import nemory.WebImageView 1.0

import "../components"
import "../dialogs"
import "../sheets"

NavigationPane 
{
    id: navigationPane
    
    property alias data_model_messages : dataModel;
    
    signal loaded();
    
    onPushTransitionEnded: 
    {
        page.scrollReady();    
    }
    
    onPopTransitionEnded: 
    {
        page.destroy();
    }
    
    function tabActivated()
    {
        Qt.navigationPane = navigationPane;
        
        scrollReady();
    }
    
    function tabDeactivated()
    {
        
    }
    
    function scrollReady()
    {
        if (_app._is_passport) 
        {
            listView.requestFocus();
        }
    }
    
    function reload()
    {
        listView.startLoading("top");
    }
    
    function load(force)
    {
        if(dataModel.size() == 0)
        {
            var inbox_json = _app.get_string_from_file("data/inbox_" + Qt.configuration.settings.active_user.id + ".json");
            
            if(inbox_json.length > 0 && inbox_json != "[]")
            {
                var json = JSON.parse(inbox_json);
                
                if(json && json.data && json.data.length > 0)
                {
                    if(force) listView.startLoading("top");
                    populate(json);
                }
                else 
                {
                    listView.startLoading("top");
                }
            }
            else 
            {
                listView.startLoading("top");
            }
        }
    }
    
    function clearDataModel()
    {
        dataModel.clear();
    }

    Page 
    {
        id: the_page
        
        titleBar: CustomTitleBar 
        {
            id: titleBar
            label_title.text: "MESSENGER";
            label_title.translationX: -20
            //image_left.defaultImageSource: "asset:///media/images/icons/icon.png";
            image_left.visible: false

            onLabelTitleClicked: 
            {
                listView.scrollToTop();
            }
            
            onLeftButtonClicked: 
            {
                listView.scrollToTop();
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
                topPadding: 10

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
                            content: ConversationItem
                            {
                                id: rootConversation
                            }
                        }
                    ]
                    
                    onScrolledDown: 
                    {
                        titleBar.fadeOut();
                        mainTabs.fadeOut();
                    }
                    
                    onScrolledUp: 
                    {
                        titleBar.fadeIn();
                        mainTabs.fadeIn();
                    }
                    
                    attachedObjects: 
                    [
                        ListScrollStateHandler 
                        {
                            id: scrollStateHandler

                            onAtEndChanged: 
                            {
                                if (atEnd) 
                                {
                                    listView.startLoading("bottom");
                                }
                            }
                        }
                    ]
                    
                    function navigationPanePush(page)
                    {
                        Qt.navigationPane.push(page);
                    }
                    
                    function refreshTriggered()
                    {
                        startLoading("top");
                    }
                    
                    function startLoading(loadTopBottom)
                    {
                        listView.loadTopBottom = loadTopBottom;
                        nemAPI.load(loadTopBottom);
                    }
                }
            }
            
            MainTabs 
            {
                id: mainTabs
                activeTab: "tabMessages"
                
                onClicked: 
                {
                    if(tab == activeTab)
                    {
                        listView.scrollToTop();
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
                text: "0 Results"
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XXSmall
            }
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
                navigationPane.load("");
            }
        }
    ]
    
    attachedObjects: 
    [
        NemAPI 
        {
            id: nemAPI
            
            property string last_previous_page : "";
            property string last_updated_time_id : "";
            
            function loadFQL(fql)
            {
//                var params 			= new Object();
//                params.endpoint 	= "fql";
//                params.url			= "https://graph.facebook.com/fql?q=" + fql;
//                params.access_token = Qt.configuration.settings.active_user.access_token;
//                getFacebook(params);
//                
//                console.log("LOADING FQL(): " + fql);
            }

            function load(loadTopBottom)
            {
                if(!listView.refreshing)
                {
                    var params          = new Object();
                    params.access_token = Qt.configuration.settings.active_user.access_token;
                    
                    if(loadTopBottom == "top")
                    {
                        params.endpoint            = "/me/inbox?";
                        getFacebook(params);
                        
                        listView.startRefreshing();
                        
                        Qt.mediaPlayer.pull_down();
                        
                        nemAPI.loadFQL("SELECT thread_id,unread,updated_time,snippet,snippet_author FROM thread WHERE viewer_id = me() AND folder_id = 0 AND (unread > 0 OR unseen > 0)");
                    }
                    else 
                    {
                        if(last_previous_page.length > 0 && last_updated_time_id.length > 0)
                        {
                            params.url          = last_previous_page;
                            params.endpoint     = "inbox_bottom";
                            getFacebook(params);
                            
                            listView.startRefreshing();
                            
                            Qt.mediaPlayer.pull_down();
                        }
                        
                        console.log("last_previous_page: " + last_previous_page);
                    }
                }
            }
            
            onComplete: 
            {
                console.log("**** MESSAGES API endpoint: " + endpoint + ", httpcode: " + httpcode + ", identifier: " + identifier + ", response: " + response);

                Qt.mediaPlayer.loaded();

                listView.stopRefreshing();
                
                if(httpcode != 200)
                {
                    _app.flurryLogError(httpcode + " - " + endpoint + " - " + response);
                    Qt.handleError(response);
                }
                else 
                {
                    var responseJSON = JSON.parse(response);

                    if(_app.contains(endpoint, "/me/inbox?"))
                    {
                        if(listView.loadTopBottom == "top")
                        {
                            _app.set_string_to_file(response, "data/inbox_" + Qt.configuration.settings.active_user.id + ".json");
                        }
                        
                        loaded();
                        
                        populate(responseJSON);
                    }
                    else if(_app.contains(endpoint, "inbox_bottom"))
                    {
                        populate(responseJSON);
                    }
                    else if(_app.contains(endpoint, "fql"))
                    {
//                        _app.set_string_to_file(response, "data/fql.json");
//                        
//                        var new_threads = new Array();
//                        
//                        if(responseJSON.data.length > 0)
//                        {
//                            for(var i = 0; i < responseJSON.data.length; i++)
//                            {
//                                var thread = responseJSON.data[i];
//                                
//                                var last_saved_thread_id = _app.get_string_from_file("data/last_saved_thread_id.user_id_" + Qt.configuration.settings.active_user.id + ".json");
//                                
//                                if(thread.thread_id != last_saved_thread_id)
//                                {
//                                    new_threads.push(thread);
//                                }
//                            }
//                            
//                            _app.set_string_to_file(responseJSON.data[0].thread_id, "data/last_saved_thread_id.user_id_" + Qt.configuration.settings.active_user.id + ".json");
//                        }
//                        
//                        console.log("NEW THREADS: " + new_threads.length);
//                        
//                        for(var i = 0; i < new_threads; i++)
//                        {
//                            var thread = new_threads[i];
//                            
//                            console.log("NEW: " + thread.snippet);
//                        }
                    }
                }
            }
        }
    ]
    
    function populate(responseJSON)
    {
        var inbox_array = new Array();
        
        for(var i = 0; i < responseJSON.data.length; i++)
        {
            var inbox  = responseJSON.data[i];
            var to     = inbox.to.data;
            
            inbox.time_ago = Qt.nemAPI.timeSince(inbox.updated_time * 1000);
            
            if(to.length == 2) // ONE TO ONE
            {
                if(to[0].id != Qt.configuration.settings.active_user.id)
                {
                    inbox.display_image = "http://graph.facebook.com/" + to[0].id + "/picture/120_" + to[0].id + ".png?width=120&height=120";
                    inbox.display_name  = to[0].name;
                    inbox.profile_url   = "https://facebook.com/" + to[0].id + "/";
                    inbox.recipient_id  = to[0].id;
                }
                else 
                {
                    inbox.display_image = "http://graph.facebook.com/" + to[1].id + "/picture/120_" + to[1].id + ".png?width=120&height=120";
                    inbox.display_name  = to[1].name;
                    inbox.profile_url   = "https://facebook.com/" + to[1].id + "/";
                    inbox.recipient_id  = to[1].id;
                }
            }
            else if(to.length > 2) // GROUP
            {
                inbox.display_image         = "http://i.imgur.com/dStSjrZ.png";
                inbox.status_image          = "asset:///images/small_messenger_group.png";
                inbox.profile_url           = "https://facebook.com/" + to[0].id + "/";
                inbox.recipient_id          = "group";
                
                var name1 					= to[0].name.split(" ");
                var name2 					= to[1].name.split(" ");
                var name3 					= to[2].name.split(" ");
                
                inbox.display_name       = "Group: " + name1[0] + ", " + name2[0] + ", " + name3[0] + " ....."
            }
            else 
            {
                inbox.display_name = to[0].name;
            }
            
            var comments = responseJSON.data[i].comments;
            
            if(comments && comments.data.length > 0)
            {
                inbox.display_message = comments.data[comments.data.length - 1].message; // latest chat message
                
                if(comments.data[0].from && comments.data[0].from.id != Qt.configuration.settings.active_user.id)
                {
                    inbox.last_sender_status_image = "asset:///media/images/icons/checkDark.png";
                }
                else 
                {
                    inbox.last_sender_status_image = "asset:///media/images/icons/replyDark.png";
                }
            }
            else 
            {
                inbox.display_message = "Tap to chat";
            }
            
            if(i == 0)
            {
                var data             = new Object();
                data.image           = inbox.display_image;
                data.text            = inbox.display_message;
                data.name            = inbox.display_name;
                data.timeago         = inbox.time_ago;
                
                _app.set_string_to_file(JSON.stringify(data), "data/active_frame.json");
                
                console.log("SAVED ACTIVE FRAME DATA");
            }
            
            inbox_array.push(inbox);
        }
        
        if(listView.loadTopBottom == "top")
        {
            dataModel.clear();
            dataModel.insert(0, inbox_array);
        }
        else if(listView.loadTopBottom == "bottom")
        {
            dataModel.append(inbox_array);
            listView.scroll(100, ScrollAnimation.Smooth);
        }
        
        if(dataModel.size() == 0)
        {
            zeroResults.visible = true;
        }
        else 
        {
            zeroResults.visible = false;
        }
        
        if(responseJSON.paging && responseJSON.paging.next)
        {
            nemAPI.last_previous_page     = responseJSON.paging.next;
            nemAPI.last_updated_time_id   = responseJSON.data[responseJSON.data.length - 1].updated_time;
        }
        else 
        {
            nemAPI.last_previous_page = "";
        }
    }
}