import bb.cascades 1.2
import nemory.WebImageView 1.0

Container
{
    preferredHeight: 120
    maxHeight: preferredHeight
    minHeight: preferredHeight
    leftPadding: 10
    rightPadding: 10
    topPadding: 5
    bottomPadding: 5
    horizontalAlignment: HorizontalAlignment.Fill
    background: Color.create(ListItemData.background_color)

    layout: StackLayout 
    {
        orientation: LayoutOrientation.LeftToRight
    }
    
    WebImageView 
    {
        url: ListItemData.image.url
        imageSource: "asset:///media/images/icons/profileThumbnail.png"
        defaultImage: "asset:///media/images/icons/profileThumbnail.png"
        preferredHeight: 120
        scalingMethod: ScalingMethod.AspectFit
        horizontalAlignment: HorizontalAlignment.Left
    }
    
    Container 
    {
        leftPadding: 10
        rightPadding: 20
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Right
        
        Label 
        {
            //text: "Messenger"
            text: ListItemData.title
            textStyle.color: Color.create(ListItemData.text_color)
            bottomMargin: 0
            textStyle.fontWeight: FontWeight.Bold
        }
        
        Label 
        {
            //text: "The best Instagram Client for BlackBerry 10, The best Instagram Client for BlackBerry 10"
            text: ListItemData.description
            textStyle.color: Color.create(ListItemData.text_color)
            textStyle.fontSize: FontSize.XXSmall
            multiline: true
            topMargin: 0
        }
    }
}