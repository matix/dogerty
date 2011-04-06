package dogerty
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.system.ApplicationDomain;
    import flash.utils.ByteArray;
    
    public class Debug extends EventDispatcher
    {
        protected var p_rootApplication:DisplayObject;        
        protected var p_appConnection:LocalTunnel;
		
        protected var p_isConnected:Boolean;
        
        private static var p_instance:Debug;
        
		// for debug purposes
		public var debug:Function
		
        /**
        * Global access getter. Returns the unique instance of the debugging interface
        * */ 
        public static function get action():Debug
        {
            if(!p_instance){
                p_instance = new Debug();
            }
            
            return p_instance;
        }
        
        public function Debug()
        {
            if(p_instance)
            {
                throw new Error("Debug class should not be directly instantiated. Instead use global access variable dogerty.Debug.action.")                
            }
        }

        /**
        * Shortcut for Debug.action.init()
        * 
        */
        public static function init(root:DisplayObjectContainer = null):void 
        {
            Debug.action.init(root);
        }
		
        /**
        * Initializer. Sets up the debugging enviroment.
        * Optionally might pass the Display Hierarchry root, if not passed, it will try to infere.
        */ 
        public function init(root:DisplayObjectContainer = null):void
        {
			// init app connection
			p_appConnection = new LocalTunnel("dogerty");
			p_appConnection.addEventListener(TunnelEvent.MESSAGE_RECEIVED, onMessageReceived);
			p_appConnection.connectInbound();
			
			// send application a ping
			ping();
        }
		
		protected function onMessageReceived(event:TunnelEvent):void
		{
			if(event.messageType == MessageTypeEnum.SYNC)
			{
				p_isConnected = true;
				ping();
			}
		}
		
		private function ping():void
		{
			p_appConnection.sendMessage(MessageTypeEnum.SYNC,"");
		}
		
		public function log(object:Object):void
		{
			p_appConnection.sendMessage(MessageTypeEnum.TRACE, object);
		}
    }
}