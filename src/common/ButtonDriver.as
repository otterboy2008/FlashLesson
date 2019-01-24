package common
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	

public class ButtonDriver extends Driver
{
	//------------------------------ statics ----------------------------------
	protected static const UP:String = "up";
	protected static const DOWN:String = "down";
	protected static const OVER:String = "over";
	protected static const OUT:String = "out";
	protected static const DISABLED:String = "disabled";
	protected static const SELECTED:String = "selected";
	
	private var soundType:int;
	
	public static const CONFIRM : int = 1;
	public static const CANCEL : int = 2;
	/*private static const defaultParam : Object = { upLabel : ButtonDriver.UP,
												   downLabel : ButtonDriver.DOWN,
												   overLabel : ButtonDriver.OVER,
												   outLabel : ButtonDriver.OUT,
												   disabledLabel : ButtonDriver.DISABLED,
												   selectedLabel : ButtonDriver.SELECTED};*/
	
	//------------------------------ constructor ------------------------------
	public function ButtonDriver( soundType:int = ButtonDriver.CONFIRM, target:DisplayObject = null, text : String = null, parameter:Object = null )
	{
		if (target)
		{
			install(target, parameter);
		}
		
		if (text)
		{
			this.label = text;
		}
	}

	//------------------------------ properties -------------------------------
	
	protected var _txtLabel:TextField;
	public function get label():String
	{
		if( _txtLabel )
			return _txtLabel.text;
		return "";
	}
	public function set label( value:String ):void
	{
		if( _txtLabel )
			_txtLabel.text = value;
	}
	
	public function get htmlLabel():String
	{
		if( _txtLabel )
			return _txtLabel.htmlText;
		return "";
	}
	public function set htmlLabel( value:String ):void
	{
		if( _txtLabel )
			_txtLabel.htmlText = value;
	}
	
	private var cachedParent : DisplayObjectContainer;
	
	//------------------------------ public methods----------------------------
	override public function install(target:DisplayObject, parameter:Object=null):void
	{
		super.install( target, parameter );
		
	}
	
	public function show():void
	{
		this.visible = true;
		if( !target.parent && cachedParent )
			cachedParent.addChild( target );
	}
	
	public function hide():void
	{
		this.visible = false;
		if( target.parent )
		{
			cachedParent = target.parent;
			target.parent.removeChild( target );
		}
	}
	//------------------------------ protected & private ----------------------
	
	
	protected var _visibleOriginal:Boolean = true;
	protected var _visibleForTutorial:Boolean = true;
	protected var _enableForTutorial:Boolean = true;
	protected var _originalEnable:Boolean = true;
	public function set visible(vis:Boolean):void
	{
		_visibleOriginal = vis;
	}
	
	
	public function get originalVisible():Boolean
	{
		return _originalEnable;
	}
	
	//------------------------------ dispose ----------------------------------
}
}
