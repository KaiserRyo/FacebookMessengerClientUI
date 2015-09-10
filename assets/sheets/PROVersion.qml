import bb.cascades 1.0

import "../components"
import bb.platform 1.2

Sheet 
{
    id: sheet
    
    property string why_pay_message : "Messenger is a 3rd Party app developed by an Independent Developer: Nemory Studios, rather than an Official Instagram App developed by Instagram / Facebook itself.\n\nNemory Studios need some support from you so that we can continue to support Messenger itself to continue bringing updates and improvements.\n\nNobody will want to work for months/years and get no salary in the end.\n\nI hope you understand. Thank you very much! :)";
    
    onClosed: 
    {
        if(Qt.app.isCard() && !Qt.has_pro_access())
        {
            Application.requestExit();
        }
    }
    
    onOpened: 
    {
        Qt.app.flurryLogEvent("upgrade_to_pro_sheet");
    }

    Page 
    {
        id: page
        
        titleBar: CustomTitleBar 
        {
            id: titleBar
            label_title.text: "UPGRADE TO PRO"
            image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"
            image_right.visible: false
            
            onLeftButtonClicked: 
            {
                sheet.close();
            }
        }
        
        ScrollView 
        {
            id: scrollView
            horizontalAlignment: HorizontalAlignment.Center
            
            Container 
            {
                id: content
                horizontalAlignment: HorizontalAlignment.Center
                
                topPadding: 30
                leftPadding: 40
                rightPadding: 40
                bottomPadding: 100
                
                ImageView 
                {
                    scalingMethod: ScalingMethod.AspectFit
                    imageSource: "asset:///media/images/icons/icon480.png"     
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    preferredHeight: 200
                }
                
                Label 
                {
                    text: "Upgrade to Pro Version"
                    multiline: true
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle.textAlign: TextAlign.Center
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.fontSize: FontSize.XLarge
                }
                
                Divider { }
                
                Button 
                {
                    id: btn_upgrade
                    text: "Upgrade Now"
                    horizontalAlignment: HorizontalAlignment.Center
                    onClicked: 
                    {
                        _app.invoke_bbworld("appworld://content/52509887/");
                    }
                }
                
                Label 
                {
                    text: "<b>PRO FEATURES</b>
                    ✔ Add Friends to Favorites
                    ✔ Set to Dark Theme
                    ✔ App Color Schemes
                    ✔ Apply App Wallpapers
                    ✔ Unlimited Multi Accounts
                    ✔ Emojis + Emoticons Keyboard
                    ✔ App Security Password Lock
                    ✔ No ADS (Advertisements)
                    ++ PLUS MORE FEATURES ++";
                    textStyle.fontSize: FontSize.XSmall
                    textFormat: TextFormat.Html
                    horizontalAlignment: HorizontalAlignment.Center
                    multiline: true
                }
                
                Label 
                {
                    text: "<a>Read why pay when Facebook Messenger on other platforms are free?</a>"
                    textStyle.fontSize: FontSize.XSmall
                    textFormat: TextFormat.Html
                    textStyle.textAlign: TextAlign.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    multiline: true
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped: 
                        {
                            Qt.dialog.pop("Why Pay for Messenger?", why_pay_message);
                        }
                    }
                }
            }
        }
    }
}