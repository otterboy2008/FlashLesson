package view.manager
{
	import VO.StudentVO;
	import common.BaseComponent;
	import common.CommonListComponent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.AssetPx;
	import model.ClassPx;
	import model.LessonPx;
	import view.AddGroupView;
	import view.SelectClassComponent;
	import view.SelectGroupComponent;
	import view.reward.GroupStudentListItem;
	import view.reward.RewardListItem;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class RewardView extends BaseComponent 
	{
		private var _view:MovieClip;
		
		private var _txtTabName:TextField;
		private var _btnClose:MovieClip;
		
		private var _mcNoGroupContainer:MovieClip;
		private var _mcGroupContainer:MovieClip;
		private var _mcTopThree:MovieClip;
		

		private var _selectClassComponent:SelectClassComponent;
		private var _selectGroupComponent:SelectGroupComponent;
		private var _studentListComponent:CommonListComponent;
		private var _groupListComponent:CommonListComponent;
		
		private var _addGroupView:AddGroupView;
		
		private var _btnAddGroup:MovieClip;
		private var _hasGroup:Boolean;
		
		private var _needEnableGroupFunction:Boolean = false;
		
		public function RewardView() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("tab", "MCTabRewardView");
			_view = new cls();
			this.addChild(_view);
			
			_txtTabName = _view.getChildByName("txt_tab_name") as TextField;
			
			_mcNoGroupContainer = _view.getChildByName("mc_container") as MovieClip;
			_mcGroupContainer = _view.getChildByName("mc_group_container") as MovieClip;
			_mcTopThree = _view.getChildByName("mc_top_three") as MovieClip;
			
			_btnClose = _view.getChildByName("btn_close") as MovieClip;
			_btnClose.buttonMode = true;
			_btnClose.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
			
			_btnAddGroup = _view.getChildByName("btn_add_group") as MovieClip;
			_btnAddGroup.buttonMode = true;
			_btnAddGroup.addEventListener(MouseEvent.CLICK, onBtnAddGroupClick);
			
			_selectClassComponent = new SelectClassComponent();
			_selectClassComponent.addEventListener(SelectClassComponent.SELECT_CLASS_CHANGE, onSelectClassChange);
			_selectClassComponent.init(_view.mc_class_tab as MovieClip);
			
			_selectGroupComponent = new SelectGroupComponent();
			_selectGroupComponent.addEventListener(SelectGroupComponent.SELECT_GROUP_CHANGE, onSelectGroupChange);
			_selectGroupComponent.init(_view.mc_group_tab as MovieClip);
			
			_studentListComponent = new CommonListComponent();
			_studentListComponent.initList(RewardListItem, 2);
			_studentListComponent.componentWidth = 1325;
			_studentListComponent.componentHeight = 700;
			_studentListComponent.setScrollBar(_view.mc_scroll_bar);
			_mcNoGroupContainer.addChild(_studentListComponent);
			
			_groupListComponent = new CommonListComponent();
			_groupListComponent.initList(GroupStudentListItem, 2);
			_groupListComponent.componentWidth = 1325;
			_groupListComponent.componentHeight = 450;
			_groupListComponent.addEventListener(CommonListComponent.ITEM_UPDATE, onGroupStudentChange);
			_groupListComponent.setScrollBar(_view.mc_group_scroll_bar);
			_mcGroupContainer.addChild(_groupListComponent);
			
			initGroupData();
		}
		
		public function initGroupData():void
		{
			var lessonPx:LessonPx = ApplicationFacade.getInstance().retrieveProxy(LessonPx.NAME) as LessonPx;
			_needEnableGroupFunction = lessonPx.needGroupFunction;
			
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var classId:int = ClassPx.selectedClassId;
			var studentList:Array = classPx.getSortedStudentList(classId);
			_studentListComponent.setDataList(studentList);
			
			var groupList:Array = classPx.getClassGroupNameList(classId);
			_groupListComponent.setDataList(groupList);
			_hasGroup = groupList.length > 0;
			_mcNoGroupContainer.visible = !_hasGroup;
			_mcGroupContainer.visible = _hasGroup;
			_mcTopThree.visible = _hasGroup;
			_selectGroupComponent.reset();
			if (_hasGroup)
			{
				for (var i:int = 0; i < 3; i++)
				{
					var txtGroupName:TextField = _mcTopThree.getChildByName("txt_groupName_" + i) as TextField;
					var txtGroupScore:TextField = _mcTopThree.getChildByName("txt_groupScore_" + i) as TextField;
					if (i < groupList.length)
					{
						txtGroupName.text = groupList[i].groupName;
						txtGroupScore.text = classPx.getClassGroupStudentsTotalScore(classId, groupList[i].groupId).toString();
					}
					else
					{
						txtGroupName.text = "未分组";
						txtGroupScore.text = "0";
					}
				}
			}
			if (_needEnableGroupFunction == false)
			{
				_btnAddGroup.visible = _needEnableGroupFunction;
				_selectGroupComponent.visible = _needEnableGroupFunction;
				_mcGroupContainer.visible = _needEnableGroupFunction;
				_mcTopThree.visible = _needEnableGroupFunction;
				_view.mc_group_tab.visible = _needEnableGroupFunction;
				_mcNoGroupContainer.visible = !_needEnableGroupFunction;
			}
		}
		
		private function onSelectClassChange(e:Event):void
		{
			if (_studentListComponent != null)
			{
				initGroupData();
			}
		}
		
		private function onSelectGroupChange(e:Event):void
		{
			
		}
		
		private function onGroupStudentChange(e:Event):void
		{
			initGroupData();
		}
		
		private function onBtnCloseClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			_selectClassComponent.reset();
			ApplicationFacade.getInstance().removePopupUI(this);
		}
		
		private function onBtnAddGroupClick(e:MouseEvent):void
		{
			if (_addGroupView == null)
			{
				_addGroupView = new AddGroupView();
			}
			ApplicationFacade.getInstance().addPopupUI(_addGroupView);
		}
		
		override public function get height():Number 
		{
			return _view.mc_bg.height;
		}
	}

}