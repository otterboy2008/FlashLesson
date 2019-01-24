package view
{
	import VO.ClassVO;
	import VO.GroupVO;
	import VO.LessonVO;
	import VO.StudentVO;
	import common.BaseComponent;
	import common.CommonListComponent;
	import common.IListItem;
	import constants.GameConstant;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import mediator.Login_Mediator;
	import mediator.SelectLesson_Mediator;
	import model.AssetPx;
	import model.ClassPx;
	import model.LessonPx;
	import net.HttpConstant;
	import net.HttpRequest;
	import view.group.GroupListItem;
	import view.reward.RewardListItem;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class AddGroupView extends BaseComponent 
	{
		private var _view:MovieClip;
		
		private var _txtInputGroupName:TextField;
		
		private var _btnConfrim:MovieClip;
		private var _btnCancel:MovieClip;
		
		private var _btnAll:MovieClip;
		private var _isAll:Boolean;
		
		private var _studentListComponent:CommonListComponent;
		
		private var _groupStudentList:Array;
		
		
		public function AddGroupView() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("tab", "MCAddGroup");
			_view = new cls();
			this.addChild(_view);
			
			_txtInputGroupName = _view.getChildByName("txt_group_name") as TextField;
			
			_btnConfrim = _view.getChildByName("btn_confirm") as MovieClip;
			_btnConfrim.buttonMode = true;
			_btnConfrim.addEventListener(MouseEvent.CLICK, onBtnConfirmClick);
			
			_btnCancel = _view.getChildByName("btn_cancel") as MovieClip;
			_btnCancel.buttonMode = true;
			_btnCancel.addEventListener(MouseEvent.CLICK, onBtnCancelClick);
			
			_btnAll = _view.getChildByName("btn_all") as MovieClip;
			_btnAll.buttonMode = true;
			_btnAll.addEventListener(MouseEvent.CLICK, onBtnAllClick);
			_btnAll.gotoAndStop(1);
			
			_studentListComponent = new CommonListComponent();
			_studentListComponent.initList(GroupListItem, 2, false);
			_studentListComponent.componentWidth = 1325;
			_studentListComponent.componentHeight = 600;
			_studentListComponent.setScrollBar(_view.mc_scroll_bar);
			//_studentListComponent.addEventListener(CommonListComponent.SELECTION_CHANGE, onListTeacherChange);
			_view.mc_container.addChild(_studentListComponent);
			
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var studentList:Array = classPx.getSortedStudentList(ClassPx.selectedClassId);
			_studentListComponent.setDataList(studentList);
			
			_groupStudentList = [];
		}
		
		
		private function onBtnConfirmClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			if (_txtInputGroupName.text.length == 0)
			{
				return;
			}
			_groupStudentList = [];
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var studentList:Vector.<StudentVO> = classPx.getClassOfStudentList(ClassPx.selectedClassId);
			for (var i:int = 0; i < studentList.length; i++)
			{
				if (studentList[i].preSelectGroup)
				{
					_groupStudentList.push(studentList[i].id);
					studentList[i].preSelectGroup = false;
				}
			}
			var json:String = HttpRequest.generateAddStudentGroup(_txtInputGroupName.text, _groupStudentList);
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.ADD_GROUP_STUDENT, json, GameConstant.NET_METHOD_POST, onSetGroupResponse);
			onBtnCloseClick(e);
		}
		
		private function onSetGroupResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				var group:GroupVO = new GroupVO();
				group.groupId = resp.data;
				group.groupName = _txtInputGroupName.text;
				
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				for (var i:int = 0; i < _groupStudentList.length; i++)
				{
					classPx.updateStudentGroupIdAndName(ClassPx.selectedClassId, _groupStudentList[i], group.groupId, group.groupName);
				}
			}
		}
		
		private function onBtnCancelClick(e:MouseEvent):void
		{
			onBtnCloseClick(e);
		}
		
		private function onBtnAllClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			if (_isAll)
			{
				_isAll = false;
				_btnAll.gotoAndStop(1);
			}
			else
			{
				_isAll = true;
				_btnAll.gotoAndStop(2);
				
			}
			var list:Vector.<IListItem> = _studentListComponent.itemList;
			for (var i:int = 0; i < list.length; i++ )
			{
				list[i].selected = _isAll;
			}
		}
		
		private function onBtnCloseClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			ApplicationFacade.getInstance().removePopupUI(this);
		}
		
		override public function get height():Number 
		{
			return _view.mc_bg.height;
		}
	}

}