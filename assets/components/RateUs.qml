import bb.cascades 1.2

Container 
{
    id: rate_container
    visible: _app._show_rate_us
    horizontalAlignment: HorizontalAlignment.Fill
    topPadding: 20
    leftPadding: 30
    rightPadding: 30
    bottomPadding: 20
    
    Label 
    {
        text: "I bet you're loving Messenger :) Please show us some love by giving a review/rating in BlackBerry World. It could only take a few minutes of your precious time. Thank you. :)"
        multiline: true
        horizontalAlignment: HorizontalAlignment.Center
        textStyle.fontSize: FontSize.Small
        textStyle.fontStyle: FontStyle.Italic
    }
    
    Container 
    {
        horizontalAlignment: HorizontalAlignment.Center
        
        layout: StackLayout 
        {
            orientation: LayoutOrientation.LeftToRight
        }
        
        Button 
        {
            text: "Give Support! Rate & Review " + _app.app_hashtag()
            horizontalAlignment: HorizontalAlignment.Center
            
            onClicked: 
            {
                var content_id = "58299022";
                
                if(Qt.has_pro_access())
                {
                    content_id = "52509887";
                }
                
                _app.invoke_bbworld("appworld://content/" + content_id + "/");
                _app.flurryLogEvent("rated_from_show_rate_us");
            }
        }
        
        Button 
        {
            text: "CLOSE"
            maxWidth: 200
            horizontalAlignment: HorizontalAlignment.Center
            
            onClicked: 
            {
                _app.set_setting("show_rate_us", "false");
                _app._show_rate_us = false;
            }
        }
    }
    
    Divider {}
}