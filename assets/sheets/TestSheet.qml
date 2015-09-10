import bb.cascades 1.0
import "../components"
import nemory.NemAPI 1.0

Sheet 
{
    id: sheet

    Page 
    {
        id: page   
        
        titleBar: CustomTitleBar 
        {
            id: titleBar
            label_title.text: "TEST SHEET"
            image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"
            image_right.visible: false
            
            onLeftButtonClicked: 
            {
               sheet.close();
            }
        }
        
        Container 
        {
            id: main_container
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            Button 
            {
                text: "TEST"
                
                onClicked: 
                {
                    nemAPI.login_natively("nemoryoliver", "DhjkLmnOP2{}3");
                }
                
                attachedObjects: 
                [
                    NemAPI
                    {
                        id: nemAPI
                    }
                ]
            }
        }
    }
}