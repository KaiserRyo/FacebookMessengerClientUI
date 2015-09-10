import bb.cascades 1.0

Container
{
    id: mainContainer
    
    property alias uploadingFileName : uploadingLabel.text
    
    signal startAnimations();
    signal stopAnimations();
    
    onStartAnimations: 
    {
        fadeAnimation.play();
        scaleAnimation.play();
    }
    
    onStopAnimations: 
    {
        fadeAnimation.stop();
        scaleAnimation.stop();
    }
    
    topPadding: 10
    
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    layout: DockLayout {}
    leftPadding: 20
    rightPadding: leftPadding
    
    Container
    {
        verticalAlignment: VerticalAlignment.Center
        
        layout: StackLayout
        {
            orientation: LayoutOrientation.LeftToRight
        }
        
        Container 
        {
            id: statImage
            rightPadding: 20
            layout: DockLayout {}
            verticalAlignment: VerticalAlignment.Center
            
            ImageView
            {
                id: theimage
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                imageSource: "asset:///media/images/icons/icon.png"
                preferredHeight: 70
                minHeight: preferredHeight
                minWidth: preferredHeight
                scalingMethod: ScalingMethod.AspectFit
                
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
                            theimage.resetOpacity();
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
                            theimage.resetScale();
                        }
                    }
                ]
            }
        }
        
        Container 
        {
            verticalAlignment: VerticalAlignment.Center  
            
            Label 
            {
                id: uploadingLabel
            }
            
//            ProgressIndicator 
//            {
//                id: progressBar    
//                horizontalAlignment: HorizontalAlignment.Fill
//                fromValue: 0
//                toValue: 100
//                value: 50
//            }
        }
    }
}
