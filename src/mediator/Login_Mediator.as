package mediator
{
	import VO.ClassVO;
	import VO.StudentVO;
	import VO.TeacherVO;
	import component.PreUseComponent;
	import constants.ApplicationConstant;
	import constants.GameConstant;
	import constants.ViewConstant;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import model.AssetPx;
	import model.ClassPx;
	import model.LessonPx;
	import model.SoundPx;
	import model.UserPx;
	import net.HttpConstant;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.system.fscommand;
	import net.HttpRequest;
	import flash.events.Event;
	import common.*;
	import view.AddClassView;
	import view.AddEducationView;
	import view.AddTeacherView;
	import view.login.*;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class Login_Mediator extends Mediator 
	{		
		private var _view:MovieClip;
		private var _btnClose:MovieClip;
		private var _btnLogin:MovieClip;
		private var _btnAddClass:MovieClip;
		private var _btnAddTeacher:MovieClip;
		private var _btnClassExpand:MovieClip;
		private var _btnTeacherExpand:MovieClip;
		
		private var _txtClassName:TextField;
		private var _txtTeacherName:TextField;
		
		private var _mcAddTeacher:AddTeacherView;
		private var _mcAddClass:AddClassView;
		private var _mcAddEducation:AddEducationView;
		
		private var _isSfxOff:Boolean;
		
		private var _classList:CommonListComponent;
		private var _teacherList:CommonListComponent;
		private var _preUseComponent:PreUseComponent;
		
		public static var selectedClass:ClassVO;
		public static var selectedTeacher:TeacherVO;
		
		public static var btnMusic:MovieClip;
		
		private var _filter:ColorMatrixFilter;
		private var _preUseDay:int = 30;
		
		public function Login_Mediator(mediatorName:String = null, viewComponent:Object = null):void
		{
			super(ViewConstant.VIEW_LOGIN, viewComponent);
			
			_filter = new ColorMatrixFilter([0.3, 0.6, 0, 0, 0, 0.3, 0.6, 0, 0, 0, 0.3, 0.6, 0, 0, 0, 0, 0, 0, 1, 0]) ;
			
			_view = viewComponent as MovieClip;
			_view.buttonMode = true;
			_btnClose = _view.getChildByName("btn_close") as MovieClip;
			_btnClose.buttonMode = true;
			_btnLogin = _view.getChildByName("btn_login") as MovieClip;
			_btnLogin.buttonMode = true;
			_btnLogin.mouseEnabled = false;
			_btnLogin.filters = [_filter];
				
			_btnAddClass = _view.getChildByName("btn_add_class") as MovieClip;
			_btnAddClass.buttonMode = true;
			_btnAddClass.addEventListener(MouseEvent.CLICK, onBtnAddClassClick);
			
			_btnAddTeacher = _view.getChildByName("btn_add_teacher") as MovieClip;
			_btnAddTeacher.buttonMode = true;
			_btnAddTeacher.addEventListener(MouseEvent.CLICK, onBtnAddTeacherClick);
			
			_btnClassExpand = _view.getChildByName("btn_class_expand") as MovieClip;
			_btnClassExpand.addEventListener(MouseEvent.CLICK, onBtnClassExpandClick);
			_btnClassExpand.buttonMode = true;
			_btnClassExpand.gotoAndStop(1);
			_btnTeacherExpand = _view.getChildByName("btn_teacher_expand") as MovieClip;
			_btnTeacherExpand.addEventListener(MouseEvent.CLICK, onBtnTeacherExpandClick);
			_btnTeacherExpand.buttonMode = true;
			_btnTeacherExpand.gotoAndStop(1);
			
			_txtClassName = _view.getChildByName("txt_class_name") as TextField;
			_txtTeacherName = _view.getChildByName("txt_teacher_name") as TextField;
			
			//_btnMusic = _view.getChildByName("btn_music") as MovieClip;
			//_btnMusic.buttonMode = true;
			//_btnMusic.addEventListener(MouseEvent.CLICK, onBtnMusicClick);
			
			//_btnSfx = _view.getChildByName("btn_sfx") as MovieClip;
			//_btnSfx.buttonMode = true;
			//_btnSfx.addEventListener(MouseEvent.CLICK, onBtnSfxClick);
			
			_btnClose.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
			_btnLogin.addEventListener(MouseEvent.ROLL_OVER, onBtnLoginOver);
			_btnLogin.addEventListener(MouseEvent.ROLL_OUT, onBtnLoginOut);
			_btnLogin.addEventListener(MouseEvent.CLICK, onBtnLoginClick);
			
			_classList = new CommonListComponent();
			_classList.initList(ClassItem, 2);
			_classList.componentWidth = 300;
			_classList.componentHeight = 160;
			_classList.addEventListener(CommonListComponent.SELECTION_CHANGE, onListClassChange);
			//_classList.addEventListener(CommonListComponent.SCROLLED, onScrolled);
			_view.mc_class_container.addChild(_classList);
			_classList.visible = false;
			
			_teacherList = new CommonListComponent();
			_teacherList.initList(TeacherItem, 2);
			_teacherList.componentWidth = 300;
			_teacherList.componentHeight = 160;
			_teacherList.addEventListener(CommonListComponent.SELECTION_CHANGE, onListTeacherChange);
			//_teacherList.addEventListener(CommonListComponent.SCROLLED, onScrolled);
			_view.mc_teacher_container.addChild(_teacherList);
			_teacherList.visible = false;
			
			var so:SharedObject = SharedObject.getLocal("lessonSO");
			var active:String = so.data.active;
			var eduId:int = so.data.eduId;
			if (active == "" || active == null)
			{
				_mcAddEducation = new AddEducationView();
				_mcAddEducation.addEventListener(AddEducationView.START_PRE_USE, onStartPreUse);
				ApplicationFacade.getInstance().addPopupUI(_mcAddEducation);
			}
			else
			{
				var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
				var class_json:String = HttpRequest.generateClassData(1, "0", "0", 0, eduId);
				HttpRequest.getInstance().sendHttpRequest(HttpConstant.GET_ALL_CLASS, class_json, GameConstant.NET_METHOD_POST, onGetAllClassResponse);
				var teacher_json:String = HttpRequest.generateTeacherData(1, "0", "0", 0, userPx.getEduId());
				HttpRequest.getInstance().sendHttpRequest(HttpConstant.GET_ALL_TEACHER, teacher_json, GameConstant.NET_METHOD_POST, onGetAllTeacherResponse);
				var preuse_json:String = HttpRequest.generateGetEduStatus(eduId);
				HttpRequest.getInstance().sendHttpRequest(HttpConstant.GET_EDUCATION_STATUS, preuse_json, GameConstant.NET_METHOD_POST, onGetPreUseResponse);
			}
			initData();
			
			initMusicButton();
			/*
			var networkInfo:NetworkInfo = NetworkInfo.networkInfo;
			var interfaces:Vector.<NetworkInterface> = networkInfo.findInterfaces();
			if( interfaces != null )
			{
				for each ( var interfaceObj:NetworkInterface in interfaces )
				{
					for each ( var address:InterfaceAddress in interfaceObj.addresses )
					{
						trace( " type: " + address.ipVersion );
						trace( " address: " + address.address );
					}
				} 
			}
			*/
		}
		
		private function initData():void
		{
			var classPx:ClassPx = facade.retrieveProxy(ClassPx.NAME) as ClassPx;
			/*
			for (var i:int = 0; i < 10; i++)
			{
				var vo:ClassVO = new ClassVO();
				vo.classId = i;
				vo.className = "class_" + i;
				vo.studentList = new Vector.<StudentVO>();
				for (var j:int = 0; j < 16; j++)
				{
					var so:StudentVO = new StudentVO();
					so.id = j;
					so.head = j + 1;
					so.name = "c" + i + "s" + j;
					if (j > 6)
					{
						so.sex = 1;
					}
					else
					{
						so.sex = 2;
					}
					so.score = j * 10;
					so.phone = i * 10 + j * 10 + 100;
					vo.studentList.push(so);
				}
				vo.teacherList = new Vector.<TeacherVO>();
				for (var k:int = 0; k < 3; k++)
				{
					var to:TeacherVO = new TeacherVO();
					to.teacherId = k;
					to.head = k + 1;
					to.classTeacher = "c" + i + "t" + k;
					to.teacherPhoneNumber = i * 130 + 1;
					vo.teacherList.push(to);
				}
				classPx.addClassData(vo);
			}
			var list:Array = classPx.classList;
			var tList:Array = classPx.getAllTeacherList();
			_classList.setDataList(list);
			_teacherList.setDataList(tList);
			_txtClassName.text = list[0].className;
			_txtTeacherName.text = tList[0].classTeacher;
			*/
			//init lesson data
			var lessonPx:LessonPx = facade.retrieveProxy(LessonPx.NAME) as LessonPx;
			var assetPx:AssetPx = facade.retrieveProxy(AssetPx.NAME) as AssetPx;
			var obj:Object = assetPx.getGeneralJSON("lesson_json");
			lessonPx.initLessonData(obj);
		}
		
		private function onGetAllTeacherResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				var teacherData:Array = resp.data;
				for (var i:int = 0; i < teacherData.length; i++)
				{
					var teacher:TeacherVO = new TeacherVO();
					teacher.teacherId = teacherData[i].id;
					teacher.eduId = teacherData[i].eduId;
					teacher.head = teacherData[i].headImageId;
					teacher.classTeacher = teacherData[i].names;
					teacher.teacherPhoneNumber = teacherData[i].phone;
					classPx.addTeacherData(teacher);
				}
				var list:Array = classPx.teacherList;
				if (list.length > 0)
				{
					_teacherList.setDataList(list);
					_txtTeacherName.text = list[0].classTeacher;
					selectedTeacher = list[0];
				}
			}
			checkBtnLoginState();
		}
		
		private function onGetAllClassResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				var classData:Array = resp.data;
				for (var i:int = 0; i < classData.length; i++)
				{
					var classVo:ClassVO = new ClassVO();
					classVo.classId = classData[i].id;
					classVo.eduId = classData[i].eduId;
					classVo.desc = classData[i].descs;
					classVo.className = classData[i].names;
					classVo.studentList = new Vector.<StudentVO>();
					classPx.addClassData(classVo);
				}
				var list:Array = classPx.classList;
				if (list.length > 0)
				{
					_classList.setDataList(list);
					_txtClassName.text = list[0].className;
					selectedClass = list[0];
					sendGetClassChapter(selectedClass.classId);
				}
			}
			checkBtnLoginState();
		}
		
		private function onStartPreUse(e:Event):void
		{
			var so:SharedObject = SharedObject.getLocal("lessonSO");
			var startDate:Date = new Date();
			var time:Number = Math.round(startDate.getTime() / 1000);
			so.data.start = time;
			so.flush();
			initPreUseHint();
		}
		
		private function onGetPreUseResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				var out:int = resp.data;
				if (out == 0)//normal
				{
					//do nothing
				}
				else if (out == 1)//pre use
				{
					initPreUseHint();
				}
				else if (out == 2)//can't use
				{
					if (_mcAddEducation == null)
					{
						_mcAddEducation = new AddEducationView();
						_mcAddEducation.addEventListener(AddEducationView.START_PRE_USE, onStartPreUse);
					}
					ApplicationFacade.getInstance().addPopupUI(_mcAddEducation);
					var hint:String = "注册失败， 该机构id不可用!";
					_mcAddEducation.setHintText(hint);
				}
			}
		}
		
		private function initPreUseHint():void
		{
			var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
			var so:SharedObject = SharedObject.getLocal("lessonSO");
			var startTime:int = so.data.start;
			var now:Date = new Date();
			var endDate:Date = new Date((startTime + _preUseDay * 24 * 60 * 60) * 1000);
			var year:int = endDate.getFullYear();
			var month:int = endDate.getMonth() + 1;
			var day:int = endDate.date;
			var endStr:String = "您当前处于试用软件阶段，" + year + "年" + month + "月" + day + "日到期";
			if (_preUseComponent == null)
			{
				_preUseComponent = new PreUseComponent();
				_view.stage.addChild(_preUseComponent);
				_preUseComponent.x = (_view.stage.width - _preUseComponent.width) / 2;
				_preUseComponent.y = (_view.stage.height - _preUseComponent.height) / 2;
				if (now.month == endDate.month && now.date == endDate.date)
				{
					endStr = "您的试用时间已经结束, 请注册后再使用！";
					_preUseComponent.setText(endStr, true);
				}
				else
				{
					_preUseComponent.setText(endStr);
				}
			}
		}
		
		private function onListClassChange(e:Event):void
		{
			var select:ClassItem = (e.currentTarget as CommonListComponent).selectedItem as ClassItem;
			trace("Class : " + select.className);
			selectedClass = select.data as ClassVO;
			_txtClassName.text = select.className;
			_classList.visible = false;
			_btnClassExpand.gotoAndStop(1);
			sendGetClassChapter(selectedClass.classId);
		}
		
		private function onListTeacherChange(e:Event):void
		{
			var select:TeacherItem = (e.currentTarget as CommonListComponent).selectedItem as TeacherItem;
			trace("Teacher : " + select.teacherName);
			selectedTeacher = select.data as TeacherVO;
			_txtTeacherName.text = select.teacherName;
			_teacherList.visible = false;
			_btnTeacherExpand.gotoAndStop(1);
		}
		
		private function onBtnAddTeacherClick(e:MouseEvent):void
		{
			var soundPx:SoundPx = ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
			soundPx.playSfx();
			if (_mcAddTeacher == null)
			{
				_mcAddTeacher = new AddTeacherView();
				_mcAddTeacher.addEventListener(AddTeacherView.ADD_TEACHER_SUCCESS, onAddTeacherSuccess);
			}
			ApplicationFacade.getInstance().addPopupUI(_mcAddTeacher);
		}
		
		private function onAddTeacherSuccess(e:Event):void
		{
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var list:Array = classPx.teacherList;
			_teacherList.setDataList(list);
			selectedTeacher = list[0];
			checkBtnLoginState();
		}
		
		private function onBtnAddClassClick(e:MouseEvent):void
		{
			var soundPx:SoundPx = ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
			soundPx.playSfx();
			if (_mcAddClass == null)
			{
				_mcAddClass = new AddClassView();
				_mcAddClass.addEventListener(AddClassView.ADD_CLASS_SUCCESS, onAddClassSuccess);
			}
			ApplicationFacade.getInstance().addPopupUI(_mcAddClass);
		}
		
		private function onAddClassSuccess(e:Event):void
		{
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var lessonPx:LessonPx = ApplicationFacade.getInstance().retrieveProxy(LessonPx.NAME) as LessonPx;
			_classList.setDataList(classPx.classList);
			selectedClass = classPx.classList[0];
			lessonPx.setCurrentLesson(0);
			checkBtnLoginState();
		}
		
		private function onBtnClassExpandClick(e:MouseEvent):void
		{
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			if (classPx.classList.length == 1 )
			{
				return;
			}
			if (_classList.visible)
			{
				_classList.visible = false;
				_btnClassExpand.gotoAndStop(1);
			}
			else
			{
				_classList.visible = true;
				_btnClassExpand.gotoAndStop(2);
			}
		}
		
		private function onBtnTeacherExpandClick(e:MouseEvent):void
		{
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			if (classPx.teacherList.length == 1 )
			{
				return;
			}
			if (_teacherList.visible)
			{
				_teacherList.visible = false;
				_btnTeacherExpand.gotoAndStop(1);
			}
			else
			{
				_teacherList.visible = true;
				_btnTeacherExpand.gotoAndStop(2);
			}
		}
		
		private static function onBtnMusicClick(e:MouseEvent):void
		{
			var soundPx:SoundPx = ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
			soundPx.setBGSound();
		}
		
		private function onBtnCloseClick(e:MouseEvent):void
		{
			fscommand("quit");
		}
		
		private function onBtnLoginOver(e:MouseEvent):void
		{
			(e.currentTarget as MovieClip).gotoAndStop(3);
		}
		
		private function onBtnLoginOut(e:MouseEvent):void
		{
			(e.currentTarget as MovieClip).gotoAndStop(1);
		}
		
		private function onBtnLoginClick(e:MouseEvent):void
		{
			var soundPx:SoundPx = ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
			soundPx.playSfx();
			ClassPx.selectedClassId = selectedClass.classId;
			sendNotification(ApplicationConstant.ADD_REMOVE_VIEW, [ViewConstant.VIEW_LOGIN, ViewConstant.VIEW_SELECT_LESSON]);
			sendNotification(ApplicationConstant.ADD_VIEW, ViewConstant.VIEW_NAVIGATE);
			/*if (_selectedClass )
			{
				var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
				var class_json:String = HttpRequest.generateClassData(_selectedClass.classId, "0", "0", 0, userPx.getEduId());
				HttpRequest.getInstance().sendHttpRequest(HttpConstant.GET_CLASS_STUDENTS, class_json, GameConstant.NET_METHOD_POST, onGetSingleClassResponse);
			}*/
			
		}
		/*
		private function onGetSingleClassResponse(resp:Object):void
		{
			if (resp.result == 0 )
			{
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				var studentList:Array = resp.data;
				for (var i:int = 0; i < studentList.length; i++)
				{
					var student:StudentVO = new StudentVO();
					student.name = studentList[i].names;
					student.phone = studentList[i].phone;
					student.score = studentList[i].star;
					student.sex = int(studentList[i].brithday);
					
					var classId:int = studentList[i].id;
					classPx.addStudentData(classId, student,true);
				}
			}
		}
		*/
		
		private function sendGetClassChapter(classId:int):void
		{
			var lesson_json:String = HttpRequest.generateLessonChapter(classId);
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.GET_LESSON_CHAPTER, lesson_json, GameConstant.NET_METHOD_POST, onGetLessonChapter);
		}
		
		private function onGetLessonChapter(resp:Object):void
		{
			if (resp.result == 0)
			{
				var lessonPx:LessonPx = ApplicationFacade.getInstance().retrieveProxy(LessonPx.NAME) as LessonPx;
				var chapter:int = resp.data;
				lessonPx.setCurrentLesson(chapter);
			}
		}
		
		private function checkBtnLoginState():void
		{
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			if (classPx.classList.length > 0 && classPx.teacherList.length > 0)
			{
				_btnLogin.mouseEnabled = true;
				_btnLogin.filters = null;
			}
			else
			{
				_btnLogin.mouseEnabled = false;
				_btnLogin.filters = [_filter];
			}
		}
		
		private function initMusicButton():void
		{
			if (btnMusic == null)
			{
				var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
				var cls:Class = assetPx.getGeneralAsset("common", "MCMusicButton");
				btnMusic = new cls();
				btnMusic.buttonMode = true;
				btnMusic.addEventListener(MouseEvent.CLICK, onBtnMusicClick);
				ApplicationFacade.getInstance().musicLayer.addChild(btnMusic);
				btnMusic.x = 5;
				btnMusic.y = assetPx.stage.height - btnMusic.height - 60;
			}
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			if (_classList != null)
			{
				_classList.destroy();
				_classList = null;
			}
			if (_teacherList != null)
			{
				_teacherList.destroy();
				_teacherList = null;
			}
		}
	}

}