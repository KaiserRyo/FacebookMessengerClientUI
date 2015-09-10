import bb.cascades 1.2
import nemory.WebImageView 1.0

import "buttons"

CustomListItem 
{
    dividerVisible: true
    property int image_size : (Qt.app._is_passport ? 200 : 120);
    
    Container
    {
        id: mainContainer
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        rightPadding: 30
        bottomPadding: 20
        maxHeight: 150
        
        layout: DockLayout {}
        
        Container
        {
            id: contentContainer
            horizontalAlignment: HorizontalAlignment.Fill
            
            layout: StackLayout
            {
                orientation: LayoutOrientation.LeftToRight
            }
            
            Container 
            {
                id: content
                
                layout: StackLayout
                {
                    orientation: LayoutOrientation.LeftToRight
                }

                Container 
                {
                    id: photoContainer
                    layout: DockLayout {}
                    minHeight: image_size
                    minWidth: image_size
                    maxWidth: image_size
                    
                    layoutProperties: StackLayoutProperties 
                    {
                        spaceQuota: 1
                    }
                    
                    WebImageView 
                    {
                        url: "http://graph.facebook.com/" + ListItemData.id + "/picture/200_" + ListItemData.id + ".png?width=200&height=200"
                        defaultImage: "asset:///media/images/icons/profileThumbnail.png"
                        imageSource: "asset:///media/images/icons/profileThumbnail.png"
                        minHeight: image_size
                        minWidth: image_size
                        maxWidth: image_size
                        scalingMethod: ScalingMethod.AspectFit
                    }
                }
                
                Container 
                {
                    id: right
                    leftPadding: 20
                    rightPadding: 20
                    verticalAlignment: VerticalAlignment.Center
                    
                    layoutProperties: StackLayoutProperties 
                    {
                        spaceQuota: 4
                    }
                    
                    Container 
                    {
                        id: top
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Center
                        
                        Label 
                        {
                            textStyle.fontSize: FontSize.Default
                            textStyle.fontWeight: FontWeight.W100
                            text: ListItemData.name
                            //text: "Nemory Oliver Martinez"
                            bottomMargin: 0
                        }
//                        
//                        Label 
//                        {
//                            textStyle.fontSize: FontSize.XSmall
//                            text: ListItemData.id
//                            //text: "@nemoryoliver"
//                            topMargin: 0
//                            textStyle.fontStyle: FontStyle.Italic
//                        }
                    }
                }    
            }
        }

        ImageView 
        {
            visible: ListItemData.active
            imageSource: "asset:///media/images/instagram/check_green.png"
            preferredHeight: 60
            preferredWidth: 60
            scalingMethod: ScalingMethod.AspectFit
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Right
        }
        
        contextActions: ActionSet 
        {
            actions: 
            [
                ActionItem 
                {
                    title: "Set Active"
                    imageSource: "asset:///media/images/icons/check.png"
                    
                    onTriggered: 
                    {
                        Qt.setActiveUser(ListItemData);
                        
                        rootAccountItem.ListItem.view.repopulate();
                        
                        Qt.pageMessages.clearDataModel();
                        Qt.pageMessages.load();
                        
                        Qt.pageFriends.clearDataModel();
                        Qt.pageFriends.load();
                        
                        Qt.pageFavorites.clearDataModel();
                        Qt.pageFavorites.load();
                        
                        Qt.toast.pop(ListItemData.name + " is now active.");
                        
                        Qt.app.set_string_to_file(ListItemData.name, "data/hub_account_name.json");
                        
                        Qt.app.command_headless("update_hub_account");
                        
                        Qt.nemAPI.logout();
                        _app.command_headless("logout");
                        //Qt.nemAPI.login(ListItemData.access_token);
                    } 
                },
                DeleteActionItem 
                {
                    title: "Remove"
                    imageSource: "asset:///media/images/icons/trash.png"
                    
                    onTriggered: 
                    {
                        Qt.removeUser(ListItemData);
                        
                        rootAccountItem.ListItem.view.repopulate();
                        
                        Qt.toast.pop(ListItemData.name + " is now removed.");
                    } 
                }
            ]
        }
    }
}