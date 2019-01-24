package view.student
{
	import common.*;
	import VO.StudentVO;
	import constants.GameConstant;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import model.AssetPx;
	import model.ClassPx;
	import net.HttpConstant;
	import net.HttpRequest;
	import view.AddStudentView;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class StudentListItem extends BaseComponent implements IListItem 
	{
		
		private var _assets:MovieClip;
		private var _btnAdd:MovieClip;
		
		private var count:int = 6;
		
		private var _mcItemList:Array;
		
		private var _iconMCList:Array;
		private var _nameTxtList:Array;
		private var _sexMCList:Array;
		private var _managerMCList:Array;
		
		private var _addStudentView:AddStudentView;
		
		private var _deleteVo:StudentVO;
				
		public function StudentListItem() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var MCItemClass:Class = assetPx.getGeneralAsset("tab", "StudentListItem");
			_assets = new MCItemClass();
			addChild(_assets);
			
			_btnAdd = _assets.getChildByName("btn_add") as MovieClip;
			_btnAdd.buttonMode = true;
			_btnAdd.addEventListener(MouseEvent.CLICK, onBtnAddClick);
			_btnAdd.visible = false;
			
			_mcItemList = [];
			_iconMCList = [];
			_nameTxtList = [];
			_sexMCList = [];
			_managerMCList = [];
			
			for (var i:int = 0; i < count; i++)
			{
				var item:MovieClip = _assets.getChildByName("mc_item_" + i) as MovieClip;
				item.mc_sex.gotoAndStop(1);
				item.btn_select.gotoAndStop(1);
				item.mc_icon.gotoAndStop(1);
				_iconMCList.push(item.mc_icon);
				_nameTxtList.push(item.txt_name);
				_sexMCList.push(item.mc_sex);
				_managerMCList.push(item.btn_select);
				item.btn_select.buttonMode = true;
				item.btn_select.index = i;
				item.btn_select.addEventListener(MouseEvent.CLICK, onBtnDeleteClick);
				_mcItemList.push(item);
			}
		}
		
		private function onBtnDeleteClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			var item:MovieClip = e.currentTarget as MovieClip;
			var index:int = item.index;
			_deleteVo = _data[index];
			var json:String = HttpRequest.generateStudentData(_deleteVo.id, _deleteVo.name, _deleteVo.phone, 1);
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.DELETE_SINGLE_STUDENT, json, GameConstant.NET_METHOD_POST, onGetDeleteResponse);
		}
		
		private function onGetDeleteResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				classPx.deleteStudentData(_deleteVo);
				_deleteVo = null;
				sendViewEvent(CommonListComponent.ITEM_UPDATE, null, true);
			}
		}
		
		private function onBtnAddClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			if (_addStudentView == null)
			{
				_addStudentView = new AddStudentView();
			}
			ApplicationFacade.getInstance().addPopupUI(_addStudentView);
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
				_btnAdd.visible = false;
				var index:int = 0;
				for (var i:int = 0; i < count; i++)
				{
					if (i < _data.length)
					{
						_nameTxtList[i].text = _data[i].name;
						_iconMCList[i].gotoAndStop(_data[i].head);
						var sex:int = _data[i].sex + 1;
						_sexMCList[i].gotoAndStop(sex);
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