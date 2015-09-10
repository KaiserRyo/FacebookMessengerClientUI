import bb.cascades 1.0
import nemory.NemAPI 1.0

import "../components/"

Sheet 
{
	id: sheet
	
    property string client_id : "onynn35vjn22nq8";
	
	onOpened: 
	{
        _app.flurryLogEvent("dropbox_auth");
        
        Qt.toast.pop("Sign In to DropBox first before you can attach & send files.");
        
        firstWebView.url = "https://www.dropbox.com/1/oauth2/authorize?client_id="+client_id+"&response_type=token&redirect_uri=http://localhost";
    }
	
    Page 
    {
        titleBar: TitleBar
        {
            title: "Dropbox Authentication"
        }
        
        Container 
        {
            id: mainContainer
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            Container 
            {
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                layout: DockLayout {}
                
                ScrollView 
                {
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    Container 
                    {
                        horizontalAlignment: HorizontalAlignment.Fill

                        WebView
                        {
                            id: firstWebView
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Center
                            minHeight: 1000
                            
                            onNavigationRequested:
                            {
                                console.log("URL : " + request.url)
                                
                                if(_app.contains(request.url, "http://localhost/#access_token="))
                                {
                                    var access_token 	= _app.regex(request.url, "access_token=(.*)&token_type", 1);
                                    var uid 			= _app.regex(request.url, "uid=(.*)", 1);
                                    
                                    _app.set_setting("dropboxAccessToken", access_token);
                                    _app.set_setting("dropboxUID", uid);
                                    
                                    var params 			= new Object();
                                    params.url 			= "https://api.dropbox.com/1/fileops/create_folder?root=dropbox&path=/TwittlyUploads/&access_token=" + access_token;
                                    params.endpoint 	= "dropboxCreateFolder";
                                    Qt.nemAPI.getRequest(params);
                                    
                                    sheet.close();
                                    
                                    Qt.toast.pop("Successfully Authenticated :) We created a folder: TwittlyUploads for uploading files.");
                                } 
                            }
                        }
                    }
                }
                
                Container 
                {
                    visible: firstWebView.loading
                    horizontalAlignment: HorizontalAlignment.Right
                    verticalAlignment: VerticalAlignment.Bottom
                    preferredHeight: 100
                    preferredWidth: 100
                    
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
        
        actions: 
        [
            ActionItem 
            {
                title: "Close"
                imageSource: "asset:///media/images/icons/x.png"
                
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: 
                {
                    sheet.close();
                }    
            },
            ActionItem 
            {
                title: "Refresh"
                imageSource: "asset:///media/images/icons/refresh.png"
                
                onTriggered: 
                {
                    firstWebView.reload();
                }    
            },
            ActionItem 
            {
                title: "Clear Browser Data"
                imageSource: "asset:///media/images/icons/x.png"
                
                onTriggered: 
                {
                    firstWebView.storage.clear();
                    
                    firstWebView.reload();
                }
            }
        ]
    }
}