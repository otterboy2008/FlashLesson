package view.manager
{
	import VO.HappyIslandVO;
	import VO.LessonVO;
	import common.BaseComponent;
	import component.CommentsComponent;
	import component.MovieComponent;
	import component.VideoComponent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import mediator.SelectLesson_Mediator;
	import model.AssetPx;
	import model.LessonPx;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class HappyIslandView extends BaseComponent 
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
		private var _currentHappyVo:HappyIslandVO;
		
		private var _movieComponent:MovieComponent;
		
		private var _filter:ColorMatrixFilter;
		
		private var _isPause:Boolean;
		private var _isMouseDown:Boolean;
		
		private var _mcItem:MovieClip;
		private var _hitMC:MovieClip;
		private var _hasHitObject:Object;
		
		private var _commentsComponent:CommentsComponent;
		
		public function HappyIslandView() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var  assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("common", "MCHappyIsland");
			_view = new cls();
			this.addChild(_view);
			
			var hitCls:Class = assetPx.getGeneralAsset("common", "MCHit");
			_hitMC = new hitCls();
			this.addChild(_hitMC);
			_hitMC.visible = false;
			
			_view.mc_video_container.mouseEnabled = false;
			
			_commentsComponent = new CommentsComponent();
			_view.mc_pizhu_container.addChild(_commentsComponent);
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
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
			
			_filter = new ColorMatrixFilter([0.3, 0.6, 0, 0, 0, 0.3, 0.6, 0, 0, 0, 0.3, 0.6, 0, 0, 0, 0, 0, 0, 1, 0]);
			
			var lessonPx:LessonPx = ApplicationFacade.getInstance().retrieveProxy(LessonPx.NAME) as LessonPx;
			_lessonVo = lessonPx.getLessonData(SelectLesson_Mediator.selectedLesson); 
			initVideo();
			initHitObjectData();
		}
		
		private function initVideo():void
		{
			var  assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("common", "MCVideoButton");
		
			for (var i:int = 0; i < _lessonVo.happyIslandList.length; i++)
			{
				if (_lessonVo.happyIslandList[i].name == "")
				{
					continue;
				}
				var btn:MovieClip = new cls();
				btn.txt_name.text = _lessonVo.happyIslandList[i].name;
				btn.index = i;
				btn.buttonMode = true;
				btn.mouseChildren = false;
				btn.addEventListener(MouseEvent.CLICK, onBtnVideoClick);
				_view.mc_btn_container.addChild(btn);
				btn.y = i * (btn.height + 10) + 10;
			}
			_currentId = 0;
			_videoId = 0;
			_currentHappyVo = _lessonVo.happyIslandList[_currentId];
			_currentVideoList = _currentHappyVo.videoList;
			
			_movieComponent = new MovieComponent();
			_movieComponent.updateComponentSize(1920, 1080);
			_btnPrev.mouseEnabled = false;
			_btnPrev.filters = [_filter];
		}
		
		public function reset():void
		{
			_videoId = 0;
			_currentId = 0;
			_currentVideoList = _lessonVo.happyIslandList[_currentId].videoList;
			checkIsVideoOrMC(_videoId);
			_commentsComponent.reset();
		}
		
		private function onBtnCloseClick(e:MouseEvent):void
		{
			ApplicationFacade.getInstance().removePopupUI(this);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			_isMouseDown = true;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_isMouseDown = false;
		}
		
		private function onUpdate(e:Event):void
		{
			if (_isMouseDown)
			{
				_hitMC.x = mouseX;
				_hitMC.y = mouseY;
				_hitMC.visible = true;
				if (_mcItem != null)
				{
					for (var i:int = 0; i < _currentHappyVo.hitPointCount; i++)
					{
						var mcHit:MovieClip = _mcItem.getChildByName("mcHit" + i) as MovieClip;
						var mc:MovieClip = _mcItem.getChildByName("mc" + i) as MovieClip;
						if (mcHit != null && _hitMC.hitTestObject(mcHit) == true)
						{
							if (i == 0)
							{
								if (_hasHitObject[i] == false)
								{
									mc.play();
								}
							}
							var prev:int = i - 1;
							if (prev >= 0)
							{
								if (_hasHitObject[prev] == true && _hasHitObject[i] == false)
								{
									mc.play();
								}
							}
						}
					}
				}
				
			}
			else
			{
				_hitMC.visible = false;
			}
		}
		
		private function onBtnVideoClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			_btnPrev.mouseEnabled = false;
			_btnPrev.filters = [_filter];
			_btnNext.mouseEnabled = true;
			_btnNext.filters = null;
			_videoId = 0;
			_currentId = e.currentTarget.index;
			_currentHappyVo = _lessonVo.happyIslandList[_currentId];
			_currentVideoList = _currentHappyVo.videoList;
			initHitObjectData();
			checkIsVideoOrMC(_videoId);
			//trace(_currentVideoList);
		}
		
		private function onBtnPrevClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			_videoId--;
			initHitObjectData();
			if (_videoId >= 0)
			{
				_btnNext.mouseEnabled = true;
				_btnNext.filters = [];
				checkIsVideoOrMC(_videoId);
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
			soundPx.playSfx();
			_videoId++;
			initHitObjectData();
			_btnPrev.mouseEnabled = true;
			_btnPrev.filters = null;
			checkIsVideoOrMC(_videoId);
			if (_videoId == _currentVideoList.length - 1)
			{
				_btnNext.mouseEnabled = false;
				_btnNext.filters = [_filter];
				_videoId = _currentVideoList.length - 1;
			}
			trace("video index :: " + _videoId);
		}
		
		private function checkIsVideoOrMC(videoId:int):void
		{
			_view.mc_video_container.removeChildren();
			_mcItem = null;
			_movieComponent.pause();
			if (_currentHappyVo.mcIndex == videoId)//is mc
			{
				var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
				var ItemClassKey:String = "MC" + _lessonVo.lessonId + "Item" + _currentId + "Video" + videoId;
				var cls:Class = assetPx.getGeneralAsset("mcList", ItemClassKey);
				if (cls != null)
				{
					_mcItem = new cls();
					_mcItem.mouseEnabled = false;
					for (var i:int = 0; i < _currentHappyVo.hitPointCount; i++)
					{
						var mc:MovieClip = _mcItem.getChildByName("mc" + i) as MovieClip;
						mc.mouseChildren = false;
						mc.mouseEnabled = false;
						mc.index = i;
						if (mc != null)
						{
							mc.addEventListener(Event.ENTER_FRAME, onMcItemUpdate);
							mc.gotoAndStop(1);
						}
					}
					_view.mc_video_container.addChild(_mcItem);
				}
				_commentsComponent.setNeedPizhu(false);
				_commentsComponent.visible = false;
			}
			else
			{
				_view.mc_video_container.addChild(_movieComponent);
				_movieComponent.play(_currentVideoList[_videoId]);
				_commentsComponent.setNeedPizhu(true);
				_commentsComponent.visible = true;
			}
		}
		
		private function onMcItemUpdate(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var index:int = e.currentTarget.index;
			if (mc.currentFrame >= mc.totalFrames)
			{
				_hasHitObject[index] = true;
				mc.stop();
				mc.removeEventListener(Event.ENTER_FRAME, onMcItemUpdate);
			}
		}
		
		private function initHitObjectData():void
		{
			_hasHitObject = {};
			for (var i:int = 0; i < _currentHappyVo.hitPointCount; i++)
			{
				_hasHitObject[i] = false;
			}
		}
		
		
		private function onBtnPauseClick(e:MouseEvent):void
		{
			soundPx.playSfx();
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
		
		override public function get width():Number 
		{
			return _view.mc_bg.width;
		}
		
		override public function get height():Number 
		{
			return _view.mc_bg.height;
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			if (_movieComponent)
			{
				_movieComponent.close();
			}
		}
	}
}