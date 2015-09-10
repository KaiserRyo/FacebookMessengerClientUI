import bb.cascades 1.0
import nemory.NemAPI 1.0
import nemory.WebImageView 1.0
import bb.cascades.maps 1.0
import bb.system 1.0

import "../components"

Page 
{
    id: page

    property bool firstStart     : true;

    function load(params)
    {
        firstStart = false;
    }
    
    function scrollReady()
    {
        if (_app._is_passport) 
        {
            scrollView.requestFocus();
        }
        
        btnClearCache.title = "Clear Cache (" + humanFileSize(_app.get_cache_size()) + ")";
    }
    
    titleBar: CustomTitleBar 
    {
        id: titleBar
        label_title.text: "ADVANCED SETTINGS"
        image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"
        
        onLeftButtonClicked: 
        {
            Qt.navigationPane.pop();
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
        
        ScrollView 
        {
            id: scrollView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            Container 
            {
                id: content
                topPadding: 20
                leftPadding: 20
                rightPadding: 20
                bottomPadding: 100
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill

                Container 
                {    
                    topPadding: 20
                    bottomPadding: 20
                    
                    Header 
                    {
                        title: "GENERAL"
                    }
                }
                
                Container 
                {
                    horizontalAlignment: HorizontalAlignment.Fill
                    layout: DockLayout {} 
                    
                    Label 
                    {
                        text: "Dark Theme"
                        verticalAlignment: VerticalAlignment.Center
                    }
                    
                    ToggleButton 
                    {
                        horizontalAlignment: HorizontalAlignment.Right
                        checked: (_app.get_setting("application_theme", "bright") == "dark" ? true : false)
                        property bool initialChecked : checked;
                        
                        onCheckedChanged: 
                        {
                            if(!firstStart)
                            {
                                if(Qt.has_pro_access())
                                {
                                    _app.set_setting("application_theme", (checked ? "dark" : "bright"));
                                    
                                    _app._dark_theme = checked;
                                    
                                    if(!checked)
                                    {
                                        Qt.app._wallpaper = "";
                                        _app._wallpaper = "";

                                        Qt.app.set_setting("wallpaper", "");
                                    }
                                    
                                    Qt.restartDialog.show();
                                }
                                else 
                                {
                                    Qt.dialog.pop("Pro Upgrade Required", "Switching to Dark Theme is only available to PRO Users. Upgrade now and access all the great features.");
                                    Qt.proSheet.open();
                                }
                            }
                        }
                    }
                }
                
                Divider {}
                
                Container 
                {
                    horizontalAlignment: HorizontalAlignment.Fill
                    layout: DockLayout {} 
                    
                    Label 
                    {
                        text: "Open links in App Browser"
                        verticalAlignment: VerticalAlignment.Center
                    }
                    
                    ToggleButton 
                    {
                        horizontalAlignment: HorizontalAlignment.Right
                        checked: (_app.get_setting("in_app_browser", "true") == "true" ? true : false)
                        property bool initialChecked : checked;
                        
                        onCheckedChanged: 
                        {
                            if(!firstStart)
                            {
                                _app.set_setting("in_app_browser", checked);
                            }
                        }
                    }
                }
                
                NemAdvertisement 
                {
                    id: ads
                }

                Divider {}
                
                Container 
                {
                    horizontalAlignment: HorizontalAlignment.Fill
                    layout: DockLayout {} 
                    
                    Label 
                    {
                        text: "Auto Hide Bars when Scrolling"
                        verticalAlignment: VerticalAlignment.Center
                    }
                    
                    ToggleButton 
                    {
                        id: autoHideBarsToggle
                        horizontalAlignment: HorizontalAlignment.Right
                        checked: (_app.get_setting("auto_hide_bars", "true") == "true" ? true : false)
                        property bool initialChecked : checked;
                        
                        onCheckedChanged: 
                        {
                            if(!firstStart)
                            {
                                _app.set_setting("auto_hide_bars", checked);
                            }
                        }
                    }
                }
                
                Label 
                {
                    visible: autoHideBarsToggle.checked
                    text: "Note: this will only affect Touch Scrolling. No Keyboard Scrolling unfortunately."
                    multiline: true
                    textStyle.fontSize: FontSize.XSmall
                    textStyle.color: Color.Gray
                    textStyle.fontStyle: FontStyle.Italic
                }
                
                Divider {}
                
                Container 
                {
                    horizontalAlignment: HorizontalAlignment.Fill
                    layout: DockLayout {} 
                    
                    Label 
                    {
                        text: "Leading Edge Scrolling"
                        verticalAlignment: VerticalAlignment.Center
                    }
                    
                    ToggleButton 
                    {
                        id: leadingEdgeScrollingToggle
                        horizontalAlignment: HorizontalAlignment.Right
                        checked: (_app.get_setting("leading_edge_scrolling", "false") == "true" ? true : false)
                        property bool initialChecked : checked;
                        
                        onCheckedChanged: 
                        {
                            if(!firstStart)
                            {
                                _app.set_setting("leading_edge_scrolling", checked);
                                
                                Qt.restartDialog.show();
                            }
                        }
                    }
                }
                
                Divider {}

                Container 
                {
                    horizontalAlignment: HorizontalAlignment.Fill
                    layout: DockLayout {} 
                    
                    Label 
                    {
                        text: "App Security Lock Layer"
                        verticalAlignment: VerticalAlignment.Center
                    }
                    
                    ToggleButton 
                    {
                        id: securityLayerToggle
                        horizontalAlignment: HorizontalAlignment.Right
                        checked: (_app.get_setting("securityEnabled", "false") == "true" ? true : false)
                        property bool initialChecked : checked;
                        
                        onCheckedChanged: 
                        {
                            if(!firstStart)
                            {
                                if(checked)
                                {
                                    securityPrompt.show();
                                }
                                else 
                                {
                                    _app.set_setting("securityEnabled", false);
                                }
                            }
                        }
                        
                        attachedObjects: 
                        [
                            SystemPrompt
                            {
                                id: securityPrompt
                                title: "Set App Security Password"
                                body: "Please don't forget your password. If ever you forget it. Please don't hesitate to contact us: nemorystudios@gmail.com"
                                
                                onFinished: 
                                {
                                    var input = inputFieldTextEntry();
                                    
                                    if(input.length > 0 && !_app.contains(input, " "))
                                    {
                                        if(Qt.has_pro_access())
                                        {
                                            _app.set_setting("securityEnabled", true);
                                            _app.set_setting("securityPassword", input);
                                            
                                            Qt.toast.pop("App Security Lock Password has been set! Please don't forget it: " + input);
                                        }
                                        else 
                                        {
                                            Qt.dialog.pop("Pro Upgrade Required", "Security Layer Password Feature is only available to PRO Users. Upgrade now and access all the great features.");
                                            Qt.proSheet.open();
                                        }
                                    }
                                    else 
                                    {
                                        securityLayerToggle.checked = false;
                                        
                                        Qt.dialog.pop("Error", "Please remove white spaces. This doesn't make your password secure and can make you forget.");
                                    }
                                }
                            }
                        ]
                    }
                }
                
                Label 
                {
                    visible: securityLayerToggle.checked
                    text: "This will ask you your password everytime you open the app or open from the Hub. Make sure not to forget your password."
                    multiline: true
                    textStyle.fontSize: FontSize.XSmall
                    textStyle.color: Color.Gray
                    textStyle.fontStyle: FontStyle.Italic
                }
                
                Divider {}

                Button 
                {
                    visible: (!Qt.has_pro_access())
                    text: "Upgrade to PRO now"
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    onClicked: 
                    {
                        Qt.proSheet.open();
                    }
                }
            }
        }
    }
    
    actions: 
    [
        ActionItem 
        {
            title: "Wallpaper Store"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///media/images/icons/shopping_white.png"
            
            onTriggered:
            {
                var page = Qt.wallpaperStoreComponent.createObject();
                var params = new Object();
                page.load(params);
                Qt.navigationPane.push(page);
            }
        },
        ActionItem 
        {
            title: "Remove Wallpaper"
            imageSource: "asset:///media/images/instagram/nav_cancel.png"

            onTriggered:
            {
                Qt.toast.pop("Removed Wallpaper. :)");
                
                Qt.app._wallpaper   = "";
                _app._wallpaper     = "";
                
                Qt.app.set_setting("wallpaper", "");
            }
        },
        ActionItem 
        {
            title: "Manage Permissions"
            imageSource: "asset:///media/images/icons/customize.png"
            
            onTriggered:
            {
                Qt.invokePermissions.trigger("bb.action.OPEN");
            }
        },
        ActionItem 
        {
            title: "Data Monitor"
            imageSource: "asset:///media/images/icons/customize.png"
            
            onTriggered:
            {
                invokeDataMonitor.trigger("bb.action.OPEN");
            }
            
            attachedObjects:
            [
                Invocation 
                {
                    id: invokeDataMonitor
                    query.mimeType: "*"
                    query.uri: "devicemonitor://memory"
                    query.invokeTargetId: "sys.SysMon.app"
                    
                    onFinished: 
                    {
                        _app.flurryLogEvent("manage_permissions");
                    }
                }
            ]
        },
        DeleteActionItem 
        {
            id: btnClearCache
            title: "Clear Cache"
            imageSource: "asset:///media/images/icons/x.png"

            onTriggered:
            {
                Qt.toast.pop("We're clearing your cache....");
                
                Qt.app.wipeFolderContents(_app.getHomePath() + "/Cache/wallpapers/");
                Qt.app.wipeFolderContents(_app.getHomePath() + "/Cache/images/");
                
                btnClearCache.title = "Clear Cache (" + humanFileSize(_app.get_cache_size()) + ")";
                
                Qt.toast.pop("Successfully Cleared Cache :)");
            }
        }
    ]

    function humanFileSize(bytes) 
    {
        var thresh = 1024;
        
        if(bytes < thresh) return bytes + ' B';
        
        var units = thresh ? ['kB','MB','GB','TB','PB','EB','ZB','YB'] : ['KiB','MiB','GiB','TiB','PiB','EiB','ZiB','YiB'];
        
        var u = -1;
        
        do 
        {
            bytes /= thresh;
            ++u;
        } 
        while(bytes >= thresh);
        
        return bytes.toFixed(1)+' '+units[u];
    }
}