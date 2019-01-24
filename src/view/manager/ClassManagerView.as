package view.manager
{
	import VO.ClassVO;
	import common.BaseComponent;
	import common.CommonListComponent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.AssetPx;
	import model.ClassPx;
	import view.AddClassView;
	import view.AddStudentView;
	import view.AddTeacherView;
	import view.SelectClassComponent;
	import view.classes.ClassListItem;
	import view.student.StudentListItem;
	import view.teacher.TeacherListItem;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class ClassManagerView extends BaseComponent 
	{
		private var _view:MovieClip;
		
		private var _txtTabName:TextField;
		private var _btnClose:MovieClip;
		
		private var _tabList:Array;
		private var _currentTab:int;
		
		private var _selectClassComponent:SelectClassComponent;
		private var _classManagerListComponent:CommonListComponent;
		private var _teacherManagerListComponent:CommonListComponent;
		private var _studentManagerListComponent:CommonListComponent;
		
		private var _btnAdd:MovieClip;
		
		private var _addClass:AddClassView;
		private var _addTeacher:AddTeacherView;
		private var _addStudent:AddStudentView;
		
		public function ClassManagerView() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("tab", "MCTabManagerView");
			_view = new cls();
			this.addChild(_view);
			
			_txtTabName = _view.getChildByName("txt_tab_name") as TextField;
			
			_btnClose = _view.getChildByName("btn_close") as MovieClip;
			_btnClose.buttonMode = true;
			_btnClose.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
			
			_btnAdd = _view.getChildByName("btn_add") as MovieClip;
			_btnAdd.buttonMode = true;
			_btnAdd.addEventListener(MouseEvent.CLICK, onBtnAddClick);
			_btnAdd.visible = false;
			
			_tabList = new Array();
			
			for (var i:int = 0; i < 3; i++)
			{
				var btn_tab:MovieClip = _view.getChildByName("btn_tab_" + i) as MovieClip;
				btn_tab.buttonMode = true;
				btn_tab.mouseChildren = false;
				btn_tab.index = i;
				btn_tab.addEventListener(MouseEvent.CLICK, onBtnTabClick);
				btn_tab.gotoAndStop(1);
				_tabList.push(btn_tab);
			}
			
			_selectClassComponent = new SelectClassComponent();
			_selectClassComponent.addEventListener(SelectClassComponent.SELECT_CLASS_CHANGE, onSelectClassChange);
			_selectClassComponent.init(_view.mc_class_tab as MovieClip);
			
			_classManagerListComponent = new CommonListComponent();
			_classManagerListComponent.initList(ClassListItem, 2);
			_classManagerListComponent.componentWidth = 1325;
			_classManagerListComponent.componentHeight = 620;
			_classManagerListComponent.setScrollBar(_view.mc_scroll_bar1);
			_classManagerListComponent.addEventListener(CommonListComponent.ITEM_UPDATE, onSelectClassChange);
			_view.mc_container.addChild(_classManagerListComponent);
			
			_teacherManagerListComponent = new CommonListComponent();
			_teacherManagerListComponent.initList(TeacherListItem, 2);
			_teacherManagerListComponent.componentWidth = 1325;
			_teacherManagerListComponent.componentHeight = 620;
			_teacherManagerListComponent.setScrollBar(_view.mc_scroll_bar2);
			_teacherManagerListComponent.addEventListener(CommonListComponent.ITEM_UPDATE, onSelectClassChange);
			_view.mc_container.addChild(_teacherManagerListComponent);
			_teacherManagerListComponent.visible = false;
			
			_studentManagerListComponent = new CommonListComponent();
			_studentManagerListComponent.initList(StudentListItem, 2);
			_studentManagerListComponent.componentWidth = 1325;
			_studentManagerListComponent.componentHeight = 620;
			_studentManagerListComponent.setScrollBar(_view.mc_scroll_bar3);
			_studentManagerListComponent.addEventListener(CommonListComponent.ITEM_UPDATE, onSelectClassChange);
			_view.mc_container.addChild(_studentManagerListComponent);
			_studentManagerListComponent.visible = false;
			
			showItemByIndex(_currentTab);
		}
		
		private function onBtnCloseClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			_selectClassComponent.reset();
			ApplicationFacade.getInstance().removePopupUI(this);
		}
		
		private function onBtnTabClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			_currentTab = e.currentTarget.index;
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var classVo:ClassVO = classPx.getClassData(ClassPx.selectedClassId);
			_selectClassComponent.setDefaultTabName(classVo.className);
			showItemByIndex(_currentTab);
		}
		
		private function onBtnAddClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			switch(_currentTab)
			{
				case 0://class
					if (_addClass == null)
					{
						_addClass = new AddClassView();
					}
					ApplicationFacade.getInstance().addPopupUI(_addClass);
					break;
				case 1://teacher
					if (_addTeacher == null)
					{
						_addTeacher = new AddTeacherView();
					}
					ApplicationFacade.getInstance().addPopupUI(_addTeacher);
					break;
				case 2://student
					if (_addStudent == null)
					{
						_addStudent = new AddStudentView();
					}
					ApplicationFacade.getInstance().addPopupUI(_addStudent);
					break;
			}
		}
		
		private function onSelectClassChange(e:Event):void
		{
			var classId:int = ClassPx.selectedClassId;
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			switch(_currentTab)
			{
				case 0://class
					if (_classManagerListComponent != null)
					{
						var classList:Array = classPx.getSortedClassList();
						_classManagerListComponent.setDataList(classList);
						checkNeedShowAddButton(classList);
					}
					break;
				case 1://teacher
					if (_teacherManagerListComponent != null)
					{
						var teacherList:Array = classPx.getSortedTeacherList();
						_teacherManagerListComponent.setDataList(teacherList);
						checkNeedShowAddButton(teacherList);
					}
					break;
				case 2://student
					if (_studentManagerListComponent != null)
					{
						var studentList:Array = classPx.getSortedStudentList(classId);
						_studentManagerListComponent.setDataList(studentList);
						checkNeedShowAddButton(studentList);
					}
					break;
			}
		}
		
		private function hideAllItem():void
		{
			for (var i:int = 0; i < _tabList.length; i++)
			{
				_tabList[i].gotoAndStop(1);
			}
			_studentManagerListComponent.visible = false;
			_teacherManagerListComponent.visible = false;
			_classManagerListComponent.visible = false;
		}
		
		public function showItemByIndex(index:int = -1):void
		{
			if (index == -1)
			{
				index = _currentTab;
			}
			hideAllItem();
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var classId:int = ClassPx.selectedClassId;
			_tabList[index].gotoAndStop(2);
			_selectClassComponent.reset();
			switch(index)
			{
				case 0:
					_txtTabName.text = "班级管理";
					var classList:Array = classPx.getSortedClassList();
					_classManagerListComponent.setDataList(classList);
					_classManagerListComponent.visible = true;
					_view.mc_class_tab.visible = false;
					checkNeedShowAddButton(classList);
					break;
				case 1:
					_txtTabName.text = "教师管理";
					var teacherList:Array = classPx.getSortedTeacherList();
					_teacherManagerListComponent.setDataList(teacherList);
					_teacherManagerListComponent.visible = true;
					_view.mc_class_tab.visible = false;
					checkNeedShowAddButton(teacherList);
					break;
				case 2:
					_txtTabName.text = "学生管理";
					var studentList:Array = classPx.getSortedStudentList(classId);
					_studentManagerListComponent.setDataList(studentList);
					_studentManagerListComponent.visible = true;
					_view.mc_class_tab.visible = true;
					checkNeedShowAddButton(studentList);
					break;
			}
		}
		
		private function checkNeedShowAddButton(data:Array):void
		{
			if (data.length > 0)
			{
				var needShow:Boolean = false;
				var len:int = data.length - 1;
				if (data[len].length == 6)
				{
					needShow = true;
				}
				_btnAdd.visible = needShow;
				_btnAdd.y = _view.mc_container.y + data.length * _btnAdd.height;
			}
			else
			{
				_btnAdd.visible = true;
				_btnAdd.y = _view.mc_container.y;
			}
		}
		
		override public function get height():Number
		{
			return _view.mc_bg.height;
		}
	}
}