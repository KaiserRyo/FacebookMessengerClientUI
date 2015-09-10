import bb.cascades 1.2
import nemory.WebImageView 1.0

import "../components"

Dialog 
{
    id: dialog
    
    property variant announcement_data;
    property bool locked : false;
    
    onOpened: 
    {
        labelObject.text          = announcement_data.message;
        image.url                 = announcement_data.image.url;
        title_text.text           = announcement_data.title;
        main_container.background = Color.create(announcement_data.background_color);
    }
    
    function scrollReady()
    {
        if (_app._is_passport()) 
        {
            scrollView.requestFocus();
        }
    }

    Container 
    {
        id: main_container
        background: Color.create("##2b5a83")
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill

        layout: DockLayout {}

        ScrollView 
        {
            id: scrollView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            Container 
            {
                horizontalAlignment: HorizontalAlignment.Fill
                bottomPadding: 30
                leftPadding: 20
                rightPadding: 20
                topPadding: 20
                
                Label 
                {
                    id: title_text
                    text: "Announcements"
                    textStyle.color: Color.White
                    textStyle.fontSize: FontSize.XXLarge
                    textStyle.fontWeight: FontWeight.W100
                    horizontalAlignment: HorizontalAlignment.Center
                }
                
                ActivityIndicator 
                {
                    visible: !image.ready
                    running: visible
                    horizontalAlignment: HorizontalAlignment.Center
                    preferredHeight: 100
                }

                WebImageView 
                {
                    id: image
                    visible: ready
                    horizontalAlignment: HorizontalAlignment.Fill
                    minHeight: (_app._is_passport ? 500 : 300)
                    maxWidth: _app.getDisplayWidth()
                    scalingMethod: ScalingMethod.AspectFill
                    defaultImage: "asset:///media/images/loadingAnnouncements.png"
                    imageSource: "asset:///media/images/loadingAnnouncements.png"
                }
                
                TextArea 
                {
                    id: labelObject
                    text: ""
                    backgroundVisible: false
                    editable: false
                    input.flags: TextInputFlag.SpellCheckOff
                    inputMode: TextAreaInputMode.Chat
                    textFormat: TextFormat.Html
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.fontSize: FontSize.Small
                    textStyle.color: Color.White
                    
                    activeTextHandler: ActiveTextHandler 
                    {
                        onTriggered:
                        {
                            if(!locked)
                            {
                                dialog.close();
                            }
                            else
                            {
                                event.abort();
                            }
                        }
                    }
                }
                
                Container 
                {
                    layout: StackLayout 
                    {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Button 
                    {
                        text: "Upgrade to Pro"
                        
                        layoutProperties: StackLayoutProperties 
                        {
                            spaceQuota: 1
                        }
                        
                        onClicked: 
                        {
                            Qt.proSheet.open();
                        }
                    }
                    
                    Button 
                    {
                        text: "Share " + _app.app_name()
                        
                        layoutProperties: StackLayoutProperties 
                        {
                            spaceQuota: 1
                        }
                        
                        onClicked: 
                        {
                            var value = Qt.app.app_hashtag() + " - The Best Facebook Messenger Client for BlackBerry 10. Get it at http://appworld.blackberry.com/webstore/content/58299022/ ";
                            Qt.invokeShare.invoke(value);
                        }
                    }
                }
                
                ImageButton 
                {
                    defaultImageSource: "asset:///media/images/icons/x.png"
                    preferredWidth: 100
                    preferredHeight: 100
                    topMargin: 50
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    onClicked: 
                    {
                        if(!locked)
                        {
                            dialog.close();
                        }
                        else 
                        {
                            Qt.dialog.pop(announcement_data.title, remove_tags(announcement_data.message));
                        }
                    }
                }
            }
        }
    }
    
    function remove_tags(html)
    {
        return html.replace(/<(?:.|\n)*?>/gm, '');
    }
}