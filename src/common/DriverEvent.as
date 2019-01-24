package common
{
	import flash.events.Event;

public class DriverEvent extends Event
{
	//------------------------------ statics ----------------------------------
	public static const DRAG_START:String = "dragStart";
	public static const DRAG_ENTER:String = "dragEnter";
	public static const DRAG_EXIT:String = "dragExit";
	public static const DRAG_DROP:String = "dragDrop";
	public static const DRAG_COMPLETE:String = "dragComplete";
	
	public static const BUTTON_CLICK:String = "buttonClick";
	
	public static const MC_LABEL_CHANGE : String = "mcLabelChange";
	
	//------------------------------ constructor ------------------------------
	public function DriverEvent( eventType:String, driver:Driver = null, data:Object = null )
	{
		super( eventType );
		_driver = driver;
		_data = data;
	}

	//------------------------------ properties -------------------------------
	protected var _driver:Driver;
	public function get driver():Driver { return _driver }
	
	protected var _data:Object;
	public function get data():Object { return _data }
	//------------------------------ public methods----------------------------
	override public function clone():Event
	{
		return new DriverEvent( type, driver, data );
	}
	//------------------------------ protected & private ----------------------
	
	//------------------------------ dispose ----------------------------------

}
}