package dogerty
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import flash.events.EventDispatcher;
    import flash.system.ApplicationDomain;
    
    public class Debug extends EventDispatcher
    {
        protected var p_rootApplication:DisplayObject;    
        protected var p_flexSupport:Boolean = false;
        
        protected var p_appConnection:DebugAppConection;
        
        private static var p_instance:Debug;
        
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
            
            p_appConnection = new DebugAppConection();
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
            if(root)
            {
                setApplicationRoot(root);
            }
            else
            {
                infereRootApplication();
            }
        }
        
        private function setApplicationRoot(root:DisplayObjectContainer):void {
            p_rootApplication = root;
        }
        
        private function infereRootApplication():void
        {
            //Check for flex 
            if(ApplicationDomain.currentDomain.hasDefinition("mx.core.Application") || ApplicationDomain.currentDomain.hasDefinition("spark.components.Application"))
            {
                // We have flex
                
            }
        }
        
        public function test():void 
        {
            p_appConnection.sendMessageToApp(MessageTypeEnum.TRACE, "Hello World!");
        }
    }
}