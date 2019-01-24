package view
{
	import VO.ClassVO;
	import VO.StudentVO;
	import common.BaseComponent;
	import common.CommonListComponent;
	import constants.GameConstant;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.AssetPx;
	import model.ClassPx;
	import model.UserPx;
	import net.HttpConstant;
	import net.HttpRequest;
	import view.login.SelectClassItem;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class SelectClassComponent extends BaseComponent 
	{
		public static const SELECT_CLASS_CHANGE:String = "select_class_change";
		
		private var _asset:MovieClip;
		
		private var _txtClassName:TextField;
		private var _btnExpand:MovieClip;
		
		private var _classListComponent:CommonListComponent;
		
		private var _isExpand:Boolean;
		
		public function SelectClassComponent() 
		{
			super();
		}
		
		public function init(asset:MovieClip):void
		{
			_asset = asset;
			_txtClassName = _asset.getChildByName("txt_class_name") as TextField;
			_btnExpand = _asset.getChildByName("btn_expand") as MovieClip;
			_btnExpand.buttonMode = true;
			_btnExpand.addEventListener(MouseEvent.CLICK, onBtnExpandClick);
			
			_classListComponent = new CommonListComponent();
			_classListComponent.initList(SelectClassItem, 2, false);
			_classListComponent.componentWidth = 250;
			_classListComponent.componentHeight = 200;
			_classListComponent.addEventListener(CommonListComponent.SELECTION_CHANGE, onListChange);
			_asset.mc_tab_container.addChild(_classListComponent);
			_asset.mc_tab_container.mouseEnabled = false;
			_classListComponent.visible = false;
			
			reset();
		}
		
		private function onBtnExpandClick(e:MouseEvent):void
		{
			if (_isExpand)
			{
				_isExpand = false;
				_classListComponent.visible = false;
			}
			else
			{
				_isExpand = true;
				_classListComponent.visible = true;
			}
		}
		
		private function onListChange(e:Event):void
		{
			var select:SelectClassItem = (e.currentTarget as CommonListComponent).selectedItem as SelectClassItem;
			trace("Class : " + select.className);
			_txtClassName.text = select.className;
			ClassPx.selectedClassId = select.classId;
			_classListComponent.visible = false;
			
			requestSingleClassData(ClassPx.selectedClassId);
			//_btnClassExpand.gotoAndStop(1);
		}
		
		private function requestSingleClassData(classId:int):void
		{
			var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
			var class_json:String = HttpRequest.generateClassData(classId, "0", "0", 0, userPx.getEduId());
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.GET_CLASS_STUDENTS, class_json, GameConstant.NET_METHOD_POST, onGetSingleClassResponse);
		}
		
		private function onGetSingleClassResponse(resp:Object):void
		{
			if (resp.result == 0 )
			{
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				var studentList:Array = resp.data;
				for (var i:int = 0; i < studentList.length; i++)
				{
					var student:StudentVO = new StudentVO();
					student.id = studentList[i].id;
					student.name = studentList[i].names;
					student.head = studentList[i].headImageId;
					student.phone = studentList[i].phone;
					student.score = studentList[i].star;
					student.sex = int(studentList[i].brithday);
					student.groupId = studentList[i].group_id;
					student.groupName = studentList[i].group_name;
					
					classPx.addStudentData(ClassPx.selectedClassId, student);
				}
				sendViewEvent(SELECT_CLASS_CHANGE);
			}
		}
		
		public function reset():void
		{
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var _class:Array = classPx.classList;
			if (_class.length > 0)
			{
				var classVo:ClassVO = classPx.getClassData(ClassPx.selectedClassId);
				_txtClassName.text = classVo.className;
				_classListComponent.setDataList(_class);
				requestSingleClassData(classVo.classId);
			}
		}
		
		public function setDefaultTabName(tabName:String):void
		{
			_txtClassName.text = tabName;
		}		
	}

}