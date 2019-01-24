package common
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.SoundPx;
	
	import org.puremvc.as3.patterns.facade.Facade;

public class BaseComponent extends Sprite
{
	//------------------------------ statics ----------------------------------
	
	//------------------------------ constructor ------------------------------
	public function BaseComponent()
	{
		
	}
	
	protected var _selected:Boolean;
	public function get selected():Boolean
	{
		return _selected;
	}
	public function set selected( value:Boolean ):void
	{
		_selected = value;
	}

	public function get displayObject():Sprite
	{
		return this;
	}
	
	protected var _id:String;
	public function get id():String 
	{ 
		return _id;
	}
	public function set id( value:String ):void 
	{ 
		_id = value; 
	}
	
	protected var _enabled:Boolean = true;
	public function get enabled():Boolean 
	{ 
		return _enabled; 
	}
	public function set enabled( value:Boolean ):void 
	{ 
		_enabled = value;
	}
	
	protected var _componentWidth:Number = 0;
	public function get componentWidth():Number 
	{ 
		return _componentWidth == 0? width:_componentWidth;
	}
	public function set componentWidth( value:Number ):void 
	{ 
		_componentWidth = value;
	}
	
	protected var _componentHeight:Number = 0;
	public function get componentHeight():Number 
	{ 
		return _componentHeight == 0 ? height: _componentHeight;
	}
	public function set componentHeight( value:Number ):void
	{
		_componentHeight = value;
	}

	public function updateComponentSize(width:Number, height:Number):void
	{
		componentWidth = width;
		componentHeight = height;
	}
	
	
	private var cachedParent : DisplayObjectContainer;
	
	public function show():void
	{
		this.visible = true;
		if( !parent && cachedParent )
			cachedParent.addChild( this );
	}
	
	public function hide():void
	{
		this.visible = false;
		if( parent )
		{
			cachedParent = parent;
			parent.removeChild( this );
		}
	}
	
	public function get soundPx():SoundPx
	{
		return ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
	}
	
	public function onRemove():void
	{
		
	}
	//------------------------------ protected & private ----------------------
	
	public function sendViewEvent( eventType:String, data:Object = null, bubbles:Boolean = false ):void
	{
		dispatchEvent( new Event( eventType, data, bubbles ));
	}
	
	//------------------------------ dispose ----------------------------------
}
}