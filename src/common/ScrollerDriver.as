package common
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;

[Event( name="dragStart",    type="common.DriverEvent" )]
[Event( name="dragComplete", type="common.DriverEvent" )]
	
public class ScrollerDriver extends Driver
{
	//------------------------------ statics ----------------------------------
	
	//------------------------------ constructor ------------------------------
	public function ScrollerDriver()
	{
	}

	//------------------------------ properties -------------------------------
	protected var _progress:Number = 0;
	protected var _rangeRatio:Number = -1.0; // default don't support
	public function get progress():Number
	{
		return _progress;
	}
	public function set progress( value:Number ):void
	{
		//if( _progress != value )
		{
			if( value > 1 )
				value = 1;
			else if( value < 0 )
				value = 0;
			_progress = value;
			
			_position = _range * _progress + _startPosition;
			updatePosition();
			_scrollable.scroll( progress );
		}
	}
	
	public function get rangeRatio():Number
	{
		return _rangeRatio;
	}
	
	public function set rangeRatio(v:Number ):void
	{
		_rangeRatio = v;
		if ( _rangeRatio > 1.0)
			_rangeRatio = 1.0;
			
		if (isVertical)
		{
			_target.height = thumbSize;	
		}
		else
		{
			_target.width = thumbSize;
		}
			
		_endPosition = _thumbEndPosition - thumbSize; //+offset?
		_range = _endPosition - _startPosition;
		updatePosition();
	}
	
	protected var _scrollable:IScrollable;
	public function get scrollable():IScrollable { return _scrollable }
	
	protected var _direction:String = "vertical";
	public function get direction():String
	{
		return _direction;
	}
	
	public function set direction(value:String):void 
	{
		_direction = value;
		updateDirection();
	}
	
	protected var _enabled:Boolean = true;
	public function get enabled():Boolean
	{
		return _enabled;
	}
	public function set enabled(value:Boolean):void
	{
		_enabled = value;
		if ( _enabled == false)
		{
			clearDragEvent();
		}
	}
	protected var _wheelEnabled:Boolean = true;
	public function get wheelEnabled():Boolean
	{
		return _wheelEnabled;
	}
	public function set wheelEnabled( value:Boolean ):void
	{
		_wheelEnabled = value;
	}
	
	protected var _wheelSpeed:Number = 2;
	public function get wheelSpeed():Number
	{
		return _wheelSpeed;
	}
	public function set wheelSpeed( value:Number ):void
	{
		if( value < 0 )
			_wheelSpeed = 0;
		else
			_wheelSpeed = value;
	}
	
	protected var isVertical:Boolean = true;
	
	protected var _thumbSize:Number = 0;
	public function get thumbSize():Number { 
		if ( _rangeRatio < 0 )
		{
			return _thumbSize;
		}
		else
		{
			var s:Number =  (_thumbEndPosition - _thumbStartPosition) * _rangeRatio;
			var leastSize:Number = Math.min(30, (_thumbEndPosition - _thumbStartPosition)  * 0.5);
			if ( s < leastSize )
			{
				s = leastSize;
			}
			
			return s;
		}
		
	}

	protected var _thumbStartPosition:Number = 0;
	public function get thumbStartPosition():Number { return _thumbStartPosition }
	public function set thumbStartPosition( value :Number ):void
	{
		if( _thumbStartPosition != value )
		{
			_startPosition = _thumbStartPosition = value;
			_range = _endPosition - _startPosition;
			_position = _range * _progress + _startPosition;
			updatePosition();
		}
	}
	protected var _thumbEndPosition:Number = 0;
	public function get thumbEndPosition():Number { return _thumbEndPosition }
	public function set thumbEndPosition( value:Number ):void
	{
		if( _thumbEndPosition != value )
		{
			_thumbEndPosition = value;
			_endPosition = _thumbEndPosition - thumbSize; //+offset?
			_range = _endPosition - _startPosition;
			_position = _range * _progress + _startPosition;
			updatePosition();
		}
	}
	
	protected var _isScrolling : Boolean;
	public function get isScrolling():Boolean { return _isScrolling };
	
	protected var _position:Number = 0;
	protected var _startPosition:Number = 0;
	protected var _endPosition:Number = 0;
	protected var _range:Number = 0;
	
	protected var mouseDownOffset:Number = 0;
	
	protected var _stage:DisplayObjectContainer;
	//------------------------------ public methods----------------------------
	override public function install(target:DisplayObject, parameter:Object=null):void
	{
		super.install( target, parameter );
		
		if( parameter )
		{
			if( parameter.hasOwnProperty( "direction" ))
				_direction = parameter.direction;
			
			if( parameter.hasOwnProperty( "thumbStartPosition" ))
				_thumbStartPosition = parameter.thumbStartPosition;
			
			if( parameter.hasOwnProperty( "thumbEndPosition" ))
				_thumbEndPosition = parameter.thumbEndPosition;
				
			if( parameter.hasOwnProperty( "thumbSize" ))
				_thumbSize = parameter.thumbSize;
			
			if( parameter.hasOwnProperty( "wheelEnabled" ))
				_wheelEnabled = parameter.wheelEnabled;
			
			if( parameter.hasOwnProperty( "wheelSpeed" ))
				_wheelSpeed = parameter.wheelSpeed;
		}
		
		updateDirection();
		
		target.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
	}
	
	public function addScrollable( scrollable:IScrollable ):void
	{
		_scrollable = scrollable;
	}
	
	public function addMouseWheelTarget( target:DisplayObject ):void
	{
		target.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true );
	}
	
	public function removeMouseWheelTarget( target:DisplayObject ):void
	{
		target.removeEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
	}
	//------------------------------ protected & private ----------------------
	protected function onMouseDown( event:MouseEvent ):void
	{
		/*if( _position <= thumbStartPosition )
			return;*/
		if ( !enabled )
			return;
			
		if( !_stage )
			_stage = target.stage;
		
		_stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		_stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		
		var localPoint:Point = target.parent.globalToLocal( new Point( _stage.mouseX, _stage.mouseY ));
		if( isVertical )
			mouseDownOffset = target.y - localPoint.y;
		else
			mouseDownOffset = target.x - localPoint.x;
		
		_isScrolling = true;
		sendEvent( DriverEvent.DRAG_START );
	}
	
	protected function onMouseMove( event:MouseEvent ):void
	{
		var localPoint:Point = target.parent.globalToLocal( new Point( _stage.mouseX, _stage.mouseY ));
		
		if( isVertical )
		{
			_position = localPoint.y + mouseDownOffset;
		}
		else
		{
			_position = localPoint.x + mouseDownOffset;
		}
		
		if( _position < _startPosition ) 
			_position = _startPosition;
		else if( _position > _endPosition )
			_position = _endPosition;
		
		_progress = ( _position - _startPosition) / _range;
		
		updatePosition();
		_scrollable.scroll( progress );
		event.updateAfterEvent();
	}
	
	protected function updatePosition():void
	{
		if( isVertical )
		{
			target.y = _position;
		}
		else
		{
			target.x = _position;
		}
	}
	
	protected function updateDirection():void
	{
		isVertical = true;
		if( direction == "horizontal" )
			isVertical = false;
		
		if( isVertical )
		{
			if( thumbSize == 0 )
				_thumbSize = target.height;
		}
		else
		{
			if( thumbSize == 0 )
				_thumbSize = target.width;
		}
		
		_startPosition = thumbStartPosition;//+offset?
		_endPosition = thumbEndPosition - thumbSize; //+offset?
		_position = _startPosition;
		_range = _endPosition - _startPosition;
		updatePosition();
	}
	
	protected function onMouseUp( event:MouseEvent ):void
	{
		clearDragEvent();
	}
	
	protected function clearDragEvent():void
	{
		if ( _stage )
		{
			_stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			_stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		}
		_isScrolling = false;
		sendEvent( DriverEvent.DRAG_COMPLETE );		
	}
	
	protected function onMouseWheel( event:MouseEvent ):void
	{
		if( wheelEnabled && enabled)
		{
			progress -= ( event.delta * 0.01 * wheelSpeed );
		}
	}
	//------------------------------ dispose ----------------------------------
	override public function uninstall():void
	{
		super.uninstall();
		
		target.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		if (_stage)
		{
			_stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			_stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		}
	}
}
}