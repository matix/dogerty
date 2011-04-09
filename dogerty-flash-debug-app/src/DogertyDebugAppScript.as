import dogerty.LocalTunnel;
import dogerty.MessageTypeEnum;
import dogerty.TunnelEvent;
import dogerty.app.api.ConnectionStatusChecker;

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

private var p_highlighting:Boolean = false;

private function toggleHightLightingMode(enable:Boolean):void
{
	p_highlighting = enable;
	if(!enable)
	{
		p_clientConnection.sendMessage(MessageTypeEnum.HIGHLIGHT_ITEM, null);
	}
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
	else if (event.messageType == MessageTypeEnum.ITEM_DESCRIPTION_RESPONSE)
	{
		setPropertiesPanel(event.messageContent);
	}
}

private function onTreeItemRollOver(event:ListEvent):void 
{
	if(p_highlighting){
		var path:Array = event.itemRenderer.data.@path.toString().split(".");
		p_clientConnection.sendMessage(MessageTypeEnum.HIGHLIGHT_ITEM, path);
	}
}

private function onTreeSelectedItemChanged(event:Event):void 
{
	var path:Array = displayTree.selectedItem.@path.toString().split(".");
	p_clientConnection.sendMessage(MessageTypeEnum.ITEM_DESCRIPTION, path);
}

private function setPropertiesPanel(itemDescription:Object):void
{
	propertiesPanel.dataProvider = itemDescription;
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