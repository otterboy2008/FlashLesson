package view.manager
{
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
	import view.SelectClassComponent;
	import view.attendance.AttendanceListItem;
	import view.reward.RewardListItem;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class AttendanceView extends BaseComponent 
	{
		private var _view:MovieClip;
		
		private var _txtTabName:TextField;
		private var _btnClose:MovieClip;
		
		private var _btnConfrim:MovieClip;
		private var _btnCancel:MovieClip;
		
		private var _btnAll:MovieClip;
		private var _isAll:Boolean;
		
		private var _selectClassComponent:SelectClassComponent;
		private var _attendanceListComponent:CommonListComponent;
		
		private var _attendanceStudentList:Array;
		
		public static var canUseOtherFunction:Boolean = true;
		
		
		public function AttendanceView() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("tab", "MCTabAttendanceView");
			_view = new cls();
			this.addChild(_view);
			
			_txtTabName = _view.getChildByName("txt_tab_name") as TextField;
			
			_btnClose = _view.getChildByName("btn_close") as MovieClip;
			_btnClose.buttonMode = true;
			_btnClose.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
			
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
			
			_selectClassComponent = new SelectClassComponent();
			_selectClassComponent.addEventListener(SelectClassComponent.SELECT_CLASS_CHANGE, onSelectClassChange);
			_selectClassComponent.init(_view.mc_class_tab as MovieClip);
			
			_attendanceListComponent = new CommonListComponent();
			_attendanceListComponent.initList(AttendanceListItem, 2, false);
			_attendanceListComponent.componentWidth = 1325;
			_attendanceListComponent.componentHeight = 620;
			_attendanceListComponent.setScrollBar(_view.mc_scroll_bar);
			//_attendanceListComponent.addEventListener(CommonListComponent.SELECTION_CHANGE, onListTeacherChange);
			_view.mc_container.addChild(_attendanceListComponent);
			
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var classList:Array = classPx.classList;
			if (classList.length > 0)
			{
				var studentList:Array = classPx.getSortedStudentList(ClassPx.selectedClassId);
				_attendanceListComponent.setDataList(studentList);
			}
			
			_attendanceStudentList = [];
		}
		
		private function onSelectClassChange(e:Event):void
		{
			if (_attendanceListComponent != null)
			{
				var classId:int = ClassPx.selectedClassId;
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				var studentList:Array = classPx.getSortedStudentList(classId);
				_attendanceListComponent.setDataList(studentList);
			}
			
		}
		
		private function onBtnConfirmClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			_attendanceStudentList = [];
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var studentList:Vector.<StudentVO> = classPx.getClassOfStudentList(ClassPx.selectedClassId);
			for (var i:int = 0; i < studentList.length; i++)
			{
				if (studentList[i].isAttendance)
				{
					_attendanceStudentList.push(studentList[i].id);
				}
			}
			var json:String = HttpRequest.generateLessonAttendanceUp(ClassPx.selectedClassId, _attendanceStudentList, Login_Mediator.selectedTeacher.teacherId);
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.LESSON_ATTENDANCE_UP, json, GameConstant.NET_METHOD_POST, onGetAttendanceResponse);
			onBtnCloseClick(e);
		}
		
		private function onGetAttendanceResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				var lessonPx:LessonPx = ApplicationFacade.getInstance().retrieveProxy(LessonPx.NAME) as LessonPx;
				var lessonVo:LessonVO = lessonPx.getLessonData(SelectLesson_Mediator.selectedLesson + 1);
				if (lessonVo != null)
				{
					lessonVo.isUnlocked = true;
				}
				trace("attendance success");
			}
			canUseOtherFunction = true;
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
			var list:Vector.<IListItem> = _attendanceListComponent.itemList;
			for (var i:int = 0; i < list.length; i++ )
			{
				list[i].selected = _isAll;
			}
		}
		
		private function onBtnCloseClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			_selectClassComponent.reset();
			ApplicationFacade.getInstance().removePopupUI(this);
			canUseOtherFunction = false;
		}
		
		override public function get height():Number 
		{
			return _view.mc_bg.height;
		}
	}

}