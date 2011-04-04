package dogerty
{
    import flash.events.Event;
    
    public class DebugEvent extends Event
    {
        public static const MESSAGE_RECEIVED:String = "messageReceived";
        
        public var messageType:String;
        public var messageContent:Object;        
        
        public function DebugEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
        
        
    }
}