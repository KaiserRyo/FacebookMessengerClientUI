import bb.cascades 1.0

Container 
{
    id: mainTabs
    
    property string activeTab : "tabMessages";
    property int height : 100 + ( _app.device() == "passport" ? 30 : 0)
    property alias tab_activity : tabOptions;
    property variant component_color: Color.create("#" + _app._color_scheme);

    horizontalAlignment: HorizontalAlignment.Center
    verticalAlignment: VerticalAlignment.Bottom

    function fadeIn()
    {
        mainTabs.resetOpacity();
        mainTabs.resetTranslationY();
    }
    
    function fadeOut()
    {
        mainTabs.opacity = 0.0;
        mainTabs.translationY += 150;
    }
    
    signal clicked(string tab);
    
    Divider 
    {
        bottomMargin: 0
        topMargin: 0
    }

    Container 
    {
        id: content
        minHeight: height
        maxHeight: height
        background: (_app._dark_theme ? Color.create("#000000") : Color.create("#FFFFFF"))
        
        layout: StackLayout 
        {
            orientation: LayoutOrientation.LeftToRight
        }
        
        Container 
        {
            id: tabMessages
            property bool active : (activeTab == "tabMessages")
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Fill
            //background: (tabMessages.active ? Color.Black : Color.Transparent)
            layout: DockLayout { }
            
            Container 
            {
                visible: tabMessages.active
                preferredHeight: 10 + (_app.device() == "passport" ? 5 : 0)
                background: component_color
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Fill
            }
            
            ImageView 
            {
                imageSource: "asset:///media/images/icons/tab_messages" + (tabMessages.active ? "_active.png" : ".png")
                preferredHeight: 65 + (_app.device() == "passport" ? 30 : 0)
                scalingMethod: ScalingMethod.AspectFit 
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 1
            }
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    Qt.tabbedPane.switchTab("tabMessages");
                    clicked("tabMessages");
                }
            }
        }
        
        Container 
        {
            id: tabFriends
            property bool active : (activeTab == "tabFriends")
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Fill
            //background: (tabFriends.active ? Color.Black : Color.Transparent)
            layout: DockLayout { }
            
            Container 
            {
                visible: tabFriends.active
                preferredHeight: 10 + (_app.device() == "passport" ? 5 : 0)
                background: component_color
                verticalAlignment: VerticalAlignment.Bottom  
                horizontalAlignment: HorizontalAlignment.Fill  
            }
            
            ImageView 
            {
                imageSource: "asset:///media/images/icons/tab_friends" + (tabFriends.active ? "_active.png" : ".png")
                preferredHeight: 65 + (_app.device() == "passport" ? 30 : 0)
                scalingMethod: ScalingMethod.AspectFit 
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 1
            }
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    Qt.tabbedPane.switchTab("tabFriends");
                    clicked("tabFriends");
                }
            }
        }
        
        Container 
        {
            id: tabFavorites
            property bool active : (activeTab == "tabFavorites")
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Fill
            //background: (tabFavorites.active ? Color.Black : Color.Transparent)
            layout: DockLayout { }
            
            Container 
            {
                visible: tabFavorites.active
                preferredHeight: 10 + (_app.device() == "passport" ? 5 : 0)
                background: component_color
                verticalAlignment: VerticalAlignment.Bottom  
                horizontalAlignment: HorizontalAlignment.Fill  
            }
            
            ImageView
            {
                imageSource: "asset:///media/images/icons/tab_favorites" + (tabFavorites.active ? "_active.png" : ".png")
                preferredHeight: 65 + (_app.device() == "passport" ? 30 : 0)
                scalingMethod: ScalingMethod.AspectFit
                horizontalAlignment: HorizontalAlignment.Center 
                verticalAlignment: VerticalAlignment.Center
            }
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 1
            }
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    Qt.tabbedPane.switchTab("tabFavorites");
                    clicked("tabFavorites");
                }
            }
        }
        
        Container 
        {
            id: tabOptions
            property bool active : (activeTab == "tabOptions")
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Fill
            //background: (tabOptions.active ? Color.Black : Color.Transparent)
            layout: DockLayout { }
            
            Container 
            {
                visible: tabOptions.active
                preferredHeight: 10 + (_app.device() == "passport" ? 5 : 0)
                background: component_color
                verticalAlignment: VerticalAlignment.Bottom  
                horizontalAlignment: HorizontalAlignment.Fill  
            }
            
            ImageView 
            {
                imageSource: "asset:///media/images/icons/tab_options" + (tabOptions.active ? "_active.png" : ".png")
                preferredHeight: 65 + (_app.device() == "passport" ? 30 : 0)
                scalingMethod: ScalingMethod.AspectFit 
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }

            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 1
            }
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    Qt.tabbedPane.switchTab("tabOptions");
                    clicked("tabOptions");
                }
            }
        }
        
        Container 
        {
            id: tabProfile
            property bool active : (activeTab == "tabProfile")
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Fill
            //background: (active ? Color.Black : Color.Transparent)
            layout: DockLayout { }
            
            Container 
            {
                visible: tabProfile.active
                preferredHeight: 10 + (_app.device() == "passport" ? 5 : 0)
                background: component_color
                verticalAlignment: VerticalAlignment.Bottom  
                horizontalAlignment: HorizontalAlignment.Fill  
            }
            
            ImageView 
            {
                imageSource: "asset:///media/images/icons/tab_profile" + (tabProfile.active ? "_active.png" : ".png")
                preferredHeight: 65 + (_app.device() == "passport" ? 30 : 0)
                scalingMethod: ScalingMethod.AspectFit 
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 1
            }
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    _app._notification_badge   = false;
                    _app._notification_tooltip = false;
                    
                    Qt.tabbedPane.switchTab("tabProfile");
                    clicked("tabProfile");
                }
            }
        }    
    }
}