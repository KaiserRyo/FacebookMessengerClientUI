import bb.cascades 1.0
import nemory.NemAPI 1.0
import nemory.WebImageView 1.0
import bb.cascades.maps 1.0
import bb.system 1.0
import nemory.ParseAPI 1.0
import nemory.TrialAPI 1.0

import "../components"
import "../sheets"

Page 
{
    id: page
     

    function load(params)
    {
        Qt.app.flurryLogEvent("accounts_page");
    }
    
    function scrollReady()
    {
        listView.repopulate();
    }
    
    titleBar: CustomTitleBar 
    {
        id: titleBar
        label_title.text: "ACCOUNTS"
        image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"
        image_right.defaultImageSource: "asset:///media/images/instagram/nav_new.png"
        
        onLeftButtonClicked: 
        {
            Qt.navigationPane.pop();
        }
        
        onRightButtonClicked: 
        {
            if(Qt.has_pro_access())
            {
                loginSheet.open();
            }
            else 
            {
                Qt.dialog.pop("Pro Upgrade Required", "Add Unlimited Multiple Accounts and access all other great features.");
                Qt.proSheet.open();
            }
        }
    }
    
    attachedObjects: 
    [
        LoginSheet
        {
            id: loginSheet
            
            onLoggedIn: 
            {
                listView.repopulate();
                
                Qt.pageMessages.clearDataModel();
                Qt.pageMessages.load();
                
                Qt.pageFriends.clearDataModel();
                Qt.pageFriends.load();
                
                Qt.pageFavorites.clearDataModel();
                Qt.pageFavorites.load();
            }
        }
    ]
    
    Container 
    {
        id: mainContainer
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        layout: DockLayout {}
        
        ImageView 
        {
            id: wallpaper
            imageSource: _app._wallpaper
            scalingMethod: ScalingMethod.AspectFill
            opacity: 0.5
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
        }
        
        Container 
        {
            id: content
            topPadding: 20
            bottomPadding: 100
            leftPadding: 30
            rightPadding: 30
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            Header 
            {
                title: "How to Logout or Switch Active Account?"
            }
            
            Label 
            {
                text: "Tap and hold the <b>Account Item</b> then press <b>Remove</b> or <b>Set Active</b>"
                textStyle.color: Color.DarkGray
                textStyle.fontSize: FontSize.XSmall
                textFormat: TextFormat.Html
                textStyle.fontStyle: FontStyle.Italic
                multiline: true
            }
            
            Divider 
            {
                bottomMargin: 0
            }
        
            PullToRefreshListView 
            {
                id: listView
                horizontalAlignment: HorizontalAlignment.Fill
                snapMode: SnapMode.Default
                pullToRefresh: false
                
                dataModel: ArrayDataModel 
                {
                    id: dataModel
                }
                
                onScrolledDown: 
                {
                    titleBar.fadeOut();
                }
                
                onScrolledUp: 
                {
                    titleBar.fadeIn();
                }

                listItemComponents: 
                [
                    ListItemComponent 
                    {
                        content: AccountItem 
                        {
                            id: rootAccountItem
                        }
                    }
                ]
                
                onTriggered: 
                {
                    var item = dataModel.data(indexPath);
                    
                    var page = Qt.profileComponent.createObject();
                    page.load(item);
                    Qt.navigationPane.push(page);
                }
                
                function repopulate()
                {
                    dataModel.clear();
                    dataModel.insert(0, Qt.configuration.accounts);
                }
            }
        }
    }
}