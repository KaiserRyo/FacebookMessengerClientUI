import bb.cascades 1.2
import nemory.WebImageView 1.0

CustomListItem 
{
    id: mainContainer
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    dividerVisible: true
    
    property int image_size : 100;

    Container
    {
        id: contentContainer
        horizontalAlignment: HorizontalAlignment.Fill
        leftPadding: 10
        topPadding: 3
        bottomPadding: 3
        
        layout: StackLayout 
        {
            orientation: LayoutOrientation.LeftToRight
        }
        
        WebImageView 
        {
            url: ListItemData.icon.url
            scalingMethod: ScalingMethod.AspectFit
            minHeight: image_size
            maxHeight: image_size
            minWidth: image_size   
            maxWidth: image_size
            verticalAlignment: VerticalAlignment.Center 
        }
        
        Container 
        {
            verticalAlignment: VerticalAlignment.Center
            leftPadding: 20
            rightPadding: 20
            
            Label 
            {
                text: ListItemData.name
                textStyle.fontSize: FontSize.Large
                bottomMargin: 0
            }
            
            Label 
            {
                text: ListItemData.description
                textStyle.fontSize: FontSize.XSmall
                topMargin: 0
            }
        }
    }
}