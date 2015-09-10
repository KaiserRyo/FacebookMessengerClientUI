import bb.cascades 1.0
import nemory.NemAPI 1.0
import nemory.WebImageView 1.0

import "../components"
import "../dialogs"
import "../sheets"

NavigationPane 
{
    id: navigationPane
    
    signal loaded();
    
    onPushTransitionEnded: 
    {
        page.scrollReady();    
    }
    
    onPopTransitionEnded: 
    {
        page.destroy();
    }
    
    function tabActivated()
    {
        Qt.navigationPane = navigationPane;
        
        scrollReady();
        
        listView.populate();
    }
    
    function tabDeactivated()
    {
    
    }
    
    function reload()
    {
        listView.populate();
    }
    
    function scrollReady()
    {
        if (_app._is_passport) 
        {
            listView.requestFocus();
        }
    }
    
    function load()
    {
        listView.populate();
    }
    
    function clearDataModel()
    {
        dataModel.clear();
    }

    Page 
    {
        id: the_page
        
        titleBar: CustomTitleBar 
        {
            id: titleBar
            label_title.text: "FAVORITES";
            label_title.translationX: -20
            image_left.visible: false

            onLabelTitleClicked: 
            {
                listView.scrollToTop();
            }
            
            onLeftButtonClicked: 
            {
                listView.scrollToTop();
            }
        }

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
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                RateUs 
                {
                    id: rate_us
                }

                PullToRefreshListView 
                {
                    id: listView
                    horizontalAlignment: HorizontalAlignment.Fill
                    snapMode: ( (_app.get_setting("leading_edge_scrolling", "false") == "true") ? SnapMode.LeadingEdge : SnapMode.Default)
                    pullToRefresh: false
                    
                    dataModel: ArrayDataModel 
                    {
                        id: dataModel
                    }
                    
                    listItemComponents: 
                    [
                        ListItemComponent 
                        {
                            content: FavoriteItem 
                            {
                                id: rootFavorite
                            }
                        }
                    ]
                    
                    onScrolledDown: 
                    {
                        titleBar.fadeOut();
                        mainTabs.fadeOut();
                    }
                    
                    onScrolledUp: 
                    {
                        titleBar.fadeIn();
                        mainTabs.fadeIn();
                    }
                    
                    function populate()
                    {
                        dataModel.clear();
                        
                        if(Qt.configuration.settings.active_user.favorites && Qt.configuration.settings.active_user.favorites.length > 0)
                        {
                            dataModel.append(Qt.configuration.settings.active_user.favorites);
                        }
                        
                        if(dataModel.size() == 0)
                        {
                            zeroResults.visible = true;
                        }
                        else 
                        {
                            zeroResults.visible = false;
                        }
                    }
                }
            }
            
            MainTabs 
            {
                id: mainTabs
                activeTab: "tabFavorites"
                
                onClicked: 
                {
                    if(tab == activeTab)
                    {
                        listView.scrollToTop();
                    }    
                }
            }
            
            Container 
            {
                background: Color.create("#ff8a00")
                preferredHeight: 30
                horizontalAlignment: HorizontalAlignment.Fill
                visible: !_app._connected
                
                Label
                {
                    text: "Connecting..."
                    textStyle.fontSize: FontSize.XXSmall
                    textStyle.color: Color.White
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }

            ActivityIndicator 
            {
                id: loadingIndicator
                visible: listView.refreshing    
                running: visible
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
            
            Label 
            {
                id: zeroResults
                visible: false
                text: "0 Results"
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XXSmall
            }
        }
    }
    
    shortcuts: 
    [
        SystemShortcut 
        {
            type: SystemShortcuts.JumpToBottom // BOTTOM
            
            onTriggered: 
            {
                listView.scrollToBottom();
            }
        },
        SystemShortcut 
        {
            type: SystemShortcuts.JumpToTop // TOP
            
            onTriggered: 
            {
                listView.scrollToTop();
            }
        },
        SystemShortcut 
        {
            type: SystemShortcuts.Forward // FILTER
            
            onTriggered: 
            {
                
            }
        },
        SystemShortcut 
        {
            type: SystemShortcuts.Reply // REFRESH
            
            onTriggered: 
            {
                navigationPane.load("");
            }
        }
    ]
}