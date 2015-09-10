import bb.cascades 1.2
import nemory.WallpaperImage 1.0

import "buttons"

Container
{
    id: mainContainer
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    
    leftPadding: 20
    rightPadding: 20
    topPadding: 20

    Container 
    {
        horizontalAlignment: HorizontalAlignment.Fill
        
        WallpaperImage
        {
            id: photo
            defaultImage: "asset:///media/images/icons/coverThumbnail.png"
            imageSource: "asset:///media/images/icons/coverThumbnail.png"
            minHeight: (Qt.app._is_passport ? 550 : 350)
            maxHeight: (Qt.app._is_passport ? 550 : 350)
            scalingMethod: ScalingMethod.AspectFill
            horizontalAlignment: HorizontalAlignment.Fill
            url: ListItemData.file.url
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    var page = Qt.pictureExpanderComponent.createObject();
                    page.load(photo.imageSource);
                    Qt.navigationPane.push(page);
                }
            }
        }
        
        Container 
        {
            topPadding: 20
            
            layout: DockLayout {}
            horizontalAlignment: HorizontalAlignment.Fill
            
            Label 
            {
                text: ListItemData.name
                //text: "Wallpaper Name"
                textStyle.fontSize: FontSize.XLarge
                textStyle.fontWeight: FontWeight.W100
            }
            
            NemButton 
            {
                label.text: (ListItemData.paid ? "Premium" : "Free")
                maxWidth: 300
                horizontalAlignment: HorizontalAlignment.Right
                solid: true
                color: (ListItemData.paid ? colorTeal : colorGray)
                
                onClicked:
                {
                    if(ListItemData.paid)
                    {
                        if(Qt.app.get_setting("purchased_wallpapers", "false") == "true" || Qt.configuration.settings.exempted == "true" || Qt.app.is_beta() == true || Qt.trial_mode())
                        {
                            setWallpaper();
                        }
                        else 
                        {
                            preview();
                            Qt.toast.pop("Set Premium and Custom Wallpapers unlimitedly! :) Upgrade now!");
                            Qt.unlockCustomWallpaper.open();
                        }
                    }
                    else 
                    {
                        setWallpaper();
                    }
                }
            }
        }
        
        Label 
        {
            text: ListItemData.description   
            //text: "Wallpaper Description... Wallpaper Description... Wallpaper Description... Wallpaper Description... Wallpaper Description... "
            textStyle.fontSize: FontSize.XSmall
            textStyle.fontWeight: FontWeight.W100
            multiline: true
        }
    }
    
    Divider {}
    
    contextActions: ActionSet 
    {
        actions: 
        [
            ActionItem 
            {
                title: "Apply as Wallpaper"   
                imageSource: "asset:///media/images/icons/maximize.png"
                
                onTriggered: 
                {
                    setWallpaper();
                } 
            },
            ActionItem 
            {
                title: "Preview for 30 Secs"   
                imageSource: "asset:///media/images/icons/maximize.png"
                
                onTriggered: 
                {
                    preview();
                } 
            }
        ]
    }
    
    property double initialScaleX : 1.0;
    property double initialScaleY : 1.0;
    property bool pressedActive          : false;
    
    onTouch: 
    {
        if (event.isDown()) 
        {
            pressedActive = true;
        } 
        else if (event.isUp() || event.isCancel()) 
        {
            if (pressedActive) 
            {
                pressedActive = false;
            }
        }
    }
    
    onPressedActiveChanged: 
    {
        if(pressedActive)
        {
            mainContainer.setScale(0.99, 0.99);
            mainContainer.opacity = 0.5;
        }    
        else 
        {
            mainContainer.resetOpacity();
            mainContainer.scaleX = initialScaleX;
            mainContainer.scaleY = initialScaleY;
        }
    }
    
    function setWallpaper()
    {
        if(Qt.dark_theme_mode) // TODO
        {
            Qt.app._wallpaper = photo.imageSource;
            Qt.lastWallpaper = photo.imageSource;
            
            Qt.app.set_setting("wallpaper", photo.imageSource);
            
            Qt.toast.pop("New wallpaper has been set. :)");
        }
        else 
        {
            if(!Qt.has_pro_access())
            {
                Qt.toast.pop("Set / Change Wallpapers. Make the app more beautiful. Upgrade to Pro NOW! :)");
                Qt.proSheet.open();
            }
            else 
            {
                Qt.toast.pop("Switch to Dark Theme first before you can set Wallpapers. :)");
            }
        }
        
        Qt.app.flurryLogEvent("set_wallpaper." + ListItemData.name.replace(" ", "").toLowerCase());
    }
    
    function preview()
    {
        if(Qt.dark_theme_mode)
        {
            Qt.app._wallpaper = photo.imageSource;
            Qt.previewTimer.start();
            
            Qt.toast.pop("Now previewing for 30 seconds :)");
        }
        else 
        {
            Qt.toast.pop("Switch to dark theme first to preview.");
        }
        
        Qt.app.flurryLogEvent("preview_wallpaper." + ListItemData.name.replace(" ", "").toLowerCase());
    }
}