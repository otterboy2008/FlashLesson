package common
{
	import flash.display.DisplayObject;

public interface IDriver
{
	function get name():String;
	function set name( value:String ):void;
	
	function get id():String;
	function set id( value:String ):void;
	
	function get isInstalled():Boolean;
	
	function install( target:DisplayObject, parameter:Object = null ):void;
	
	function uninstall():void;

}
}