import bb.cascades 1.0
import nemory.ParseAPI 1.0
import bb.system 1.2
import nemory.WebImageView 1.0

import "../components"

Sheet 
{
    id: sheet
    
    property variant announcement_data;
    property bool locked : false;
    
    onOpened: 
    {
        console.log("announcement_data: " + JSON.stringify(announcement_data));
        
        message.text              = announcement_data.message;
        image.url                 = announcement_data.image.url;
        titleBar.label_title.text = announcement_data.title;
        main_container.background = Color.create(announcement_data.background_color);
        
        btn_upgrade.visible       = (!Qt.has_pro_access());
        
        scrollReady();
    }
    
    function scrollReady()
    {
        if (_app._is_passport) 
        {
            scrollView.requestFocus();
        }
    }

    Page 
    {
        id: page
        
        titleBar: CustomTitleBar 
        {
            id: titleBar
            label_title.text: "ANNOUNCEMENTS"
            image_left.visible: false
            backgroundColor: Color.create("#222222")
        }

        Container 
        {
            id: main_container
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            background: Color.Black
            
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
                        horizontalAlignment: HorizontalAlignment.Fill
                        minHeight: (_app._is_passport ? 500 : 300)
                        maxWidth: _app.get_display_width()
                        scalingMethod: ScalingMethod.AspectFill
                        defaultImage: "asset:///media/images/loadingAnnouncements.png"
                        imageSource: "asset:///media/images/loadingAnnouncements.png"
                    }
                    
                    TextArea 
                    {
                        id: message
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
                                    sheet.close();
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
                            id: btn_upgrade
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
                                sheet.close();
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
    }
    
    function remove_tags(html)
    {
        return html.replace(/<(?:.|\n)*?>/gm, '');
    }
}