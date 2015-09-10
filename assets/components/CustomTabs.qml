import bb.cascades 1.2

Container 
{
    id: main_container
    
    property variant font_size : FontSize.Small
    
    property bool tabbing : true;
    
    property string tab1 : "TAB 1";
    property string tab2 : "TAB 2";
    property string tab3 : "";
    property string tab4 : "";
    property string tab5 : "";
    property string tab6 : "";
    
    property string tab1value : "";
    property string tab2value : "";
    property string tab3value : "";
    property string tab4value : "";
    property string tab5value : "";
    property string tab6value : "";
    
    property string active_tab : tab1;
    
    property string colorGray            : "#919191";
    property string colorBlack           : "#222222";
    property string colorTwitterNew      : "#3383c0";
    
    property variant active_text_color : getColor();
    
    signal tab1Clicked();
    signal tab2Clicked();
    signal tab3Clicked();
    signal tab4Clicked();
    signal tab5Clicked();
    signal tab6Clicked();
    
    function getColor()
    {
        var the_color = _app._color_theme;
        
        if(_app._color_theme == colorGray || _app._color_theme == colorBlack)
        {
            the_color = colorTwitterNew;
        }
        
        if(!tabbing)
        {
            the_color = Color.DarkGray;
        }
        
        return Color.create(the_color);
    }
    
    Container 
    {
        id: segments
        horizontalAlignment: HorizontalAlignment.Fill
        bottomPadding: 20
        topPadding: 20
        
        layout: StackLayout 
        {
            orientation: LayoutOrientation.LeftToRight
        }
        
        Container
        {
            verticalAlignment: VerticalAlignment.Center
            visible: (tab1.length > 0)
            
            Label 
            {
                text: tab1value
                visible: (tab1value.length > 0)
                textStyle.fontSize: FontSize.XXSmall
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                bottomMargin: 0
            }
            
            Label 
            {
                topMargin: 0
                text: tab1
                textStyle.fontSize: font_size
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                textStyle.color: (active_tab == tab1) ? active_text_color : Color.DarkGray;
            }
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 1
            }
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    active_tab = tab1;
                    tab1Clicked();
                }
            }
        }
        
        Container
        {
            verticalAlignment: VerticalAlignment.Center
            visible: (tab2.length > 0)
            
            Label 
            {
                text: tab2value
                visible: (tab2value.length > 0)
                textStyle.fontSize: FontSize.XXSmall
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                bottomMargin: 0
            }
            
            Label 
            {
                topMargin: 0
                text: tab2
                textStyle.fontSize: font_size
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                textStyle.color: (active_tab == tab2) ? active_text_color : Color.DarkGray;
            }
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 1
            }
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    active_tab = tab2;
                    tab2Clicked();
                }
            }
        }
        
        Container
        {
            verticalAlignment: VerticalAlignment.Center
            visible: (tab3.length > 0)
            
            Label 
            {
                text: tab3value
                visible: (tab3value.length > 0)
                textStyle.fontSize: FontSize.XXSmall
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                bottomMargin: 0
            }
            
            Label 
            {
                topMargin: 0
                text: tab3
                textStyle.fontSize: font_size
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                textStyle.color: (active_tab == tab3) ? active_text_color : Color.DarkGray;
            }
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 1
            }
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    active_tab = tab3;
                    tab3Clicked();
                }
            }
        }
        
        Container
        {
            verticalAlignment: VerticalAlignment.Center
            visible: (tab4.length > 0)
            
            Label 
            {
                text: tab4value
                visible: (tab4value.length > 0)
                textStyle.fontSize: FontSize.XXSmall
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                bottomMargin: 0
            }
            
            Label 
            {
                topMargin: 0
                text: tab4
                textStyle.fontSize: font_size
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                textStyle.color: (active_tab == tab4) ? active_text_color : Color.DarkGray;
            }
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 1
            }
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    active_tab = tab4;
                    tab4Clicked();
                }
            }
        }
        
        Container
        {
            verticalAlignment: VerticalAlignment.Center
            visible: (tab5.length > 0)
            
            Label 
            {
                text: tab5value
                visible: (tab5value.length > 0)
                textStyle.fontSize: FontSize.XXSmall
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                bottomMargin: 0
            }
            
            Label 
            {
                topMargin: 0
                text: tab5
                textStyle.fontSize: font_size
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                textStyle.color: (active_tab == tab5) ? active_text_color : Color.DarkGray;
            }
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 1
            }
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    active_tab = tab5;
                    tab5Clicked();
                }
            }
        }
        
        Container
        {
            verticalAlignment: VerticalAlignment.Center
            visible: (tab6.length > 0)
            
            Label 
            {
                text: tab6value
                visible: (tab6value.length > 0)
                textStyle.fontSize: FontSize.XXSmall
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                bottomMargin: 0
            }
            
            Label 
            {
                topMargin: 0
                text: tab6
                textStyle.fontSize: font_size
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.W500
                textStyle.color: (active_tab == tab6) ? active_text_color : Color.DarkGray;
            }
            
            layoutProperties: StackLayoutProperties 
            {
                spaceQuota: 1
            }
            
            gestureHandlers: TapHandler 
            {
                onTapped: 
                {
                    active_tab = tab6;
                    tab6Clicked();
                }
            }
        }
    } 
    
    Divider 
    {
        topMargin: 0
        bottomMargin: 0
    } 
}