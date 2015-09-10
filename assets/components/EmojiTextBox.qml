import bb.cascades 1.0

import "../emoji"
import "../components/buttons"

Container 
{
    id: main_container
    horizontalAlignment: HorizontalAlignment.Fill

    property bool show_submit_button : true;
    property bool show_background : true;
    property string hint_text : "Type your messsage";

    background: (show_background ? (_app.get_setting("application_theme", "bright") == "bright" ? Color.create("#eeeeee") : Color.create("#222222")) : Color.Transparent)
    
    signal submit(string text);
    signal scrollToBottom();
    
    onCreationCompleted: 
    {
        if(_app.get_setting("enter_key_to_send", "true") == "true")
        {
            txtComment.input.submitKey = SubmitKey.Send;
        }
        else 
        {
            txtComment.input.submitKey = SubmitKey.Default;
        }
    }
    
    function requestFocus()
    {
       txtComment.requestFocus();
    }
    
    function enableTextBox()
    {
        txtComment.enabled = true;
        btnSend.enabled = true;
    }
    
    function disableTextBox()
    {
        txtComment.enabled = false;
        btnSend.enabled = false;
    }
    
    function setText(text)
    {
        txtComment.text = text;
    }
    
    function resetText()
    {
        txtComment.resetText();
    }
    
    function getText()
    {
        return remove_tags(txtComment.text);
    }
    
    function remove_tags(html)
    {
        return html.replace(/<(?:.|\n)*?>/gm, '');
    }
    
    function hideEmoticons()
    {
        smileysContainer.visible = false;
    }
    
    function clear()
    {
        txtComment.resetText();
    }

    Container 
    {
        id: text_comment_container
        minHeight: (_app.device() == "passport" ? 130 : 100)
        
        layout: StackLayout 
        {
            orientation: LayoutOrientation.LeftToRight
        }
        
        TextArea
        {
            id: txtComment
            backgroundVisible: show_background
            hintText: hint_text
            textStyle.fontWeight: FontWeight.W100
            textFormat: TextFormat.Html
            verticalAlignment: VerticalAlignment.Center
            input.submitKey: SubmitKey.Send
            
            input.onSubmitted: 
            {
                if(_app.get_setting("enter_key_to_send", "true") == "true")
                {
                    btnSend.clicked();
                }
                else 
                {
                    txtComment.text = txtComment.text + "\n";
                }
                
                console.log("enter_key_to_send: " + _app.get_setting("enter_key_to_send", "true"));
            }
            
            property string lastWord : "";
            
            content 
            {
                flags: TextContentFlag.Emoticons
            }
        }
        
        Container 
        {
            id: right_buttons
            verticalAlignment: VerticalAlignment.Fill
            
            layout: StackLayout 
            {
                orientation: LayoutOrientation.LeftToRight
            }
            
            ImageButton
            {
                id: btnAttachments
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                defaultImageSource: "asset:///media/images/icons/like.png"
                preferredHeight: (_app.device() == "passport" ? 80 : 50)
                preferredWidth: (_app.device() == "passport" ? 80 : 50)
                
                onClicked: 
                {
                    submit(remove_tags("(y)"));
                }
            }
            
//            ImageButton
//            {
//                id: btnAttachments
//                verticalAlignment: VerticalAlignment.Center
//                horizontalAlignment: HorizontalAlignment.Center
//                defaultImageSource: (attachmentsContainer.visible ? "asset:///media/images/icons/arrowUpDark.png" : "asset:///media/images/icons/arrowDownDark.png")
//                preferredHeight: (_app.device() == "passport" ? 80 : 50)
//                preferredWidth: (_app.device() == "passport" ? 80 : 50)
//                
//                onClicked: 
//                {
//                    attachmentsContainer.visible = !attachmentsContainer.visible;
//                }
//            }
            
            ImageButton
            {
                id: btnEmoji
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                defaultImageSource: "asset:///media/images/icons/smiley_gray.png"
                preferredHeight: (_app.device() == "passport" ? 80 : 50)
                preferredWidth: (_app.device() == "passport" ? 80 : 50)
                
                onClicked: 
                {
                    smileysContainer.visible = !smileysContainer.visible;
                }
            }
            
            Container 
            {
                visible: show_submit_button
                background: Color.create("#3c3c3c")
                verticalAlignment: VerticalAlignment.Fill
                leftPadding: (_app.device() == "passport" ? 40 : 20)
                rightPadding: (_app.device() == "passport" ? 40 : 20)
                
                layout: DockLayout {}
                
                ImageButton
                {
                    id: btnSend
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    defaultImageSource: "asset:///media/images/instagram/send.png"
                    preferredHeight: (_app.device() == "passport" ? 80 : 50)
                    preferredWidth: (_app.device() == "passport" ? 80 : 50)
                    
                    onClicked: 
                    {
                        if(txtComment.text.length > 0)
                        { 
                            submit(remove_tags(txtComment.text));
                        }
                        else
                        {
                            Qt.dialog.pop("Please add some message before you submit.");
                        }
                    }
                }
            }
        }
    }
    
    Container 
    {
        id: attachmentsContainer
        visible: false
        horizontalAlignment: HorizontalAlignment.Fill
        preferredHeight: (_app.device() == "passport" ? 500 : 400)
        
        
    }
    
    Container 
    {
        id: smileysContainer
        visible: false
        horizontalAlignment: HorizontalAlignment.Fill
        preferredHeight: (_app.device() == "passport" ? 500 : 400)

        EmojiKeyboard 
        { 
            id: emojiInput
            visible: true
            
            onEmojiTapped: 
            {
                if(Qt.has_pro_access())
                {
                    txtComment.editor.insertPlainText(getUnicodeCharacter('0x'+chars));
                }
                else 
                {
                    Qt.dialog.pop("Pro Upgrade Required", "Using the Emoji + Emoticons Keyboard is only available to PRO Users. Upgrade now and access all the great features.");
                    Qt.proSheet.open();
                }
            }
            
            onBbmEmoticonTapped: 
            {
                if(Qt.has_pro_access())
                {
                    txtComment.editor.insertPlainText(data);
                }
                else 
                {
                    Qt.dialog.pop("Pro Upgrade Required", "Using the Emoji + Emoticons Keyboard is only available to PRO Users. Upgrade now and access all the great features.");
                    Qt.proSheet.open();
                }
            }
            
            onKeyboardShown1: 
            {
                smileysContainer.visible = false;
                scrollToBottom();
            }
            
            onKeyboardHidden1: 
            {
                
            }
        }
    } 
}
