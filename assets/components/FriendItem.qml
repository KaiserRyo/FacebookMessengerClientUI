import bb.cascades 1.2
import nemory.WebImageView 1.0

CustomListItem 
{
    preferredHeight: 150
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    dividerVisible: false
    
    Container
    {
        id: mainContainer
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        layout: DockLayout {}
        leftPadding: 20
        rightPadding: leftPadding
        topPadding: leftPadding
        bottomPadding: 60
        
        Container
        {
            horizontalAlignment: HorizontalAlignment.Left
            
            layout: StackLayout
            {
                orientation: LayoutOrientation.LeftToRight
            }
            
            Container 
            {
                id: profilePhotoContainer
                layout: DockLayout {}
                minWidth: 120
                minHeight: minWidth
                maxWidth: minWidth
                maxHeight: minWidth
                
                layoutProperties: StackLayoutProperties 
                {
                    spaceQuota: 1
                }
                
                WebImageView 
                {
                    url: "http://graph.facebook.com/" + ListItemData.uid + "/picture/120_" + ListItemData.uid + ".png?width=120&height=120"
                    defaultImage: "asset:///media/images/icons/profileThumbnail.png"
                    preferredHeight: 120
                    preferredWidth: preferredHeight
                    scalingMethod: ScalingMethod.AspectFit
                }
                
                ImageView 
                {
                    imageSource: "asset:///images/circle_cover.png"
                    preferredHeight: 120
                    preferredWidth: preferredHeight
                    scalingMethod: ScalingMethod.AspectFit
                }
                
                ImageView 
                {
                    preferredHeight: 40
                    preferredWidth: preferredHeight
                    horizontalAlignment: HorizontalAlignment.Right
                    verticalAlignment: VerticalAlignment.Bottom
                    scalingMethod: ScalingMethod.AspectFit
                    
                    imageSource: 
                    {
                        var image = "";
                        
                        if(ListItemData.online_presence == "active")
                        {
                            image = "asset:///media/images/icons/small_messenger_active.png";
                        }
                        else if(ListItemData.online_presence == "idle")
                        {
                            image = "asset:///media/images/icons/small_messenger_idle.png";
                        }
                        else if(ListItemData.online_presence == "offline")
                        {
                            image = "asset:///media/images/icons/small_messenger_offline.png";
                        }
                        
                        return image;
                    }
                }
            }
            
            Container 
            {
                id: contactNameChatContainer
                leftPadding: 20
                verticalAlignment: VerticalAlignment.Center
                
                layoutProperties: StackLayoutProperties 
                {
                    spaceQuota: 4
                }
                
                Container 
                {
                    layout: DockLayout {}
                    
                    Label 
                    {
                        text: ListItemData.name
                        textStyle.fontSize: FontSize.Large
                    }
                }
            }
            
            Container
            {
                verticalAlignment: VerticalAlignment.Center
                
                Label 
                {
                    text: ListItemData.online_presence.toUpperCase();
                    textStyle.fontSize: FontSize.XSmall
                    
                    textStyle.color: 
                    {
                        var the_color = "";
                        
                        if(ListItemData.online_presence == "active")
                        {
                            the_color = Color.create("#0284ff");
                        }
                        else if(ListItemData.online_presence == "idle")
                        {
                            the_color = Color.create("#ff9d31");
                        }
                        else if(ListItemData.online_presence == "offline")
                        {
                            the_color = Color.Gray;
                        }
                        
                        return the_color;
                    }
                }
            }
        }
    }
    
    gestureHandlers: 
    [
        TapHandler 
        {
            onTapped: 
            {
                start_chat();
            }
        }
    ]
    
    function start_chat()
    {
        var params = new Object();
        
        params.exists = false;
        
        for(var i = 0; i < Qt.pageMessages.data_model_messages.size(); i++)
        {
            var conversation = Qt.pageMessages.data_model_messages.value(i);
            
            if(conversation.recipient_id == ListItemData.uid)
            {
                params.data = conversation;
                params.exists = true;
                
                break;
            }
        }
        
        if(!params.exists)
        {
            var conversation = new Object();
            conversation.recipient_id = ListItemData.uid;
            conversation.display_name = ListItemData.name;
            
            params.data = conversation;
        }
        
        var page = Qt.chatComponent.createObject();
        page.load(params);
        Qt.navigationPane.push(page);
    }
    
    contextActions: 
    [
        ActionSet 
        {
            title: "User Actions"
            
            ActionItem 
            {
                title: "Chat"
                imageSource: "asset:///media/images/instagram/send.png"
                
                onTriggered: 
                {
                    start_chat();
                }
            }
            
            ActionItem 
            {
                title: "View Profile"
                imageSource: "asset:///media/images/instagram/dock_profile_active.png"
                
                onTriggered: 
                {
                    var page = Qt.browserComponent.createObject();
                    var params = new Object();
                    params.url = ListItemData.profile_url;
                    page.load(params);
                    Qt.navigationPane.push(page);
                }
            }
            
            ActionItem 
            {
                title: "Add to Favorites"
                imageSource: "asset:///media/images/icons/star.png"
                
                onTriggered: 
                {
                    if(Qt.has_pro_access())
                    {
                        var favorites = Qt.configuration.settings.active_user.favorites;
                        
                        var exists = false;
                        
                        for(var i = 0; i < favorites.length; i++)
                        {
                            var favorite = favorites[i];
                            
                            if(favorite.uid == ListItemData.uid)
                            {
                                exists = true;
                                break;
                            }
                        }
                        
                        if(exists)
                        {
                            Qt.dialog.pop("Attention", "This user is already in your Favorites List.");
                        }
                        else 
                        {
                            favorites.push(ListItemData);
                            
                            Qt.toast.pop(ListItemData.name + " added to favorites.");
                        }
                        
                        var active_user           = Qt.configuration.settings.active_user;
                        active_user.favorites     = favorites;
                        Qt.re_configurate(active_user);
                    }
                    else 
                    {
                        Qt.dialog.pop("Pro Upgrade Required", "Add friends to Favorites for easy access and access all other great features.");
                        Qt.proSheet.open();
                    }
                }
            }
        }
    ]
}