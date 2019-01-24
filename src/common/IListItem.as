package common
{
	import flash.display.Sprite;

public interface IListItem
{
	function get displayObject():Sprite;	
		
	function get componentHeight():Number;
		
	function get componentWidth():Number;
	
	//function get id():Object;
	//function set id( value:String ):void;
	
	function get data():Object;
	function set data( value:Object ):void;
	
	function get selected():Boolean;
	function set selected( value:Boolean ):void;
	

}
}