package view.attendance
{
	import common.*;
	import VO.StudentVO;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import model.AssetPx;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class AttendanceListItem extends BaseComponent implements IListItem 
	{
		private var _assets:MovieClip;
		
		private var count:int = 6;
		
		private var _mcItemList:Array;
		
		private var _iconMCList:Array;
		private var _nameTxtList:Array;
		private var _sexMCList:Array;
		private var _attendanceMCList:Array;
				
		public function AttendanceListItem() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var MCItemClass:Class = assetPx.getGeneralAsset("tab", "AttendanceListItem");
			_assets = new MCItemClass();
			addChild(_assets);
			
			_mcItemList = [];
			_iconMCList = [];
			_nameTxtList = [];
			_sexMCList = [];
			_attendanceMCList = [];
			
			for (var i:int = 0; i < count; i++)
			{
				var item:MovieClip = _assets.getChildByName("mc_item_" + i) as MovieClip;
				item.mc_sex.gotoAndStop(1);
				item.mc_icon.gotoAndStop(1);
				item.btn_select.gotoAndStop(1);
				_iconMCList.push(item.mc_icon);
				_nameTxtList.push(item.txt_name);
				_sexMCList.push(item.mc_sex);
				_attendanceMCList.push(item.btn_select);
				item.btn_select.buttonMode = true;
				item.btn_select.index = i;
				item.btn_select.addEventListener(MouseEvent.CLICK, onBtnAttendanceClick);
				_mcItemList.push(item);
			}
		}
		
		private function onBtnAttendanceClick(e:MouseEvent):void
		{
			var item:MovieClip = e.currentTarget as MovieClip;
			var index:int = item.index;
			if (item.currentFrame == 1)
			{
				item.gotoAndStop(2);
				_data[index].isAttendance = true;
			}
			else
			{
				item.gotoAndStop(1);
				_data[index].isAttendance = false;
			}
			e.stopImmediatePropagation();
		}
		
		private var _data:Array;
		public function get data() : Object
		{
			return _data;
		}
		
		public function set data( value:Object ) : void
		{
			_data = value as Array;
			update();
		}
		
		override public function get selected():Boolean 
		{
			return super.selected;
		}
		
		override public function set selected(value:Boolean):void 
		{
			super.selected = value;
			for (var i:int = 0; i < count; i++)
			{
				if (i < _data.length)
				{
					if (value )
					{
						_attendanceMCList[i].gotoAndStop(2);
						_data[i].isAttendance = true;
					}
					else
					{
						_attendanceMCList[i].gotoAndStop(1);
						_data[i].isAttendance = true;
					}
				}
			}
		}
		
		public function update():void
		{
			if (_data)
			{
				for (var i:int = 0; i < count; i++)
				{
					if (i < _data.length)
					{
						_nameTxtList[i].text = _data[i].name;
						_iconMCList[i].gotoAndStop(_data[i].head);
						_sexMCList[i].gotoAndStop(_data[i].sex);
						_mcItemList[i].visible = true;
					}
					else
					{
						_mcItemList[i].visible = false;
					}
				}
			}	
		}
		
		override public function get componentHeight():Number 
		{
			return _assets.height;
		}
		
		override public function set componentHeight(value:Number):void 
		{
			super.componentHeight = value;
		}
	}

}