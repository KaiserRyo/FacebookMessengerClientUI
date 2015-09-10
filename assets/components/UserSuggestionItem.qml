import bb.cascades 1.2
import nemory.WebImageView 1.0

import "buttons"

CustomListItem 
{
    id: mainContainer
    property int image_size : (Qt.app._is_passport ? 120 : 70);
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill

    Container 
    {
        id: content
        leftPadding: 20
        
        layout: StackLayout 
        {
            orientation: LayoutOrientation.LeftToRight    
        }  
        
        Container 
        {
            id: photoContainer
            minHeight: image_size
            minWidth: image_size
            layout: DockLayout {}
            
            WebImageView 
            {
                url: "http://graph.facebook.com/" + ListItemData.uid + "/picture/120_" + ListItemData.uid + ".png?width=120&height=120"
                defaultImage: "asset:///media/images/icons/profileThumbnail.png"
                imageSource: "asset:///media/images/icons/profileThumbnail.png"
                minHeight: image_size
                minWidth: image_size
                maxWidth: image_size
                maxHeight: image_size
                scalingMethod: ScalingMethod.AspectFit
            }
            
            ImageView 
            {
                imageSource: "asset:///images/circle_cover.png"
                minHeight: image_size
                minWidth: image_size
                maxWidth: image_size
                maxHeight: image_size
                scalingMethod: ScalingMethod.AspectFit
            }
        }
        
        Container 
        {
            leftPadding: 20
            verticalAlignment: VerticalAlignment.Center
            
            Label 
            {
                text: ListItemData[3] // full_name
                topMargin: 0
                bottomMargin: 0
            }  
            
            Label 
            {
                text: ListItemData.name
                textStyle.color: Color.Gray
                verticalAlignment: VerticalAlignment.Center
                topMargin: 0
                bottomMargin: 0
            }  
        }
    }
}