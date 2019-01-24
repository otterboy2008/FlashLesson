package view.manager
{
	import VO.LessonVO;
	import common.BaseComponent;
	import component.CommentsComponent;
	import component.MovieComponent;
	import component.VideoComponent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import mediator.SelectLesson_Mediator;
	import model.AssetPx;
	import model.LessonPx;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class RainbowView extends BaseComponent 
	{
		private var _view:MovieClip;
		
		private var _btnClose:MovieClip;
		private var _btnPrev:MovieClip;
		private var _btnNext:MovieClip;
		private var _btnPause:MovieClip;
		
		private var _lessonVo:LessonVO;
		
		private var _currentId:int;
		private var _videoId:int;
		private var _currentVideoList:Array;
		
		private var _movieComponent:MovieComponent;
		private var _commentsComponent:CommentsComponent;
		
		private var _filter:ColorMatrixFilter;
		
		private var _isPause:Boolean;
		
		public function RainbowView() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var  assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("common", "MCRainBow");
			_view = new cls();
			this.addChild(_view);
			
			_btnClose = _view.getChildByName("btn_close") as MovieClip;
			_btnClose.buttonMode = true;
			_btnClose.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
			
			_btnPrev = _view.getChildByName("btn_prev") as MovieClip;
			_btnPrev.buttonMode = true;
			_btnPrev.addEventListener(MouseEvent.CLICK, onBtnPrevClick);
			
			_btnNext = _view.getChildByName("btn_next") as MovieClip;
			_btnNext.buttonMode = true;
			_btnNext.addEventListener(MouseEvent.CLICK, onBtnNextClick);
			
			_btnPause = _view.getChildByName("btn_pause") as MovieClip;
			_btnPause.buttonMode = true;
			_btnPause.addEventListener(MouseEvent.CLICK, onBtnPauseClick);
			
			_commentsComponent = new CommentsComponent();
			_view.mc_pizhu_container.addChild(_commentsComponent);
			
			_filter = new ColorMatrixFilter([0.3, 0.6, 0, 0, 0, 0.3, 0.6, 0, 0, 0, 0.3, 0.6, 0, 0, 0, 0, 0, 0, 1, 0]) ;
			
			var lessonPx:LessonPx = ApplicationFacade.getInstance().retrieveProxy(LessonPx.NAME) as LessonPx;
			_lessonVo = lessonPx.getLessonData(SelectLesson_Mediator.selectedLesson); 
			initVideo();
		}
		
		private function initVideo():void
		{
			var  assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("common", "MCVideoButton");
		
			for (var i:int = 0; i < _lessonVo.rainBowList.length; i++)
			{
				var btn:MovieClip = new cls();
				btn.txt_name.text = _lessonVo.rainBowList[i].name;
				btn.index = i;
				btn.buttonMode = true;
				btn.mouseChildren = false;
				btn.addEventListener(MouseEvent.CLICK, onBtnVideoClick);
				_view.mc_btn_container.addChild(btn);
				btn.y = i * (btn.height + 10) + 10;
			}
			_currentId = 0;
			_videoId = 0;
			_currentVideoList = _lessonVo.rainBowList[_currentId].videoList;
			
			_movieComponent = new MovieComponent();
			_movieComponent.play(_currentVideoList[_videoId]);
			_view.mc_video_container.addChild(_movieComponent);
			_movieComponent.updateComponentSize(1920, 1080);
			_btnPrev.mouseEnabled = false;
			_btnPrev.filters = [_filter];
		}
		
		private function onBtnCloseClick(e:MouseEvent):void
		{
			ApplicationFacade.getInstance().removePopupUI(this);
		}
		
		public function reset():void
		{
			_videoId = 0;
			_currentId = 0;
			_currentVideoList = _lessonVo.rainBowList[_currentId].videoList;
			_movieComponent.play(_currentVideoList[_videoId]);
		}
		
		private function onBtnVideoClick(e:MouseEvent):void
		{
			_btnPrev.mouseEnabled = false;
			_btnPrev.filters = [_filter];
			_btnNext.mouseEnabled = true;
			_btnNext.filters = null;
			_videoId = 0;
			_currentId = e.currentTarget.index;
			_currentVideoList = _lessonVo.rainBowList[_currentId].videoList;
			_movieComponent.play(_currentVideoList[_videoId]);
			//trace(_currentVideoList);
		}
		
		private function onBtnPrevClick(e:MouseEvent):void
		{
			_videoId--;
			if (_videoId >= 0)
			{
				_btnNext.mouseEnabled = true;
				_btnNext.filters = [];
				_movieComponent.play(_currentVideoList[_videoId]);
				if (_videoId == 0)
				{
					_btnPrev.mouseEnabled = false;
					_btnPrev.filters = [_filter];
				}
			}
			else
			{
				_btnPrev.mouseEnabled = false;
				_btnPrev.filters = [_filter];
				_videoId = 0;
			}
			trace("video index :: " + _videoId);
		}
		
		private function onBtnNextClick(e:MouseEvent):void
		{
			_videoId++;
			_btnPrev.mouseEnabled = true;
			_btnPrev.filters = null;
			_movieComponent.play(_currentVideoList[_videoId]);
			if (_videoId == _currentVideoList.length - 1)
			{
				_btnNext.mouseEnabled = false;
				_btnNext.filters = [_filter];
				_videoId = _currentVideoList.length - 1;
			}
			trace("video index :: " + _videoId);
		}
		
		private function onBtnPauseClick(e:MouseEvent):void
		{
			if (_isPause)
			{
				_isPause = false;
				_movieComponent.resume();
			}
			else
			{
				_isPause = true;
				_movieComponent.pause();
			}
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			if (_movieComponent != null)
			{
				_movieComponent.close();
			}
		}
	}
}