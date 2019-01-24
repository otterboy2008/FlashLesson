package common
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

public class ScrollableDriver extends Driver implements IScrollable
{
	//------------------------------ statics ----------------------------------
	public static const EVENT_POSITION_UPDATE:String = "POSITION_UPDATE"
	
	//------------------------------ constructor ------------------------------
	public function ScrollableDriver()
	{
	}
	
	//------------------------------ properties -------------------------------
	public var cb_positionUpdate :Function;
	
	
	protected var _progress:Number = 0;
	public function get progress():Number
	{
		return _progress;
	}
	public function set progress( value:Number ):void
	{
		_progress = value;
	}
	
	protected var _displayObject:Sprite;
	public function get displayObject():Sprite
	{
		return _displayObject;
	}
	
	protected var _targetWidth:Number;
	public function get targetWidth():Number
	{
		return _targetWidth;
	}
	public function set targetWidth( value:Number ):void
	{
		if( _targetWidth != value )
		{
			_targetWidth = value;
			updateScrollRange();
		}
	}
	
	protected var _targetHeight:Number;
	public function get targetHeight():Number
	{
		return _targetHeight;
	}
	public function set targetHeight( value:Number ):void
	{
		if( _targetHeight != value )
		{
			_targetHeight = value;
			updateScrollRange();
		}
	}
	
	protected var _direction:String = "vertical";
	public function get direction():String
	{
		return _direction;
	}
	
	protected var isVertical:Boolean = true;
	
	protected var _scrollWidth:Number = 0;
	public function get scrollWidth():Number
	{
		return _scrollWidth;
	}
	public function set scrollWidth( value:Number ):void
	{
		if( _scrollWidth != value )
		{
			_scrollWidth = value;
			updateScrollRange();
			drawMask();
			updatePosition();
		}
	}
	
	protected var _scrollHeight:Number = 0;
	public function get scrollHeight():Number
	{
		return _scrollHeight;
	}
	public function set scrollHeight( value:Number ):void
	{
		if( _scrollHeight != value )
		{
			_scrollHeight = value;
			updateScrollRange();
			drawMask();
			updatePosition();
		}
	}
	
	protected var _paddingLeft:Number = 0;
	public function get paddingLeft():Number { return _paddingLeft; }
	
	protected var _paddingTop:Number = 0;
	public function get paddingTop():Number { return _paddingTop; }
	
	protected var _startPosition:Number;
	protected var _scrollRange:Number;
	public function get scrollRange():Number
	{
		return _scrollRange;
	}
	
	protected var _targetMask:DisplayObject;
	//------------------------------ public methods----------------------------
	override public function install(target:DisplayObject, parameter:Object=null):void
	{
		super.install( target, parameter );
		
		_displayObject = target as Sprite;
		
		if( parameter )
		{
			if( parameter.hasOwnProperty( "direction" ))
				_direction = parameter.direction;
			
			if( parameter.hasOwnProperty( "scrollWidth" ))
				_scrollWidth = parameter.scrollWidth;
			
			if( parameter.hasOwnProperty( "scrollHeight" ))
				_scrollHeight = parameter.scrollHeight;
			
			if( parameter.hasOwnProperty( "startPosition" ))
				_startPosition = parameter.startPosition;
			
			if( parameter.hasOwnProperty( "paddingLeft" ))
				_paddingLeft = parameter.paddingLeft;
			
			if( parameter.hasOwnProperty( "paddingTop" ))
				_paddingTop = parameter.paddingTop;
		}
		
		if( direction == "horizontal" )
			isVertical = false;
		
		if( _displayObject.width == 0 )
		{
			_scrollWidth = 0;
		}
			
		if( _displayObject.height == 0 )
		{
			_scrollHeight = 0;
		}
		
		_targetWidth = _displayObject.width;
		_targetHeight = _displayObject.height;
		
		//temp
		if( isVertical )
		{
			if( isNaN(_startPosition))
				_startPosition = _displayObject.y;
			_scrollRange = displayObject.height - _scrollHeight;
		}
		else
		{
			if( isNaN(_startPosition))
				_startPosition = _displayObject.x;
			_scrollRange = displayObject.width - _scrollWidth;
		}
		
		if( _scrollRange < 0 )
			_scrollRange = 0;
		
		_targetMask = new Shape();
		drawMask();
		
		if( displayObject.parent )
			displayObject.parent.addChild(_targetMask);
		else
			displayObject.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		
		displayObject.mask = _targetMask;
		
		updatePosition();
	}
	
	protected function updateScrollRange():void
	{
		if( isVertical )
		{
			_scrollRange = targetHeight - _scrollHeight;
		}
		else
		{
			_scrollRange = targetWidth - _scrollWidth;
		}
		
		if (_scrollRange < 0 )
		{
			_scrollRange = 0;
		}
	}
	
	public function scroll( progress:Number ):void
	{
		_progress = progress;
		
		updatePosition();
	}
	//------------------------------ protected & private ----------------------
	protected function updatePosition():void
	{
		if( isVertical )
			displayObject.y = _startPosition - ( _scrollRange + _paddingTop ) * progress;
		else
			displayObject.x = _startPosition - ( _scrollRange + _paddingLeft ) * progress;
			
			
		if ( cb_positionUpdate != null)
		{
			cb_positionUpdate();
		}
		
		dispatchEvent(new Event(EVENT_POSITION_UPDATE) );
	}
	
	
	protected function drawMask():void
	{
		var g:Graphics = Shape(_targetMask).graphics;
		g.clear();
		g.beginFill(0x00ff00,0.5);
		//g.drawRect( _paddingLeft, _paddingTop, _scrollWidth - _paddingLeft, _scrollHeight - _paddingTop);
		g.drawRect( 0, 0, _scrollWidth, _scrollHeight);
		g.endFill();
	}
	
	protected function onAddedToStage( event:Event ):void
	{
		displayObject.parent.addChild(_targetMask);
	}
	//------------------------------ dispose ----------------------------------
	override public function uninstall():void
	{
		super.uninstall();
		
		displayObject.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		
		cb_positionUpdate = null;
	}
}
}