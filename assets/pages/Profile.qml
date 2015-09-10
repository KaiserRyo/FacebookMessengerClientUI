import bb.cascades 1.0
import nemory.NemAPI 1.0
import nemory.WebImageView 1.0

import "../components"
import "../components/buttons"
import "../dialogs"
import "../sheets"

NavigationPane 
{
    id: navigationPane
    
    signal loaded();
    
    onPushTransitionEnded: 
    {
        page.scrollReady();    
    }
    
    onPopTransitionEnded: 
    {
        page.destroy();
    }
    
    function tabActivated()
    {
        Qt.navigationPane = navigationPane;
        
        scrollReady();
        
        img_profile_photo.url   = "http://graph.facebook.com/" + Qt.configuration.settings.active_user.id + "/picture/200_" + Qt.configuration.settings.active_user.id + ".png?width=200&height=200";
        
        if(Qt.configuration.settings.active_user.cover)
        {
            img_cover_photo.url   = Qt.configuration.settings.active_user.cover.source;
        }
        else 
        {
            img_cover_photo.resetImageSource();
            img_cover_photo.url = "";
        }
        
        if(Qt.configuration.settings.active_user.bio)
        {
            lbl_bio.text          = Qt.configuration.settings.active_user.bio;
        }
        
        lbl_name.text         = Qt.configuration.settings.active_user.name;
    }
    
    function tabDeactivated()
    {
        
    }
    
    function scrollReady()
    {
        if (_app._is_passport) 
        {
            scrollView.requestFocus();
        }
    }
    
    function load()
    {
        
    }
    
    function clearDataModel()
    {
        
    }

    Page 
    {
        id: the_page
        
        titleBar: CustomTitleBar 
        {
            id: titleBar
            label_title.text: "PROFILE";
            label_title.translationX: -20
            image_left.visible: false

            onLabelTitleClicked: 
            {
                
            }
            
            onLeftButtonClicked: 
            {
                
            }
        }

        Container 
        {
            id: mainContainer
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            layout: DockLayout {}
            
            ImageView 
            {
                id: wallpaper
                imageSource: _app._wallpaper
                scalingMethod: ScalingMethod.AspectFill
                opacity: 0.5
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
            }

            ScrollView 
            {
                id: scrollView
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                Container 
                {
                    id: content
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    
                    RateUs 
                    {
                        id: rate_us
                    }
                
                    Container 
                    {
                        horizontalAlignment: HorizontalAlignment.Fill
                        layout: DockLayout {}
                        
                        WebImageView 
                        {
                            id: img_cover_photo
                            horizontalAlignment: HorizontalAlignment.Fill
                            preferredHeight: (_app._is_passport ? 700 : 400)
                            scalingMethod: ScalingMethod.AspectFill
                        } 
                        
                        Container 
                        {
                            verticalAlignment: VerticalAlignment.Bottom
                            bottomPadding: 20
                            leftPadding: 20
                            rightPadding: 20
                            
                            WebImageView 
                            {
                                id: img_profile_photo
                                property int image_size : (_app._is_passport ? 250 : 150);
                                preferredHeight: image_size
                                preferredWidth: image_size
                                maxWidth: image_size
                                maxHeight: image_size
                                minHeight: image_size
                                minWidth: image_size
                                scalingMethod: ScalingMethod.AspectFit
                            }
                        }
                    }
                    
                    Container 
                    {
                        leftPadding: 20
                        rightPadding: 20
                        topPadding: 20
                        bottomPadding: 20
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        Label 
                        {
                            id: lbl_name
                            text: "User Name"
                            multiline: true
                            textStyle.color: Color.Black
                            textStyle.fontSize: FontSize.XLarge
                            horizontalAlignment: HorizontalAlignment.Center
                        }
                        
                        Label 
                        {
                            id: lbl_bio
                            multiline: true
                            textStyle.fontSize: FontSize.XSmall
                            horizontalAlignment: HorizontalAlignment.Center
                            textStyle.textAlign: TextAlign.Center
                            text: "Biography..."
                        }
                        
                        Button 
                        {
                            text: "View Full Profile"
                            horizontalAlignment: HorizontalAlignment.Center

                            onClicked: 
                            {
                                _app.invoke_browser("https://m.facebook.com/" + Qt.configuration.settings.active_user.id + "/")
                            }
                        }
                    }
                }
            }
            
            MainTabs 
            {
                id: mainTabs
                activeTab: "tabProfile"
                
                onClicked: 
                {
                    if(tab == activeTab)
                    {
                        load();
                    }    
                }
            }
            
            Container 
            {
                background: Color.create("#ff8a00")
                preferredHeight: 30
                horizontalAlignment: HorizontalAlignment.Fill
                visible: !_app._connected
                
                Label
                {
                    text: "Connecting..."
                    textStyle.fontSize: FontSize.XXSmall
                    textStyle.color: Color.White
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }

            ActivityIndicator 
            {
                id: loadingIndicator 
                visible: false
                running: visible
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
        }
    }
}