import bb.cascades 1.2
import nemory.WebImageView 1.0

CustomListItem 
//Container
{
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    dividerVisible: false
    
    Container
    {
        id: mainContainer
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        layout: DockLayout {}
        leftPadding: 20
        rightPadding: leftPadding
 
        Container
        {
            horizontalAlignment: HorizontalAlignment.Left
            
            layout: StackLayout
            {
                orientation: LayoutOrientation.LeftToRight
            }
            
            WebImageView 
            {
                visible: !ListItemData.is_dir
                url: "https://api-content.dropbox.com/1/thumbnails/"+ListItemData.root+ListItemData.path+"?access_token=" + Qt.nemData.get_setting("dropboxAccessToken", "")
                defaultImage: "asset:///images/dropbox/loading.png"
                preferredHeight: 100
                preferredWidth: preferredHeight
                scalingMethod: ScalingMethod.AspectFit
            }
            
            ImageView 
            {
                visible: ListItemData.is_dir
                imageSource: "asset:///images/dropbox/folder_42.png"
                preferredHeight: 100
                preferredWidth: preferredHeight
                scalingMethod: ScalingMethod.AspectFit
            }
            
            Container 
            {
                id: contactNameChatContainer
                leftPadding: 20
                verticalAlignment: VerticalAlignment.Center
                
                layoutProperties: StackLayoutProperties 
                {
                    spaceQuota: 4
                }
                
                Container 
                {
                    layout: DockLayout {}
                    
                    Label 
                    {
                        text: baseName(ListItemData.path);
                        textStyle.fontWeight: FontWeight.W100
                    }
                }
            }
        }
    }
    
    contextActions: 
    [
        ActionSet 
        {
            title: "File Actions"
            
            ActionItem 
            {
                title: "Fetch Direct URL"
                imageSource: "asset:///images/ic_to_bottom.png"
                onTriggered: 
                {
                    Qt.toast.pop("Fetching Direct URL for: "+ListItemData.path+"...");
                    var params 			= new Object();
                    params.url 			= "https://api.dropbox.com/1/shares/dropbox/"+ListItemData.path+"?access_token=" + Qt.nemData.get_setting("dropboxAccessToken", "");
                    params.endpoint 	= "getDropBoxDirectLink";
                    Qt.nemory.getRequest(params);
                }
            }
        }
    ]
    
    function baseName(str)
    {
        var base = new String(str).substring(str.lastIndexOf('/') + 1); 
        return base;
    }
}