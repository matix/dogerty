import dogerty.Debug;
import dogerty.LocalTunnel;
import dogerty.MessageTypeEnum;
import dogerty.TunnelEvent;
import dogerty.app.api.ConnectionStatusChecker;
import dogerty.app.api.Utils;

import flash.net.sendToURL;

import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.events.ListEvent;

[Bindable] private var p_connectionStatus:uint = 0;

private var p_clientConnection:LocalTunnel;
private var p_clientConnectionStatusChecker:ConnectionStatusChecker;

public function get app():DogertyDebugApp
{
	return FlexGlobals.topLevelApplication as DogertyDebugApp;
}

private function onCreationComplete(event:FlexEvent):void 
{
	this.nativeWindow.alwaysInFront = true;
	
    p_clientConnection = new LocalTunnel("dogerty",true);
    p_clientConnection.addEventListener(TunnelEvent.MESSAGE_RECEIVED, onMessageReceived);
	p_clientConnection.connectInbound();
	
	p_clientConnectionStatusChecker = new ConnectionStatusChecker(p_clientConnection);
	p_clientConnectionStatusChecker.addEventListener("connectionPing", onConnectionPing);
	p_clientConnectionStatusChecker.addEventListener("connectionTimedOut", onConnectionTimedOut);
	
	p_clientConnection.sendMessage(MessageTypeEnum.SYNC,"");
	p_clientConnection.sendMessage(MessageTypeEnum.DISPLAY_TREE_UPDATE,"");
}

private function onConnectionPing(event:Event):void 
{
	p_connectionStatus = 1;
}

private function onConnectionTimedOut(event:Event):void 
{
	p_connectionStatus = 0;
	displayTree.dataProvider = null;
}

private function onClosing(event:Event):void 
{
	
}

private function onMessageReceived(event:TunnelEvent):void 
{
	if(event.messageType == MessageTypeEnum.TRACE){
		consoleLog(event.messageContent);
	}
	else if (event.messageType == MessageTypeEnum.DISPLAY_TREE_UPDATE)
	{
		displayTree.dataProvider = event.messageContent;
	}
}

private function onItemRollOver(event:ListEvent):void 
{
	p_clientConnection.sendMessage(MessageTypeEnum.HIGHLIGHT_ITEM, Utils.getItemPath(event.itemRenderer.data));
}

public function consoleLog(object:Object):void
{
	log.appendText("\n" + object.toString());
}

protected function toogleWindowSize():void
{
	if(this.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED) 
		this.restore() 
	else 
		this.nativeWindow.maximize()
}