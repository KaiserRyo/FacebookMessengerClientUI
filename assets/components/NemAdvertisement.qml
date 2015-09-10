import bb.cascades 1.2
import nemory.WebImageView 1.0
import QtQuick 1.0

Container 
{
    preferredHeight: 120
    maxHeight: preferredHeight
    minHeight: preferredHeight
    visible: false
    horizontalAlignment: HorizontalAlignment.Fill
    
    property variant animationDirection: LayoutOrientation.TopToBottom
    property int evolutionInterval: 3
    
    layout: DockLayout {}

    PullToRefreshListView 
    {
        id: listView
        snapMode: SnapMode.LeadingEdge
        flickMode: FlickMode.SingleItem
        stickToEdgePolicy: ListViewStickToEdgePolicy.Beginning
        preferredHeight: 120
        maxHeight: preferredHeight
        minHeight: preferredHeight
        horizontalAlignment: HorizontalAlignment.Fill
        pullToRefresh: false
        
        dataModel: ArrayDataModel 
        {
            id: dataModel
        }
        
        layout: StackListLayout 
        {
            orientation: animationDirection
        }
        
        listItemComponents: 
        [
            ListItemComponent 
            {
                content: AdvertisementItem 
                {
                    id: rootAdvertisement
                    minWidth: Qt.app.getDisplayWidth();
                }
            }
        ]
        
        onTriggered: 
        {
            var item = dataModel.data(indexPath);
            
            if(item.type == "link")
            {
                Qt.invokeBrowser.open(item.data);
            }
            else if(item.type == "text")
            {
                Qt.dialog.pop(item.title, item.data);
            }
            else if(item.type == "bbworld")
            {
                Qt.app.invokeBBWorld(item.data);
            }
            else if(item.type == "Messengeruri")
            {
                Qt.openURI(item.data);
            }
        }
    }
    
    Container 
    {
        horizontalAlignment: HorizontalAlignment.Right
        rightPadding: 10
        topPadding: 10
        
        ImageButton 
        {
            defaultImageSource: "asset:///media/images/icons/x.png"
            maxWidth: 200
            
            onClicked: 
            {
                Qt.dialog.pop("Remove Advertisements", "Upgrade now and remove the ads as well as access all the great features.");
                Qt.proSheet.open();
            }
        }
    }
    
    onCreationCompleted: 
    {
        if(Qt.nemory_ads && Qt.nemory_ads.length > 0 && !Qt.has_pro_access())
        {
            visible = true;
            
            var ads_array = shuffle(Qt.nemory_ads);
            
            dataModel.insert(0, Qt.nemory_ads);
            
            adsEvolutionTimer.start();
        }
    }
    
    function shuffle(array) 
    {
        var currentIndex = array.length, temporaryValue, randomIndex ;
        
        // While there remain elements to shuffle...
        while (0 !== currentIndex) 
        {
            // Pick a remaining element...
            randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex -= 1;
            
            // And swap it with the current element.
            temporaryValue = array[currentIndex];
            array[currentIndex] = array[randomIndex];
            array[randomIndex] = temporaryValue;
        }
        
        return array;
    }
    
    attachedObjects: 
    [
        Timer
        {
            id: adsEvolutionTimer
            repeat: true
            interval: (evolutionInterval * 1000)
            property int currentIndex : 0;
            
            onTriggered: 
            {
                var indexPath = new Array();
                indexPath[0] = currentIndex;
                
                listView.scrollToItem(indexPath);
                
                if(currentIndex > dataModel.size())
                {
                    currentIndex = 0;
                }
                
                currentIndex++;
            }
        }
    ]
}