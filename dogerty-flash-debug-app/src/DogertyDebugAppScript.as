import dogerty.app.api.DebugClientConnection;
import dogerty.app.api.DebugEvent;

import mx.events.FlexEvent;

private var p_clientConnection:DebugClientConnection;

private function onCreationComplete(event:FlexEvent):void 
{
    p_clientConnection = new DebugClientConnection();
    p_clientConnection.addEventListener(DebugEvent.MESSAGE_RECEIVED, onMessageReceived);
}

private function onMessageReceived(event:DebugEvent):void 
{
    log.appendText("\n"+event.messageContent);
}