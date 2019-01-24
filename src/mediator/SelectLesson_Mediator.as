package mediator 
{
	import VO.LessonVO;
	import constants.ApplicationConstant;
	import constants.ViewConstant;
	import flash.events.MouseEvent;
	import model.LessonPx;
	import model.SoundPx;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class SelectLesson_Mediator extends Mediator 
	{		
		public static var selectedLesson:int = 0;//from 0 to 15
		
		private var _view:MovieClip;
		
		private var _btnLessonList:Array;
		
		private var _btnBack:MovieClip;
		
		private var _btnPrepare:MovieClip;
		
		private var _totalCount:int = 16;
		
		public function SelectLesson_Mediator(mediatorName:String = null, viewComponent:Object = null):void
		{
			super(ViewConstant.VIEW_SELECT_LESSON, viewComponent);
			_view = viewComponent as MovieClip;
			
			_btnBack = _view.getChildByName("btn_back") as MovieClip;
			_btnBack.buttonMode = true;
			_btnBack.addEventListener(MouseEvent.CLICK, onBtnBackClick);
			
			_btnPrepare = _view.getChildByName("btn_prepare") as MovieClip;
			_btnPrepare.buttonMode = true;
			_btnPrepare.addEventListener(MouseEvent.CLICK, onBtnPrepareClick);
			
			_btnLessonList = new Array();
			
			var lessonPx:LessonPx = ApplicationFacade.getInstance().retrieveProxy(LessonPx.NAME) as LessonPx;
			for (var i:int = 0; i < _totalCount; i++)
			{
				var btn:MovieClip = _view.getChildByName("btn_lesson_" + i) as MovieClip;
				btn.buttonMode = true;
				btn.mouseChildren = false;
				btn.index = i;
				btn.addEventListener(MouseEvent.CLICK, onBtnLessonClick);
				var lessonVo:LessonVO = lessonPx.getLessonData(i);
				if (lessonVo.isOver)
				{
					btn.gotoAndStop(1);
				}
				else
				{
					if (lessonVo.isUnlocked)
					{
						btn.gotoAndStop(2);
					}
					else
					{
						btn.gotoAndStop(3);
					}
				}
				_btnLessonList.push(btn);
			}
			
		}
		
		
		private function onBtnLessonClick(e:MouseEvent):void
		{
			var soundPx:SoundPx = ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
			soundPx.playSfx();
			var index:int = e.currentTarget.index;
			SelectLesson_Mediator.selectedLesson = index;
			var lessonPx:LessonPx = ApplicationFacade.getInstance().retrieveProxy(LessonPx.NAME) as LessonPx;
			var lessonVo:LessonVO = lessonPx.getLessonData(index);
			if (lessonVo.isUnlocked)
			{
				sendNotification(ApplicationConstant.ADD_REMOVE_VIEW, [ViewConstant.VIEW_SELECT_LESSON, ViewConstant.VIEW_MAP]);
			}
			trace(index + " lesson locked : " + lessonVo.isUnlocked);
		}
		
		private function onBtnPrepareClick(e:MouseEvent):void
		{
			
		}
		
		private function onBtnBackClick(e:MouseEvent):void
		{
			var soundPx:SoundPx = ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
			soundPx.playSfx();
			sendNotification(ApplicationConstant.ADD_REMOVE_VIEW, [ViewConstant.VIEW_SELECT_LESSON, ViewConstant.VIEW_LOGIN]);
			sendNotification(ApplicationConstant.REMOVE_VIEW, ViewConstant.VIEW_NAVIGATE);
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
		}
		
	}

}