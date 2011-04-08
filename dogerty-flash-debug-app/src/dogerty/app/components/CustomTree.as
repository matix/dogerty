package dogerty.app.components
{
	import mx.controls.Tree;
	
	public class CustomTree extends Tree
	{
		public function CustomTree()
		{
			super();
		}
		
		override protected function itemToUID(data:Object):String
		{
			if(data && data.@path){
				return data.@path.toString();
			}
			else {
				return super.itemToUID(data);
			}
		}
	}
}