import bb.cascades 1.2
import nemory.WebImageView 1.0

import "buttons"

Container 
{
    property int image_size : (Qt.app._is_passport ? 120 : 70);
    
    Container
    {
        id: mainContainer
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        rightPadding: 20
        leftPadding: 20
        bottomPadding: 20

        Label 
        {
            text: Qt.nemAPI.timeSince(ListItemData.created_time * 1000);
            textStyle.fontSize: FontSize.XXSmall
            textStyle.fontStyle: FontStyle.Italic
            horizontalAlignment: HorizontalAlignment.Right
            bottomMargin: 0
            topMargin: 0
            textStyle.color: Color.Gray
        }
        
        Container 
        {
            id: content
            
            layout: StackLayout
            {
                //orientation: LayoutOrientation.LeftToRight
                orientation: (ListItemData.from.id == Qt.configuration.settings.active_user.id) ? LayoutOrientation.LeftToRight : LayoutOrientation.RightToLeft;
            }
            
            Container 
            {
                verticalAlignment: VerticalAlignment.Bottom
                minHeight: image_size
                minWidth: image_size
                maxWidth: image_size
                layout: DockLayout {}
                
                layoutProperties: StackLayoutProperties 
                {
                    spaceQuota: 1
                }
                
                WebImageView 
                {
                    url: "http://graph.facebook.com/" + ListItemData.from.id + "/picture/120_" + ListItemData.from.id + ".png?width=120&height=120";
                    defaultImage: "asset:///media/images/icons/profileThumbnail.png"
                    imageSource: "asset:///media/images/icons/profileThumbnail.png"
                    minHeight: image_size
                    minWidth: image_size
                    maxWidth: image_size
                    scalingMethod: ScalingMethod.AspectFit
                }
                
                ImageView 
                {
                    imageSource: "asset:///images/circle_cover.png"
                    minHeight: image_size
                    minWidth: image_size
                    maxWidth: image_size
                    preferredWidth: image_size
                    scalingMethod: ScalingMethod.AspectFit
                }
            }
 
            Container 
            {
                leftMargin: 10
                rightMargin: 10
                leftPadding: 20
                rightPadding: 20
                verticalAlignment: VerticalAlignment.Bottom
                background: Color.create("#22b0b0b0");
                
                layoutProperties: StackLayoutProperties 
                {
                    spaceQuota: 4
                }
                
                TextArea 
                {
                    text: ListItemData.message
                    //text: "This is my CHAT MESSAGE......This is my CHAT MESSAGE......This is my CHAT MESSAGE......This is my CHAT MESSAGE......This is my CHAT MESSAGE......"
                    content.flags: TextContentFlag.ActiveTextOff;
                    backgroundVisible: false
                    editable: false
                    textStyle.fontSize: FontSize.Small
                    input.flags: TextInputFlag.SpellCheckOff
                    inputMode: TextAreaInputMode.Chat
                }
            }    
        }
        
        contextActions: ActionSet 
        {
            actions: 
            [
                ActionItem 
                {
                    title: "Copy"
                    imageSource: "asset:///media/images/icons/copy.png"
                    
                    onTriggered: 
                    {
                        Qt.app.copy_to_clipboard(ListItemData.msssage);
                        
                        Qt.toast.pop("Copied to clipboard.");
                    } 
                },
                ActionItem 
                {
                    title: "View Profile"
                    imageSource: "asset:///media/images/instagram/dock_profile_active.png"
                    
                    onTriggered: 
                    {
                        var the_url = "https://m.facebook.com/" + ListItemData.from.id + "/";

                        var page = Qt.browserComponent.createObject();
                        var params = new Object();
                        params.url = the_url;
                        page.load(params);
                        Qt.navigationPane.push(page);
                    } 
                }
            ]
        }
    }
}