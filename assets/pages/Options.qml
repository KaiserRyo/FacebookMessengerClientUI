import bb.cascades 1.0
import nemory.NemAPI 1.0
import nemory.WebImageView 1.0

import "../components"
import "../dialogs"
import "../sheets"
import bb.system 1.0

NavigationPane 
{
    id: navigationPane
    
    property bool firstStart     : true;
    
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
        
        firstStart = false;
    }
    
    function tabDeactivated()
    {
    
    }
    
    function scrollReady()
    {
        if (_app._is_passport) 
        {
            scrollView.requestFocus();
        }
    }
    
    function load()
    {
       
    }

    Page 
    {
        id: the_page
        
        titleBar: CustomTitleBar 
        {
            id: titleBar
            label_title.text: "OPTIONS";
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

                ScrollView 
                {
                    id: scrollView
                    
                    Container 
                    {
                        horizontalAlignment: HorizontalAlignment.Fill
                        leftPadding: 30
                        rightPadding: 30
                        topPadding: 30
                        bottomPadding: 150
                        
                        Container 
                        {
                            horizontalAlignment: HorizontalAlignment.Fill
                            
                            layout: StackLayout 
                            {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            
                            Container 
                            {
                                preferredWidth: (_app._is_passport ? 100 : 40)
                                minHeight: (_app._is_passport ? 100 : 40)
                                minWidth: (_app._is_passport ? 100 : 40)
                                verticalAlignment: VerticalAlignment.Center
                                
                                ImageView 
                                {
                                    imageSource: "asset:///media/images/icons/painter.png"
                                    preferredWidth: (_app._is_passport ? 100 : 40)
                                    minHeight: (_app._is_passport ? 100 : 40)
                                    minWidth: (_app._is_passport ? 100 : 40)
                                    scalingMethod: ScalingMethod.AspectFit
                                    verticalAlignment: VerticalAlignment.Center
                                }
                            }
                            
                            DropDown 
                            {
                                id: colorScheme
                                title: "Color Scheme"
                                preferredWidth: (_app._is_passport ? 1200 : 600)
                                maxWidth: (_app._is_passport ? 1200 : 600)
                                
                                onSelectedValueChanged: 
                                {
                                    if(Qt.has_pro_access())
                                    {
                                        _app.set_setting("color_scheme", selectedValue);
                                        _app._color_scheme = selectedValue;
                                        Qt.color_scheme = _app._color_scheme;
                                    }
                                    else 
                                    {
                                        Qt.dialog.pop("Pro Upgrade Required", "Switching Color Schemes Feature is only available to PRO Users. Upgrade now and access all the great features.");
                                        Qt.proSheet.open();
                                    }
                                }
                                
                                options: 
                                [
                                    Option 
                                    {
                                        text: "Original"
                                        value: colorInstagram
                                        imageSource: "asset:///components/buttons/ButtonInstagramSolid.png"
                                    },
                                    Option 
                                    {
                                        text: "Magenta"
                                        value: colorMagenta
                                        imageSource: "asset:///components/buttons/ButtonMagentaSolid.png"
                                    },
                                    Option 
                                    {
                                        text: "Blue"
                                        value: colorBlue
                                        imageSource: "asset:///components/buttons/ButtonBlueSolid.png"
                                    },
                                    Option 
                                    {
                                        text: "Black"
                                        value: colorBlack
                                        imageSource: "asset:///components/buttons/ButtonBlackSolid.png"
                                    },
                                    Option 
                                    {
                                        text: "Orange"
                                        value: colorOrange
                                        imageSource: "asset:///components/buttons/ButtonOrangeSolid.png"
                                    },
                                    Option 
                                    {
                                        text: "Purple"
                                        value: colorPurple
                                        imageSource: "asset:///components/buttons/ButtonPurpleSolid.png"
                                    },
                                    Option 
                                    {
                                        text: "Red"
                                        value: colorRed
                                        imageSource: "asset:///components/buttons/ButtonRedSolid.png"
                                    },
                                    Option 
                                    {
                                        text: "Teal"
                                        value: colorTeal
                                        imageSource: "asset:///components/buttons/ButtonTealSolid.png"
                                    },
                                    Option 
                                    {
                                        text: "Green"
                                        value: colorGreen
                                        imageSource: "asset:///components/buttons/ButtonGreenSolid.png"
                                    }
                                ]
                            }
                        }
                        
                        Divider {}
                        
                        Container 
                        {
                            horizontalAlignment: HorizontalAlignment.Fill
                            
                            layout: StackLayout 
                            {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            
                            ImageView 
                            {
                                imageSource: "asset:///media/images/icons/speaker.png"
                                minHeight: (_app._is_passport ? 100 : 40)
                                minWidth: (_app._is_passport ? 100 : 40)
                                scalingMethod: ScalingMethod.AspectFit
                                horizontalAlignment: HorizontalAlignment.Left
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            Container 
                            {
                                horizontalAlignment: HorizontalAlignment.Fill
                                translationX: 10
                                rightPadding: 20
                                minWidth: (_app._is_passport ? 1250 : 630)
                                layout: DockLayout {} 
                                
                                Label 
                                {
                                    text: "Sound Effects"
                                    verticalAlignment: VerticalAlignment.Center
                                    horizontalAlignment: HorizontalAlignment.Left
                                }
                                
                                ToggleButton 
                                {
                                    horizontalAlignment: HorizontalAlignment.Right
                                    checked: (_app.get_setting("sound_effects", "true") == "true" ? true : false)
                                    property bool initialChecked : checked;
                                    
                                    onCheckedChanged: 
                                    {
                                        _app.set_setting("sound_effects", checked)
                                    }
                                }
                            }
                        }
                        
                        Divider {}
                        
                        Container 
                        {
                            horizontalAlignment: HorizontalAlignment.Fill
                            
                            layout: StackLayout 
                            {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            
                            ImageView 
                            {
                                imageSource: "asset:///media/images/icons/enter_key.png"
                                minHeight: (_app._is_passport ? 100 : 40)
                                minWidth: (_app._is_passport ? 100 : 40)
                                scalingMethod: ScalingMethod.AspectFit
                                horizontalAlignment: HorizontalAlignment.Left
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            Container 
                            {
                                horizontalAlignment: HorizontalAlignment.Fill
                                translationX: 10
                                rightPadding: 20
                                minWidth: (_app._is_passport ? 1250 : 630)
                                layout: DockLayout {} 
                                
                                Label 
                                {
                                    text: "Enter Key to Send"
                                    verticalAlignment: VerticalAlignment.Center
                                    horizontalAlignment: HorizontalAlignment.Left
                                }
                                
                                ToggleButton 
                                {
                                    horizontalAlignment: HorizontalAlignment.Right
                                    checked: (_app.get_setting("enter_key_to_send", "true") == "true" ? true : false)
                                    property bool initialChecked : checked;
                                    
                                    onCheckedChanged: 
                                    {
                                        _app.set_setting("enter_key_to_send", checked)
                                    }
                                }
                            }
                        }
                        
                        Divider {}
                        
//                        Container 
//                        {
//                            horizontalAlignment: HorizontalAlignment.Fill
//                            
//                            layout: StackLayout 
//                            {
//                                orientation: LayoutOrientation.LeftToRight
//                            }
//                            
//                            ImageView 
//                            {
//                                imageSource: "asset:///media/images/icons/notification.png"
//                                minHeight: (_app._is_passport ? 100 : 40)
//                                minWidth: (_app._is_passport ? 100 : 40)
//                                scalingMethod: ScalingMethod.AspectFit
//                                verticalAlignment: VerticalAlignment.Center
//                            }
//                            
//                            Container 
//                            {
//                                horizontalAlignment: HorizontalAlignment.Fill
//                                translationX: 10
//                                rightPadding: 20
//                                minWidth: (_app._is_passport ? 1250 : 630)
//                                layout: DockLayout {} 
//
//                                Label 
//                                {
//                                    text: "Hub Notifications"
//                                    verticalAlignment: VerticalAlignment.Center
//                                }
//                                
//                                ToggleButton 
//                                {
//                                    id: notificationsToggle
//                                    horizontalAlignment: HorizontalAlignment.Right
//                                    checked: (_app.get_setting("notifications", "true") == "true" ? true : false)
//                                    property bool initialChecked : checked;
//                                    
//                                    onCheckedChanged: 
//                                    {
//                                        _app.set_setting("notifications", checked);
//                                        _app.set_string_to_file(checked, "data/notifications.json");
//                                    }
//                                }
//                            }
//                        }
//                        
//                        
//                        Label 
//                        {
//                            visible: notificationsToggle.checked
//                            text: "This will turn on/off all kinds of notifications"
//                            textStyle.fontSize: FontSize.XSmall
//                            textStyle.color: Color.Gray
//                            textStyle.fontStyle: FontStyle.Italic
//                        }
//                        
//                        Container 
//                        {
//                            visible: notificationsToggle.checked
//                            
//                            Divider {}
//                            
//                            DropDown 
//                            {
//                                id: notificationsTimer
//                                title: "Notifications Refresh Interval"
//                                
//                                onSelectedValueChanged: 
//                                {
//                                    if(!firstStart)
//                                    {
//                                        _app.set_setting("headless_refresh_timer", selectedValue);
//                                        
//                                        Qt.dialog.pop("Attention", "Changing this value will require you to Restart your Phone or close both the app and the running Headless via Settings > Data Monitor then opening the App again to re run the headless.");
//                                    }
//                                }
//                                
//                                options: 
//                                [
//                                    Option 
//                                    {
//                                        text: "10 Seconds Interval"
//                                        value: "10000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "20 Seconds Interval"
//                                        value: "20000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "30 Seconds Interval"
//                                        value: "30000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "40 Seconds Interval"
//                                        value: "40000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "50 Seconds Interval"
//                                        value: "50000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "1 Minute Interval"
//                                        value: "60000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "2 Minutes Interval"
//                                        value: "120000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "3 Minutes Interval"
//                                        value: "180000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "4 Minutes Interval"
//                                        value: "240000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "5 Minutes Interval"
//                                        value: "300000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "10 Minutes Interval"
//                                        value: "600000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "20 Minutes Interval"
//                                        value: "1200000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "30 Minutes Interval"
//                                        value: "1800000"
//                                    },
//                                    Option 
//                                    {
//                                        text: "1 Hour Interval"
//                                        value: "3600000"
//                                    }
//                                ]
//                            }
//                            
//                            Label 
//                            {
//                                text: "The lesser time : the more battery usage"
//                                textStyle.fontSize: FontSize.XSmall
//                                textStyle.color: Color.Gray
//                                textStyle.fontStyle: FontStyle.Italic
//                            }
//                            
//                            Divider {}
//                            
//                            Container 
//                            {
//                                horizontalAlignment: HorizontalAlignment.Fill
//                                layout: DockLayout {} 
//                                
//                                Label 
//                                {
//                                    text: "Hub Integrated Notifications"
//                                    verticalAlignment: VerticalAlignment.Center
//                                }
//                                
//                                ToggleButton 
//                                {
//                                    id: hubIntegratedToggle
//                                    horizontalAlignment: HorizontalAlignment.Right
//                                    checked: (_app.get_setting("hub_integration", "true") == "true" ? true : false)
//                                    property bool initialChecked : checked;
//                                    
//                                    onCheckedChanged: 
//                                    {
//                                        if(!_app.contains(_app.os_version(), "10.3.0"))
//                                        {
//                                            _app.set_setting("hub_integration", checked);
//                                            _app.set_string_to_file(checked, "data/hub_integration.json");
//                                        }
//                                        else 
//                                        {
//                                            var message = "I am very sorry, but Hub Integrated Notifications will not work really well if your OS Version is 10.3.0. \n\nIf you really want to get Hub Integrated Notifications please update your OS to 10.3.1.\n\nOpen your Phone's Settings Icon, go to Software Updates, then click Check for Updates. \n\nIf you don't get any updates, I'm sorry but you may have to wait for it.";
//                                            Qt.dialog.pop("Attention", message);
//                                        }
//                                    }
//                                }
//                            }
//                            
//                            Label 
//                            {
//                                visible: hubIntegratedToggle.checked
//                                text: "When this is off and notifications is still on, you'll get regular notifications. When both are on, you'll get hub integrated notifications"
//                                multiline: true
//                                textStyle.fontSize: FontSize.XSmall
//                                textStyle.color: Color.Gray
//                                textStyle.fontStyle: FontStyle.Italic
//                            }
//                        }
//                        
//                        Divider {}
                        
                        Container 
                        {
                            horizontalAlignment: HorizontalAlignment.Fill
                            
                            layout: StackLayout 
                            {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            
                            ImageView 
                            {
                                imageSource: "asset:///media/images/icons/wallpapers.png"
                                minHeight: (_app._is_passport ? 100 : 40)
                                minWidth: (_app._is_passport ? 100 : 40)
                                scalingMethod: ScalingMethod.AspectFit
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            Label 
                            {
                                text: "Set Wallpaper"
                                textStyle.fontWeight: FontWeight.W400
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            gestureHandlers: TapHandler 
                            {
                                onTapped:
                                {
                                    var page = Qt.wallpaperStoreComponent.createObject();
                                    var params = new Object();
                                    page.load(params);
                                    Qt.navigationPane.push(page);
                                }
                            }
                        }
                        
                        Divider {}
                        
                        Container 
                        {
                            visible: (_app._wallpaper.length > 0)
                            horizontalAlignment: HorizontalAlignment.Fill
                            
                            layout: StackLayout 
                            {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            
                            ImageView 
                            {
                                imageSource: "asset:///media/images/icons/x_red.png"
                                minHeight: (_app._is_passport ? 100 : 40)
                                minWidth: (_app._is_passport ? 100 : 40)
                                scalingMethod: ScalingMethod.AspectFit
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            Label 
                            {
                                text: "Remove Wallpaper"
                                textStyle.fontWeight: FontWeight.W400
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            gestureHandlers: TapHandler 
                            {
                                onTapped:
                                {
                                    Qt.toast.pop("Removed Wallpaper. :)");
                                    
                                    Qt.app._wallpaper   = "";
                                    _app._wallpaper     = "";
                                    
                                    Qt.app.set_setting("wallpaper", "");
                                }
                            }
                        }
                        
                        Divider 
                        {
                            visible: (_app._wallpaper.length > 0)
                        }
                        
                        Container 
                        {
                            horizontalAlignment: HorizontalAlignment.Fill
                            
                            layout: StackLayout 
                            {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            
                            ImageView 
                            {
                                imageSource: "asset:///media/images/icons/help.png"
                                minHeight: (_app._is_passport ? 100 : 40)
                                minWidth: (_app._is_passport ? 100 : 40)
                                scalingMethod: ScalingMethod.AspectFit
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            Label 
                            {
                                text: "Help / Tutorial"
                                textStyle.fontWeight: FontWeight.W400
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            gestureHandlers: TapHandler 
                            {
                                onTapped:
                                {
                                    Qt.tutorialSheet.open();
                                }
                            }
                        }
                        
                        Divider {}
                        
                        Container 
                        {
                            horizontalAlignment: HorizontalAlignment.Fill
                            
                            layout: StackLayout 
                            {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            
                            ImageView 
                            {
                                imageSource: "asset:///media/images/icons/report.png"
                                minHeight: (_app._is_passport ? 100 : 40)
                                minWidth: (_app._is_passport ? 100 : 40)
                                scalingMethod: ScalingMethod.AspectFit
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            Label 
                            {
                                text: "Report a problem"
                                textStyle.fontWeight: FontWeight.W400
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            gestureHandlers: TapHandler 
                            {
                                onTapped:
                                {
                                    contactFaqsDialog.show();
                                }
                            }
                            
                            attachedObjects: 
                            [
                                SystemDialog 
                                {
                                    id: contactFaqsDialog
                                    title: "Attention"
                                    body: "Would you like to view the FAQs Page first for commonly asked questions before contacting our support?"
                                    cancelButton.label: "Contact"
                                    confirmButton.label: "View FAQs"
                                    onFinished: 
                                    {
                                        if(buttonSelection().label == "View FAQs")
                                        {
                                            Qt.invokeBrowser.open("http://goo.gl/4bLXZ8");
                                            
                                            Qt.app.flurryLogEvent("faqs_opened");
                                        }
                                        else 
                                        {
                                            Qt.invokeEmail.query.uri = "mailto:nemorystudios@gmail.com?subject=Support: Messenger&body=\n\nApp_v: " + _app.app_version() + "\nOS_v: " + _app.os_version() + "\nDevice: " + _app.device() + "\nExempted: " +  _app.get_setting("exempted", "false") + "\nTrial: " + Qt.trial_mode() + "\nUser ID: " + Qt.configuration.settings.active_user.id;
                                            Qt.invokeEmail.query.updateQuery();
                                            
                                            Qt.app.flurryLogEvent("contact_support");
                                        }
                                        
                                        cancel();
                                    }
                                }
                            ]
                        }
                        
                        Divider {}
                        
                        Container 
                        {
                            horizontalAlignment: HorizontalAlignment.Fill
                            
                            layout: StackLayout 
                            {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            
                            ImageView 
                            {
                                imageSource: "asset:///media/images/icons/settings.png"
                                minHeight: (_app._is_passport ? 100 : 40)
                                minWidth: (_app._is_passport ? 100 : 40)
                                scalingMethod: ScalingMethod.AspectFit
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            Label 
                            {
                                text: "Advanced Settings"
                                textStyle.fontWeight: FontWeight.W400
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            gestureHandlers: TapHandler 
                            {
                                onTapped:
                                {
                                    var page = Qt.settingsComponent.createObject();
                                    var params = new Object();
                                    page.load(params);
                                    Qt.navigationPane.push(page);
                                }
                            }
                        }
                    }
                }
            }
            
            MainTabs 
            {
                id: mainTabs
                activeTab: "tabOptions"
                
                onClicked: 
                {
                    if(tab == activeTab)
                    {
                        
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
        }
    }
    
    property string colorInstagram       : "#2b5a83";
    property string colorMagenta         : "#ba4780";
    property string colorBlue            : "#4171a7";
    property string colorBlack           : "#222222";
    property string colorOrange          : "#bb6735";
    property string colorPurple          : "#825190";
    property string colorRed             : "#b93841";
    property string colorTeal            : "#29777a";
    property string colorGreen           : "#5c874a";
}