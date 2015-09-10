import bb.cascades 1.0
import bb.system 1.0
import nemory.NemAPI 1.0

import "../pages"
import "../sheets"
import "../components"
import "../components/buttons"

Sheet 
{
    id: sheet
    
    property string webURL : "http://translate.google.com/m/translate";
    
    property variant data : new Object();
    
    function load(params)
    {
        data = params.data;
        
        if(!ready)
        {
            Qt.toast.pop("Sorry, Please reload the page. And retry again.");
        }
        else 
        {
            translate();
        }
    }
    
    function translate()
    {
        var script = "document.getElementsByClassName('orig goog-textarea')[0].value = '" + data + "'; document.getElementsByClassName('gp-footer')[0].remove()";
        browser.evaluateJavaScript(script);
    }
    
    onCreationCompleted: 
    {
        browser.url = webURL;
        ready = false;
    }

    property bool ready : false;

    Page 
    {
        id: page
        actionBarVisibility: (_app.get_setting("backButton", "false") == "false" ? ChromeVisibility.Hidden : ChromeVisibility.Default)

        Container 
        {
            layout: DockLayout {}
 
            Container 
            {
                id: mainContainer
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                topPadding: 100
                bottomPadding: 100
                
                ProgressIndicator
                {
                    visible: browser.visible && browser.loading
                    fromValue: 0
                    toValue: 100
                    value: browser.loadProgress
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Bottom
                }
                
                Container 
                {
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    layout: DockLayout {}
                    
                    ScrollView 
                    {
                        id: scrollView
                        horizontalAlignment: HorizontalAlignment.Fill

                        Container 
                        {
                            horizontalAlignment: HorizontalAlignment.Fill

                            WebView
                            {
                                id: browser
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Center
                                minHeight: 1000
                                
                                onLoadingChanged: 
                                {
                                    if(loadRequest.status == WebLoadStatus.Succeeded)
                                    {
                                        ready = true;
                                        
                                        translate();
                                    }
                                }
                            }
                        }
                    }
                    
                    Container 
                    {
                        visible: browser.loading
                        horizontalAlignment: HorizontalAlignment.Right
                        verticalAlignment: VerticalAlignment.Bottom
                        
                        bottomPadding: 20
                        rightPadding: 20
                        
                        onVisibleChanged: 
                        {
                            if(visible)
                            {
                                loadingLogo.play();
                            }
                            else 
                            {
                                loadingLogo.stop();
                            }
                        }
                        
                        layout: DockLayout {}
                        
                        ImageView 
                        {
                            id: loadingLogo
                            imageSource: "asset:///media/images/icons/icon.png" 
                            scalingMethod: ScalingMethod.AspectFit
                            preferredHeight: 50
                            
                            animations: 
                            [
                                FadeTransition 
                                {
                                    id: fadeAnimation
                                    duration: 1000
                                    repeatCount: 99999999
                                    toOpacity: 1.0
                                    fromOpacity: 0.3
                                    easingCurve: StockCurve.Linear
                                    
                                    onStopped: 
                                    {
                                        loadingLogo.resetOpacity();
                                    }
                                },
                                ScaleTransition 
                                {
                                    id: scaleAnimation
                                    duration: 1000
                                    repeatCount: 99999999
                                    toX: 1.0
                                    toY: 1.0
                                    fromX: 0.7
                                    fromY: 0.7
                                    easingCurve: StockCurve.BounceInOut
                                    
                                    onStopped: 
                                    {
                                        loadingLogo.resetScale();
                                    }
                                }
                            ]
                            
                            function play()
                            {
                                loadingLogo.visible = true;
                                fadeAnimation.play();
                                scaleAnimation.play();
                            }
                            
                            function stop()
                            {
                                loadingLogo.visible = false;
                                fadeAnimation.stop();
                                scaleAnimation.stop();
                            }
                        }
                    }
                }
            }
        }
    }
}