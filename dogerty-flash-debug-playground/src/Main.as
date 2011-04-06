package
{
    import dogerty.Debug;
    import dogerty.TunnelEvent;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    
    public class Main extends Sprite
    {
		private var tf:TextField;
		
        public function Main()
        {	
			bg();
			
			tf = new TextField();
			tf.width = stage.stageWidth;
			tf.width = stage.stageHeight;
			addChild(tf);
			
        	Debug.init();
			
			addEventListener(MouseEvent.CLICK, Debug.action.log);
        }

		public function log(...args):void
		{
			tf.appendText("\n"+args.join("\n"));
		}
		
		private function bg():void
		{
			graphics.beginFill(0x00FF11,0.7);
			graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
    }
}