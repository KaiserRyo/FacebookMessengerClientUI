import bb.cascades 1.0

import "../components"

Dialog 
{
    id: dialog
    property variant actions : new Array();
    
    signal actionTriggered(variant data);
    
    function load(data)
    {
        dataModel.clear();
        dataModel.insert(0, data);
        listView.maxHeight = dataModel.size() * (105 + (_app._is_passport ? 30 : 0));
    }
    
    onOpened: 
    {
        playIn();
    }
    
    onClosed: 
    {
        playOut();
    }
    
    function playIn()
    {
        amdBackground.opacity = 1.0;
        amdBackground.scaleX = 1.0;
        amdBackground.scaleY = 1.0;
    }
    
    function playOut()
    {
        amdBackground.opacity = 0.2;
        amdBackground.scaleX = 0.5;
        amdBackground.scaleY = 0.5;
    }

    Container 
    {
        id: main_container
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        background: Color.create("#66000000")
        
        layout: DockLayout {}
        
        gestureHandlers: TapHandler 
        {
            onTapped: 
            {
                dialog.close();
            }
        }
        
        Container 
        {
            horizontalAlignment: HorizontalAlignment.Right
            verticalAlignment: VerticalAlignment.Top
            
            topPadding: 20
            rightPadding: 20
            
            ImageButton 
            {
                defaultImageSource: "asset:///media/images/icons/x.png"
                
                onClicked: 
                {
                    playOut();
                    dialog.close();
                }
            }
        }

        Container 
        {
            id: amdBackground
            scaleX: 0.5
            scaleY: 0.5
            opacity: 0.2
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            layout: DockLayout {}
            
            ImageView 
            {
                id: imageButtonObject
                imageSource: "asset:///components/buttons/ButtonWhiteSolid.amd"
                scalingMethod: ScalingMethod.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
            }
            
            Container 
            {
                id: contentObject
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                leftPadding: 30
                maxWidth: (_app._is_passport ? 1000 : 600)
                
                PullToRefreshListView 
                {
                    id: listView
                    verticalAlignment: VerticalAlignment.Center
                    snapMode: SnapMode.Default
                    pullToRefresh: false
                    
                    dataModel: ArrayDataModel
                    {
                        id: dataModel
                    }
                    
                    listItemComponents:
                    [
                        ListItemComponent
                        {
                            content: ContextMenuItem 
                            {
                                id: rootUser
                            }
                        }
                    ]
                    
                    onTriggered: 
                    {
                        var action = dataModel.data(indexPath);
                        actionTriggered(action);
                    }
                }
            }
        }
    }
}