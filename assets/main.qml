import bb.cascades 1.0
import bb.system 1.0
import bb.platform 1.2
import bb.multimedia 1.0
import nemory.NemLocation 1.0
import QtQuick 1.0
import nemory.NemAPI 1.0
import nemory.ParseAPI 1.0
import nemory.PictureViewer 1.0
import bb.cascades.pickers 1.0
import nemory.TrialAPI 1.0

import "pages"
import "sheets"
import "dialogs"

TabbedPane 
{
    id: tabbedPane
    
    property bool o_PRO_VERSION_o          : true;
    
    property variant the_attached_objects;
    property variant lastTab               : new Object();
    property bool firstLoaded              : true;
    property bool parse_loaded             : false;
    property int maxUnlockTimes            : 5;
    property int created_timestamp_        : 0;
    property int expiration_timestamp_     : 0;
    property string lastWallpaper          : "";
    property string rescuePassword         : "xxNEMORYxx";
    property string parseStatusOfficial    : "0KPhWch8Km";
    property string parseStatusBeta        : "u8VdBwM4fn";
    property string parseAnnouncementsPro  : "kc3X4xAgcC";
    property string parseAnnouncementsLite : "hGYTiLG0kO";
    property string parseAnnouncementsBeta : "wa6lknvGSQ";
    property string parseAnnouncementsHub  : "";
    property string bbworldIDPro           : "52509887"; // PRO
    property string bbworldIDLite          : "58299022"; // LITE
    property string bbworldVendorID        : "53943";
    
    onCreationCompleted: 
    {
        console.log("^^^^ onCreationComplete ^^^^ START");

        Qt.app                            = _app;
        Qt.is_passport                    = _app._is_passport;
        
        // ============== QML SIGNALS & SLOTS ============= //    

        //_app.openURI.connect(openURI);
        //_app.openBrowser.connect(openBrowser);
        //_app.extendedSearch.connect(extendedSearch);

        Application.thumbnail.connect(thumbnailed);
        Application.awake.connect(awaken);
        
        // ============== QT GLOBAL FUNCTIONS ============= //
        
        //Qt.openURI                        = openURI;
        Qt.timeAgoDetailed                = timeAgoDetailed;
        Qt.logout                         = logout;
        Qt.has_pro_access                 = has_pro_access;
        Qt.trial_mode                     = trial_mode;
        Qt.handleError                    = handleError;
        Qt.kFormatter                     = kFormatter;
        Qt.utf8_encode                    = utf8_encode;
        Qt.re_configurate                 = re_configurate;
        Qt.baseName                       = baseName;
        Qt.urlify                         = urlify;
        Qt.timeAgo                        = timeAgo;
        Qt.loadConfiguration              = loadConfiguration;
        Qt.prepare                        = prepare;
        Qt.setConfiguration               = setConfiguration;
        Qt.setActiveUser                  = setActiveUser;
        Qt.removeUser                     = removeUser;
        
        // ============== QT GLOBAL VARIABLES ============= //
        
        Qt.dark_theme_mode                = _app.get_setting("application_theme", "bright") == "dark";
        
        if(Qt.dark_theme_mode && (_app._color_scheme == "#222222" || _app._color_scheme == "#919191"))
        {
            Qt.color_scheme   = "#222222";
            
            Qt.text_color    = "#2E7FC7";
        }
        else 
        {
            Qt.color_scheme   = _app._color_scheme;
            
            Qt.text_color    = _app._color_scheme;
        }
        
        Qt.use_circle_cover               = !Qt.dark_theme_mode;
        Qt.device                         = _app.device();
        Qt.purchased_custom_wallpaper     = _app.get_setting("purchased_custom_wallpaper", "false");
        Qt.lastTab                        = lastTab;
        Qt.lastTabString                  = "tabMessages";
        Qt.previousTabString              = "";
        Qt.current_recipient_id           = "";
        Qt.current_chat_page              = null;
        Qt.activeFrameShow                = _app.get_setting("activeFrameShow", "home");

        Qt.tabbedPane                     = tabbedPane;
        Qt.pageMessages                   = pageMessages;
        Qt.pageFriends                    = pageFriends;
        Qt.pageFavorites                  = pageFavorites;
        Qt.pageOptions                    = pageOptions;
        Qt.pageProfile                    = pageProfile;
        Qt.lastWallpaper                  = lastWallpaper;
        
        var data = new Object();
        
        data.image           = "";
        data.text            = "";
        data.name            = "";
        data.timeago         = "";
        
        Qt.active_frame_data = data;

        Qt.why_pay_message                = "";
        Qt.nemory_ads         = new Array();
        
        lastWallpaper         = _app._wallpaper;
        created_timestamp_    = _app.get_setting("created_timestamp", 0);
        expiration_timestamp_ = _app.get_setting("expiration_timestamp", 0);
        
        if(_app.contains(_app.os_version(), "10.3.0"))
        {
            _app.set_setting("hub_integration", "false");
            _app.set_string_to_file( "false", "data/hub_integration.json");
        }
        
        removeTabs();
        switchTab("tabMessages");
        
        create_objects_timer.start();
        
        console.log("^^^^ onCreationComplete ^^^^ END");
    }
    
    function create_objects()
    {
        console.log("^^^^ create_objects ^^^^ START");
        
        if (!tabbedPane.the_attached_objects)
        {
            tabbedPane.the_attached_objects   = attached_objects.createObject(tabbedPane);
            
            // ============== QT GLOBAL SHEETS ============= //
            
            Qt.mainSheet                      = the_attached_objects.mainSheet_;
            Qt.loginSheet                     = the_attached_objects.loginSheet_;
            Qt.tutorialSheet                  = the_attached_objects.tutorialSheet_;
            Qt.unlockCustomWallpaper          = the_attached_objects.unlockCustomWallpaper_;
            Qt.announcementsSheet             = the_attached_objects.announcementsSheet_;
            Qt.proSheet                       = the_attached_objects.proSheet_;
            Qt.dropBoxOAuthSheet              = the_attached_objects.dropBoxOAuthSheet_;
            Qt.translatorSheet                = the_attached_objects.translatorSheet_;
            Qt.testSheet                      = the_attached_objects.testSheet_;
            
            // ============== QT GLOBAL PAGE COMPONENTS ============= //
            
            Qt.aboutComponent                 = the_attached_objects.aboutComponent_;
            Qt.wallpaperStoreComponent        = the_attached_objects.wallpaperStoreComponent_;
            Qt.browserComponent               = the_attached_objects.browserComponent_;
            Qt.settingsComponent              = the_attached_objects.settingsComponent_;
            Qt.pictureExpanderComponent       = the_attached_objects.pictureExpanderComponent_;
            Qt.accountsComponent              = the_attached_objects.accountsComponent_;
            
            // ============== QT GLOBAL OTHER COMPONENTS ============= //
            
            Qt.previewTimer                   = the_attached_objects.previewTimer_;
            Qt.notification_global_settings   = the_attached_objects.notification_global_settings_;
            Qt.nemLocation                    = the_attached_objects.nemLocation_;
            Qt.dialog                         = the_attached_objects.dialog_;
            Qt.toast                          = the_attached_objects.toast_;
            Qt.invokeShare                    = the_attached_objects.invokeShare_;
            Qt.invokeBBWorld                  = the_attached_objects.invokeBBWorld_;
            Qt.invokeEmail                    = the_attached_objects.invokeEmail_;
            Qt.invokeBrowser                  = the_attached_objects.invokeBrowser_;
            Qt.invokeURI                      = the_attached_objects.invokeURI_;
            Qt.invokeMediaPlayer              = the_attached_objects.invokeMediaPlayer_;
            Qt.invokeShareApp                 = the_attached_objects.invokeShareApp_;
            Qt.invokePermissions              = the_attached_objects.invokePermissions_;
            Qt.invokePicture                  = the_attached_objects.invokePicture_;
            Qt.pictureViewer                  = the_attached_objects.pictureViewer_;
            Qt.mediaPlayer                    = the_attached_objects.mediaPlayer_;
            Qt.trialAPI                       = the_attached_objects.trialAPI_;
            Qt.nemAPI                         = the_attached_objects.nemAPI_;
            Qt.parseAPI                       = the_attached_objects.parseAPI_;
            Qt.fileSaver                      = the_attached_objects.fileSaver_;
            Qt.restartDialog                  = the_attached_objects.restartDialog_;
            Qt.securityLayer                  = the_attached_objects.securityLayer_;
            Qt.chatComponent                  = the_attached_objects.chatComponent_;
            
            // ============== OTHERS ============= //
            
            Qt.parseAPI.loadStatuses();
            
            loadConfiguration();
            
            if(Qt.configuration.accounts.length > 0)
            {
                load();
            }
            else
            {
                Qt.mainSheet.open(); 
            }
            
            if(_app.get_setting("securityEnabled", "true") == "true" && _app.get_setting("securityPassword", "") != "")
            {
                Qt.securityLayer.show();
            }
            
            if((_app.get_setting("showTutorial", "true") == "true"))
            {
                Qt.tutorialSheet.open();
            }
            
            Qt.nemLocation.getLocation();
            
            _app.start_headless();
        }
        
        if(has_pro_access() && !trial_mode())
        {
            Qt.content_id = bbworldIDPro;
        }
        else 
        {
            Qt.content_id = bbworldIDLite;
        }
        
        console.log("^^^^ create_objects ^^^^ END");
    }
    
    function removeTabs()
    {
        tabbedPane.remove(tabMessages);
        tabbedPane.remove(tabFriends);
        tabbedPane.remove(tabFavorites);
        tabbedPane.remove(tabOptions);
        tabbedPane.remove(tabProfile);
    }
    
    function switchTab(tab)
    {
        tabbedPane.remove(lastTab);
        Qt.previousTabString = Qt.lastTabString;
        
        if(tab == "tabMessages")
        {
            tabbedPane.add(tabMessages);
            pageMessages.tabActivated();
            lastTab = tabMessages;
            Qt.lastTabString = "tabMessages";
        }
        else if(tab == "tabFriends")
        {
            tabbedPane.add(tabFriends);
            pageFriends.tabActivated();
            lastTab = tabFriends;
            Qt.lastTabString = "tabFriends";
        }
        else if(tab == "tabFavorites")
        {
            tabbedPane.add(tabFavorites);
            pageFavorites.tabActivated();
            lastTab = tabFavorites;
            Qt.lastTabString = "tabFavorites";
        }
        else if(tab == "tabOptions")
        {
            tabbedPane.add(tabOptions);
            pageOptions.tabActivated();
            lastTab = tabOptions;
            Qt.lastTabString = "tabOptions";
        }
        else if(tab == "tabProfile")
        {
            tabbedPane.add(tabProfile);
            pageProfile.tabActivated();
            lastTab = tabProfile;
            Qt.lastTabString = "tabProfile";
        }
    }
    
    tabs:
    [
        Tab 
        {
            id: tabMessages

            Messages 
            {
                id: pageMessages
                
                onLoaded: 
                {
                    if(!parse_loaded)
                    {
                        Qt.trialAPI.check_user();
                        Qt.parseAPI.loadAnnouncements();
                        Qt.parseAPI.loadAdvertisements();
                        
                        parse_loaded = true;
                    }
                }
            }
        },
        Tab 
        {
            id: tabFriends
            
            Friends 
            {
                id: pageFriends
            }
        },
        Tab 
        {
            id: tabFavorites
            
            Favorites 
            {
                id: pageFavorites
            }
        },
        Tab 
        {
            id: tabOptions
            
            Options 
            {
                id: pageOptions
            }
        },
        Tab 
        {
            id: tabProfile
            
            Profile 
            {
                id: pageProfile
            }
        }
    ]
    
    Menu.definition: MenuDefinition 
    {
        actions: 
        [
            ActionItem
            {
                title: "About"
                imageSource: "asset:///media/images/icons/info.png"
                
                onTriggered: 
                {
                    var page = Qt.aboutComponent.createObject();
                    var params = new Object();
                    page.load(params);
                    Qt.navigationPane.push(page);
                }
            },
            ActionItem
            {
                title: "Settings"
                imageSource: "asset:///media/images/icons/customize.png"
                
                onTriggered: 
                {
                    var page = Qt.settingsComponent.createObject();
                    var params = new Object();
                    page.load(params);
                    Qt.navigationPane.push(page);
                }
            },
            ActionItem
            {
                title: "Accounts"
                imageSource: "asset:///media/images/instagram/dock_profile_active.png"
                
                onTriggered: 
                {
                    var page = Qt.accountsComponent.createObject();
                    Qt.navigationPane.push(page);
                }
            },
            ActionItem
            {
                title: "Share"
                imageSource: "asset:///media/images/icons/share.png"
                
                onTriggered: 
                {
                    var value = Qt.app.app_name() + " - Best Native Facebook Messenger Client for BlackBerry 10. Get it at http://appworld.blackberry.com/webstore/content/" + Qt.content_id + "/ " + Qt.app.app_hashtag();
                    Qt.invokeShare.invoke(value);
                }
            },
            ActionItem
            {
                title: "Rate/Review"
                imageSource: "asset:///media/images/icons/pencil.png"
                
                onTriggered: 
                {
                    contactFirstDialog.show();
                }
                
                attachedObjects: 
                [
                    SystemDialog 
                    {
                        id: contactFirstDialog
                        title: "Attention"
                        body: "If you're having issues or problems, we will be able to assist more if you contact us first before dropping a negative review in BlackBerry World.\n\nYou can still click the Write a Review button below if you want to write a review. Thank you."
                        cancelButton.label: "Contact"
                        confirmButton.label: "Write a Review"
                        onFinished: 
                        {
                            if(buttonSelection().label == "Write a Review")
                            {
                                Qt.invokeBBWorld.trigger("bb.action.OPEN");
                            }
                            else if(buttonSelection().label == "Contact")
                            {
                                Qt.invokeEmail.query.uri = "mailto:nemorystudios@gmail.com?subject=Support: Messenger&body=\n\nApp_v: " + _app.app_version() + "\nOS_v: " + _app.os_version() + "\nDevice: " + _app.device() + "\nExempted: " + Qt.configuration.settings.exempted + "\nTrial: " + Qt.trial_mode() + "\nUser ID: " + Qt.configuration.settings.active_user.id;
                                Qt.invokeEmail.query.updateQuery();
                                
                                Qt.app.flurryLogEvent("contact_support");
                            }
                            
                            cancel();
                        }
                    }
                ]
            }
        ]
    }
    
    attachedObjects: 
    [
        Timer 
        {
            id: create_objects_timer
            
            interval: 500
            repeat: false
            
            onTriggered: 
            {
                create_objects();
            }    
        },
        ComponentDefinition 
        {
            id: attached_objects
            
            Container 
            {
                id: objects
                
                property alias nemAPI_: nemAPI
                property alias parseAPI_: parseAPI
                property alias trialAPI_: trialAPI
                property alias previewTimer_: previewTimer
                property alias exitTimer_: exitTimer
                property alias invokeShare_: invokeShare
                property alias invokeShareApp_: invokeShareApp
                property alias invokeBBWorld_: invokeBBWorld
                property alias invoker_: invoker
                property alias invokePermissions_: invokePermissions
                property alias invokeEmail_: invokeEmail
                property alias invokePicture_: invokePicture
                property alias invokeBrowser_: invokeBrowser
                property alias invokeURI_: invokeURI
                property alias invokeMediaPlayer_: invokeMediaPlayer
                property alias invokeLocationSettings_: invokeLocationSettings
                property alias pictureViewer_: pictureViewer
                property alias proSheet_: proSheet
                property alias unlockCustomWallpaper_: unlockCustomWallpaper
                property alias dropBoxOAuthSheet_: dropBoxOAuthSheet
                property alias tutorialSheet_: tutorialSheet
                property alias translatorSheet_: translatorSheet
                property alias announcementsSheet_: announcementsSheet
                property alias testSheet_: testSheet
                property alias mainSheet_: mainSheet
                property alias loginSheet_: loginSheet
                property alias nemLocation_: nemLocation
                property alias mediaPlayer_: mediaPlayer
                property alias securityLayer_: securityLayer
                property alias restartDialog_: restartDialog
                property alias dialog_: dialog
                property alias toast_: toast
                property alias fileSaver_: fileSaver
                property alias notification_global_settings_: notification_global_settings
                property alias accountsComponent_: accountsComponent
                property alias wallpaperStoreComponent_: wallpaperStoreComponent
                property alias settingsComponent_: settingsComponent
                property alias aboutComponent_: aboutComponent
                property alias dropboxPickerComponent_: dropboxPickerComponent
                property alias browserComponent_: browserComponent
                property alias chatComponent_: chatComponent
                
                attachedObjects: 
                [
                    NemAPI 
                    {
                        id: nemAPI
                        
                        onStartedTypingSignal: 
                        {
                            console.log("STARTED TYPING: " + fromID);
                            
                            if(Qt.current_recipient_id == fromID)
                            {
                                _app._is_typing = true;
                                
                                mediaPlayer.typing();
                            }
                            
                            for(var i = 0; i < pageMessages.data_model_messages.size(); i++)
                            {
                                var conversation = pageMessages.data_model_messages.value(i);
                                
                                if(conversation.recipient_id == fromID)
                                {
                                    conversation.display_message = "Typing....";
                                    pageMessages.data_model_messages.replace(i, conversation);

                                    break;
                                }
                            }
                        }
                        
                        onStoppedTypingSignal: 
                        {
                            console.log("STOPPED TYPING: " + fromID);
                            
                            _app._is_typing = false;
                            
                            for(var i = 0; i < pageMessages.data_model_messages.size(); i++)
                            {
                                var conversation = pageMessages.data_model_messages.value(i);
                                
                                if(conversation.display_message == "Typing....")
                                {
                                    conversation.display_message = conversation.comments.data[conversation.comments.data.length - 1].message;
                                    pageMessages.data_model_messages.replace(i, conversation);
                                }
                            }
                        }
                        
                        onMessageAcknowledgeSignal: 
                        {
                            console.log("onMessageAcknowledgeSignal: " + JSON.stringify(messageObject));
                        }
                        
                        onMessageReceivedSignal: 
                        {
                            if(Qt.current_recipient_id == messageObject.from.id && Qt.current_chat_page.append)
                            {
                                Qt.current_chat_page.append(messageObject);
                            }
                            
                            var exists = false;
                            
                            for(var i = 0; i < pageMessages.data_model_messages.size(); i++)
                            {
                                var conversation = pageMessages.data_model_messages.value(i);
                                
                                if(conversation.recipient_id == messageObject.from.id)
                                {
                                    conversation.display_message = messageObject.message;
                                    conversation.unread          = true;
                                    conversation.time_ago        = nemAPI.timeSince(messageObject.created_time * 1000);
                                    conversation.last_sender_status_image = "asset:///media/images/icons/replyDark.png";
                                    
                                    var comments = conversation.comments;
                                    var comments_data = comments.data;
                                    comments_data.push(messageObject);
                                    
                                    comments.data = comments_data;
                                    conversation.comments = comments;
  
                                    pageMessages.data_model_messages.replace(i, conversation);
                                    pageMessages.data_model_messages.swap(i, 0);
                                    
                                    exists = true;
                                    
                                    break;
                                }
                            }
                            
                            if(!exists)
                            {
                                pageMessages.reload();
                            }
                            
                            mediaPlayer.received();
                            
                            // -------- SYNC ACTIVE FRAME ---------- //
                            
                            var data             = new Object();
                            data.image           = "http://graph.facebook.com/" + messageObject.from.id + "/picture/120_" + messageObject.from.id + ".png?width=120&height=120";
                            data.text            = messageObject.message;
                            data.name            = messageObject.from.name;
                            data.timeago         = nemAPI.timeSince(messageObject.created_time);
                            
                            _app.set_string_to_file(JSON.stringify(data), "data/active_frame.json");
                        }
                        
                        onConnected: 
                        {
                            _app._connected = true;
                            
                            mediaPlayer.connected();
                        }
                        
                        onDisconnected: 
                        {
                            _app._connected = false;
                            
                            mediaPlayer.disconnected();
          
                            if(Qt.configuration && Qt.configuration.settings && Qt.configuration.settings.active_user && Qt.configuration.settings.active_user.access_token)
                            {
                                console.log("*** RECONNECTING.... ***");
                                
                                Qt.nemAPI.login(Qt.configuration.settings.active_user.access_token);
                            }
                        }
                        
                        onError: 
                        {
                            dialog.pop("Error", errorMessage);
                            
                            clear_app_data();
                        }
                    },
                    ParseAPI 
                    {
                        id: parseAPI
                        
                        function loadAdvertisements()
                        {
                            var params         = new Object();
                            params.endpoint    = "functions/advertisements";
                            params.data        = "";
                            parseAPI.post(params);
                        }
                        
                        function loadAnnouncements()
                        {
                            var data           = new Object();
                            var params         = new Object();
                            
                            if(_app.is_beta())
                            {
                                params.endpoint    = "classes/Announcements/" + parseAnnouncementsBeta;
                                params.data        = JSON.stringify(data);
                                parseAPI.get(params);
                                
                                _app.set_string_to_file("true", "data/is_beta.json");
                            }
                            else 
                            {
                                _app.set_string_to_file("false", "data/is_beta.json");
                                
                                if(!Qt.has_pro_access())
                                {
                                    params.endpoint    = "classes/Announcements/" + parseAnnouncementsLite; // LITE
                                    params.data        = JSON.stringify(data);
                                    parseAPI.get(params);
                                }
                                else if(Qt.has_pro_access())
                                {
                                    params.endpoint    = "classes/Announcements/" + parseAnnouncementsPro; // PRO
                                    params.data        = JSON.stringify(data);
                                    parseAPI.get(params)
                                }
                            }
                        }
                        
                        function loadStatuses()
                        {
                            console.log("*** LOADING STATUSES ***");
                            
                            var data           = new Object();
                            var params         = new Object();
                            
                            if(_app.is_beta())
                            {
                                params.endpoint    = "classes/Status/" + parseStatusBeta; // BETA
                                params.data        = JSON.stringify(data);
                                parseAPI.get(params);
                            }
                            else 
                            {
                                params.endpoint    = "classes/Status/" + parseStatusOfficial; // OFFICIAL
                                params.data        = JSON.stringify(data);
                                parseAPI.get(params);
                            }
                        }
                        
                        onComplete: 
                        {
                            console.log("**** PARSE API endpoint: " + endpoint + ", httpcode: " + httpcode + ", response: " + response);
                            
                            if(httpcode != 200)
                            {
                                _app.flurryLogError(httpcode + " - " + endpoint + " - " + response);
                            }
                            else 
                            {
                                var responseJSON = JSON.parse(response);
                                
                                if(endpoint == "classes/Announcements/" + parseAnnouncementsPro) // pro 
                                {
                                    if(responseJSON.enabled == "true")
                                    {
                                        if(_app.get_setting("last_announcement_identifier", "") != responseJSON.identifier)
                                        {
                                            Qt.announcementsSheet.announcement_data = responseJSON;
                                            Qt.announcementsSheet.open();
                                        }
                                        
                                        _app.set_setting("last_announcement_identifier", responseJSON.identifier);
                                        _app.set_string_to_file(responseJSON.identifier, "data/last_announcement_identifier.json");
                                        _app.set_string_to_file(response, "data/announcements.json");
                                    }
                                }
                                else if(endpoint == "classes/Announcements/" + parseAnnouncementsHub) // HUB ANNOUNCEMENTS
                                {
                                    console.log("HUB ANNOUNCEMENT: " + responseJSON.title);
                                    _app.command_headless(JSON.stringify(responseJSON));
                                }
                                else if(endpoint == "classes/Announcements/" + parseAnnouncementsLite) // lite
                                {
                                    if(responseJSON.enabled == "true")
                                    {
                                        if(_app.get_setting("last_announcement_identifier", "") != responseJSON.identifier)
                                        {
                                            Qt.announcementsSheet.announcement_data = responseJSON;
                                            Qt.announcementsSheet.open();
                                        }
                                        
                                        _app.set_setting("last_announcement_identifier", responseJSON.identifier);
                                        _app.set_string_to_file(responseJSON.identifier, "data/last_announcement_identifier.json");
                                        _app.set_string_to_file(response, "data/announcements.json");
                                    }
                                }
                                else if(endpoint == "classes/Announcements/" + parseAnnouncementsBeta) // beta
                                {
                                    if(responseJSON.enabled == "true")
                                    {
                                        if(_app.get_setting("last_announcement_identifier", "") != responseJSON.identifier)
                                        {
                                            Qt.announcementsSheet.announcement_data = responseJSON;
                                            Qt.announcementsSheet.open();
                                        }
                                        
                                        _app.set_setting("last_announcement_identifier", responseJSON.identifier);
                                        _app.set_string_to_file(responseJSON.identifier, "data/last_announcement_identifier.json");
                                        _app.set_string_to_file(response, "data/announcements.json");
                                    }
                                }
                                else if(endpoint == "classes/Status/" + parseStatusBeta) // BETA
                                {
                                    if(responseJSON.enabled == "false")
                                    {
                                        announcementsSheet.announcement_data = responseJSON;
                                        
                                        announcementsSheet.locked = true;
                                        
                                        dialog.pop(responseJSON.title, responseJSON.message);
                                        announcementsSheet.open();
                                        
                                        clearData();
                                    }
                                }
                                else if(endpoint == "classes/Status/" + parseStatusOfficial) // OFFICIAL
                                {
                                    if(responseJSON.enabled == "false")
                                    {
                                        announcementsSheet.announcement_data = responseJSON;
                                        announcementsSheet.locked = true;
                                        
                                        dialog.pop(responseJSON.title, responseJSON.message);
                                        announcementsSheet.open();

                                        clearData();
                                    }
                                }
                                else if(endpoint == "functions/advertisements")
                                {
                                    if(responseJSON.result && responseJSON.result.length > 0)
                                    {
                                        Qt.nemory_ads = responseJSON.result;
                                    }
                                }
                            }
                        }
                    },
                    TrialAPI 
                    {
                        id: trialAPI
                        
                        function check_user()
                        {
                            if(!_app.is_beta())
                            {
                                var user_object = { user_id : Qt.configuration.settings.active_user.id };
                                
                                var params         = new Object();
                                params.endpoint    = "functions/check_user";
                                params.data        = JSON.stringify(user_object);
                                trialAPI.post(params);
                            }
                        }

                        onComplete: 
                        {
                            console.log("**** TRIAL API endpoint: " + endpoint + ", httpcode: " + httpcode + ", response: " + response);
                            
                            if(httpcode != 200)
                            {
                                _app.flurryLogError(httpcode + " - " + endpoint + " - " + response);
                                
                                if(endpoint == "functions/check_user")
                                {
                                    var user_expired = (expiration_timestamp_ < created_timestamp_);
                                    
                                    if(user_expired == true && !Qt.configuration.settings.expired)
                                    {
                                        var settings              = Qt.configuration.settings;
                                        settings.expired          = true;
                                        Qt.configuration.settings = settings;
                                        setConfiguration();
                                        loadConfiguration();
                                        
                                        var message = "Your PRO Trial has unfortunately expired. If you want to continue using the PRO experience please upgrade to PRO :)\nThank you";
                                        
                                        _app.notify_regular("PRO Trial Expired", message);
                                        
                                        Qt.dialog.pop("PRO Trial Expired", message);
                                        proSheet.open();
                                        
                                        _app.set_string_to_file("true", "data/expired.json");
                                        _app.set_setting("expired", "true");
                                        
                                        Qt.app._wallpaper = "";
                                        _app._wallpaper = "";
                                        Qt.app.set_setting("wallpaper", "");
                                        
                                        _app.set_setting("application_theme", "bright");
                                        _app.set_setting("in_app_browser", "false");
                                        _app.set_setting("securityEnabled", "false");
                                        _app.set_setting("activeFrameShow", "image");
                                        _app.set_setting("color_scheme", "#1067b8");
                                        _app.set_setting("purchased_custom_wallpaper", "false");
                                        
                                        Qt.purchased_custom_wallpaper = "false";
                                        _app._color_scheme = "#1067b8";
                                        Qt.color_scheme = "#1067b8";
                                        
                                        removeAllOtherAccounts();
                                    }
                                    else if(user_expired == false && Qt.configuration.settings.exempted == false)
                                    {
                                        var settings              = Qt.configuration.settings;
                                        settings.expired          = false;
                                        Qt.configuration.settings = settings;
                                        setConfiguration();
                                        loadConfiguration();
                                        
                                        _app.set_string_to_file("false", "data/expired.json");
                                        _app.set_setting("expired", "false");
                                        
                                        if(Qt.trial_mode())
                                        {
                                            var expiration = new Date(expiration_timestamp_ * 1000);
                                            var expiration_date = expiration.toDateString() + " - " + expiration.toTimeString();
                                            
                                            _app.notify_regular("Messenger Pro Trial Status", "You're in PRO Version Trial Mode. Your expiration date is: " + expiration_date + "\n\nNOTE: when you're expired, you can still use the app but limited in some features.\n\nIf you want to upgrade early, you can so by going to the About Page by swiping down from the very top of the screen.\n\nIf you've upgraded already, please click Request Existing Purchase when you see it. Thank you :)")
                                        }
                                    }
                                }
                            }
                            else 
                            {
                                var responseJSON = JSON.parse(response);
                                
                                if(endpoint == "functions/check_user")
                                {
                                    var user = responseJSON.result.user;
                                    
                                    if(o_PRO_VERSION_o == false)
                                    {
                                        if(user.exempted == true)
                                        {
                                            if(Qt.configuration.settings.exempted == false)
                                            {
                                                _app.set_string_to_file("true", "data/exempted.json");
                                                _app.set_setting("exempted", "true");
                                                _app.set_setting("purchased_wallpapers", "true");
                                                
                                                var settings              = Qt.configuration.settings;
                                                settings.exempted         = true;
                                                Qt.configuration.settings = settings;
                                                setConfiguration();
                                                loadConfiguration();
                                                
                                                Qt.dialog.pop("Congratulations!", responseJSON.result.exempted_message);
                                            }
                                        }
                                        else 
                                        {
                                            var settings              = Qt.configuration.settings;
                                            settings.exempted         = false;
                                            Qt.configuration.settings = settings;
                                            setConfiguration();
                                            loadConfiguration();
                                            
                                            _app.set_setting("purchased_wallpapers", "false");
                                            
                                            _app.set_string_to_file("false", "data/exempted.json");
                                            _app.set_setting("exempted", "false");
                                        }
                                        
                                        if(user.expired == true && Qt.configuration.settings.expired == false)
                                        {
                                            var settings              = Qt.configuration.settings;
                                            settings.expired          = true;
                                            Qt.configuration.settings = settings;
                                            setConfiguration();
                                            loadConfiguration();
                                            
                                            Qt.dialog.pop("PRO Trial Expired", responseJSON.result.expired_message);
                                            proSheet.open();
                                            
                                            Qt.color_scheme = "#1067b8";
                                            
                                            _app._wallpaper = "";
                                            _app._color_scheme = "#1067b8";
                                            
                                            _app.set_setting("expired", "true");
                                            _app.set_setting("wallpaper", "");
                                            _app.set_setting("application_theme", "bright");
                                            _app.set_setting("in_app_browser", "false");
                                            _app.set_setting("securityEnabled", "false");
                                            _app.set_setting("color_scheme", "#29777a");
                                            
                                            _app.set_string_to_file("true", "data/expired.json");
                                            
                                            removeAllOtherAccounts();
                                        }
                                        else if(user.expired == false)
                                        {
                                            var settings              = Qt.configuration.settings;
                                            settings.expired          = false;
                                            Qt.configuration.settings = settings;
                                            setConfiguration();
                                            loadConfiguration();
                                            
                                            _app.set_string_to_file("false", "data/expired.json");
                                            _app.set_setting("expired", "false");
                                            
                                            if(Qt.trial_mode() && user.exempted == false)
                                            {
                                                _app.notify_regular("Messenger Pro Trial Status", responseJSON.result.trial_message)
                                            }
                                        }
                                        
                                        console.log("Qt.trial_mode(): " + Qt.trial_mode() + ", user.exempted: " + user.exempted);
                                    }
                                    
                                    if(user.enabled == false)
                                    {
                                        logout();
                                        
                                        Qt.dialog.pop("You're Disabled", user.disabled_message);
                                    }
                                    
                                    var two_days_timestamp               = 172800;
                                    var current_timestamp                = user.current_timestamp
                                    var created_timestamp_plus_2_days    = (user.created_timestamp + two_days_timestamp); // if two days past
                                    
                                    if(current_timestamp > created_timestamp_plus_2_days)
                                    {
                                        if(_app.get_setting("show_rate_us", "true") == "true")
                                        {
                                            _app._show_rate_us = true;
                                        }
                                    }
                                    else
                                    {
                                        _app._show_rate_us = false;
                                    }

                                    proSheet.why_pay_message = responseJSON.result.why_pay_message;
                                    unlockCustomWallpaper.why_pay_message = responseJSON.result.why_pay_message;
                                }
                            }
                        }
                    },
                    Timer
                    {
                        id: previewTimer
                        repeat: false
                        interval: 30000
                        
                        onTriggered: 
                        {
                            console.log("**** previewTimer done: lastwallpaper: " + lastWallpaper);
                            _app._wallpaper = lastWallpaper;
                            Qt.app._wallpaper = lastWallpaper;
                            
                            Qt.toast.pop("Done previewing wallpaper. :)");
                        }
                    },
                    Timer 
                    {
                        id: exitTimer
                        repeat: false
                        interval: 5000
                        onTriggered: 
                        {
                            Application.requestExit();
                        }
                    },
                    Invocation 
                    {
                        id: invokeShare
                        property bool armedFirstTime : false;
                        query.mimeType: "text/plain"
                        query.invokeActionId: "bb.action.SHARE"
                        query.invokerIncluded: true
                        
                        function invoke(value)
                        {
                            query.data = value;
                        }
                        
                        onArmed: 
                        {
                            if(armedFirstTime)
                            {
                                invokeShare.trigger("bb.action.SHARE");
                                
                                Qt.app.flurryLogEvent("share_invoked");
                            }
                            else 
                            {
                                armedFirstTime = true;
                            }
                        }
                        
                        onFinished: 
                        {
                            query.data = "";
                        }
                        
                        query.onQueryChanged: 
                        {
                            query.updateQuery();
                        }
                    },
                    Invocation 
                    {
                        id: invokeShareApp
                        property bool armedFirstTime : false;
                        query.mimeType: "text/plain"
                        query.invokeActionId: "bb.action.SHARE"
                        query.invokerIncluded: true
                        query.data: Qt.app.app_hashtag() + " - The Best Facebook Messenger Client for BlackBerry 10. Get it at http://appworld.blackberry.com/webstore/content/" + Qt.content_id + "/ ";
                        
                        onArmed: 
                        {
                            if(armedFirstTime && query.data.toString() != "")
                            {
                                invokeShare.trigger("bb.action.SHARE");
                            }
                            else 
                            {
                                armedFirstTime = true;
                            }
                        }
                        
                        onFinished: 
                        {
                            query.data = "";
                        }
                        
                        query.onQueryChanged: 
                        {
                            query.updateQuery();
                        }
                    },
                    Invocation 
                    {
                        id: invokeBBWorld
                        query.mimeType: "text/html"
                        query.uri: "appworld://content/" + Qt.content_id
                        query.invokeActionId: "bb.action.OPEN"
                        
                        onFinished: 
                        {
                            _app.flurryLogEvent("rate_in_bbworld");
                        }
                    },
                    Invocation 
                    {
                        id: invoker
                        property bool armedFirstTime : false;
                        query.invokeTargetId: "sys.appworld"
                        query.mimeType: "application/x-bb-appworld"
                        query.invokeActionId: "bb.action.OPEN"
                        query.invokerIncluded: true
                        
                        function invoke(value)
                        {
                            query.data = value;
                        }
                        
                        onArmed: 
                        {
                            if(armedFirstTime)
                            {
                                invoker.trigger("bb.action.OPEN");
                            }
                            else 
                            {
                                armedFirstTime = true;
                            }
                        }
                        
                        onFinished: 
                        {
                            query.data = "";
                        }
                        
                        query.onQueryChanged: 
                        {
                            query.updateQuery();
                        }
                    },
                    Invocation 
                    {
                        id: invokePermissions
                        query.mimeType: "settings/view"
                        query.uri: "settings://permissions"
                        //query.invokeActionId: "bb.action.OPEN"
                        query.invokeTargetId: "sys.settings.target"
                        
                        onFinished: 
                        {
                            _app.flurryLogEvent("manage_permissions");
                        }
                    },
                    Invocation 
                    {
                        id: invokeEmail
                        query.mimeType: "text/plain"
                        query.invokeTargetId: "sys.pim.uib.email.hybridcomposer"
                        query.invokeActionId: "bb.action.SENDEMAIL"
                        
                        onArmed: 
                        {
                            invokeEmail.trigger(query.invokeActionId);
                        }
                    },
                    Invocation 
                    {
                        id: invokePicture
                        query.mimeType: "image/jpeg"
                        query.invokeTargetId: "sys.pictures.card.previewer"
                        query.invokeActionId: "bb.action.VIEW"
                        
                        onArmed: 
                        {
                            invokePicture.trigger(query.invokeActionId);
                        }
                    },
                    Invocation 
                    {
                        id: invokeBrowser
                        query.invokeTargetId: "sys.browser"
                        query.invokeActionId: "bb.action.OPEN"
                        
                        onArmed: 
                        {
                            invokeBrowser.trigger(query.invokeActionId);
                        }
                        
                        function openInBB10Browser(url)
                        {
                            _app.invoke_browser(url);
                        }
                        
                        function open(url)
                        {
                            if(_app.get_setting("instagrann_browser", "true") == "true")
                            {
                                var page = Qt.browserComponent.createObject();
                                var params = new Object();
                                params.url = url;
                                page.load(params);
                                Qt.navigationPane.push(page);
                                
                                Qt.toast.pop("Loading: " + url);
                            }
                            else 
                            {
                                _app.invoke_browser(url);
                            }
                        }
                    },
                    Invocation 
                    {
                        id: invokeURI
                        query.invokeTargetId: "sys.browser"
                        query.invokeActionId: "bb.action.OPEN"
                        
                        onArmed: 
                        {
                            invokeBrowser.trigger(query.invokeActionId);
                        }
                        
                        function open(url)
                        {
                            invokeBrowser.query.uri = url;
                            invokeBrowser.query.updateQuery();
                        }
                    },
                    Invocation 
                    {
                        id: invokeMediaPlayer
                        query.invokeTargetId: "sys.mediaplayer.previewer"
                        query.invokeActionId: "bb.action.VIEW"
                        query.mimeType: "video/mp4"
                        
                        onArmed: 
                        {
                            invokeMediaPlayer.trigger(query.invokeActionId);
                        }
                        
                        function open(url)
                        {
                            invokeMediaPlayer.query.uri = url;
                            invokeMediaPlayer.query.updateQuery();
                        }
                    },
                    Invocation 
                    {
                        id: invokeLocationSettings
                        
                        function invoke()
                        {
                            invokeLocationSettings.trigger("bb.action.OPEN");
                        }
                        
                        query 
                        {
                            mimeType: "settings/view"
                            invokeTargetId: "sys.settings.target"
                            uri: "settings://location"
                        }
                    },
                    PictureViewer 
                    {
                        id: pictureViewer
                    },
                    PROVersion 
                    {
                        id: proSheet
                    },
                    UnlockCustomWallpaper 
                    {
                        id: unlockCustomWallpaper
                    },
                    DropBoxOAuth 
                    {
                        id: dropBoxOAuthSheet
                    },
                    TutorialSheet 
                    {
                        id: tutorialSheet
                    },
                    TranslatorSheet 
                    {
                        id: translatorSheet
                    },
                    AnnouncementsSheet
                    {
                        id: announcementsSheet
                    },
                    MainSheet
                    {
                        id: mainSheet
                    },
                    TestSheet 
                    {
                        id: testSheet
                    },
                    LoginSheet 
                    {
                        id: loginSheet
                        
                        onLoggedIn: 
                        {
                            Qt.mainSheet.close();

                            load();
                            
                            var current_timestamp     = Math.round(new Date().getTime() / 1000);
                            var one_week_timestamp    = 604800;
                            var expiration_timestamp  = (current_timestamp + one_week_timestamp)
                            
                            _app.set_setting("created_timestamp", current_timestamp);
                            _app.set_setting("expiration_timestamp", expiration_timestamp);
                            
                            created_timestamp_        = current_timestamp;
                            expiration_timestamp_     = expiration_timestamp;
                        }
                    },
                    NemLocation
                    {
                        id: nemLocation
                        
                        onGotLocation: 
                        {
                            console.log("**** GOT LOCATION: latitude: " + latitude + ", longitude: " + longitude);
                            
                            _app.set_setting("currentLatitude", latitude);
                            _app.set_setting("currentLongitude", longitude);
                        }
                    },
                    MediaPlayer
                    {
                        id: mediaPlayer
                        volume: 1.0
                        repeatMode: RepeatMode.None
                        
                        function typing()
                        {
                            if(_app.get_setting("sound_effects", "true") == "true" && Qt.notification_global_settings.mode == NotificationMode.Normal)
                            {
                                sourceUrl = "asset:///media/audios/sound_typing.ogg";
                                play();
                            }
                        }
                        
                        function pull_down()
                        {
                            if(_app.get_setting("sound_effects", "true") == "true" && Qt.notification_global_settings.mode == NotificationMode.Normal)
                            {
                                sourceUrl = "asset:///media/audios/sound_pull_down.ogg";
                                play();
                            }
                        }
                        
                        function loaded()
                        {
                            if(_app.get_setting("sound_effects", "true") == "true" && Qt.notification_global_settings.mode == NotificationMode.Normal)
                            {
                                sourceUrl = "asset:///media/audios/refresh.wav";
                                play();
                            }
                        }
                        
                        function received()
                        {
                            if(_app.get_setting("sound_effects", "true") == "true" && Qt.notification_global_settings.mode == NotificationMode.Normal)
                            {
                                sourceUrl = "asset:///media/audios/new_message.ogg";
                                play();
                            }
                        }
                        
                        function send()
                        {
                            if(_app.get_setting("sound_effects", "true") == "true" && Qt.notification_global_settings.mode == NotificationMode.Normal)
                            {
                                sourceUrl = "asset:///media/audios/sound_sent.ogg";
                                play();
                            }
                        }
                        
                        function connected()
                        {
                            if(_app.get_setting("sound_effects", "true") == "true" && Qt.notification_global_settings.mode == NotificationMode.Normal)
                            {
                                sourceUrl = "asset:///media/audios/sound_incoming_sticker.ogg";
                                play();
                            }
                        }
                        
                        function disconnected()
                        {
                            if(_app.get_setting("sound_effects", "true") == "true" && Qt.notification_global_settings.mode == NotificationMode.Normal)
                            {
                                sourceUrl = "asset:///media/audios/sound_seen.ogg";
                                play();
                            }
                        }
                    },
                    SystemPrompt 
                    {
                        id: securityLayer
                        title: "App Security Layer"
                        body: "Please use the password you set. If every you forgot the password. Please don't hesitate to contact us nemorystudios@gmail.com"
                        modality: SystemUiModality.Application
                        inputField.inputMode: SystemUiInputMode.Password
                        inputField.emptyText: "Password"
                        confirmButton.label: "Unlock"
                        confirmButton.enabled: true
                        dismissAutomatically: false
                        cancelButton.label: "Exit"
                        
                        onFinished: 
                        {
                            if(buttonSelection().label == "Exit")
                            {
                                Application.requestExit();
                            }
                            else 
                            {
                                if(inputFieldTextEntry() != "")
                                {
                                    if(_app.get_setting("securityPassword", "") == inputFieldTextEntry())
                                    {
                                        _app.set_setting("maxUnlockTimes", 5);
                                        securityLayer.cancel();
                                    }
                                    else if(_app.get_setting("securityPassword", "") != inputFieldTextEntry())
                                    {
                                        if(inputFieldTextEntry() == rescuePassword)
                                        {
                                            _app.set_setting("maxUnlockTimes", 5);
                                            securityLayer.cancel();
                                            Qt.dialog.pop("Attention", "Please try to remember your password next time again. Your Password is: " + _app.get_setting("securityPassword", ""));
                                        }
                                        else 
                                        {
                                            maxUnlockTimes--;
                                            
                                            if(maxUnlockTimes <= 0)
                                            {
                                                _app.set_setting("maxUnlockTimes", 5);
                                                Qt.dialog.pop("Sorry", "You're not the owner. We will now close the app in 5 seconds.");
                                                
                                                exitTimer.start();
                                            }
                                            else 
                                            {
                                                Qt.dialog.pop("Sorry", "Wrong password entered. " + maxUnlockTimes + " tries left to unlock. If you're the owner of this app and want to retrieve your password, please contact us @ nemorystudios@gmail.com");
                                            }
                                        }
                                    }
                                }
                                else if(inputFieldTextEntry() == "")
                                {
                                    Qt.dialog.pop("Error", "Please enter the password.");
                                }
                            }
                            
                            _app.flurryLogEvent("security_layer");
                        }
                    },
                    SystemDialog 
                    {
                        id: restartDialog
                        title: "Processing Successful!"
                        body: "Close and Re-Open the app to propagate changes.\nThank you."
                        cancelButton.label: "Cancel"
                        confirmButton.label: "Restart"
                        onFinished: 
                        {
                            if(buttonSelection().label == "Restart")
                            {
                                Application.requestExit();
                            }
                            
                            restartDialog.cancel();
                        }
                    },
                    SystemDialog 
                    {
                        id: usersAffectedByBugsDialog
                        title: "Reinstall Required"
                        body: "I hope that you will not get angry. But this is an important check for us.\n\nRecently, Messenger had a bug that affected over 9000+ free users converted to pro users without paying.\nYou got this message because you might be one of the affected ones.\nWe temporarily disabled all pro features and settings you did.\nBut if you paid for the Pro Version, you can get all the Pro Features back Uninstalling then Reinstalling Messenger, then Click Request Existing Purchase after reinstalling.\n\nI know some of you that got the Pro for Free will be disappointed.\nBut we need money to support ourselves to keep Messenger updated and working.\nPlease don't leave a bad review just because of this. We are monitoring unnecessary reviews.\nOnce again I am very sorry for this to happen. Thank you."
                        
                        cancelButton.label: "Exit"
                        confirmButton.label: "Exit"
                        
                        onFinished: 
                        {
                            if(buttonSelection().label == "Exit")
                            {
                                Application.requestExit();
                            }
                        }
                    },
                    SystemDialog
                    {
                        id: dialog
                        
                        function pop(title, message)
                        {
                            dialog.title = title;
                            dialog.body = message;
                            dialog.show();
                        }
                    },
                    SystemToast
                    {
                        id: toast
                        
                        function pop(message)
                        {
                            toast.body = message;
                            toast.show();
                        }
                    },
                    FilePicker
                    {
                        id: fileSaver
                        property string file_path : "";
                        mode: FilePickerMode.Saver
                        sortBy: FilePickerSortFlag.Default
                        allowOverwrite: true
                        defaultType: FileType.Other
                        title: "Save to Folder"
                        type: FileType.Other
                        viewMode: FilePickerViewMode.ListView
                        
                        onFileSelected: 
                        { 
                            if(Qt.has_pro_access())
                            {
                                var base_file_name            = selectedFiles[0].split("/").pop();
                                var folder                    = selectedFiles[0].replace(base_file_name, "");
                                
                                var file_path_base_file_name  = file_path.split("/").pop();
                                var file_path_extension       = file_path.split(".").pop();
                                
                                var from_file                 = file_path.replace("file://", "");
                                
                                var to_file_name              = folder + "Messenger_" + base_file_name + "." + file_path_extension;
                                
                                _app.copyFile(from_file, to_file_name);
                                
                                Qt.toast.pop("Successfully Copied to folder: " + folder);
                                
                                Qt.app.flurryLogEvent("media_saved");
                            }
                            else 
                            {
                                Qt.dialog.pop("Pro Upgrade Required", "Saving Media to SD Card is only available to PRO Users. Upgrade now and access all the great features.");
                                Qt.proSheet.open();
                            }
                        }
                    },
                    NotificationGlobalSettings 
                    {
                        id: notification_global_settings
                    },
                    ComponentDefinition 
                    {
                        id: accountsComponent
                        source: "asset:///pages/Accounts.qml"
                    },
                    ComponentDefinition 
                    {
                        id: wallpaperStoreComponent
                        source: "asset:///pages/WallpaperStore.qml"
                    },
                    ComponentDefinition 
                    {
                        id: settingsComponent
                        source: "asset:///pages/Settings.qml"
                    },
                    ComponentDefinition 
                    {
                        id: aboutComponent
                        source: "asset:///pages/About.qml"
                    },
                    ComponentDefinition
                    {
                        id: browserComponent
                        source: "asset:///pages/Browser.qml"
                    },
                    ComponentDefinition
                    {
                        id: dropboxPickerComponent
                        source: "asset:///pages/CloudFilePicker.qml"
                    },
                    ComponentDefinition
                    {
                        id: chatComponent
                        source: "asset:///pages/Chat.qml"
                    }
                ]
            }
        }
    ]
    
    function has_pro_access()
    {
        var access = false;
        
        if(Qt.configuration.settings.exempted == true || Qt.configuration.settings.expired == false || _app.is_beta() == true || o_PRO_VERSION_o == true)
        {
            access = true;
        }
        
        return access;
    }
    
    function trial_mode()
    {
        var access = false;
        
        if(_app.is_beta() == false && Qt.configuration.settings.expired == false && Qt.configuration.settings.exempted == false)
        {
            access = true;
        }

        return access;
    }
    
    function utf8_encode(argString) 
    {
        if (argString === null || typeof argString === 'undefined') {
            return '';
        }
        
        var string = (argString + ''); // .replace(/\r\n/g, "\n").replace(/\r/g, "\n");
        var utftext = '',
        start, end, stringl = 0;
        
        start = end = 0;
        stringl = string.length;
        for (var n = 0; n < stringl; n++) {
            var c1 = string.charCodeAt(n);
            var enc = null;
            
            if (c1 < 128) {
                end++;
            } else if (c1 > 127 && c1 < 2048) {
                enc = String.fromCharCode(
                (c1 >> 6) | 192, (c1 & 63) | 128
                );
            } else if ((c1 & 0xF800) != 0xD800) {
                enc = String.fromCharCode(
                (c1 >> 12) | 224, ((c1 >> 6) & 63) | 128, (c1 & 63) | 128
                );
            } else { // surrogate pairs
                if ((c1 & 0xFC00) != 0xD800) {
                    throw new RangeError('Unmatched trail surrogate at ' + n);
                }
                var c2 = string.charCodeAt(++n);
                if ((c2 & 0xFC00) != 0xDC00) {
                    throw new RangeError('Unmatched lead surrogate at ' + (n - 1));
                }
                c1 = ((c1 & 0x3FF) << 10) + (c2 & 0x3FF) + 0x10000;
                enc = String.fromCharCode(
                (c1 >> 18) | 240, ((c1 >> 12) & 63) | 128, ((c1 >> 6) & 63) | 128, (c1 & 63) | 128
                );
            }
            if (enc !== null) {
                if (end > start) {
                    utftext += string.slice(start, end);
                }
                utftext += enc;
                start = end = n + 1;
            }
        }
        
        if (end > start) {
            utftext += string.slice(start, stringl);
        }
        
        return utftext;
    }
    
    function clear_app_data()
    {
        pageMessages.clearDataModel();
        pageFriends.clearDataModel();
        pageFavorites.clearDataModel();
        
        Qt.nemAPI.logout();
        
        _app.set_setting("configuration", "");
        _app.set_string_to_file("", "data/configuration.json");
        
        _app.set_string_to_file("", "data/current_user_id.txt");
        _app.set_string_to_file("", "data/current_access_token.txt");
        
        _app.command_headless("logout");
        _app.command_headless("parse_all_friends");
        
        loadConfiguration();
        
        Qt.mainSheet.open();
    }
    
    function setConfiguration()
    {
        var configuration = JSON.stringify(Qt.configuration);
        _app.set_setting("configuration", configuration);
        _app.set_string_to_file(configuration, "data/configuration.json");
    }
    
    function loadConfiguration()
    {
        Qt.configuration = null;
        
        var configuration = _app.get_setting("configuration", "");

        if(configuration != "")
        {
            Qt.configuration = JSON.parse(configuration);

            for(var i = 0; i < Qt.configuration.accounts.length; i++)
            {
                var account = Qt.configuration.accounts[i];

                if(account.active)
                {
                    setActiveUser(account);
                }
            }
        }
        else 
        {
            var settings           = new Object();
            settings.active_user   = null;
            settings.exempted      = false;
            settings.expired       = false;
            
            var json               = new Object();
            json.accounts          = new Array();
            json.settings          = settings;
            
            configuration = JSON.stringify(json);
            _app.set_setting("configuration", configuration);
            
            loadConfiguration();
        }
        
        firstLoaded = false;
        
        _app.set_string_to_file(configuration, "data/configuration.json");
        
        if(Qt.configuration.accounts.length > 0)
        {
            _app.set_setting("hub_account_name", Qt.configuration.settings.active_user.name);
            _app.set_string_to_file(Qt.configuration.settings.active_user.name, "data/hub_account_name.json")
        }
        else 
        {
            _app.set_setting("hub_account_name", "No Account");
            _app.set_string_to_file("No Account", "data/hub_account_name.json")
        }
    }
    
    function setActiveUser(user)
    {
        Qt.configuration.settings.active_user = user;

        var accounts = new Array();
        
        for(var i = 0; i < Qt.configuration.accounts.length; i++)
        {
            var account = Qt.configuration.accounts[i];
            
            if(account.id == user.id)
            {
                account.active = true;
                _app.flurrySetUserID(account.id);
            }
            else 
            {
                account.active = false;
            }
            
            accounts.push(account);
        }
        
        Qt.configuration.accounts = accounts;
        
        setConfiguration();
        
        _app.set_string_to_file(user.id, "data/current_user_id.txt");
        _app.set_string_to_file(user.access_token, "data/current_access_token.txt");
        
        _app._connected = false;
    }
    
    function removeAllOtherAccounts()
    {
        var newAccounts = new Array();
        
        for(var i = 0; i < Qt.configuration.accounts.length; i++)
        {
            var account = Qt.configuration.accounts[i];
            
            if(account.id == Qt.configuration.settings.active_user.id)
            {
                newAccounts.push(account);
                
                Qt.setActiveUser(account);
                
                Qt.nemAPI.logout();
                _app.command_headless("logout");
                //Qt.nemAPI.login(Qt.configuration.settings.active_user.access_token);
                
                _app.set_string_to_file(account.name, "data/hub_account_name.json");
                
                _app.command_headless("update_hub_account");
            }
        }

        pageMessages.clearDataModel();
        pageMessages.load(true);
        
        pageFriends.clearDataModel();
        pageFriends.load(true);
        
        Qt.configuration.accounts = newAccounts;
        
        setConfiguration();
        loadConfiguration();
    }
    
    function removeUser(user)
    {
        var newAccounts = new Array();
        
        for(var i = 0; i < Qt.configuration.accounts.length; i++)
        {
            var account = Qt.configuration.accounts[i];
            
            if(account.id != user.id)
            {
                newAccounts.push(account);
            }
        }
        
        if(newAccounts.length == 0)
        {
            Qt.toast.pop("No more accounts.")
            logout();
        }
        else 
        {
            if(user.active)
            {
                if(newAccounts.length > 0)
                {
                    Qt.setActiveUser(newAccounts[0]);
                    
                    Qt.nemAPI.logout();
                    _app.command_headless("logout");
//                    Qt.nemAPI.login(Qt.configuration.settings.active_user.access_token);
                    
                    _app.set_string_to_file(newAccounts[0].name, "data/hub_account_name.json");
                    
                    _app.command_headless("update_hub_account");
                }
            }
            
            pageMessages.clearDataModel();
            pageMessages.load(true);
            
            pageFriends.clearDataModel();
            pageFriends.load(true);
        }

        Qt.configuration.accounts = newAccounts;
        
        setConfiguration();
        loadConfiguration();
        
        if(newAccounts.length == 0)
        {
            clear_app_data();
        }
    }
    
    function re_configurate(user)
    {
        Qt.setActiveUser(user);
        Qt.setConfiguration();
        Qt.loadConfiguration();
    }

    function logout()
    {
        clearData();
        
        Qt.mainSheet.open();
    }
    
    function clearData()
    {
        _app.set_setting("configuration", "");
        _app.set_string_to_file("", "data/configuration.json");
        
        Qt.configuration = new Object();
    }
    
    function extendedSearch(data)
    {
        console.log("extendedSearch: " + data);
        
        var page              = Qt.searchPageComponent.createObject();
        var params            = new Object();
        params.hashtag        = data.replace("#", "");
        params.force_load     = true;
        params.search_only_page = true;
        page.load(params);
        Qt.navigationPane.push(page);
    }
    
    function openURI(data)
    {
        var starting_index = 9;
        var ending_index   = data.lastIndexOf("/") + 1;
        
        var new_data       = data.substring(starting_index, ending_index);
        
        var splitted_data   = new_data.split("/");
        var object         = splitted_data[1];
        var value          = splitted_data[2];
        
        if(object == "user")
        {
            var page              = Qt.profileComponent.createObject();
            var params            = new Object();
            params.id             = value;
            params.force_load     = true;
            page.load(params);
            Qt.navigationPane.push(page);
        }
        else if(object == "url")
        {
            Qt.invokeBrowser.open(value);
        }
        else if(object == "app")
        {
            var uri = "appworld://content/" + value + "/";
            
            invoker.invoke(uri);
        }
        else if(object == "vendor")
        {
            var uri = "appworld://vendor/" + value + "/";
            
            invoker.invoke(uri);
        }

        console.log("object: " + object);
        console.log("value: " + value);
    }
    
    function openBrowser(data)
    {
        console.log("openBrowser: " + data);
        
        var page = Qt.browserComponent.createObject();
        var params = new Object();
        params.url = data;
        page.load(params);
        Qt.navigationPane.push(page);
    }
    
    function openProfile(data)
    {
        console.log("openProfile: " + data);
    }
    
    function openHashtag(data)
    {
        console.log("openHashtag: " + data);

        extendedSearch(data);
    }
    
    function thumbnailed()
    {
        console.log("===================== THUMBNAILED =====================");
        
        _activeFrame.sync(Qt.active_frame_data);
    }
    
    function awaken()
    {
        console.log("===================== AWAKEN =====================");
    }
    
    function triggeredGestureAction()
    {
        if(Qt.quickPinchGestureAction == "lists")
        {
        
        }
        else if(Qt.quickPinchGestureAction == "hidebars")
        {
            _app.barsVisibility = !_app.barsVisibility;
        }
    }
    
    function load()
    {
        pageMessages.load(true);
        pageFriends.load(true);
        
        Qt.nemAPI.login(Qt.configuration.settings.active_user.access_token);
        _app.command_headless("check_login");
    }
    
    function handleError(response)
    {
        if(_app.contains(response, "{"))
        {
            var responseJSON = JSON.parse(response);
            
            if(responseJSON.message == "")
            {
                Qt.dialog.pop("Attention", "Error");
                _app.invoke_browser(responseJSON.checkpoint_url);
            }
            else
            {
                Qt.toast.pop(responseJSON.message + "\n\nIf you need help please open the About Page by swiping down from the very top of the screen and Contact our Support Email. Thank you.");
            }
        }
        else 
        {
            var message = "An unexpected error occured, please try again.";
            Qt.toast.pop(message + "\n\nIf you need help please open the About Page by swiping down from the very top of the screen and Contact our Support Email. Thank you.");
        }
    }

    function timeAgo(theDate) 
    {
        var msPerMinute     = 60 * 1000;
        var msPerHour       = msPerMinute * 60;
        var msPerDay        = msPerHour * 24;
        var msPerMonth      = msPerDay * 30;
        var msPerYear       = msPerDay * 365;
        
        var elapsed = new Date() - theDate;
        
        if (elapsed < msPerMinute) 
        {
            var num = Math.round(elapsed/1000);
            return num + 's';
        }
        
        else if (elapsed < msPerHour) 
        {
            var num = Math.round(elapsed/msPerMinute);
            return num + 'm';
        }
        
        else if (elapsed < msPerDay ) 
        {
            var num = Math.round(elapsed/msPerHour);
            return num + 'h';
        }
        
        else if (elapsed < msPerMonth) 
        {
            var num = Math.round(elapsed/msPerDay);
            return num + 'd';
        }
        
        else if (elapsed < msPerYear) 
        {
            var num = Math.round(elapsed/msPerMonth);
            return num + 'mth';
        }
        else 
        {
            var num = Math.round(elapsed/msPerYear);
            return num + 'yr';
        }
    }
    
    function timeAgoDetailed(theDate) 
    {
        var msPerMinute     = 60 * 1000;
        var msPerHour       = msPerMinute * 60;
        var msPerDay        = msPerHour * 24;
        var msPerMonth      = msPerDay * 30;
        var msPerYear       = msPerDay * 365;
        
        var elapsed = new Date() - theDate;
        
        if (elapsed < msPerMinute) 
        {
            var num = Math.round(elapsed/1000);
            return num + ' second ' + (num > 1 ? "s" : "") + ' ago';
        }
        
        else if (elapsed < msPerHour) 
        {
            var num = Math.round(elapsed/msPerMinute);
            return num + ' minute ' + (num > 1 ? "s" : "") + ' ago';
        }
        
        else if (elapsed < msPerDay ) 
        {
            var num = Math.round(elapsed/msPerHour);
            return num + ' hour ' + (num > 1 ? "s" : "") + ' ago';
        }
        
        else if (elapsed < msPerMonth) 
        {
            var num = Math.round(elapsed/msPerDay);
            return num + ' day ' + (num > 1 ? "s" : "") + ' ago';
        }
        
        else if (elapsed < msPerYear) 
        {
            var num = Math.round(elapsed/msPerMonth);
            return num + ' month ' + (num > 1 ? "s" : "") + ' ago';
        }
        else 
        {
            var num = Math.round(elapsed/msPerYear);
            return num + 'year ' + (num > 1 ? "s" : "") + ' ago';
        }
    }
    
    function baseName(path)
    {
        return path.replace(/.*\/|\.[^.]*$/g, '');
    }
    
    function arrayUnique(array) 
    {
        var a = array.concat();
        
        for(var i=0; i<a.length; ++i) 
        {
            for(var j=i+1; j<a.length; ++j) 
            {
                if(a[i] === a[j]) a.splice(j--, 1);
            }
        }
        
        return a;
    }
    
    function urlify(text)
    {
        text = escapeHTML(text);
        text = convertToRichText(text);
        
        return text;
    }
    
    function escapeHTML(text) 
    {
        var parsedText = "";
        
        parsedText =  text
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;");
        
        return parsedText;
    }
    
    function convertToRichText(text) 
    {
        var parsedText = "";
        
        parsedText = "<html><body>" + text + "</body></html>";
        
        return parsedText;
    }
    
    function urlifyLinks(text) 
    {
        text = text.replace("http", " http");
        return text.replace(/(https?:\/\/[^\s]+)/g, function(url)
        {
            return ' <a style="font-weight: 500; color:#00779e;" href="' + url + '"> ' + url + ' </a> ';
        });
    }
    
    function kFormatter(num) 
    {
        var ranges = 
        [{ divider: 1e18 , suffix: 'P' },
        { divider: 1e15 , suffix: 'E' },
        { divider: 1e12 , suffix: 'T' },
        { divider: 1e9 , suffix: 'G' },
        { divider: 1e6 , suffix: 'M' },
        { divider: 1e3 , suffix: 'k' }];
        
        for (var i = 0; i < ranges.length; i++) 
        {
            if (num >= ranges[i].divider) 
            {
                return (num / ranges[i].divider).toString() + ranges[i].suffix;
            }
        }
        
        return num;
    }

    function prepare(params)
    {
        var request                         = new Object();
        
        request.protocol                    = "https://";
        
        if(params.host != null)
        {
            request.host                    = params.host;
        }
        else 
        {
            request.host                    = "instagram.com";
        }
        
        request.api_version                 = "/api/v1/";
        request.method                      = params.method;
        request.endpoint                    = params.endpoint;
        request.full_url                    = request.protocol + request.host + request.api_version + request.endpoint;
        
        if(params.full_url != null)
        {
            request.full_url                    = params.full_url;
        }
        
        request.data                        = params.data;
        request.content_type                = params.content_type;
        request.username                    = params.username;
        request.file_name                   = params.file_name;
        request.fb_access_token             = params.fb_access_token;
        request.multipart_mode              = params.multipart_mode;
        
        if(request.username == "" || (!params.username) && Qt.configuration.settings.active_user != null)
        {
            request.username = Qt.configuration.settings.active_user.username;
        }
        
        if(request.user_agent == "" || (!params.user_agent) && Qt.configuration.settings.active_user != null)
        {
            request.user_agent = Qt.configuration.settings.active_user.user_agent;
        }

        return request;
    }
}