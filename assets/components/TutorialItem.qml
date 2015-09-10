import bb.cascades 1.2
import nemory.WebImageView 1.0

Container
{
    id: contentContainer
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    //background: Color.create("#2b5a83");
    background: Color.create(ListItemData.background_color);
    
    property int image_width : 700;
    property int image_height : 200;
    property variant text_font_size : FontSize.XSmall
    
    layout: DockLayout {}
    
    Container
    {
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center
        leftPadding: 20
        rightPadding: 20
        
        Container 
        {
            id: titles
            horizontalAlignment: HorizontalAlignment.Center
            
            Label 
            {
                //text: "Welcome"
                text: ListItemData.title
                textStyle.color: Color.White
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XXLarge
                textStyle.fontWeight: FontWeight.W100
                textFormat: TextFormat.Html
                bottomMargin: 0
                multiline: true
            }
            
            Label 
            {
                //text: "The best Instagram Client for BlackBerry 10"
                text: ListItemData.subtitle
                textStyle.color: Color.White
                textStyle.fontSize: FontSize.XSmall
                horizontalAlignment: HorizontalAlignment.Center
                textFormat: TextFormat.Html
                topMargin: 0
                multiline: true
            }
        }
        
        Divider {}
        
        ActivityIndicator 
        {
            visible: !screenshot.ready
            running: visible
            horizontalAlignment: HorizontalAlignment.Center
            preferredHeight: 100
        }
        
        WebImageView 
        {
            //imageSource: "asset:///images/logoword.png"
            visible: !ListItemData.last
            id: screenshot
            url: ListItemData.screenshot.url
            horizontalAlignment: HorizontalAlignment.Center
            preferredWidth: image_width
            maxHeight: image_height
            scalingMethod: ScalingMethod.AspectFit
        }
        
        Label 
        {
            //text: "Natively Fast, Fluid Instagram experience! \nPost pictures, Send Direct Messages, Receive Hub Integrated Notifications, Compose from Hub, Share from Gallery, Change Color & Application Schemes, Set Wallpapers with Wallpaper Store, Regram, Edit Posts, Emoji Keyboard, Save Media, Secure with Password. and + MORE"
            text: ListItemData.text
            textStyle.color: Color.White
            textStyle.fontSize: text_font_size
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            textFormat: TextFormat.Html
            textStyle.textAlign: TextAlign.Center
            multiline: true
        }
        
        Divider {}
        
        Container 
        {
            visible: !ListItemData.last
            horizontalAlignment: HorizontalAlignment.Center
            
            layout: StackLayout 
            {
                orientation: LayoutOrientation.LeftToRight
            }    
            
            ImageView 
            {
                imageSource: "asset:///media/images/icons/arrowDown.png"
                preferredHeight: 50
                scalingMethod: ScalingMethod.AspectFit
            }
            
            Label 
            {
                text: "Scroll down or tap anywhere to continue"
                textStyle.color: Color.White
                textStyle.fontSize: FontSize.XXSmall
                verticalAlignment: VerticalAlignment.Center
            }
            
            ImageView 
            {
                imageSource: "asset:///media/images/icons/arrowDown.png"
                preferredHeight: 50
                scalingMethod: ScalingMethod.AspectFit
            }
        }
        
        Container 
        {
            visible: ListItemData.last
            horizontalAlignment: HorizontalAlignment.Center
            
            Button 
            {
                text: "Take me to #Messenger!"
                touchPropagationMode: TouchPropagationMode.None
            }
        }
    }
}