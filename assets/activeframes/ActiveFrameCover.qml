import bb.cascades 1.0
import nemory.WebImageView 1.0

Container 
{   
    horizontalAlignment: HorizontalAlignment.Fill
    
    maxHeight: 396
    maxWidth: 334

    background: Color.create("#11000000")
    
    layout: DockLayout {}
    
    onCreationCompleted: 
    {
        _frame.load.connect(load);
    }
    
    function load(params)
    {
        var data_string = _frame.get_string_from_file("data/active_frame.json");

        console.log("*** active_frame data_string: " + data_string);
        
        if(data_string != "" && data_string.length > 0)
        {
            var data = JSON.parse(data_string);

            imgBackground.url         = data.image;
            txtCaption.text           = data.text;
            lblName.text              = data.name;
            lblTimeAgo.text           = data.timeago;
            
            txtCaption.visible        = true;
            lblTimeAgo.visible        = true;
            containerHeader.visible   = true;
            containerDarker.visible   = true;
        }
        else // IMAGE MODE
        {
            imgBackground.imageSource = "asset:///images/activeframe.jpg";
            txtCaption.text           = "";
            lblName.text              = "";
            lblTimeAgo.text           = "";
            
            txtCaption.visible        = false;
            lblTimeAgo.visible        = false;
            containerHeader.visible   = false;
            containerDarker.visible   = false;
        }
    }

    Container
    {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        layout: DockLayout {}
        
        WebImageView 
        {
            id: imgBackground
            scalingMethod: ScalingMethod.AspectFill
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
        }
        
        Container 
        {
            id: containerDarker
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            background: Color.create("#66000000")
        }
        
        Container
        {
            topPadding: 60
            bottomPadding: 15
            
            TextArea 
            {
                id: txtCaption
                text: "Caption Text Here"
                backgroundVisible: false
                editable: false
                input.flags: TextInputFlag.SpellCheckOff
                inputMode: TextAreaInputMode.Chat
                textStyle.fontSize: FontSize.Small
                textStyle.color: Color.White
                textFormat: TextFormat.Plain
            }
        }
        
        Container 
        {
            verticalAlignment: VerticalAlignment.Bottom
            leftPadding: 10
            bottomPadding: 10
            
            Label 
            {
                id: lblTimeAgo
                text: "time ago"
                textStyle.color: Color.White
                textStyle.fontSize: FontSize.XXSmall
            }
        }
    }
    
    Container 
    {
        id: containerHeader
        background: Color.create("#00506d")
        minHeight: 70
        maxHeight: minHeight
        horizontalAlignment: HorizontalAlignment.Fill
        leftPadding: 15
        rightPadding: 15
        
        layout: StackLayout 
        {
            orientation: LayoutOrientation.LeftToRight
        }
        
        Label 
        {
            id: lblName
            text: "User Name"
            textStyle.color: Color.White
            verticalAlignment: VerticalAlignment.Center
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 0.8
            }
        }
        
        ImageView 
        {
            imageSource: "asset:///media/images/icons/icon.png"
            scalingMethod: ScalingMethod.AspectFit
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Right
            maxHeight: 40
            maxWidth: 40
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 0.2
            }
        }
    }
}