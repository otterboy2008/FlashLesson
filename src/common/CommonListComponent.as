package common 
{	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	
	public class CommonListComponent extends BaseComponent 
	{
		//------------------------------ statics ----------------------------------				
		public static const ITEM_CLICK			:String = "ItemClick";
		public static const SELECTION_CHANGE			:String = "SelectionChange";
		public static const SCROLLED					:String = "Scrolled";
		public static const ITEM_UPDATE					:String = "ItemUpdate";
		//------------------------------ constructor ------------------------------
		public function CommonListComponent() 
		{
			_init();
		}
			
		//------------------------------ properties -------------------------------
		private var ItemClass : Class;

		protected var _listComponent : DListComponent;
		public function get listComponent() : DListComponent { return _listComponent }
		
		
		protected var _requireSelection : Boolean;
		public function get requireSelection() : Boolean { return _requireSelection }
		
		protected var _selectedItem : IListItem;
		
		public function get selectedItem():IListItem
		{
			return _selectedItem;
		}
		

		
		public function get progress():Number
		{
			return listComponent.progress;
		}
		public function set progress( value:Number ):void
		{
			listComponent.progress = value;
		}
		
		override public function set componentWidth(value:Number):void
		{
			if( _componentWidth != value )
			{
				_componentWidth = value;
				listComponent.componentWidth = value;
			}
		}
		
		override public function set componentHeight(value:Number):void
		{
			if( _componentHeight != value )
			{
				_componentHeight = value;
				listComponent.componentHeight = value
			}
		}
		

		
		public function numItems():int
		{
			return itemList.length;
		}
		
		public function getItem(idx:int):IListItem
		{
			if (idx >= 0 && idx < itemList.length )
			{
				return itemList[idx];
			}
			
			return null;
		}
		
		public function findItem(theData:Object):IListItem
		{
			for each( var item:IListItem in itemList )
			{
				if ( item.data == theData )
				{
					return item;
				}
			}		
			
			return null;
		}
		
		public function updateItemData(theData:Object):void
		{
			for each( var item:IListItem in itemList )
			{
				if ( item.data == theData )
				{
					item.data = theData;
					break;
				}
			}
		}		
		
		
		
		public function updateItemsPosition():void
		{
			listComponent.updateListHeight();
		}
		
		
		//------------------------------ public methods----------------------------
		public function initList(renderClass : Class,gap :int= 0, requireSelection : Boolean = true, itemWidth:int = 0, itemHeight :int = 0  ) : void
		{
			_requireSelection = requireSelection;
			
			if (renderClass!= null)
				ItemClass = renderClass;
			
				
			if ( itemWidth == 0 || itemHeight == 0)
			{
				var item:Object= new ItemClass();
				
				if ( itemWidth == 0 )
				{
					itemWidth = item.width;					
				}
				
				if ( itemHeight == 0 )
				{
					itemHeight = item.height;
				}
			}
			listComponent.initList(gap);
			
			addChild(listComponent);
		}
		
		public function setDataList( data:Array, needReconstruct:Boolean = false ):void
		{
			_dataList = data;
			if ( needReconstruct )
			{
				_selectedItem = null;
				m_cacheVOToItem = new Dictionary(true);	//clear all cache
			}
			
			update();
		}
		
		//------------------------------ protected & private ----------------------
		protected function _init():void
		{
			_listComponent = new DListComponent();
			_itemList = new Vector.<IListItem>;
			
			_listComponent.scrollableDriver.cb_positionUpdate = onPositionScrolled
		}
		
		protected function onPositionScrolled():void
		{
			sendViewEvent(SCROLLED);
		}
		
		private var m_cacheVOToItem:Dictionary = new Dictionary(true);
		
		protected function update( ) : void
		{
			for each(var lbRender : IListItem in itemList)
			{
				lbRender.displayObject.removeEventListener(MouseEvent.CLICK, onItemClick);
				lbRender.displayObject.removeEventListener(ITEM_UPDATE, onItemUpdate);
			}
			
			_itemList = new Vector.<IListItem> ();
				
			var lastSelectItem:IListItem = _selectedItem;
			_selectedItem = null;
			for each(var data : Object in _dataList)
			{		
				var listItem : IListItem = m_cacheVOToItem[data];
				if (listItem == null )
				{
					if ( data.hasOwnProperty("ItemClass") && data.ItemClass && data.ItemClass is Class )
					{
						listItem = new (data.ItemClass as Class)();
					}
					else
					{
						listItem = new ItemClass();
					}
					
					m_cacheVOToItem[data] = listItem;
				}
				
				
				
				listItem.data = data;
				listItem.displayObject.addEventListener( MouseEvent.CLICK, onItemClick );
				listItem.displayObject.addEventListener(ITEM_UPDATE, onItemUpdate);
				itemList.push(listItem);
				
				if (listItem == lastSelectItem)
				{
					_selectedItem = lastSelectItem;
				}
			}
			
			if ( _selectedItem == null)
			{
				if (requireSelection && itemList.length >= 1)
				{
					var item0 : IListItem = itemList[0] as IListItem;
					item0.selected = true;
					_selectedItem = item0;
				}
				else
				{
					_selectedItem = null;				
				}
			}
			
			listComponent.setItems(itemList);
			
			if (_selectedItem != lastSelectItem && requireSelection)
			{
				sendViewEvent( SELECTION_CHANGE, { last:lastSelectItem, current: _selectedItem } );
			}
		}
		
		protected function onItemClick( event : MouseEvent) : void
		{
			var itemRender : IListItem = event.currentTarget as IListItem;
			var lastSelectedItem:IListItem = _selectedItem
			if (itemRender != _selectedItem)
			{
				itemRender.selected = true;
				
				if (_selectedItem)
					_selectedItem.selected = false;
				_selectedItem = itemRender;
				
				sendViewEvent( SELECTION_CHANGE, { last:lastSelectedItem, current:itemRender } );
			}
			
			sendViewEvent( ITEM_CLICK, itemRender );
		}
		
		protected function onItemUpdate(e:Event):void
		{
			sendViewEvent(ITEM_UPDATE);
		}
		
		// ------------------------ Protected Properties --------------------------		
		protected var _dataList : Array;
		public function get dataList():Array
		{
			return _dataList;
		}
		
		protected var _itemList : Vector.<IListItem>;		
		public function get itemList(): Vector.<IListItem>
		{
			return _itemList;
		}
		
		//------------------------------ dispose ----------------------------------
		public function destroy():void
		{
			_listComponent.destroy();
		}
		
		public function setScrollBar(mc:MovieClip):void
		{
			_listComponent.setScrollBar(mc);
		}
		
	}
}
