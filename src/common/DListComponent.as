package common
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import flash.display.Graphics;
	import flash.display.Sprite;

public class DListComponent extends BaseComponent
{
	//------------------------------ statics ----------------------------------
	
	//------------------------------ constructor ------------------------------
	public function DListComponent()
	{
		_init();
	}

	//------------------------------ properties -------------------------------
	protected var _scroller:ScrollerComponent;
	public function get scroller():ScrollerComponent { return _scroller }
	
	protected var _scrollerDriver:ScrollerDriver;
	
	protected var _scrollableDriver:ScrollableDriver;
	public function get scrollableDriver():ScrollableDriver { return _scrollableDriver }
	
	protected var _listDriver:DListDriver;
	public function get listDriver():DListDriver { return _listDriver }
	
	protected var _container:Sprite;
	public function get container():Sprite { return _container }
	
	
	override public function set componentWidth(value:Number):void
	{
		if( _componentWidth != value )
		{
			_componentWidth = value;
			var scrollerWidth:Number = 0;
			if (scroller)
			{
				scroller.x = _componentWidth - scroller.componentWidth;
				scrollerWidth = scroller.componentWidth
			}
			
			scrollableDriver.scrollWidth = _componentWidth - scrollerWidth;
			drawBG();
			
			//calculateVisibleNumItems();
		}
		
		
	}
	
	override public function set componentHeight(value:Number):void
	{
		if( _componentHeight != value )
		{
			_componentHeight = value;
			if (scroller)
			{
				scroller.componentHeight = _componentHeight;
				
			}
			scrollableDriver.scrollHeight = _componentHeight;
			drawBG();
			
			//calculateVisibleNumItems();
		}
	}
	
	public function get progress():Number
	{
		return _scrollerDriver.progress;
	}
	public function set progress( value:Number ):void
	{
		_scrollerDriver.progress = value;
	}
	//------------------------------ public methods----------------------------
	public function initList( 
							  verticalGap:Number = 0, 
							  paddingLeft:Number = 0, 
							  paddingTop:Number = 0 ):void
	{
		_scrollableDriver.install( container, { paddingLeft:paddingLeft, paddingTop:paddingTop } );
		
		listDriver.install( _container, {verticalGap:verticalGap } );
			
		_container.x = paddingLeft;
		_container.y = paddingTop;
		
		//calculateVisibleNumItems();
	}
	
	public function update():void
	{
		listDriver.updateAll();
		updateListHeight();
		//scrollableDriver.updateScrollRange();
	}
	
	public function getItems():Vector.<IListItem> 
	{ 
		return listDriver.getItems();
	}
	
	public function setItems( items:Vector.<IListItem> ):void
	{
		listDriver.setItems( items );
		updateListHeight();
		//scrollableDriver.updateScrollRange();
	}
	
	public function addItem( item:IListItem ):void
	{
		listDriver.addItem( item );
		updateListHeight();
		//scrollableDriver.updateScrollRange();
	}
	
	//------------------------------ protected & private ----------------------
	protected function _init():void
	{
		_container = new Sprite();
		addChild( _container );
		
		_listDriver = new DListDriver();
		
		_scrollableDriver = new ScrollableDriver();
		_scroller = new ScrollerComponent();
		_scroller.addScrollableTarget( scrollableDriver );
		_scroller.addMouseWheelTarget( this );
		addChild( _scroller );
		
		_scrollerDriver = _scroller.scrollerDriver;
		
		_scrollableDriver.addEventListener(ScrollableDriver.EVENT_POSITION_UPDATE, onPositionUpdate);
		drawBG();
	}
	
	public function onPositionUpdate(event:Event ):void
	{
		//sendViewEvent(ListComponent.EVENT_LIST_UPDATE, this, true);
	}	
	
	public function setScrollBar(mc:MovieClip):void
	{
		if (_scroller)
		{
			if ( _scroller.parent )
			{
				 _scroller.parent.removeChild(_scroller);
			}
			_scroller.destroy();
			
			_scroller = null;
		}
		
		if ( _scrollerDriver )
		{
			_scrollerDriver.uninstall();
		}
		
		_scroller = new ScrollerComponent(mc);
		_scroller.addScrollableTarget( scrollableDriver );
		_scroller.addMouseWheelTarget( this );
		
		_scrollerDriver = _scroller.scrollerDriver;
		addChild( _scroller );
	}
	
	protected var _numVisibleRows:int = 0;
	public function get numVisibleRows():int
	{
		return _numVisibleRows;
	}
	
	public function isItemVisible(item:IListItem, buf:Number = 0):Boolean
	{				
		if ( item.componentHeight <= _componentHeight * ( 1-buf*2) )
		{
			if ( isItemAboveVisible(item, buf ) )
				return false;
			else if ( isItemUnderVisible(item, buf) )
				return false;
			else 
				return true;
		}
		else
		{
			return isItemAboveVisible(item, buf ) &&  isItemUnderVisible(item, buf);
		}
		
		return false;
	}
	
	public function isItemAboveVisible(item:IListItem, buf:Number = 0):Boolean
	{
		if ( progress == 0 )
			return false;
			
		var pos:Number = item.displayObject.y + _container.y;
		return pos < buf * _componentHeight;
	}
	
	public function isItemUnderVisible(item:IListItem, buf:Number = 0 ):Boolean
	{
		if ( progress == 1 )
		{
			return false;
		}
		
		var pos:Number = item.displayObject.y + _container.y;
		return pos + item.componentHeight > _componentHeight * (1 - buf)
	}
	
	public function makeRowVisible(rowIdx:int, buf:Number = 0, bForceFromTop:Boolean = false):void
	{
		if (getItems().length == 0)
		{
			return;
		}
		if ( buf < 0)
			buf = 0;
			
		if ( !bForceFromTop )
		{
			if ( buf > 0.5 )
				buf = 0.5;		
		}
			
		if ( rowIdx < 0 )
		{
			rowIdx = 0;
		}
		
		if ( rowIdx >= getItems().length )
		{
			rowIdx = getItems().length - 1;
		}
		var item:IListItem = getItems()[rowIdx];
		var pos:Number = item.displayObject.y + _container.y;
		
		if ( bForceFromTop || pos < 0 )
		{
			var progress:Number = (-buf *_componentHeight + item.displayObject.y  ) / ( scrollableDriver.scrollRange);
				
			_scrollerDriver.progress = progress;
		}		
		else if ( item.componentHeight > _componentHeight )
		{
			// don't adjust
		}
		else if (pos + item.componentHeight > _componentHeight )
		{
			progress = ( (item.displayObject.y + item.componentHeight - _componentHeight) + buf *_componentHeight  ) / ( scrollableDriver.scrollRange);
				
			_scrollerDriver.progress = progress;			
		}
	}
	public function get firstVisibleRowIdx():int
	{
		var items :Vector.<IListItem> = getItems();
		for ( var i :int = 0; i < items.length; ++ i )
		{
			if (items[i].displayObject.y + _container.y >= -.5)	//so that make some 0.5 point buff
			{
				return i;
			}
		}
		
		return -1;
	}
	
	public function get lastVisibleRowIdx():int
	{
		var items :Vector.<IListItem> = getItems();
		for ( var i :int = 0; i < items.length; ++ i )
		{
			if (items[i].displayObject.y + _container.y + items[i].componentHeight > _componentHeight)
			{
				return i -1;
			}
		}
		
		return items.length;
	}
	
	public function updateListHeight():void
	{
		var absProgress:Number = scrollableDriver.progress * scrollableDriver.scrollRange;
		
		scrollableDriver.targetHeight = _container.height;
		
		if ( scrollableDriver.scrollRange > 0 )
		{
			_scrollerDriver.enabled = true
		}
		else
		{
			_scrollerDriver.enabled = false;
		}
			
		if ( scrollableDriver.scrollRange > 0 )
		{
			_scrollerDriver.progress = absProgress / scrollableDriver.scrollRange
		}
		else
		{
			_scrollerDriver.progress = 0;
		}
		
		_scrollerDriver.rangeRatio= scrollableDriver.scrollHeight / scrollableDriver.targetHeight ;
	}
	
	protected function drawBG():void
	{
		var g:Graphics = this.graphics;
		g.clear();
		g.beginFill( 0, 0 );
		g.drawRect( 0,0,componentWidth, componentHeight );
		g.endFill();
		

	}
	//------------------------------ dispose ----------------------------------
	public function destroy():void
	{
		
		scroller.destroy();
		_scrollableDriver.uninstall();
		_listDriver.uninstall();
	}
}
}