package common
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;

public class Driver extends EventDispatcher implements IDriver
{
	//------------------------------ statics ----------------------------------
	
	//------------------------------ constructor ------------------------------
	public function Driver()
	{
	}

	//------------------------------ properties -------------------------------
	private var _name:String;
	public function get name():String { return _name }
	public function set name( value:String ):void { _name = value }
	
	private var _id:String;
	public function get id():String { return _id }
	public function set id( value:String ):void { _id = value }
	
	protected var _target:DisplayObject;
	public function get target():DisplayObject { return _target }
	
	protected var _parameter:Object;
	public function get parameter():Object { return _parameter };
	
	protected var _isInstalled:Boolean;
	public function get isInstalled():Boolean { return _isInstalled }
	//------------------------------ public methods----------------------------
	public function install( target:DisplayObject, parameter:Object = null ):void
	{
		if( !isInstalled )
		{
			_target = target;
			_parameter = parameter;
		}
		else
			throw new Error( "Please Uninstall First!" );
		//to be overrided
	}
	//------------------------------ protected & private ----------------------
	protected function sendEvent( eventType:String, data:Object = null ):Boolean
	{
		return dispatchEvent( new DriverEvent( eventType, this, data ));
	}
	//------------------------------ dispose ----------------------------------
	public function uninstall():void
	{
		_isInstalled = false;
		//to be overrided
	}
}
}