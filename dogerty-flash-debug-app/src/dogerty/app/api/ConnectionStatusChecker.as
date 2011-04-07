package dogerty.app.api
{
	import dogerty.LocalTunnel;
	import dogerty.MessageTypeEnum;
	import dogerty.TunnelEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class ConnectionStatusChecker extends EventDispatcher
	{
		private var p_conn:LocalTunnel;
		private var p_timer:Timer;
		
		public function ConnectionStatusChecker(conn:LocalTunnel)
		{
			this.p_conn = conn;
			p_conn.addEventListener(TunnelEvent.MESSAGE_RECEIVED, onMessageReceived);
			
			p_timer = new Timer(2000);
			p_timer.addEventListener(TimerEvent.TIMER, timeout);
		}
		
		private function onMessageReceived(event:TunnelEvent):void
		{
			if(event.messageType == MessageTypeEnum.SYNC){
				dispatchEvent(new Event("connectionPing"));
				p_conn.sendMessage(MessageTypeEnum.SYNC,"");
				p_timer.reset();
				p_timer.start();
			}
		}
		
		private function timeout(event:TimerEvent):void
		{
			p_timer.reset();
			dispatchEvent(new Event("connectionTimedOut"));
		}
	}
}