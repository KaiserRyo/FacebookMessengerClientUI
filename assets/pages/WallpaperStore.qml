import bb.cascades 1.0
import bb.system 1.0
import nemory.NemAPI 1.0
import nemory.WallpaperAPI 1.0
import bb.cascades.pickers 1.0

import "../pages"
import "../sheets"
import "../components"
import "../components/buttons"

Page 
{
    id: page
     

    function scrollReady()
    {
        if (_app._is_passport) 
        {
            listView.requestFocus()
        } 
    }
    
    property string tabAll      : "all"
    property string tabFree     : "free"
    property string tabPaid     : "paid"
    property string activeTab   : tabAll

    function load(params)
    {
        _app.flurryLogEvent("wallpaper_store_accessed");
        
        listView.startLoading("");
    }
    
    titleBar: CustomTitleBar 
    {
        id: titleBar
        label_title.text: "WALLPAPER STORE"
        image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"
        image_right.defaultImageSource: "asset:///media/images/instagram/nav_new.png"
        
        onLeftButtonClicked: 
        {
            Qt.navigationPane.pop();
        }
        
        onRightButtonClicked: 
        {
            unlockWallpaperPicker.open();
        }
        
        attachedObjects: FilePicker 
        {
            id: unlockWallpaperPicker
            viewMode: FilePickerViewMode.GridView
            type: FileType.Picture
            
            onFileSelected: 
            {
                var file = selectedFiles[0];
                
                if(_app.get_setting("purchased_wallpapers", "false") == "true" || Qt.configuration.settings.exempted == true || _app.is_beta() == true || Qt.trial_mode())
                {
                    if(_app.contains(file, "jpg") || _app.contains(file, "jpeg") || _app.contains(file, "png"))
                    {
                        _app._wallpaper = "file://" + file;
                        Qt.lastWallpaper = "file://" + file;
                        
                        _app.set_setting("wallpaper", "file://" + file);
                        _app.flurryLogEvent("set_custom_wallpaper");
                        
                        Qt.toast.pop("Custom Wallpaper has been set. :)");
                    }
                    else 
                    {
                        Qt.toast.pop("That file didn't look like an Image File. :(\n\nExtensions allowed: png, jpg, jpeg");
                    }
                }
                else 
                {
                    Qt.toast.pop("Set your own custom beautiful wallpapers! Unlock this feature now!");
                    Qt.unlockCustomWallpaper.open();
                }
            }
        }
    }

    Container 
    {
        id: main_container
        verticalAlignment: VerticalAlignment.Top
        horizontalAlignment: HorizontalAlignment.Fill
        
        layout: DockLayout {}
         
        Container 
        {
            id: content
            
            Container 
            {
                id: segments
                horizontalAlignment: HorizontalAlignment.Fill
                minHeight: 100
                property string tabAll : "tabAll";
                property string tabFree : "tabFree";
                property string tabPaid : "tabPaid";
                property string activeTab : tabAll;
                
                onActiveTabChanged: 
                {
                    if(activeTab == tabAll)
                    {
                       
                    }
                    else if(activeTab == tabFree)
                    {
                        
                    }
                    else if(activeTab == tabPaid)
                    {
                    
                    }
                }
                
                layout: StackLayout 
                {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                Container
                {
                    verticalAlignment: VerticalAlignment.Center
                    
                    Label 
                    {
                        text: "ALL"
                        horizontalAlignment: HorizontalAlignment.Center
                        textStyle.fontWeight: FontWeight.W500
                        textStyle.color: (segments.activeTab == segments.tabAll) ? Color.create(_app._color_scheme) : Color.DarkGray;
                    }
                    
                    layoutProperties: StackLayoutProperties 
                    {
                        spaceQuota: 1
                    }
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped: 
                        {
                            segments.activeTab = segments.tabAll;
                        }
                    }
                }
                
                Container
                {
                    verticalAlignment: VerticalAlignment.Center
                    
                    Label 
                    {
                        text: "FREE"
                        horizontalAlignment: HorizontalAlignment.Center
                        textStyle.fontWeight: FontWeight.W500
                        textStyle.color: (segments.activeTab == segments.tabFree) ? Color.create(_app._color_scheme) : Color.DarkGray;
                    }
                    
                    layoutProperties: StackLayoutProperties 
                    {
                        spaceQuota: 1
                    }
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped: 
                        {
                            segments.activeTab = segments.tabFree;
                        }
                    }
                }
                
                Container
                {
                    verticalAlignment: VerticalAlignment.Center
                    
                    Label 
                    {
                        text: "PAID"
                        horizontalAlignment: HorizontalAlignment.Center
                        textStyle.fontWeight: FontWeight.W500
                        textStyle.color: (segments.activeTab == segments.tabPaid) ? Color.create(_app._color_scheme) : Color.DarkGray;
                    }
                    
                    layoutProperties: StackLayoutProperties 
                    {
                        spaceQuota: 1
                    }
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped: 
                        {
                            segments.activeTab = segments.tabPaid;
                        }
                    }
                }
            } 
            
            Divider 
            {
                topMargin: 0
                bottomMargin: 0
            }

            PullToRefreshListView 
            {
                id: listView
                horizontalAlignment: HorizontalAlignment.Fill
                visible: (segments.activeTab == segments.tabAll)
                
                dataModel: ArrayDataModel 
                {
                    id: dataModel
                }
                
                onScrolledDown: 
                {
                    titleBar.fadeOut();
                }
                
                onScrolledUp: 
                {
                    titleBar.fadeIn();
                }
                
                listItemComponents: 
                [
                    ListItemComponent 
                    {
                        content: WallpaperItem 
                        {
                            id: root
                        }
                    }
                ]
                
                function navigationPanePush(page)
                {
                    navigationPane.push(page);
                }
                
                function refreshTriggered()
                {
                    startLoading("top");
                }
                
                function startLoading(loadTopBottom)
                {
                    listView.loadTopBottom = loadTopBottom;
                    wallpaperAPI.load(loadTopBottom);
                }
            }
            
            PullToRefreshListView 
            {
                id: listViewFree
                horizontalAlignment: HorizontalAlignment.Fill
                visible: (segments.activeTab == segments.tabFree)
                
                dataModel: ArrayDataModel 
                {
                    id: dataModelFree
                }
                
                listItemComponents: 
                [
                    ListItemComponent 
                    {
                        content: WallpaperItem 
                        {
                        
                        }
                    }
                ]
                
                onScrolledDown: 
                {
                    titleBar.fadeOut();
                }
                
                onScrolledUp: 
                {
                    titleBar.fadeIn();
                }
                
                function refreshTriggered()
                {
                    listView.startLoading("top");
                }
            }
            
            PullToRefreshListView 
            {
                id: listViewPaid
                horizontalAlignment: HorizontalAlignment.Fill
                visible: (segments.activeTab == segments.tabPaid)
                
                dataModel: ArrayDataModel 
                {
                    id: dataModelPaid
                }
                
                listItemComponents: 
                [
                    ListItemComponent 
                    {
                        content: WallpaperItem 
                        {
                            
                        }
                    }
                ]
                
                onScrolledDown: 
                {
                    titleBar.fadeOut();
                }
                
                onScrolledUp: 
                {
                    titleBar.fadeIn();
                }
                
                function refreshTriggered()
                {
                    listView.startLoading("top");
                }
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
        
        Container 
        {
            id: bottomContainer
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Fill
        }
    }
    
    attachedObjects: 
    [
        WallpaperAPI
        {
            id: wallpaperAPI
            
            function load(loadTopBottom)
            {
                if(!listView.refreshing && !listViewFree.refreshing && !listViewPaid.refreshing)
                {
                    listView.startRefreshing();
                    listViewFree.startRefreshing();
                    listViewPaid.startRefreshing();
                    
                    var params         = new Object();
                    params.endpoint    = "functions/wallpapers";
                    params.data        = JSON.stringify({ paid : false });
                    wallpaperAPI.post(params);
                }
            }
            
            onComplete: 
            {
                console.log("**** WALLPAPER STORE endpoint: " + endpoint + ", httpcode: " + httpcode + ", response: " + response);
                
                if(httpcode != 200 && httpcode != 201)
                {
                    _app.flurryLogError(httpcode + " - " + endpoint + " - " + response);
                    
                    _app.set_string_to_file(response, "data/wallpaper_store_error.json");
                    
                    if(endpoint == "functions/wallpapers")
                    {
                        listView.stopRefreshing();
                        listViewFree.stopRefreshing();
                        listViewPaid.stopRefreshing();
                    }
                }
                else 
                {
                    dataModel.clear();
                    dataModelFree.clear();
                    dataModelPaid.clear();
                    
                    var responseJSON = JSON.parse(response);

                    if(endpoint == "functions/wallpapers")
                    {
                        listView.stopRefreshing();
                        listViewFree.stopRefreshing();
                        listViewPaid.stopRefreshing();
                        
                        if(responseJSON.result.length > 0)
                        {
                            if(Qt.soundEffects)
                            {
                                Qt.mediaPlayer.loaded();
                            }
                            
                            if(Qt.ledIndicator)
                            {
                                Qt.led.lit();
                            }
                            
                            dataModel.insert(0, responseJSON.result);
                            
                            var free = new Array();
                            var paid = new Array();
                            
                            for(var i = 0; i < responseJSON.result.length; i++)
                            {
                                var item = responseJSON.result[i];
                                
                                if(!item.paid)
                                {
                                    free.push(item);
                                }
                                
                                if(item.paid)
                                {
                                    paid.push(item);
                                }
                            }
                            
                            dataModelFree.insert(0, free);
                            dataModelPaid.insert(0, paid);
                        }
                        
                        if(dataModel.size() == 0)
                        {
                            zeroResults.visible = true;
                        }
                        else 
                        {
                            zeroResults.visible = false;
                        }
                    }
                }
            }
        }
    ]

    shortcuts: 
    [
        SystemShortcut 
        {
            type: SystemShortcuts.JumpToBottom
            onTriggered: 
            {
                listView.scrollToPosition(ScrollPosition.End, ScrollAnimation.Smooth)
            }
        },
        SystemShortcut 
        {
            type: SystemShortcuts.JumpToTop
            onTriggered: 
            {
                listView.scrollToPosition(ScrollPosition.Beginning, ScrollAnimation.Smooth)
            }
        },
        SystemShortcut 
        {
            type: SystemShortcuts.Forward
            onTriggered: 
            {
               
            }
        },
        SystemShortcut 
        {
            type: SystemShortcuts.Reply
            
            onTriggered: 
            {
                listView.refreshTriggered();
            }
        }
    ]
}