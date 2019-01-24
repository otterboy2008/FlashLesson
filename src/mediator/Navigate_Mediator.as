package mediator
{
	import VO.LessonVO;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import constants.ApplicationConstant;
	import constants.GameConstant;
	import constants.ViewConstant;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import model.LessonPx;
	import model.SoundPx;
	import net.HttpConstant;
	import net.HttpRequest;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import view.PasswordView;
	import view.manager.*;
	import view.video.VideoView;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class Navigate_Mediator extends Mediator 
	{
		private var _view:MovieClip;
		
		private var _btnNavigate:MovieClip;
		private var _mcNavigate:MovieClip;
		
		private var _btnReward:MovieClip;//奖励
		private var _btnManagement:MovieClip;//综合管理
		private var _btnWorld:MovieClip;//奇妙世界
		private var _btnRainbow:MovieClip;//彩虹王国
		private var _btnCastle:MovieClip;//文化城堡
		private var _btnHeroHall:MovieClip;//英雄殿堂
		private var _btnExpand:MovieClip;//拓展戈壁
		private var _btnClassExercise:MovieClip;//课间操
		private var _btnGetOff:MovieClip;
		
		private var _isExpand:Boolean;
		private var _originalX:Number;
		
		//reward view
		private var _rewardView:RewardView;
		//manager view
		private var _passwordView:PasswordView;
		private var _classManagerView:ClassManagerView;
		//rainbow view
		private var _rainBowView:RainbowView;
		//castle view
		private var _castleView:VideoView;
		//world view
		private var _worldView:VideoView;
		//herohall view
		private var _heroHallView:HeroHallView;
		//expand view
		private var _expandView:VideoView;
		//class exercise view
		private var _classExerciseView:VideoView;
		
		public function Navigate_Mediator(mediatorName:String = null, viewComponent:Object = null):void
		{
			super(ViewConstant.VIEW_NAVIGATE, viewComponent);
			_view = viewComponent as MovieClip;
			
			_btnNavigate = _view.getChildByName("btn_navigate") as MovieClip;
			_btnNavigate.buttonMode = true;
			_btnNavigate.gotoAndStop(1);
			_btnNavigate.addEventListener(MouseEvent.CLICK, onBtnNavigateClick);
			
			_mcNavigate = _view.getChildByName("mc_navigate") as MovieClip;
			_originalX = _mcNavigate.x;
			
			_btnReward = _mcNavigate.getChildByName("btn_reward") as MovieClip;
			_btnReward.buttonMode = true;
			_btnReward.addEventListener(MouseEvent.CLICK, onBtnClickEvent);
			
			_btnManagement = _mcNavigate.getChildByName("btn_management") as MovieClip;
			_btnManagement.buttonMode = true;
			_btnManagement.addEventListener(MouseEvent.CLICK, onBtnClickEvent);
			
			_btnWorld = _mcNavigate.getChildByName("btn_world") as MovieClip;
			_btnWorld.buttonMode = true;
			_btnWorld.addEventListener(MouseEvent.CLICK, onBtnClickEvent);
			
			_btnRainbow = _mcNavigate.getChildByName("btn_rainbow") as MovieClip;
			_btnRainbow.buttonMode = true;
			_btnRainbow.addEventListener(MouseEvent.CLICK, onBtnClickEvent);
			
			_btnCastle = _mcNavigate.getChildByName("btn_castle") as MovieClip;
			_btnCastle.buttonMode = true;
			_btnCastle.addEventListener(MouseEvent.CLICK, onBtnClickEvent);
			
			_btnHeroHall = _mcNavigate.getChildByName("btn_herohall") as MovieClip;
			_btnHeroHall.buttonMode = true;
			_btnHeroHall.addEventListener(MouseEvent.CLICK, onBtnClickEvent);
			
			_btnExpand = _mcNavigate.getChildByName("btn_expand") as MovieClip;
			_btnExpand.buttonMode = true;
			_btnExpand.addEventListener(MouseEvent.CLICK, onBtnClickEvent);
			
			_btnClassExercise = _mcNavigate.getChildByName("btn_classexercise") as MovieClip;
			_btnClassExercise.buttonMode = true;
			_btnClassExercise.addEventListener(MouseEvent.CLICK, onBtnClickEvent);
			
			_btnGetOff = _mcNavigate.getChildByName("btn_getoff") as MovieClip;
			_btnGetOff.buttonMode = true;
			_btnGetOff.addEventListener(MouseEvent.CLICK, onBtnClickEvent);
		}
		
		private function onBtnNavigateClick(e:MouseEvent):void
		{
			var soundPx:SoundPx = ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
			soundPx.playSfx();
			if (!_isExpand)
			{
				_isExpand = true;
				_btnNavigate.gotoAndStop(2);
				TweenLite.to(_mcNavigate, 0.5, {x: _originalX - 360, ease:Back.easeOut});
			}
			else
			{
				_isExpand = false;
				_btnNavigate.gotoAndStop(1);
				TweenLite.to(_mcNavigate, 0.5, {x: _originalX, ease:Back.easeOut});
			}
		}
		
		private function onBtnClickEvent(e:MouseEvent):void
		{
			var soundPx:SoundPx = ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
			soundPx.playSfx();
			var lessonPx:LessonPx = ApplicationFacade.getInstance().retrieveProxy(LessonPx.NAME) as LessonPx;
			var lessonVo:LessonVO = lessonPx.getLessonData(SelectLesson_Mediator.selectedLesson);
			ApplicationFacade.getInstance().removeAllPopup();
			var btnName:String = e.currentTarget.name;
			switch(btnName)
			{
				case "btn_reward":
					if (!AttendanceView.canUseOtherFunction)
					{
						return;
					}
					if (_rewardView == null)
					{
						_rewardView = new RewardView();
					}
					_rewardView.initGroupData();
					ApplicationFacade.getInstance().addPopupUI(_rewardView);
					break;
				case "btn_management":
					if (_passwordView == null)
					{
						_passwordView = new PasswordView();
					}
					ApplicationFacade.getInstance().addPopupUI(_passwordView);
					/*
					}
					else
					{
						if (_classManagerView == null)
						{
							_classManagerView = new ClassManagerView();
						}
						else
						{
							_classManagerView.showItemByIndex(0);
						}
						ApplicationFacade.getInstance().addPopupUI(_classManagerView);
					}
					*/
					break;
				case "btn_world":
					if (!AttendanceView.canUseOtherFunction)
					{
						return;
					}
					if (_worldView == null)
					{
						_worldView = new VideoView();
					}
					_worldView.playVideo(lessonVo.worldVideo, true);
					ApplicationFacade.getInstance().addPopupUI(_worldView, false);
					break;
				case "btn_rainbow":
					if (!AttendanceView.canUseOtherFunction)
					{
						return;
					}
					if (_rainBowView == null)
					{
						_rainBowView = new RainbowView();
					}
					_rainBowView.reset();
					ApplicationFacade.getInstance().addPopupUI(_rainBowView);
					break;
				case "btn_castle":
					if (!AttendanceView.canUseOtherFunction)
					{
						return;
					}
					if (_castleView == null)
					{
						_castleView = new VideoView();
					}
					_castleView.playVideo(lessonVo.castleVideo, true);
					ApplicationFacade.getInstance().addPopupUI(_castleView, false);
					break;
				case "btn_herohall":
					if (!AttendanceView.canUseOtherFunction)
					{
						return;
					}
					if (_heroHallView == null)
					{
						_heroHallView = new HeroHallView();
					}
					ApplicationFacade.getInstance().addPopupUI(_heroHallView, false);
					break;
				case "btn_expand":
					if (!AttendanceView.canUseOtherFunction)
					{
						return;
					}
					if (_expandView == null)
					{
						_expandView = new VideoView();
					}
					_expandView.playVideo(lessonVo.expandVideo, true);
					ApplicationFacade.getInstance().addPopupUI(_expandView, false);
					break;
				case "btn_classexercise":
					if (!AttendanceView.canUseOtherFunction)
					{
						return;
					}
					if (_classExerciseView == null)
					{
						_classExerciseView = new VideoView();
					}
					_classExerciseView.playVideo(lessonVo.classexerciseVideo, true);
					ApplicationFacade.getInstance().addPopupUI(_classExerciseView, false);
					break;
				case "btn_getoff":
					if (!AttendanceView.canUseOtherFunction)
					{
						return;
					}
					var lessonId:int = SelectLesson_Mediator.selectedLesson + 1;
					var json:String = HttpRequest.generateLessonAttendanceDown(SelectLesson_Mediator.selectedLesson, lessonPx.sectionId, lessonId);
					HttpRequest.getInstance().sendHttpRequest(HttpConstant.LESSON_ATTENDANCE_DOWN, json, GameConstant.NET_METHOD_POST, onGetLessonDownResponse);
					_btnGetOff.mouseEnabled = false;
					break;
			}
			trace(btnName);
		}
		
		private function onGetLessonDownResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				trace("lesson down success");
				var lessonPx:LessonPx = ApplicationFacade.getInstance().retrieveProxy(LessonPx.NAME) as LessonPx;
				var current:int = lessonPx.currentLesson;
				var next:int = SelectLesson_Mediator.selectedLesson + 1;
				if (current < next)
				{
					lessonPx.setCurrentLesson(next);
					var lesson_json:String = HttpRequest.generateLessonChapter(Login_Mediator.selectedClass.classId, next);
					//no need response,just update client chapter id
					HttpRequest.getInstance().sendHttpRequest(HttpConstant.UPDATE_LESSON_CHAPTER, lesson_json, GameConstant.NET_METHOD_POST/*, onGetUpdateLessonChapter*/);
				}
				sendNotification(ApplicationConstant.REMOVE_VIEW, ViewConstant.VIEW_MAP);
				sendNotification(ApplicationConstant.REMOVE_VIEW, ViewConstant.VIEW_SELECT_LESSON);
				sendNotification(ApplicationConstant.ADD_REMOVE_VIEW, [ViewConstant.VIEW_NAVIGATE, ViewConstant.VIEW_LOGIN]);
			}
			else
			{
				_btnGetOff.mouseEnabled = true;
			}
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			if (_worldView != null)
			{
				_worldView.destory();
				_worldView = null;
			}
			if (_castleView != null)
			{
				_castleView.destory();
				_castleView = null;
			}
			if (_expandView != null)
			{
				_expandView.destory();
				_expandView = null;
			}
			if (_classExerciseView != null)
			{
				_classExerciseView.destory();
				_classExerciseView = null;
			}
		}
	}

}