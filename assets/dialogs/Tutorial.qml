import bb.cascades 1.0
import nemory.NemAPI 1.0

import "../components/buttons"
import "../components/toggles"
import "../sheets"

Dialog 
{
    property variant data : new Object();

    Container 
    {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        background: Color.create("#dd000000")
        
        layout: DockLayout {}
        
        ScrollView 
        {
            horizontalAlignment: HorizontalAlignment.Center
            
            Container 
            {
                topPadding: 50
                bottomPadding: 50
                rightPadding: 50
                leftPadding: 50
                horizontalAlignment: HorizontalAlignment.Center

                Label 
                {
                    text: "This is the tutorial page in the works"
                    textStyle.color: Color.White
                    multiline: true
                }
                
                Container
                {
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    layout: StackLayout 
                    {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label 
                    {
                        text: "Always show on start up"
                        textStyle.color: Color.Gray
                    }
                    
                    CheckBox 
                    {
                        checked: (_app.get_setting("showTutorial", "true") == "true")
                        
                        onCheckedChanged: 
                        {
                            _app.set_setting("showTutorial", checked);
                        }
                    }
                }
            }
        }
        
        Container 
        {
            topPadding: 20
            rightPadding: 20
            horizontalAlignment: HorizontalAlignment.Right
            verticalAlignment: VerticalAlignment.Top
            
            NemButton
            {
                image.imageSource: "asset:///media/images/icons/x.png"

                onClicked: 
                {
                    close();
                }
            }
        }
    }
}