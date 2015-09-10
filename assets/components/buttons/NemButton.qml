import bb.cascades 1.0

Container 
{
    id: buttonObject
    minWidth: (Qt.app._is_passport ? 120 : 80)
    minHeight: (Qt.app._is_passport ? 120 : 80)
    preferredWidth: (Qt.app._is_passport ? 120 : 80)
    preferredHeight: (Qt.app._is_passport ? 120 : 80)
    topMargin: 10
    bottomMargin: 10
    leftMargin: 10
    rightMargin: 10
    scaleX: initialScaleX;
    scaleY: initialScaleY;
    layout: DockLayout {}

    property string colorTwitter         : "#55acef";
    property string colorGray            : "#919191";
    property string colorMagenta         : "#ff4a9b";
    property string colorBlue            : "#0084ff";
    property string colorBlack           : "#222222";
    property string colorOrange          : "#ffc14a";
    property string colorPurple          : "#b94aff";
    property string colorRed             : "#ff4a4a";
    property string colorTeal            : "#21b691";
    property string colorGreen           : "#75b621";
    property string colorWhite           : "#ffffff";
    property string colorDefault         : "#7c7c7c";
    property string colorDisabled        : "#b5b5b5";
    property string color                : colorDefault;
    
    property bool pressedActive          : false;
    property bool solid                  : false;
    
    property alias label                 : labelObject;
    property alias image                 : imageObject;
    property alias content               : contentObject;

    property double initialScaleX : 1.0;
    property double initialScaleY : 1.0;
    
    signal clicked();
    
    onEnabledChanged: 
    {
        reflect();
    }
    
    onSolidChanged: 
    {
        reflect();
    }
    
    onColorChanged: 
    {
        reflect();
    }
    
    onCreationCompleted: 
    {
        reflect();
    }

    ImageView 
    {
        id: imageButtonObject
        imageSource: "asset:///components/buttons/Button.amd"
        scalingMethod: ScalingMethod.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
    }
    
    Container 
    {
        id: contentObject
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        
        leftPadding: 15
        rightPadding: 15
        topPadding: 15
        bottomPadding: 15
        
        layout: StackLayout 
        {
            orientation: LayoutOrientation.LeftToRight
        }
        
        ImageView 
        {
            id: imageObject
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            scalingMethod: ScalingMethod.AspectFit
            visible: (imageObject.imageSource != "")
        }
        
        Label 
        {
            id: labelObject
//            textStyle.fontSize: FontSize.PointValue
//            textStyle.fontSizeValue: 6
            textStyle.fontWeight: FontWeight.W300
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            visible: (text.length > 0)
            
            textStyle.color:
            {
                if(buttonObject.enabled)
                {
                    if(solid)
                    {
                        if(color == colorBlack)
                        {
                            Color.create(colorWhite)
                        }
                        else if(color == colorWhite)
                        {
                            Color.create(colorDefault)
                        }
                        else 
                        {
                            Color.create(colorWhite)
                        }
                    }
                    else 
                    {
                        if(color == colorBlack && Qt.colortheme == "dark")
                        {
                            Color.create(colorGray)
                        }
                        else 
                        {
                            Color.create(color)
                        }
                    }
                }
                else 
                {
                    if(solid)
                    {
                        Color.create("#77ffffff")
                    }
                    else 
                    {
                        Color.create(colorDisabled)
                    }
                }
            }
            
            attachedObjects: 
            [
                LayoutUpdateHandler 
                {
                    onLayoutFrameChanged: 
                    {
                        buttonObject.preferredWidth = layoutFrame.width + 60
                    }
                }
            ]
        }
    }
       
    onTouch: 
    {
        if (buttonObject.enabled) 
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

                    if(event.localX > 0 || event.localY > 0)
                    {
                        clicked();
                    }
                }
            }
        }
    }
    
    attachedObjects: 
    [
        TextStyleDefinition 
        {
            id: labelStyle
            color: Color.Gray
            fontSize: FontSize.PointValue
            fontSizeValue: 7
            fontWeight: FontWeight.W100
        },
        TextStyleDefinition 
        {
            id: disabledLabelStyle
            color: Color.LightGray
            fontSize: FontSize.PointValue
            fontSizeValue: 7
            fontWeight: FontWeight.W100
        }
    ]
    
    function reflect()
    {
        var theColor = "";
        
        if(color == colorBlack)
        {
            if(Qt.colortheme == "dark")
            {
                theColor = "Gray";
            }
            else 
            {
                theColor = "Black";
            }
        }
        else if(color == colorBlue)
        {
            theColor = "Blue";
        }
        else if(color == colorGreen)
        {
            theColor = "Green";
        }
        else if(color == colorMagenta)
        {
            theColor = "Magenta";
        }
        else if(color == colorOrange)
        {
            theColor = "Orange";
        }
        else if(color == colorPurple)
        {
            theColor = "Purple";
        }
        else if(color == colorRed)
        {
            theColor = "Red";
        }
        else if(color == colorTeal)
        {
            theColor = "Teal";
        }
        else if(color == colorWhite)
        {
            theColor = "White";
        }
        else if(color == colorTwitter)
        {
            theColor = "Twitter";
        }
        else if(color == colorGray || color == colorDefault)
        {
            theColor = "Gray";
        }
        else 
        {
            theColor = "Gray";
        }
        
        if(!enabled)
        {
            theColor = "Disabled";
        }
        
        if(solid)
        {
            theColor = theColor + "Solid";
        }

        imageButtonObject.imageSource = "asset:///components/buttons/Button" + theColor + ".amd";
    }
    
    onPressedActiveChanged: 
    {
        if(pressedActive)
        {
            buttonObject.setScale(0.9, 0.9);
            buttonObject.opacity = 0.5;
        }    
        else 
        {
            buttonObject.resetOpacity();
            buttonObject.scaleX = initialScaleX;
            buttonObject.scaleY = initialScaleY;
        }
    }
}
