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
        topPadding: 10
        bottomPadding: 10
        
        Container
        {
            id: conversationContainer
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
                    url: ListItemData.display_image
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
                
                Label 
                {
                    textStyle.fontSize: FontSize.Large
                    textStyle.fontWeight: (ListItemData.unread ? FontWeight.W500 : FontWeight.W100)
                    text: ListItemData.display_name
                    //text: "Oliver Martinez Nemory"
                    bottomMargin: 0
                }
                
                Label 
                {
                    content.flags: TextContentFlag.ActiveTextOff;
                    textStyle.fontSize: FontSize.Small
                    textStyle.fontWeight: (ListItemData.unread ? FontWeight.W500 : FontWeight.W100)
                    //textStyle.color: (ListItemData.unread ? Color.create("#0284ff") : Color.Gray)
                    topMargin: 0
                    text: ListItemData.display_message
                    visible: (text.length > 0)
                    //text: "Test Message Test Message"
                }
            }
            
            Container
            {
                id: dateTimeStatusContainer
                verticalAlignment: VerticalAlignment.Center
                
                layoutProperties: StackLayoutProperties 
                {
                    spaceQuota: 1
                }
                
                Container 
                {
                    horizontalAlignment: HorizontalAlignment.Right
                    
                    Label 
                    {
                        text: ListItemData.time_ago
                        textStyle.color: (ListItemData.unread ? Color.create("#0284ff") : Color.Gray)
                        textStyle.fontSize: FontSize.XSmall
                    }
                }
                
                Container 
                {
                    horizontalAlignment: HorizontalAlignment.Right
                    
                    ImageView 
                    {   
                        imageSource:ListItemData.last_sender_status_image
                        preferredHeight: 40
                        preferredWidth: 40
                    }
                }
            }
        }
    }
    
    gestureHandlers: TapHandler 
    {
        onTapped: 
        {
            if(ListItemData.to.data.length > 2)
            {
                var group_chat_url = "https://m.facebook.com/messages/read/?tid=id." + ListItemData.id;
                
                var page = Qt.browserComponent.createObject();
                var params = new Object();
                params.url = group_chat_url;
                page.load(params);
                Qt.navigationPane.push(page);
            }
            else 
            {
                var page = Qt.chatComponent.createObject();
                var params = new Object();
                params.data = ListItemData;
                page.load(params);
                Qt.navigationPane.push(page);
                
                Qt.current_chat_page = page;
            }
            
            var item = ListItemData;
            item.unread = false;
            rootConversation.ListItem.view.dataModel.replace(rootConversation.ListItem.indexPath, item);
        }
    }
    
    contextActions: 
    [
        ActionSet 
        {
            title: "Conversation Actions"
            
            ActionItem 
            {
                title: "Chat"
                imageSource: "asset:///media/images/instagram/send.png"
                
                onTriggered: 
                {
                    if(ListItemData.to.data.length > 2)
                    {
                        var group_chat_url = "https://m.facebook.com/messages/read/?tid=id." + ListItemData.id;
                        
                        var page = Qt.browserComponent.createObject();
                        var params = new Object();
                        params.url = group_chat_url;
                        page.load(params);
                        Qt.navigationPane.push(page);
                    }
                    else 
                    {
                        var page = Qt.chatComponent.createObject();
                        var params = new Object();
                        params.data = ListItemData;
                        page.load(params);
                        Qt.navigationPane.push(page);
                        
                        Qt.current_chat_page = page;
                    }
                    
                    var item = ListItemData;
                    item.unread = false;
                    rootConversation.ListItem.view.dataModel.replace(rootConversation.ListItem.indexPath, item);
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
        }
    ]
}