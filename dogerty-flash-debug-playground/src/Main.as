package
{
    import dogerty.Debug;
    import dogerty.TunnelEvent;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.TextField;
    
    public class Main extends Sprite
    {
		private var tf:TextField;
		
        public function Main()
        {	
			bg();
        	Debug.init(root);
			
			tf = new TextField();
			tf.width = stage.stageWidth;
			tf.width = stage.stageHeight;
			tf.text = "ALALALALALALALALALLALALA"
			addChild(tf);
			
			
			addEventListener(MouseEvent.CLICK, onClick);
        }
		
		private function onClick(e:Event):void {
			var sp:Sprite = randomSP();
			var sp2:Sprite = sp.addChild(randomSP(new Point(10,10))) as Sprite;
			sp2.addChild(randomSP(new Point(10,10)));
			addChild(sp);
		}
		
		private function randomSP(pos:Point = null):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(Math.random()*0xffffff,Math.random());
			sp.graphics.drawRect(0,0,Math.random()*300,Math.random()*300);
			sp.graphics.endFill();
			sp.x = pos? pos.x : Math.random()*stage.stageWidth;
			sp.y = pos? pos.y : Math.random()*stage.stageHeight;
			return sp;
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