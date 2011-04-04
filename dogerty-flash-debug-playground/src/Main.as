package
{
    import dogerty.Debug;
    
    import flash.display.Sprite;
    
    public class Main extends Sprite
    {
        public function Main()
        {
            Debug.init();
            Debug.action.test();
        }
    }
}