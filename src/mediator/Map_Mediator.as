package mediator
{
	import VO.LessonVO;
	import constants.ApplicationConstant;
	import constants.ViewConstant;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import model.LessonPx;
	import model.SoundPx;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import view.manager.AttendanceView;
	import view.manager.HappyIslandView;
	import view.manager.HeroHallView;
	import view.manager.RainbowView;
	import view.video.VideoView;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class Map_Mediator extends Mediator 
	{		
		private var _view:MovieClip;
		
		private var _btnBack:MovieClip;
		
		private var _btnWorld:MovieClip;//奇妙世界
		private var _btnRainbow:MovieClip;//彩虹王国
		private var _btnHappyIsland:MovieClip;//快乐岛
		private var _btnCastle:MovieClip;//文化城堡
		private var _btnHeroHall:MovieClip;//英雄殿堂
		private var _btnExpand:MovieClip;//拓展戈壁
		private var _btnClassExercise:MovieClip;//课间操
		
		private var _attendanceView:AttendanceView;
		
		private var _rainBowView:RainbowView;
		private var _happyIslandView:HappyIslandView;
		
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
		
		public function Map_Mediator(mediatorName:String = null, viewComponent:Object = null):void
		{
			super(ViewConstant.VIEW_MAP, viewComponent);
			_view = viewComponent as MovieClip;
			
			_btnBack = _view.getChildByName("btn_back") as MovieClip;
			_btnBack.buttonMode = true;
			_btnBack.addEventListener(MouseEvent.CLICK, onBtnBackClick);
			
			_btnWorld = _view.getChildByName("btn_world") as MovieClip;
			_btnWorld.buttonMode = true;
			_btnWorld.addEventListener(MouseEvent.CLICK, onBtnMapItemClick);
			
			_btnRainbow = _view.getChildByName("btn_rainbow") as MovieClip;
			_btnRainbow.buttonMode = true;
			_btnRainbow.addEventListener(MouseEvent.CLICK, onBtnMapItemClick);
			
			_btnHappyIsland = _view.getChildByName("btn_happyisland") as MovieClip;
			_btnHappyIsland.buttonMode = true;
			_btnHappyIsland.addEventListener(MouseEvent.CLICK, onBtnMapItemClick);
			
			_btnCastle = _view.getChildByName("btn_castle") as MovieClip;
			_btnCastle.buttonMode = true;
			_btnCastle.addEventListener(MouseEvent.CLICK, onBtnMapItemClick);
			
			_btnHeroHall = _view.getChildByName("btn_herohall") as MovieClip;
			_btnHeroHall.buttonMode = true;
			_btnHeroHall.addEventListener(MouseEvent.CLICK, onBtnMapItemClick);
			
			_btnExpand = _view.getChildByName("btn_expand") as MovieClip;
			_btnExpand.buttonMode = true;
			_btnExpand.addEventListener(MouseEvent.CLICK, onBtnMapItemClick);
			
			_btnClassExercise = _view.getChildByName("btn_classexercise") as MovieClip;
			_btnClassExercise.buttonMode = true;
			_btnClassExercise.addEventListener(MouseEvent.CLICK, onBtnMapItemClick);
			
			//when enter map ui, auto show attendance ui
			_attendanceView = new AttendanceView();
			ApplicationFacade.getInstance().addPopupUI(_attendanceView);
		}
		
		private function onBtnMapItemClick(e:MouseEvent):void
		{
			var soundPx:SoundPx = ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
			soundPx.playSfx();
			var lessonPx:LessonPx = ApplicationFacade.getInstance().retrieveProxy(LessonPx.NAME) as LessonPx;
			var lessonVo:LessonVO = lessonPx.getLessonData(SelectLesson_Mediator.selectedLesson);
			var item_name:String = e.currentTarget.name;
			switch(item_name)
			{
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
				case "btn_happyisland":
					if (!AttendanceView.canUseOtherFunction)
					{
						return;
					}
					if (_happyIslandView == null)
					{
						_happyIslandView = new HappyIslandView();
					}
					_happyIslandView.reset();
					ApplicationFacade.getInstance().addPopupUI(_happyIslandView);
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
			}
			trace(item_name);
		}
		
		private function onBtnBackClick(e:MouseEvent):void
		{
			var soundPx:SoundPx = ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
			soundPx.playSfx();
			sendNotification(ApplicationConstant.ADD_REMOVE_VIEW, [ViewConstant.VIEW_MAP, ViewConstant.VIEW_SELECT_LESSON]);
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