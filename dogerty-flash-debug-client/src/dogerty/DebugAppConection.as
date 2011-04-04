package dogerty
{
    import flash.events.AsyncErrorEvent;
    import flash.events.EventDispatcher;
    import flash.events.SecurityErrorEvent;
    import flash.events.StatusEvent;
    import flash.net.LocalConnection;
    
    public class DebugAppConection extends EventDispatcher
    {
        private static const CONNECTION_IN_KEY:String = "_dogerty_in_7102";
        private static const CONNECTION_OUT_KEY:String = "_dogerty_out_7102";
        private static const CONNECTION_OUT_METHOD:String = "receiveMessageFromClient";
        
        private var p_localConnectionIn:LocalConnection
        private var p_localConnectionOut:LocalConnection
        
        private var p_inboundClientObject:Object;
        
        public function DebugAppConection():void 
        {
            p_localConnectionIn = new LocalConnection();
            p_localConnectionIn.addEventListener(StatusEvent.STATUS, onConnectionInStatus);
            p_localConnectionIn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
            p_localConnectionIn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            
            p_inboundClientObject = {};
            p_inboundClientObject.receiveMessageFromApp = this.receiveMessageFromApp;
            p_localConnectionIn.client = p_inboundClientObject;
            
            p_localConnectionIn.allowDomain("*");
            p_localConnectionIn.connect(CONNECTION_IN_KEY);
            
            p_localConnectionOut = new LocalConnection();
            p_localConnectionOut.allowDomain("*");
            p_localConnectionOut.addEventListener(StatusEvent.STATUS, onConnectionInStatus);
            p_localConnectionOut.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
            p_localConnectionOut.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        }
        
        private function onConnectionInStatus(event:StatusEvent):void
        {
            trace(event.toString());
        }
        
        private function onAsyncError(event:AsyncErrorEvent):void
        {
            trace(event.toString());
        }
        
        private function onSecurityError(event:SecurityErrorEvent):void
        {
            trace(event.toString());
        }
        
        public function sendMessageToApp(type:String, message:Object):void
        {
            p_localConnectionOut.send("app#DogertyDebugApp:"+CONNECTION_OUT_KEY,CONNECTION_OUT_METHOD, type, message);
        }
        
        protected function receiveMessageFromApp(type:String, message:Object):void
        {
            var event:DebugEvent = new DebugEvent(DebugEvent.MESSAGE_RECEIVED);
            event.messageType = type;
            event.messageContent = message;
            dispatchEvent(event);
        }
    }
}