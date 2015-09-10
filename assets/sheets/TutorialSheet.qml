import bb.cascades 1.0

import "../components"
import nemory.ParseAPI 1.0
import bb.system 1.2

Sheet 
{
    id: sheet
    
    onOpened: 
    {
        dataModel.clear();
        
        parseAPI.load();
    }

    Page 
    {
        id: page

        Container 
        {
            id: main_container
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            background: Color.Black
            
            layout: DockLayout {}
            
            ListView 
            {
                id: listView
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                snapMode: SnapMode.LeadingEdge
                flickMode: FlickMode.SingleItem
                stickToEdgePolicy: ListViewStickToEdgePolicy.Beginning
                preferredHeight: Qt.app.get_display_height()
                maxHeight: Qt.app.get_display_height()
                
                dataModel: ArrayDataModel
                {
                    id: dataModel
                }

                listItemComponents:
                [
                    ListItemComponent
                    {
                        content: TutorialItem 
                        {
                            id: rootTutorial
                            minHeight: Qt.app.get_display_height()
                            image_height: (Qt.app._is_passport ? 400 : 200)
                            image_width: (Qt.app._is_passport ? 1300 : 700)
                            text_font_size: (Qt.app.device() == "q10" ? FontSize.XSmall : FontSize.Medium)
                        }
                    }
                ]

                onTriggered: 
                {
                    var item = dataModel.data(indexPath);
                    
                    if(item.last)
                    {
                        Qt.app.set_setting("showTutorial", false);
                        sheet.close();
                    }
                    else 
                    {
                        var next_index_path      = (indexPath[0] + 1);
                        
                        var next_index_pathArray = new Array();
                        next_index_pathArray[0]  = next_index_path;
                        
                        if(next_index_path < dataModel.size())
                        {
                            listView.scrollToItem(next_index_pathArray, ScrollAnimation.Default);
                        }
                    }
                }
            }
            
            Container 
            {
                id: loading_container
                visible: false
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                
                Container 
                {
                    layout: StackLayout 
                    {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label 
                    {
                        text: "loading..."
                        textStyle.fontStyle: FontStyle.Italic
                        textStyle.color: Color.White
                    }
                    
                    ActivityIndicator 
                    {
                        running: loading_container.visible
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Center
                    }
                }
            }
            
            Container 
            {
                horizontalAlignment: HorizontalAlignment.Right
                verticalAlignment: VerticalAlignment.Bottom
                rightPadding: 20
                bottomPadding: 20
                opacity: 0.6
                
                ImageButton 
                {
                    defaultImageSource: "asset:///media/images/icons/x.png"
                    maxWidth: 200
                    
                    onClicked: 
                    {
                        sureDialog.show();
                    }
                    
                    attachedObjects: 
                    [
                        SystemDialog 
                        {
                            id: sureDialog
                            title: "Attention"
                            body: "Are you sure you want to skip tutorials?\n\nThis tutorial will help you get started quickly."
                            cancelButton.label: "Cancel"
                            confirmButton.label: "Skip"
                            onFinished: 
                            {
                                if(buttonSelection().label == "Skip")
                                {
                                    Qt.app.set_setting("showTutorial", false);
                                    sheet.close();
                                }
                                
                                cancel();
                            }
                        }
                    ]
                }
            }
        }
    }
    
    attachedObjects: 
    [
        ParseAPI 
        {
            id: parseAPI
            
            function load()
            {
                var params         = new Object();
                params.endpoint    = "functions/tutorials";
                params.data        = "";
                parseAPI.post(params);
                
                loading_container.visible = true;
            }
            
            onComplete: 
            {
                console.log("**** TUTORIAL endpoint: " + endpoint + ", httpcode: " + httpcode + ", response: " + response);
                
                if(httpcode != 200)
                {
                    Qt.app.flurryLogError(httpcode + " - " + endpoint + " - " + response);
                    
                    Qt.toast.pop("Tutorials failed to load.");
                    sheet.close();
                }
                else 
                {
                    var responseJSON = JSON.parse(response);
                    
                    if(endpoint == "functions/tutorials")
                    {
                        Qt.app.set_string_to_file(response, "data/tutorials.json");
                        
                        console.log("responseJSON.result: " + responseJSON.result.length);
                        
                        dataModel.clear();
                        
                        if(responseJSON.result && responseJSON.result.length > 0)
                        {
                            dataModel.insert(0, responseJSON.result);
                        }
                        
                        loading_container.visible = false;
                    }
                }
            }
        }
    ]
}