package dogerty
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.sendToURL;
    
    import mx.core.IVisualElement;
    import mx.core.UIComponent;
    
    import spark.components.SkinnableContainer;
    
    public class Debug extends EventDispatcher
    {
        protected var p_rootApplication:DisplayObjectContainer;        
        protected var p_highlightLayer:Sprite;        
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
        public static function init(dobj:DisplayObject):void 
        {
            action.init(dobj);
			action.updateDisplayTree();
        }
		
        /**
        * Initializer. Sets up the debugging enviroment.
        * Optionally might pass the Display Hierarchry root, if not passed, it will try to infere.
        */ 
        public function init(dobj:DisplayObject):void
        {
			setAppRoot(dobj);

			p_highlightLayer = new Sprite();
			p_highlightLayer.name = "dogertyHighlightSpite7102";
			p_highlightLayer.visible = false;
			//p_highlightLayer.graphics.lineStyle(1,0x0000ff,1);
			p_highlightLayer.graphics.beginFill(0x00ffff,.5);
			p_highlightLayer.graphics.drawRect(0,0,10,10);
			p_highlightLayer.graphics.endFill();
			//p_highlightLayer.scale9Grid = new Rectangle(2,2,6,6);
			p_highlightLayer.mouseEnabled = false;
			p_highlightLayer.mouseChildren = false;			
			
			p_rootApplication.addChild(p_highlightLayer);
			p_rootApplication.addEventListener(Event.ADDED, onDisplayListUpdated);
			p_rootApplication.addEventListener(Event.REMOVED, onDisplayListUpdated);
			
			// init app connection
			p_appConnection = new LocalTunnel("dogerty");
			p_appConnection.addEventListener(TunnelEvent.MESSAGE_RECEIVED, onMessageReceived);
			p_appConnection.connectInbound();
			
			// send application a ping
			ping();
        }
		
		private function setAppRoot(dobj:DisplayObject):void 
		{
			p_rootApplication = dobj.root as DisplayObjectContainer;
		}
		
		protected function onDisplayListUpdated(event:Event):void
		{
			p_rootApplication.setChildIndex(p_highlightLayer, p_rootApplication.numChildren-1);				
			updateDisplayTree();
		}
		
		protected function onMessageReceived(event:TunnelEvent):void
		{
			if(event.messageType == MessageTypeEnum.SYNC)
			{
				p_isConnected = true;
				ping();
			}
			else if(event.messageType == MessageTypeEnum.DISPLAY_TREE_UPDATE)
			{
				updateDisplayTree();
			}
			else if(event.messageType == MessageTypeEnum.HIGHLIGHT_ITEM)
			{
				highLightItem(event.messageContent as Array);
			}
			else if(event.messageType == MessageTypeEnum.ITEM_DESCRIPTION)
			{
				var desc:Array = describeItem(event.messageContent as Array);
				p_appConnection.sendMessage(MessageTypeEnum.ITEM_DESCRIPTION_RESPONSE, desc);
			}
		}
		
		private function ping():void
		{
			p_appConnection.sendMessage(MessageTypeEnum.SYNC,null);
		}
		
		private function updateDisplayTree():void
		{
			var display:Object = Parser.parseDisplayList(p_rootApplication);
			p_appConnection.sendMessage(MessageTypeEnum.DISPLAY_TREE_UPDATE,display);
		}
		
		private function highLightItem(path:Array):void
		{
			if(path){
				p_highlightLayer.visible = true;
			}
			else {
				p_highlightLayer.visible = false;
				return;
			}
			
			var item:DisplayObject = getItemByPath(path);
			
			if(item){
				var global:Point = item.parent.localToGlobal(new Point(item.x,item.y));
				var app_local:Point = p_rootApplication.globalToLocal(global);
				p_highlightLayer.x = app_local.x
				p_highlightLayer.y = app_local.y
				p_highlightLayer.width = item.width
				p_highlightLayer.height = item.height
			}
			else
			{
				p_highlightLayer.visible = false;
			}
		}
		
		private function describeItem(path:Array):Array
		{
			var item:DisplayObject = getItemByPath(path);
			return Parser.parseObjectProperties(item);
		}
		
		private function getItemByPath(path:Array):DisplayObject 
		{
			var item:DisplayObject = p_rootApplication;
			for (var i:uint = 1; i < path.length; i++)
			{
				if(item is DisplayObjectContainer){
					item = DisplayObjectContainer(item).getChildByName(path[i]);
				}
				else {
					if(i < path.length -1)
					{
						item = null
						break;
					}
				}
			}
			
			return item;
		}
		
		public function log(object:Object):void
		{
			p_appConnection.sendMessage(MessageTypeEnum.TRACE, object);
		}
    }
}