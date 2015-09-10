import bb.cascades 1.0
import bb.data 1.0
import bb.cascades.pickers 1.0
import nemory.NemAPI 1.0
import bb.system 1.0

import "../components/"

Page 
{
    id: page

    function scrollReady()
    {
        if (isPassport) 
        {
            listView.requestFocus()
        } 
    }
    
    property bool isPassport : _app._is_passport();
	property string currentPath : "";
	property bool autoClose : false;
	property string uploadFile : "";

    signal stopLoading();
    signal startLoading();
    signal scrollDown();
    signal scrollUp();
    
    titleBar: CustomTitleBar 
    {
        id: titleBar
        label_title.text: "DROPBOX PICKER"
        image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"
        image_right.visible: false
        
        onLeftButtonClicked: 
        {
            Qt.navigationPane.pop();
        }
    }
    
    paneProperties: NavigationPaneProperties 
    {
        backButton: ActionItem 
        {
            title: "Back"
            onTriggered: 
            {
                if(uploadingIndicator.visible)
                {
                    stopPrompt.show();
                }
                else 
                {
                    navigationPane.pop();
                }
            }
        }
    }

    onStartLoading: 
    {
        loadingContainer.visible = true;
    }
    
    onStopLoading: 
    {
        listView.stopRefreshing();
        
        loadingContainer.visible = false;
    }
    
    onScrollDown: 
    {
        listView.scrollToPosition(ScrollPosition.End, ScrollAnimation.Smooth)
    }
    
    onScrollUp: 
    {
        listView.scrollToPosition(ScrollPosition.Beginning, ScrollAnimation.Smooth)
    }
    
    function upload(file)
    {
        uploadFile = file;
        
        var baseFileName = baseName(uploadFile);
        
        uploadingIndicator.visible = true;
        uploadingIndicator.uploadingFileName = baseFileName;
        
        if(!_app.contains(currentPath, "dropbox"))
        {
            currentPath = "dropbox" + currentPath;
        }
        
        var params 			= new Object();
        params.url			= "https://api-content.dropbox.com/1/files_put/"+currentPath+"/"+baseFileName+"?access_token=" + _app.get_setting("dropboxAccessToken", "") + "&overwrite=false";
        params.filename		= uploadFile;
        params.basefilename	= baseFileName;
        params.endpoint		= "dropboxUpload";
        uploader.uploadDropBox(params);
    }
    
    function setAutoClose(value)
    {
        autoClose = value;
    }
    
    function setCurrentPath(path)
    {
        currentPath = path;
    }
    
    function load(path)
    {
        var dropboxURL = "https://api.dropbox.com/1/metadata/" + path + "?access_token=" + _app.get_setting("dropboxAccessToken", "");
        dataSource.source = dropboxURL;
        dataSource.load();
        
        startLoading();
    }
    
    shortcuts: 
    [
        SystemShortcut 
        {
            type: SystemShortcuts.JumpToBottom
            onTriggered: 
            {
                scrollDown();
            }
        },
        SystemShortcut
        {
            type: SystemShortcuts.JumpToTop
            onTriggered: 
            {
                scrollUp();
            }
        }
    ]
    
    Container 
    {
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        layout: DockLayout {}
        
        ImageView 
        {
            id: wallpaper
            imageSource: _app._wallpaper
            scalingMethod: ScalingMethod.AspectFill
            opacity: 0.5
        }
        
        gestureHandlers: 
        [
            PinchHandler 
            {
                onPinchEnded: 
                {
                    Qt.triggeredGestureAction();
                }
            }
        ]
        
        Container 
        {
            id: stackContainer
            verticalAlignment: VerticalAlignment.Fill
            
            UploadingFakeItem 
            {
                id: uploadingIndicator
                visible: false
                uploadingFileName: ""
                onVisibleChanged: 
                {
                    if(visible)
                    {
                        startAnimations();
                    }
                    else 
                    {
                        stopAnimations();
                    }
                }
            }
            
            Header 
            {
                title: "Current Path"
                subtitle: currentPath
            }
            
            PullToRefreshListView 
            {
                id: listView
                dataModel: theDataModel
                horizontalAlignment: HorizontalAlignment.Fill
                snapMode: SnapMode.Default
                
                listItemComponents: 
                [
                    ListItemComponent 
                    {
                        FileItem 
                        {
                            id: root
                        }
                    }
                ]
                
                onTriggered: 
                {
                    var selectedItem = dataModel.data(indexPath);
                    
                    if(selectedItem.is_dir)
                    {
                        var dropboxPickerComponent 		= Qt.dropboxPickerComponent.createObject();
                        dropboxPickerComponent.load("dropbox" + selectedItem.path);
                        dropboxPickerComponent.setCurrentPath(selectedItem.path);
                        navigationPane.push(dropboxPickerComponent);
                    }
                    else
                    {
                        Qt.toast.pop("Fetching Direct URL for: "+selectedItem.path+"...");
                        var params 			= new Object();
                        params.url 			= "https://api.dropbox.com/1/shares/dropbox/"+selectedItem.path+"?access_token=" + _app.get_setting("dropboxAccessToken", "");
                        params.endpoint 	= "getDropBoxDirectLink";
                        uploader.getRequest(params);
                    }
                }
                
                attachedObjects: 
                [
                    ListScrollStateHandler 
                    {
                        id: scrollStateHandler
                    },
                    DataSource
                    {
                        id: dataSource
                        remote: true
                        type: DataSourceType.Json
                        onDataLoaded: 
                        {
                            stopLoading();
                            theDataModel.clear();
                            
                            if(data.contents.length >= 10)
                            {
                                data.contents[0].advertisement = true;
                            }
                            
                        	theDataModel.insert(0, data.contents);   
                        }
                    },
                    ArrayDataModel
                    {
                        id: theDataModel
                    }
                ]
                
                function refreshTriggered()
                {
                    dataSource.load();
                    
                    startLoading();
                }
            }
        }
        
        Container 
        {
            id: loadingContainer
            visible: false
            horizontalAlignment: HorizontalAlignment.Right
            verticalAlignment: VerticalAlignment.Bottom
            
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
            
            ImageView 
            {
                id: loadingLogo
                imageSource: "asset:///media/images/icons/114.png"
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
        
        Container 
        {
            id: jumpButtons
            opacity: 0.5
            horizontalAlignment: HorizontalAlignment.Right
            verticalAlignment: VerticalAlignment.Center
            rightPadding: 20
            visible: scrollStateHandler.scrolling && _app.get_setting("floatingButtons", "true") == "true"
            
            ImageButton
            {
                defaultImageSource: "asset:///media/images/icons/jumpToTop.png"
                verticalAlignment: VerticalAlignment.Center
                
                onClicked: 
                {
                    listView.scrollToPosition(ScrollPosition.Beginning, ScrollAnimation.Smooth)
                }
            }
            
            ImageButton
            {
                defaultImageSource: "asset:///media/images/icons/jumpToBottom.png"
                verticalAlignment: VerticalAlignment.Center
                
                onClicked: 
                {
                    listView.scrollToPosition(ScrollPosition.End, ScrollAnimation.Smooth)
                }
            }
        }
    }
    
    actions:
    [
        ActionItem 
        {
            title: (!uploadingIndicator.visible ? "Upload" : "Uploading...")
            enabled: !uploadingIndicator.visible
            imageSource: "asset:///media/images/icons/attach.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: 
            {
                filePicker.open();
            }
        },
        ActionItem
        {
            title: "Refresh"
            imageSource: "asset:///media/images/icons/refresh.png"
            onTriggered: 
            {
                listView.refreshTriggered();
            }
        },
        ActionItem
        {
            title: "Disconnect Dropbox"
            imageSource: "asset:///media/images/icons/x.png"
            onTriggered: 
            {
                _app.set_setting("dropboxAccessToken", "");
                
                navigationPane.pop();
            }
        }
    ]
    
    attachedObjects: 
    [
        FilePicker
        {
            id: filePicker
            onFileSelected: 
            {
                var baseFileName = baseName(selectedFiles[0]);
                
                uploadingIndicator.visible = true;
                uploadingIndicator.uploadingFileName = baseFileName;
                
                if(!_app.contains(currentPath, "dropbox"))
                {
                    currentPath = "dropbox" + currentPath;
                }
                
                var params 			= new Object();
                params.url			= "https://api-content.dropbox.com/1/files_put/"+currentPath+"/"+baseFileName+"?access_token=" + _app.get_setting("dropboxAccessToken", "") + "&overwrite=false";
                params.filename		= selectedFiles[0];
                params.basefilename	= baseFileName;
                params.endpoint		= "dropboxUpload";
                uploader.uploadDropBox(params);
                
                console.log("UPLOAD URL: " + params.url)
            }
        },
        NemAPI
        {
            id: uploader
            
            onComplete: 
            {
                if(Qt.soundEffects)
                {
                    Qt.mediaPlayer.loaded();
                }
                
                if(Qt.ledIndicator)
                {
                    Qt.led.lit();
                }
                
                console.log("UPLOADER - " + httpcode + " - " + endpoint + " - " + response);
                
                if(httpcode == 200)
                {
                    if(endpoint == "getDropBoxDirectLink")
                    {
                        if(Qt.has_pro_access())
                        {
                            console.log(response);
                            var responseJSON = JSON.parse(response);
                            Qt.app.copyToClipboard(responseJSON.url);
                            Qt.toast.pop("Direct URL Copied to Clipboard. :)");
                            
                            Qt.clipboard = responseJSON.url;
                            
                            if(autoClose)
                            {
                                navigationPane.pop();
                            }
                        }
                        else 
                        {
                            Qt.dialog.pop("Pro Upgrade Required", "Sending a Cloud Attachment is only available to PRO Users. Upgrade now and access all the great features.");
                            Qt.proSheet.open();
                        }
                        
                        uploadingIndicator.visible = false;
                    }
                    else if(endpoint == "dropboxUpload")
                    {
                        if(!_app.contains(currentPath, "dropbox"))
                        {
                            currentPath = "dropbox" + currentPath;
                        }
                        
                        var responseJSON 	= JSON.parse(response);
                        var filePath 		= responseJSON.path;
                        
                        Qt.toast.pop("Upload Successful. :) Fetching direct link...");
                        var params 			= new Object();
                        params.url 			= "https://api.dropbox.com/1/shares/dropbox"+filePath+"?access_token=" + _app.get_setting("dropboxAccessToken", "");
                        params.endpoint 	= "getDropBoxDirectLink";
                        uploader.getRequest(params);
                        
                        console.log("FETCH URL: " + params.url)
                    }
                    
                    dataSource.load();
                }
                else 
                {
                    Qt.toast.pop("There was an error uploading your file. Please try again.");
                    
                    uploadingIndicator.visible = false;
                }
            }
        },
        SystemDialog
        {
            id: stopPrompt
            title: "Attention"
            body: "The file is still uploading, Are you sure you want to stop the upload and close this page?"
            modality: SystemUiModality.Application
            confirmButton.label: "Stop"
            confirmButton.enabled: true
            dismissAutomatically: true
            cancelButton.label: "Continue"
            onFinished: 
            {
                if(buttonSelection().label == "Stop")
                {
                    navigationPane.pop();
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
