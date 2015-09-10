import bb.cascades 1.0

import "../buttons/"

Container 
{
    id: parent
    horizontalAlignment: HorizontalAlignment.Fill 
    layout: DockLayout {}
    
    property bool reverse : false;
    
    property string colorGray            : "#919191";
    property string colorMagenta         : "#ff4a9b";
    property string colorBlue            : "#0084ff";
    property string colorBlack           : "#222222";
    property string colorOrange          : "#ffc14a";
    property string colorPurple          : "#b94aff";
    property string colorRed             : "#ff4a4a";
    property string colorTeal            : "#21b691";
    property string colorGreen           : "#75b621";
    property string colorWhite           : "#ffffff";
    property string colorDefault         : "#7c7c7c";
    property string colorDisabled        : "#b5b5b5";

    property alias color                 : toggleObject.color;
    property alias checked               : toggleObject.solid;
    property alias label                 : labelObject;
    property alias button                : toggleObject;
    
    Label
    {
        id: labelObject
        text: "Enabled"
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: (!reverse ? HorizontalAlignment.Left : HorizontalAlignment.Right)
        //textStyle.color: Color.Gray
        textStyle.fontWeight: FontWeight.W100
    }
    
    NemButton
    {
        id: toggleObject
        solid: false
        color: colorDefault
        horizontalAlignment: (!reverse ? HorizontalAlignment.Right : HorizontalAlignment.Left)
        verticalAlignment: VerticalAlignment.Center
        initialScaleX: 0.5
        initialScaleY: 0.5

        onClicked: 
        {
            solid = !solid;
        }
    }
}