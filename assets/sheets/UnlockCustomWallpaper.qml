import bb.cascades 1.0

import "../components"
import bb.platform 1.2

Sheet 
{
    id: sheet
    
    property string why_pay_message : "Messenger is a 3rd Party app developed by an Independent Developer: Nemory Studios, rather than an Official Instagram App developed by Instagram / Facebook itself.\n\nNemory Studios need some support from you so that we can continue to support Messenger itself to continue bringing updates and improvements.\n\nNobody will want to work for months/years and get no salary in the end.\n\nI hope you understand. Thank you very much! :)";
    
    onOpened: 
    {
        Qt.app.flurryLogEvent("unlock_custom_wallpaper");
        
        storePaymentManager.requestPrice("", "messenger_custom_premium_walls");
        
        if(!_app.is_beta())
        {
            storePaymentManager.setConnectionMode(1);
        }
        else 
        {
            storePaymentManager.setConnectionMode(0);
        }
    }

    Page 
    {
        titleBar: CustomTitleBar 
        {
            id: titleBar
            label_title.text: "CUSTOM & PREMIUM WALLS"
            image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"
            image_right.visible: false
            
            onLeftButtonClicked: 
            {
                sheet.close();
            }
        }
        
        ScrollView 
        {
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            
            Container 
            {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                
                leftPadding: 20
                rightPadding: 20
                bottomPadding: 100
                topPadding: 50
                
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
                    text: "Set Custom & Unlimited Premium Wallpapers"
                    multiline: true
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle.textAlign: TextAlign.Center
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.fontSize: FontSize.Large
                }
                
                Divider { }
                
                Button 
                {
                    id: btn_upgrade
                    text: "Upgrade"
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    onClicked: 
                    {
                        Qt.app.flurryLogEvent("unlock_custom_wallpapers");
                        
                        storePaymentManager.requestPurchase("", "messenger_custom_premium_walls", "", "", "");
                    }
                }
                
                Label 
                {
                    text: "<b>PRO FEATURES</b>
                    ✔ Set Custom Wallpapers from your Gallery
                    ✔ Set any Premium Wallpapers";
                   textStyle.fontSize: FontSize.XSmall
                   textFormat: TextFormat.Html
                   horizontalAlignment: HorizontalAlignment.Center
                   multiline: true
                }
                
                Label 
                {
                    text: "This is a separate Upgrade Feature."
                    textStyle.fontStyle: FontStyle.Italic
                    textStyle.fontSize: FontSize.XSmall
                    textFormat: TextFormat.Html
                    textStyle.textAlign: TextAlign.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    multiline: true
                    textStyle.color: Color.Red
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

                Divider { }
                
                Label 
                {
                    text: "Already purchased this? Click below.";
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle.textAlign: TextAlign.Center
                    textStyle.color: Color.DarkCyan
                    multiline: true
                }
                
                Button 
                {
                    text: "Request Existing Purchase"
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    onClicked: 
                    {
                        Qt.app.flurryLogEvent("request_existing_unlock_custom_wallpapers");
                        
                        storePaymentManager.requestExistingPurchases(true);
                        
                        Qt.toast.pop("Checking for existing purchase...");
                    }
                }
            }
        }
    }
    
    attachedObjects: 
    [
        PaymentManager 
        {
            id: storePaymentManager
            
            property bool busy: false
            
            onExistingPurchasesFinished: 
            {
                console.log("onExistingPurchasesFinished: " + JSON.stringify(reply));
                
                storePaymentManager.busy = false;
                
                if (reply.errorCode == 0) 
                {
                    if(reply.purchases.length > 0)
                    {
                        _app.set_setting("purchased_wallpapers", "true");
                        
                        Qt.restartDialog.show();
                    }
                    else 
                    {
                        Qt.dialog.pop("Attention", "You have not paid any Pro Features yet. \n\nYou will get a purchase receipt in your email if you really did paid.\n\nPlease restart app.");
                    }
                } 
                else 
                {
                    Qt.dialog.pop("Payment Manager Error", reply.errorCode + ", " + reply.errorText);
                }
            }
            
            onPurchaseFinished: 
            {
                console.log("onPurchaseFinished: " + JSON.stringify(reply));
                
                storePaymentManager.busy = false;
                
                if (reply.errorCode == 0)
                {
                    _app.set_setting("purchased_wallpapers", "true");
                    
                    Qt.restartDialog.show();
                } 
                else 
                {
                    Qt.dialog.pop("Payment Manager Error", reply.errorCode + ", " + reply.errorText);
                }
            }
            
            onPriceFinished: 
            {
                console.log("onPriceFinished: " + JSON.stringify(reply));
                
                storePaymentManager.busy = false;
                
                if (reply.errorCode == 0) 
                {
                    btn_upgrade.text = "Upgrade for just " + reply.price;
                } 
                else 
                {
                    console.log("Error: " + reply.errorCode + ", " + reply.errorText);
                }
            }
        }
    ]
}