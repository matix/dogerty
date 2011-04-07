package dogerty
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;

	public class DisplayListParser
	{
		private static const MAX_INSPECTION_LEVEL:uint = 5;
		
		public static function parse(root:DisplayObject):XML
		{
			if(!root) return null;
			
			var object:XML;
			object = <displayObject name={root.name} type={getQualifiedClassName(root)}/>;
			if(root is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = root as DisplayObjectContainer;
				for (var i:uint = 0; i< container.numChildren; i++)
				{
					var child:DisplayObject = container.getChildAt(i);
					object[child.name] = parse(child);
				}
			}
			
			return object;
		}
		
		
	}
}