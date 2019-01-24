package common
{
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.AssetPx;

[Event( name="scrollStart",    type="common.ScrollerComponent")]
[Event( name="scrollComplete", type="common.ScrollerComponent")]
	
public class ScrollerComponent extends BaseComponent
{
	//------------------------------ statics ----------------------------------
	public static const SCROLL_START    : String = "scrollStart";
	public static const SCROLL_COMPLETE : String = "scrollComplete";
	//------------------------------ constructor ------------------------------
	public function ScrollerComponent(mc:Sprite = null)
	{
		init(mc);
	}

	//------------------------------ properties -------------------------------
	protected var asset:Sprite;
	
	protected var bg:Sprite;
	protected var thumbBtn:ButtonDriver;
	public function get thumbBtnDriver():ButtonDriver
	{
		return thumbBtn;
	}
	
	protected var _scrollerDriver:ScrollerDriver;
	protected var scrollable:IScrollable;
	

	public function get scrollerDriver():ScrollerDriver
	{
		return _scrollerDriver
	}
	override public function set enabled( value:Boolean ):void
	{
		//thumbBtn.enabled = value;
		_scrollerDriver.wheelEnabled = value;
		super.enabled = value;
	}
	
	public function get progress():Number
	{
		return _scrollerDriver.progress;
	}
	public function set progress( value:Number ):void
	{
		_scrollerDriver.progress = value;
	}
	
	override public function set componentWidth(value:Number):void 
	{
		if (_componentWidth != value)
		{
			_componentWidth = value;
			bg.width = _componentWidth;
			_scrollerDriver.thumbStartPosition = bg.x;
			_scrollerDriver.thumbEndPosition = bg.x + _componentWidth;
		}
	}
	
	override public function set componentHeight(value:Number):void
	{
		if( _componentHeight != value )
		{
			_componentHeight = value;
			bg.height = _componentHeight;
			_scrollerDriver.thumbStartPosition = bg.y;
			_scrollerDriver.thumbEndPosition = bg.y + _componentHeight;
		}
	}
	
	public function get isScrolling():Boolean
	{
		return _scrollerDriver.isScrolling;
	}
	//------------------------------ public methods----------------------------
	public function addScrollableTarget( scrollable:IScrollable ):void
	{
		this.scrollable = scrollable;
		_scrollerDriver.addScrollable( scrollable );
	}
	
	public function addMouseWheelTarget( target:DisplayObject ):void
	{
		_scrollerDriver.addMouseWheelTarget( target );
	}
	
	private var _thumb:Sprite;
	public function get thumb():Sprite
	{
		return _thumb;
	}
	//------------------------------ protected & private ----------------------
	protected function init(mc:Sprite):void
	{
		if ( mc == null )
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset( "login", "scroller_bar" );
			asset = new cls();
		}
		else
		{
			asset = mc;
		}
		
		bg = asset.getChildByName( "bg" ) as Sprite;
		_thumb = asset.getChildByName( "thumb" ) as MovieClip;
		thumbBtn = new ButtonDriver();
		thumbBtn.install( _thumb );
		
		_componentWidth = bg.width;
		_componentHeight = bg.height;
		addChild( asset );
		
		_scrollerDriver = new ScrollerDriver();
		_scrollerDriver.install( _thumb, { thumbStartPosition: bg.y, thumbEndPosition: bg.y + _componentHeight } );
		_scrollerDriver.addEventListener( DriverEvent.DRAG_START, onDragStart );
		_scrollerDriver.addEventListener( DriverEvent.DRAG_COMPLETE, onDragComplete);
	}
	
	protected function onDragStart( event:DriverEvent ):void
	{
		//thumbBtn.selected = true;
		sendViewEvent( SCROLL_START );
	}
	
	protected function onDragComplete( event:DriverEvent ):void
	{
		//thumbBtn.selected = false;
		sendViewEvent( SCROLL_COMPLETE );
	}
	//------------------------------ dispose ----------------------------------
	public function destroy():void
	{

		_scrollerDriver.uninstall();
		_scrollerDriver.removeEventListener( DriverEvent.DRAG_START, onDragStart );
		_scrollerDriver.removeEventListener( DriverEvent.DRAG_COMPLETE, onDragComplete);
	}
}
}