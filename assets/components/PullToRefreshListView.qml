import bb.cascades 1.0
import bb.platform 1.2

ListView 
{
    id: refreshableListView
    leadingVisualSnapThreshold: 0
    snapMode: SnapMode.LeadingEdge
    bufferedScrollingEnabled: true
    focusRetentionPolicyFlags: FocusRetentionPolicy.LoseToFocusable

    property bool force_bar_hiding : false;
    property bool refreshing : false;
    property bool more_available : false;
    property string loadTopBottom : "top";
    property bool pullToRefresh : true;
    property string next_max_id : "";
    property string last_min_id : "";
    property bool canNowScroll : false;
    property bool being_touched : false;
    property int last_event_y : 0;
    property int scroll_offset : 10;
    property string last_scroll_direction : "";
    
    signal refreshTriggered();
    signal startRefreshing();
    signal stopRefreshing();
    signal scrolledUp();
    signal scrolledDown();

    onCreationCompleted: 
    {
        if(_app.get_setting("leading_edge_scrolling", "false") == "true")
        {
            snapMode = SnapMode.LeadingEdge;
        }    
        else 
        {
            snapMode = SnapMode.Default;
        }
    }
    
    onStartRefreshing: 
    {
        refreshing = true;
        refreshHeaderComponent.startRefreshing();
    }
    
    onStopRefreshing: 
    {
        refreshing = false;
        refreshHeaderComponent.stopRefreshing();
    }
    
    leadingVisual: RefreshHeader 
    {
        id: refreshHeaderComponent
        
        onRefreshTriggered:
        {
            refreshableListView.refreshTriggered();
        }
    }
    
    onTouch: 
    {
        if(pullToRefresh)
        {
            refreshHeaderComponent.onListViewTouch(event);
        }
        
        if(event.isDown())
        {
            last_event_y = event.localY;
            
            being_touched = true;
        }
        
        if(event.isMove())
        {
            being_touched = true;
        }
        
        if(event.isUp())
        {
            being_touched = false;
            
            if(last_event_y != event.localY)
            {
                var touch_difference = Math.abs((last_event_y - event.localY));
                
                if(touch_difference > scroll_offset)
                {
                    if(last_event_y < event.localY) // up
                    {
                        if(last_scroll_direction != "up")
                        {
                            if(_app.get_setting("auto_hide_bars", "true") == "true" || force_bar_hiding)
                            {
                                scrolledUp();
                            }
                            
                            last_scroll_direction = "up";
                        }
                    }
                    else if(last_event_y > event.localY) // down
                    {
                        if(last_scroll_direction != "down")
                        {
                            if(_app.get_setting("auto_hide_bars", "true") == "true" || force_bar_hiding)
                            {
                                scrolledDown();
                            }
                            
                            last_scroll_direction = "down";
                        }
                    }
                }
            }
        }  
    }

    function refreshHeader()
    {
        refreshTriggered();
        refreshHeaderComponent.refreshTriggered();
    }
    
    function scrollToTop()
    {
        scrollToPosition(ScrollPosition.Beginning, ScrollAnimation.Smooth);
    }
    
    function scrollToBottom()
    {
        scrollToPosition(ScrollPosition.End, ScrollAnimation.Smooth);
    }
}
