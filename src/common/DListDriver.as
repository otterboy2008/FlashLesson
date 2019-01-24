package common
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	

public class DListDriver extends Driver
{
	//------------------------------ statics ----------------------------------
	
	//------------------------------ constructor ------------------------------
	public function DListDriver()
	{
	}

	//------------------------------ properties -------------------------------
	protected var _items:Vector.<IListItem>;
	
	protected var _container:DisplayObjectContainer;
	
	protected var _rowCount:int;
	public function get rowCount():int { return _rowCount; }
	
	protected var _verticalGap:Number = 0;
	public function get verticalGap():Number { return _verticalGap; }

	//------------------------------ public methods----------------------------
	/**
	 *  
	 * @param target:
	 * 		container:Sprite
	 * 
	 * @param parameter:
	 * 		maxColumns    : int = -1
	 * 		columnWidth   : Number = 30
	 * 		rowHeight     : Number = 30
	 * 		horizontalGap : Number = 0
	 * 		verticalGap   : Number = 0
	 * 		paddingLeft   : Number = 0
	 * 		paddingTop    : Number = 0
	 */	
	override public function install( target:DisplayObject, parameter:Object = null ):void
	{
		super.install( target, parameter );
		
		if( !_items )
			_items = new Vector.<IListItem>();
		
		_container = target as DisplayObjectContainer;
		
		if( parameter )
		{
			if( parameter.hasOwnProperty( "verticalGap" ))
				_verticalGap = parameter.verticalGap;		
		}
		
		updateAll();
	}
	
	public function updateAll():void
	{
		clear();
		updateFrom();
	}
	
	public function getItems():Vector.<IListItem> 
	{ 
		return _items; 
	}
	
	public function setItems( items:Vector.<IListItem> ):void
	{
		clear();
		_items = items;
		updateFrom();
	}
	
	public function addItem( item:IListItem ):void
	{
		_items.push( item );
		updateFrom( 99999 );
	}
	
	//------------------------------ protected & private ----------------------
	
	public function updateFrom( startIndex:int = 0 ):void
	{
		var length:int = _items.length;
		if( length == 0 )
			return;
		if( startIndex >= length )
			startIndex = length - 1;
		var endIndex:int = length;

		for ( var i:int = startIndex; i < endIndex; i++ )
		{
			var item:IListItem = _items[ i ];
			_container.addChild( item.displayObject );
			updateItemPosition( item, i );
		}
	}
	

	protected function updateItemPosition(item:IListItem, index:int):void 
	{
		//super.updateItemPosition(item, index);
		
		item.displayObject.x = 0;
		
		var lastMaxY:Number = 0
		
		if ( index - 1 >= 0)
		{
			lastMaxY = Math.max(lastMaxY, getItems()[index - 1].displayObject.y + getItems()[index - 1].componentHeight );
			lastMaxY += _verticalGap;
		}
		
		item.displayObject.y = lastMaxY ;
	}
	
	protected function clear():void
	{
		for each( var item:IListItem in _items )
		{
			_container.removeChild( item.displayObject );
		}
	}
	//------------------------------ dispose ----------------------------------
	override public function uninstall():void
	{
		super.uninstall();
		
		clear();
		_items = null;
		_container = null;
	}
}

}