package view.teacher
{
	import common.*;
	import VO.StudentVO;
	import VO.TeacherVO;
	import constants.GameConstant;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import model.AssetPx;
	import model.ClassPx;
	import model.UserPx;
	import net.HttpConstant;
	import net.HttpRequest;
	import view.AddTeacherView;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class TeacherListItem extends BaseComponent implements IListItem 
	{
		private var _assets:MovieClip;
		private var _btnAdd:MovieClip;
		
		private var count:int = 6;
		
		private var _mcItemList:Array;
		
		private var _iconMCList:Array;
		private var _nameTxtList:Array;
		private var _teacherMCList:Array;
		
		private var _addTeacherView:AddTeacherView;
		
		private var _deleteVo:TeacherVO;
				
		public function TeacherListItem() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var MCItemClass:Class = assetPx.getGeneralAsset("tab", "TeacherListItem");
			_assets = new MCItemClass();
			addChild(_assets);
			
			_btnAdd = _assets.getChildByName("btn_add") as MovieClip;
			_btnAdd.buttonMode = true;
			_btnAdd.addEventListener(MouseEvent.CLICK, onBtnAddClick);
			_btnAdd.visible = false;
			
			_mcItemList = [];
			_iconMCList = [];
			_nameTxtList = [];
			_teacherMCList = [];
			
			for (var i:int = 0; i < count; i++)
			{
				var item:MovieClip = _assets.getChildByName("mc_item_" + i) as MovieClip;
				item.mc_icon.gotoAndStop(1);
				_iconMCList.push(item.mc_icon);
				_nameTxtList.push(item.txt_name);
				_teacherMCList.push(item.btn_select);
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
			var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
			var json:String = HttpRequest.generateTeacherData(_deleteVo.teacherId, _deleteVo.classTeacher, _deleteVo.teacherPhoneNumber, 1, userPx.getEduId());
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.DELETE_SINGLE_TEACHER, json, GameConstant.NET_METHOD_POST, onGetDeleteResponse);
		}
		
		private function onGetDeleteResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				classPx.deleteTeacherData(_deleteVo);
				_deleteVo = null;
				sendViewEvent(CommonListComponent.ITEM_UPDATE, null, true);
			}
		}
		
		private function onBtnAddClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			if (_addTeacherView == null)
			{
				_addTeacherView = new AddTeacherView();
			}
			ApplicationFacade.getInstance().addPopupUI(_addTeacherView);
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
						_nameTxtList[i].text = _data[i].classTeacher;
						_iconMCList[i].gotoAndStop(_data[i].head);
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