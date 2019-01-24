package view.classes
{
	import common.*;
	import VO.ClassVO;
	import VO.StudentVO;
	import constants.GameConstant;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import model.AssetPx;
	import model.ClassPx;
	import model.UserPx;
	import net.HttpConstant;
	import net.HttpRequest;
	import view.AddClassView;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class ClassListItem extends BaseComponent implements IListItem 
	{
		private var _assets:MovieClip;
		private var _btnAdd:MovieClip;
		
		private var count:int = 6;
		
		private var _mcItemList:Array;
		
		private var _iconMCList:Array;
		private var _nameTxtList:Array;
		private var _classMCList:Array;
		
		private var _addClassView:AddClassView;
		private var _deleteVo:ClassVO;
				
		public function ClassListItem() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var MCItemClass:Class = assetPx.getGeneralAsset("tab", "ClassListItem");
			_assets = new MCItemClass();
			addChild(_assets);
			
			_btnAdd = _assets.getChildByName("btn_add") as MovieClip;
			_btnAdd.buttonMode = true;
			_btnAdd.addEventListener(MouseEvent.CLICK, onBtnAddClick);
			_btnAdd.visible = false;
			
			_mcItemList = [];
			_iconMCList = [];
			_nameTxtList = [];
			_classMCList = [];
			
			for (var i:int = 0; i < count; i++)
			{
				var item:MovieClip = _assets.getChildByName("mc_item_" + i) as MovieClip;
				_iconMCList.push(item.mc_icon);
				_nameTxtList.push(item.txt_name);
				_classMCList.push(item.btn_select);
				item.btn_select.buttonMode = true;
				item.btn_select.index = i;
				item.btn_select.addEventListener(MouseEvent.CLICK, onBtnDeleteClassClick);
				_mcItemList.push(item);
			}
		}
		
		private function onBtnDeleteClassClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			var item:MovieClip = e.currentTarget as MovieClip;
			var index:int = item.index;
			_deleteVo = _data[index];
			var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
			var json:String = HttpRequest.generateClassData(_deleteVo.classId, _deleteVo.className, "0", 1, userPx.getEduId());
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.DELETE_SINGLE_CLASS, json, GameConstant.NET_METHOD_POST, onGetDeleteResponse);
		}
		
		private function onGetDeleteResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				classPx.deleteClassData(_deleteVo);
				_deleteVo = null;
				sendViewEvent(CommonListComponent.ITEM_UPDATE, null, true);
			}
		}
		
		private function onBtnAddClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			if (_addClassView == null)
			{
				_addClassView = new AddClassView();
			}
			ApplicationFacade.getInstance().addPopupUI(_addClassView);
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
		
		public function update():void
		{
			if (_data)
			{
				var index:int = 0;
				for (var i:int = 0; i < count; i++)
				{
					if (i < _data.length)
					{
						_nameTxtList[i].text = _data[i].className;
						_mcItemList[i].visible = true;
					}
					else
					{
						_mcItemList[i].visible = false;
						if (index == 0)
						{
							index = i;
							_btnAdd.x = _mcItemList[i].x;
						}
						_btnAdd.visible = true;
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