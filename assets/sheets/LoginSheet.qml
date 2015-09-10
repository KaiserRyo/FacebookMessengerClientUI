import bb.cascades 1.0
import bb.system 1.0
import nemory.NemAPI 1.0

import "../components"
import QtQuick 1.0

Sheet 
{
    id: sheet
    
    //property string auth_url : "https://m.facebook.com/dialog/oauth?client_id=138055292887831&scope=xmpp_login,read_mailbox&redirect_uri=fbconnect://success&response_type=token";
    property string auth_url : "https://m.facebook.com/dialog/oauth?client_id=" + _app.fb_app_id() + "&response_type=token&scope=xmpp_login,read_mailbox&redirect_uri=fbconnect://success";
    //property string auth_url : "https://www.facebook.com/dialog/oauth?app_id=1378001845774632&client_id=1378001845774632&display=popup&domain=www.safechat.im&e2e={}&locale=en_US&origin=1&redirect_uri=https://s-static.ak.facebook.com/connect/xd_arbiter/NM7BtzAR8RM.js?version=41#cb=f184dfd2c4&domain=www.safechat.im&origin=https%3A%2F%2Fwww.safechat.im%2Ff27ff10ddc&relation=opener&frame=f28fa47c&response_type=token,signed_request&scope=read_mailbox,xmpp_login&sdk=joey";
    //property string auth_url : "https://m.facebook.com/dialog/oauth?client_id=138055292887831&e2e=%7B%22init%22%3A1432127958985%7D&type=user_agent&scope=xmpp_login%2Cread_friendlists%2Cread_mailbox&redirect_uri=http://localhost/&display=touch";
    property string last_access_token : "";

    signal loggedIn();
    
    function clearBrowsingData()
    {
        browser.storage.clearCache();
        browser.storage.clearCookies();
        browser.storage.clearCredentials();
        browser.storage.clearDatabases();
        browser.storage.clearLocalStorage();
        browser.storage.clearWebFileSystem();
        browser.storage.clear();
    }

    onOpened: 
    {
        clearBrowsingData();
        
        browser.url = auth_url;
        last_access_token = "";
        
        Qt.toast.pop("Loading Login Screen...")
    }
    
    onClosed: 
    {
        clearBrowsingData();
        last_access_token = "";
    }
    
    Page 
    {
        id: page

        titleBar: CustomTitleBar 
        {
            id: titleBar
            label_title.text: "AUTHENTICATION"
            image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"
            image_right.visible: false
            
            onLeftButtonClicked: 
            {
                sheet.close();
            }
        }

        Container 
        {
            layout: DockLayout {}
            
            ScrollView 
            {
                id: scrollView
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                //visible: !loadingIndicator.visible
                
                Container 
                {
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill

                    WebView
                    {
                        id: browser
                        //visible: (loadingIndicator.visible == false || Qt.app.contains(browser.url, "https://www.facebook.com/nemorystudios/"))
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Center
                        minHeight: _app.get_display_height();
                        
                        onNavigationRequested:
                        {
                            console.log("URL: " + request.url);
                            
                            if(Qt.app.contains(request.url, "#access_token"))
                            {
                                last_access_token = Qt.app.regex(request.url, "access_token=(.*)&expires_in", 1);

                                nemAPI.loadUser();
                                nemAPI.loadPermissions();
                                
                                console.log("access_token: " + last_access_token);
                            } 
                        }
                        
                        onLoadProgressChanged: 
                        {
                            do_shits();
                        }
                        
                        onLoadingChanged: 
                        {
                            do_shits();
                            
                            if (loadRequest.status == WebLoadStatus.Started) 
                            {
                                show_browser_timer.start();
                            }
                            else if (loadRequest.status == WebLoadStatus.Succeeded) 
                            {
                                loadingIndicator.visible = false;
                            }
                            else if (loadRequest.status == WebLoadStatus.Failed) 
                            {
                                loadingIndicator.visible = false;
                            }
                        }
                        
                        function do_shits()
                        {
                            if(_app.contains(browser.url, "m.facebook.com/login.php?skip_api_login=1&api_key=")) // MAIN LOGIN
                            {
                                browser.evaluateJavaScript(" if(document.getElementsByClassName('acy apm abb').length > 0) document.getElementsByClassName('acy apm abb')[0].style.visibility = 'hidden'; ");
                            }
                            
                            if(_app.contains(browser.url, "facebook.com/v1.0/dialog/oauth?redirect_uri=fbconnect") || _app.contains(browser.url, "m.facebook.com/v1.0/dialog/oauth/read")) // AUTHORIZED ALREADY
                            {
                                browser.evaluateJavaScript(" if(document.getElementsByClassName('img _51ti img').length > 0) document.getElementsByClassName('img _51ti img')[0].style.backgroundImage = \"url('http://i.imgur.com/JhKKZWS.png')\"; ");
                                browser.evaluateJavaScript(" if(document.getElementsByClassName('_5iy9').length > 0) document.getElementsByClassName('_5iy9')[0].innerHTML = 'You have already authorized <b>Nemory Studios Facebook Messenger</b>'; ");	
                            } 
                        }
                        
                        attachedObjects: 
                        [
                            Timer
                            {
                                id: show_browser_timer
                                interval: 1000
                                repeat: false
                                
                                onTriggered: 
                                {
                                    loadingIndicator.visible = true;
                                }
                            }
                        ]
                    }
                    
                    ProgressIndicator 
                    {
                        visible: browser.loading
                        value: browser.loadProgress
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Bottom
                    }
                }
            }
            
            ActivityIndicator 
            {
                id: loadingIndicator  
                visible: false
                running: visible
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                touchPropagationMode: TouchPropagationMode.None
            }
        }
        
        actions: 
        [
            ActionItem 
            {
                title: "Back"
                enabled: browser.canGoBack
                imageSource: "asset:///media/images/instagram/nav_arrow_back.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
                onTriggered: 
                {
                    browser.goBack();
                }
            },
            ActionItem 
            {
                title: "Refresh"
                imageSource: "asset:///media/images/instagram/nav_refresh.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
                onTriggered: 
                {
                    browser.reload();
                }
            },
            ActionItem 
            {
                title: "Forward"
                enabled: browser.canGoForward
                imageSource: "asset:///media/images/instagram/nav_arrow_next.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
                onTriggered: 
                {
                    browser.goBack();
                }
            },
            ActionItem 
            {
                title: "Clear Browsing Data"
                imageSource: "asset:///media/images/instagram/nav_arrow_next.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
                onTriggered: 
                {
                    clearBrowsingData();
                    
                    browser.url = auth_url;
                    
                    last_access_token = "";
                    
                    Qt.toast.pop("Loading Login Screen...")
                }
            }
        ]
    }
    
    attachedObjects: 
    [
        NemAPI 
        {
            id: nemAPI
            
            function loadUser()
            {
                var params 			= new Object();
                params.url          = "https://graph.facebook.com/me?fields=cover,bio,name,picture"
                params.endpoint 	= "my_profile";
                params.access_token = last_access_token;
                getFacebook(params);
            }
            
            function loadPermissions()
            {
                var params 			= new Object();
                params.endpoint 	= "/me/permissions?";
                params.access_token = last_access_token;
                getFacebook(params);
            }
            
            function likeNemoryStudios()
            {
                browser.url = "https://www.facebook.com/nemorystudios/";
                
                loadingIndicator.visible = false;
                
                Qt.dialog.pop("Welcome to " + Qt.app.app_name(), "Like Nemory Studios on Facebook for news and updates!\n\nPlease wait for the page to load. Or just press the back button to skip. \nThank you :)");
            }
            
            onComplete: 
            {
                console.log("**** AUTHENTICATION endpoint: " + endpoint + ", httpcode: " + httpcode + ", identifier: " + identifier + ", response: " + response);
                
                loadingIndicator.visible = false;
                
                if(httpcode != 200)
                {
                    Qt.app.flurryLogError(httpcode + " - " + endpoint + " - " + response);
                    
                    if(Qt.app.contains(response, "{"))
                    {
                        var responseJSON = JSON.parse(response);
                        
                        Qt.handleError(responseJSON.message);
                    }
                    else 
                    {
                        Qt.handleError(response);
                    }
                }
                else 
                {
                    var responseJSON = JSON.parse(response);

                    if(_app.contains(endpoint, "my_profile"))
                    {                        
                        var exists = false;
                        
                        for(var i = 0; i < Qt.configuration.accounts.length; i++)
                        {
                            var account = Qt.configuration.accounts[i];
                            
                            if(account.id == responseJSON.id)
                            {
                                exists = true;
                                break;
                            }
                        }
                        
                        if(!exists)
                        {
                            var user            = responseJSON;
                            user.active         = true;
                            user.access_token   = last_access_token;
                            user.favorites      = new Array();
                            
                            Qt.loadConfiguration();
                            Qt.setActiveUser(user);
                            Qt.configuration.accounts.push(user);
                            Qt.setConfiguration();
                            Qt.loadConfiguration();
                            
                            sheet.loggedIn();
                            
                            nemAPI.likeNemoryStudios();
                            
                            Qt.app.flurryLogEvent("logged_in_fb");
                            
                            Qt.nemAPI.logout();
                            _app.command_headless("logout");
                            //Qt.nemAPI.login(last_access_token);
                        }
                        else 
                        {
                            Qt.dialog.pop("Error", "Cannot add duplicate accounts.");
                            
                            browser.storage.clear();
                            browser.url = auth_url;
                            last_access_token = "";
                            
                            Qt.toast.pop("Loading Login Screen...")
                        }
                    }
                    else if(_app.contains(endpoint, "/me/permissions?"))
                    {  
//                        var error_message = "";
//                        
//                        if(responseJSON.data.user_friends != "1")
//                        {
//                            error_message += "* Error loading friends due to denied permission \n\n";
//                        }
//                        
//                        if(responseJSON.data.read_mailbox != "1")
//                        {
//                            error_message += "* Error loading inbox messages due to denied permission \n\n";
//                        }
//                        
//                        if(responseJSON.data.xmpp_login != "1")
//                        {
//                            error_message += "* Error connecting to chat due to denied permission \n\n";
//                        }
//                        
//                        if(error_message.length > 0)
//                        {
//                            error_message += "\n\nFOR SUPPORT, CONTACT US PLEASE";
//                            
//                            Qt.dialog.pop("Important Notice", error_message);
//                        }
                    }
                }
            }
        }
    ]
}