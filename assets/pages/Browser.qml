import bb.cascades 1.0
import bb.system 1.0
import nemory.NemAPI 1.0

import "../pages"
import "../sheets"
import "../components"
import "../components/buttons"

Page 
{
    id: page
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    
    function scrollReady()
    {
        if (_app._is_passport) 
        {
            scrollView.requestFocus()
        } 
    }

    function load(params)
    {
        browser.url = params.url;
        
        Qt.toast.pop("Loading: " + params.url);
    }
    
    titleBar: CustomTitleBar 
    {
        id: titleBar
        label_title.text: Qt.app.app_name().toUpperCase() + " BROWSER"
        image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"

        onLeftButtonClicked: 
        {
            Qt.navigationPane.pop();
        }
    }
    
    ScrollView 
    {
        id: scrollView
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        scrollViewProperties 
        {
            scrollMode: ScrollMode.Both
            pinchToZoomEnabled: true
        }
        
        Container 
        {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            layout: DockLayout {}
            
            WebView
            {
                id: browser
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                minHeight: 1000
                
                onMinContentScaleChanged: 
                {
                    scrollView.scrollViewProperties.minContentScale = minContentScale;
                }
                
                onMaxContentScaleChanged: 
                {
                    scrollView.scrollViewProperties.maxContentScale = maxContentScale;
                }
            }
            
            ProgressIndicator
            {
                visible: browser.visible && browser.loading
                fromValue: 0
                toValue: 100
                value: browser.loadProgress
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Bottom
            }
        }
    }
    
    actions: 
    [
        ActionItem 
        {
            title: "Back"
            enabled: browser.canGoBack
            imageSource: "asset:///media/images/instagram/nav_arrow_back.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: 
            {
                browser.goBack();
            }
        },
        ActionItem 
        {
            title: "Refresh"
            imageSource: "asset:///media/images/instagram/nav_refresh.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: 
            {
                browser.reload();
            }
        },
        ActionItem 
        {
            title: "Forward"
            enabled: browser.canGoForward
            imageSource: "asset:///media/images/instagram/nav_arrow_next.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: 
            {
                browser.goBack();
            }
        }
    ]
}