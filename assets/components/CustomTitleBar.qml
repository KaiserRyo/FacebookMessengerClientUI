import bb.cascades 1.0

TitleBar 
{
    property alias label_title : label_title_
    property alias container_main : container_main_
    property alias container_image_left : container_image_left_
    property alias container_image_right : container_image_right_
    property alias text_field : text_field_
    property alias text_field_icon : text_field_icon_
    property alias image_left : image_left_
    property alias image_right : image_right_
    property bool main_content_click_mode : false;
    property int passportOffset  : 30;
    property variant backgroundColor: Color.create("#" + _app._color_scheme);
    property int button_dimensions : (_app._is_passport ? 70 : 50);
    
    signal leftButtonClicked();
    signal rightButtonClicked();
    signal labelTitleClicked();
    signal mainContentClicked();
    signal textFieldSubmitted(string text);
    
    function focusTextField()
    {
        text_field_.requestFocus();
    }
    
    appearance: TitleBarAppearance.Plain
    scrollBehavior: TitleBarScrollBehavior.Sticky
    kind: TitleBarKind.FreeForm
    
    function fadeIn()
    {
        visibility = ChromeVisibility.Visible;
    }
    
    function fadeOut()
    {
        visibility = ChromeVisibility.Hidden;
    }
    
    kindProperties: FreeFormTitleBarKindProperties 
    {
        content: Container 
        {
            id: container_main_
            background: backgroundColor
            horizontalAlignment: HorizontalAlignment.Fill
            layout: DockLayout {}
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    if(main_content_click_mode)
                    {
                        mainContentClicked();
                    }
                }
            }
            
            Container 
            {
                id: container_image_left_
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Left
                leftPadding: 35
                
                layout: StackLayout 
                {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                ImageButton 
                {
                    id: image_left_
                    verticalAlignment: VerticalAlignment.Center
                    minWidth: button_dimensions
                    maxWidth: button_dimensions
                    maxHeight: button_dimensions
                    minHeight: button_dimensions
                    
                    onClicked: 
                    {
                        leftButtonClicked();
                    }
                }
                
                ImageView 
                {
                    id: text_field_icon_
                    visible: false
                    verticalAlignment: VerticalAlignment.Center
                    scalingMethod: ScalingMethod.AspectFit
                    minWidth: button_dimensions
                    maxWidth: button_dimensions
                    maxHeight: button_dimensions
                    minHeight: button_dimensions
                    opacity: 0.5
                }
                
                TextField 
                {
                    id: text_field_
                    visible: false
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Fill
                    backgroundVisible: false
                    textStyle.color: Color.White
                    translationX: -15
                    
                    input
                    {
                        submitKey: SubmitKey.Search
                        
                        onSubmitted: 
                        {
                            textFieldSubmitted(text);
                        }
                    }
                }
                
                Container 
                {
                    leftPadding: 20
                    verticalAlignment: VerticalAlignment.Center
                    
                    Label 
                    {
                        id: label_title_
                        text: "TITLE"
                        textStyle.color: Color.White
                        textStyle.fontSize: FontSize.Large
                        textStyle.fontWeight: FontWeight.W500
                        verticalAlignment: VerticalAlignment.Center
                        
                        gestureHandlers: TapHandler 
                        {
                            onTapped: 
                            {
                                labelTitleClicked();
                            }
                        }
                    }
                }
            }
            
            Container 
            {
                id: container_image_right_
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Right
                rightPadding: 35
                
                ImageButton 
                {
                    id: image_right_
                    verticalAlignment: VerticalAlignment.Center
                    minWidth: button_dimensions
                    maxWidth: button_dimensions
                    maxHeight: button_dimensions
                    minHeight: button_dimensions
                    
                    onClicked: 
                    {
                        rightButtonClicked();
                    }
                }
            }
        }
    }
}