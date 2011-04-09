package dogerty
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	public class Parser
	{
		private static const MAX_INSPECTION_LEVEL:uint = 5;
		
		public static function parseDisplayList(root:DisplayObject, ...args):XML
		{
			if(!root) return null;
			
			var object:XML;
			var path:String = "";
			if(args[0] is String){
				path += args[0] + "." + root.name;
			}else{
				path = root.name;
			}
			object = <displayObject name={root.name} type={getQualifiedClassName(root)} path={path}/>;
			if(root is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = root as DisplayObjectContainer;
				for (var i:uint = 0; i< container.numChildren; i++)
				{
					var child:DisplayObject = container.getChildAt(i);
					object[child.name] = parseDisplayList(child, path);
				}
			}
			
			return object;
		}
		
		public static function parseObjectProperties(obj:Object):Array
		{
			if(!obj) return null;
			
			var typeProps:XMLList = describeType(obj).accessor.(@access!='writeonly');
			var desc:Array = [];
			
			for each (var name:String in typeProps.@name)
			{
				desc.push({name:name, value:obj[name]})
			}
			
			return desc;
		}
	}
}