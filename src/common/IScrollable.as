package common
{
	import flash.display.Sprite;

	public interface IScrollable
	{
		function scroll( progress:Number ):void;
		
		function get displayObject():Sprite;
		//function get displayRange():Number;
	}
}