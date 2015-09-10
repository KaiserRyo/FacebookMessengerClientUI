import bb.cascades 1.0
import nemory.NemAPI 1.0
import nemory.WebImageView 1.0

import "../components"
import "../dialogs"
import "../sheets"

NavigationPane 
{
    id: navigationPane
    
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
        
        load(false);
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
    
    function clearDataModel()
    {
        dataModelAll.clear();
        dataModelActive.clear();
        dataModelIdle.clear();
        dataModelOffline.clear();
        
        dataModelAll2.clear();
        dataModelActive2.clear();
        dataModelIdle2.clear();
        dataModelOffline2.clear();
    }
    
    function load(force)
    {
        if(dataModelAll.size() == 0)
        {
            var friends_json = _app.get_string_from_file("data/friends_" + Qt.configuration.settings.active_user.id + ".json");
            
            if(friends_json.length > 0 && friends_json != "[]")
            {
                var json = JSON.parse(friends_json);
                
                if(json && json.data && json.data.length > 0)
                {
                    if(force) listView.startLoading("all");
                    populate(json);
                }
                else 
                {
                    listView.startLoading("all");
                }
            }
            else 
            {
                listView.startLoading("all");
            }
            
            console.log("friends_json: " + friends_json);
        }
        
        console.log("dataModelAll.size(): " + dataModelAll.size());
    }
    
    Page 
    {
        id: the_page
        
        titleBar: CustomTitleBar 
        {
            id: titleBar
            label_title.text: "FACEBOOK FRIENDS";
            label_title.translationX: -20
            image_left.visible: false
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
                
                RateUs 
                {
                    id: rate_us
                }
                
                CustomTabs 
                {
                    id: tabs
                    tab1: "ALL"
                    tab2: "ONLINE"
                    tab3: "OFFLINE"
                    tab4: "IDLE"
                    
                    onActive_tabChanged: 
                    {
                        if(active_tab == tab1)
                        {
                            listView.dataModel = dataModelAll;
                        }
                        else if(active_tab == tab2)
                        {
                            listView.dataModel = dataModelActive;
                        }
                        else if(active_tab == tab3)
                        {
                            listView.dataModel = dataModelOffline;
                        }
                        else if(active_tab == tab4)
                        {
                            listView.dataModel = dataModelIdle;
                        }
                    }
                }
                
                TextField 
                {
                    id: txt_search
                    topMargin: 0
                    hintText: "Search a friend to chat"
                    
                    onTextChanging: 
                    {
                        if(tabs.active_tab == tabs.tab1)
                        {
                            var found_users = new Array();
                            
                            for(var i = 0; i < dataModelAll2.size(); i++)
                            {
                                var user = dataModelAll2.value(i);
                                
                                if(_app.contains(user.name, text))
                                {
                                    found_users.push(user); 
                                }
                            }
                            
                            dataModelAll.clear();
                            dataModelAll.insert(0, found_users);
                        }
                        else if(tabs.active_tab == tabs.tab2)
                        {
                            var found_users = new Array();
                            
                            for(var i = 0; i < dataModelActive2.size(); i++)
                            {
                                var user = dataModelActive2.value(i);
                                
                                if(_app.contains(user.name, text))
                                {
                                    found_users.push(user); 
                                }
                            }
                            
                            dataModelActive.clear();
                            dataModelActive.insert(0, found_users);
                        }
                        else if(tabs.active_tab == tabs.tab3)
                        {
                            var found_users = new Array();
                            
                            for(var i = 0; i < dataModelOffline2.size(); i++)
                            {
                                var user = dataModelOffline2.value(i);
                                
                                if(_app.contains(user.name, text))
                                {
                                    found_users.push(user); 
                                }
                            }
                            
                            dataModelOffline.clear();
                            dataModelOffline.insert(0, found_users);
                        }
                        else if(tabs.active_tab == tabs.tab4)
                        {
                            var found_users = new Array();
                            
                            for(var i = 0; i < dataModelIdle2.size(); i++)
                            {
                                var user = dataModelIdle2.value(i);
                                
                                if(_app.contains(user.name, text))
                                {
                                    found_users.push(user); 
                                }
                            }
                            
                            dataModelIdle.clear();
                            dataModelIdle.insert(0, found_users);
                        }
                    }
                }

                PullToRefreshListView 
                {
                    id: listView
                    horizontalAlignment: HorizontalAlignment.Fill
                    snapMode: ( (_app.get_setting("leading_edge_scrolling", "false") == "true") ? SnapMode.LeadingEdge : SnapMode.Default)
                    pullToRefresh: true

                    listItemComponents: 
                    [
                        ListItemComponent 
                        {
                            content: FriendItem 
                            {
                                id: rootFriend
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
                        ArrayDataModel 
                        {
                            id: dataModelAll
                        },
                        ArrayDataModel 
                        {
                            id: dataModelActive
                        },
                        ArrayDataModel 
                        {
                            id: dataModelOffline
                        },
                        ArrayDataModel 
                        {
                            id: dataModelIdle
                        },
                        ArrayDataModel 
                        {
                            id: dataModelAll2
                        },
                        ArrayDataModel 
                        {
                            id: dataModelActive2
                        },
                        ArrayDataModel 
                        {
                            id: dataModelOffline2
                        },
                        ArrayDataModel 
                        {
                            id: dataModelIdle2
                        }
                    ]
                    
                    function navigationPanePush(page)
                    {
                        Qt.navigationPane.push(page);
                    }
                    
                    function refreshTriggered()
                    {
                        startLoading();
                    }
                    
                    function startLoading()
                    {
                        nemAPI.loadFriends("all");
                    }
                }
            }
            
            MainTabs 
            {
                id: mainTabs
                activeTab: "tabFriends"
                
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

            Label 
            {
                id: zeroResults
                visible: false
                text: "0 Results"
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XXSmall
            }
            
            ActivityIndicator 
            {
                id: loadingIndicator
                visible: false
                running: visible
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
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
            
            property variant all_users : Array();
            property variant active_users : Array();
            property variant offline_users : Array();
            property variant idle_users : Array();
            
            function loadFriends(presence)
            {
                console.log("loadFriends(): START >>> ");
                
                if(!loadingIndicator.visible)
                {
                    loadingIndicator.visible = true;
                    
                    var fql_friends = "SELECT uid,name,pic,profile_url,pic_cover,online_presence FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())"
                    
                    if(presence != "all")
                    {
                        fql_friends     += " AND online_presence='" + presence + "'";
                    }
                    
                    var params 			= new Object();
                    params.endpoint 	= "friends_" + presence;
                    params.url			= "https://graph.facebook.com/fql?q=" + fql_friends;
                    params.access_token = Qt.configuration.settings.active_user.access_token;
                    getFacebook(params);
                    
                    console.log("loadFriends(): " + params.url);
                    
                    Qt.mediaPlayer.pull_down();
                }
                
                console.log("loadFriends(): END >>> ");
            }
            
            onComplete: 
            {
                console.log("**** FRIENDS API endpoint: " + endpoint + ", httpcode: " + httpcode + ", identifier: " + identifier + ", response: " + response);
                
                Qt.mediaPlayer.loaded();

                loadingIndicator.visible = false;
                
                if(httpcode != 200)
                {
                    _app.flurryLogError(httpcode + " - " + endpoint + " - " + response);
                    Qt.handleError(response);
                }
                else 
                {
                    var responseJSON = JSON.parse(response);
                    
                    _app.set_string_to_file(response, "data/friends_" + Qt.configuration.settings.active_user.id + ".json");
                    
                    if(_app.contains(endpoint, "friends_all"))
                    {
                        populate(responseJSON);
                    }
                }
            }
        }
    ]
    
    function populate(responseJSON)
    {
        var active_users   = new Array();
        var offline_users  = new Array();
        var idle_users     = new Array();
        
        var all_friends_keyvalue_pair   = new Array();
        
        for(var i = 0; i < responseJSON.data.length; i++)
        {
            var friend = responseJSON.data[i];
            
            if(friend.online_presence == "active")
            {
                active_users.push(friend);
            }
            else if(friend.online_presence == "offline")
            {
                offline_users.push(friend);
            }
            else if(friend.online_presence == "idle")
            {
                idle_users.push(friend);
            }
            
            var friend_key_value_pair             = new Object();
            friend_key_value_pair[friend.uid]     = friend.name;
            all_friends_keyvalue_pair.push(friend_key_value_pair);
        }
        
        _app.set_string_to_file(JSON.stringify(all_friends_keyvalue_pair), "data/all_friends_keyvalue_pair.json");
        
        _app.command_headless("parse_all_friends");
        
        dataModelActive.clear();
        dataModelActive.insert(0, active_users);
        
        dataModelOffline.clear();
        dataModelOffline.insert(0, offline_users);
        
        dataModelIdle.clear();
        dataModelIdle.insert(0, idle_users);
        
        dataModelAll.clear();
        dataModelAll.insert(0, responseJSON.data);
        
        // BACKUP //
        
        dataModelActive2.clear();
        dataModelActive2.insert(0, active_users);
        
        dataModelOffline2.clear();
        dataModelOffline2.insert(0, offline_users);
        
        dataModelIdle2.clear();
        dataModelIdle2.insert(0, idle_users);
        
        dataModelAll2.clear();
        dataModelAll2.insert(0, responseJSON.data);
        
        // OTHERS //
        
        if(dataModelAll.size() == 0)
        {
            zeroResults.visible = true;
        }
        else 
        {
            zeroResults.visible = false;
        }
        
        nemAPI.all_users = responseJSON.data;
        nemAPI.active_users = active_users;
        nemAPI.offline_users = offline_users;
        nemAPI.idle_users = idle_users;
    }
}