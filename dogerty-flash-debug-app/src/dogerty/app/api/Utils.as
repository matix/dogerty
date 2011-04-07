package dogerty.app.api
{
	public class Utils
	{
		public static function getItemPath(item:Object):Array
		{
			if(item){
				var path:Array = [];
				while(item)
				{
					path.unshift(item.@name.toString());
					item = item.parent();
				}
				return path
			}
			else return null;
		}
	}
}