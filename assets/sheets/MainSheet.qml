import bb.cascades 1.2
import bb.cascades.pickers 1.0
import bb.system 1.0

import "../components"
import "../components/buttons"

Sheet 
{
    id: sheet
    
    peekEnabled: false
    
    Page 
    {
        id: page
        
        Container 
        {
//            ImageView 
//            {
//                imageSource: "asset:///media/images/backgrounds/colorful_blur.jpg"
//                scalingMethod: ScalingMethod.AspectFill
//                horizontalAlignment: HorizontalAlignment.Fill
//                verticalAlignment: VerticalAlignment.Fill
//            }
            
            layout: DockLayout {}  
            
            Container 
            {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                
                ImageView 
                {
                    imageSource: "asset:///media/images/icons/icon480.png"
                    horizontalAlignment: HorizontalAlignment.Center
                    maxHeight: 300
                    scalingMethod: ScalingMethod.AspectFit
                }
                
                Container 
                {
                    topPadding: 30
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    Label 
                    {
                        text: "Facebook Messenger"
                        textStyle.fontSize: FontSize.Large
                    }
                    
//                    ImageView 
//                    {
//                        imageSource: "asset:///media/images/icons/logoword1.png"
//                        horizontalAlignment: HorizontalAlignment.Center
//                        maxHeight: 300
//                        scalingMethod: ScalingMethod.AspectFit
//                    }
                }
                
                Container 
                {
                    bottomPadding: 50
                    topPadding: 20
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    Label 
                    {
                        text: "Fast, Beautiful Facebook Messenger Client!"
                        multiline: true
                        textStyle.textAlign: TextAlign.Center
                        textStyle.fontSize: FontSize.XSmall
                        textStyle.fontWeight: FontWeight.W100
                    }
                }
                
                Container 
                {
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    layout: StackLayout 
                    {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    NemButton 
                    {
                        label.text: "Facebook Connect"
                        color: colorBlue
                        solid: false
                        horizontalAlignment: HorizontalAlignment.Fill
                        minWidth: 500
                        
                        onClicked: 
                        {
                            Qt.loginSheet.open();
//                            Qt.loginSheetNative.open();
                        }
                    }
                }
            }
            
            Container 
            {
                id: versions
                horizontalAlignment: HorizontalAlignment.Right
                verticalAlignment: VerticalAlignment.Bottom
                rightPadding: 10
                bottomPadding: 10
                
                Label 
                {
                    text: "Version " + _app.app_version(); 
                    textStyle.fontSize: FontSize.XXSmall
                    textStyle.fontWeight: FontWeight.W100
                    multiline: true
                    bottomMargin: 0
                    horizontalAlignment: HorizontalAlignment.Right
                }
                
                Label 
                {
                    text: "Your OS Version " + _app.os_version(); 
                    textStyle.fontSize: FontSize.XXSmall
                    textStyle.fontWeight: FontWeight.W100
                    multiline: true
                    topMargin: 0
                    horizontalAlignment: HorizontalAlignment.Right
                }
            }
        }
    }
}