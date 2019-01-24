package view.video
{
	import com.greensock.TweenLite;
	import common.BaseComponent;
	import component.VideoComponent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import mediator.SelectLesson_Mediator;
	import model.AssetPx;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class VideoView extends BaseComponent 
	{
		private var _assets:MovieClip;
		
		private var _btnClose:MovieClip;
		private var _btnPlay:MovieClip;
		private var _btnPause:MovieClip;
		
		private var _btnThumb:MovieClip;
		
		private var _mcContainer:MovieClip;
		
		//private var _video:VideoComponent;
		private var _mcMovie:MovieClip;
		
		private var _isDrag:Boolean;
		
		private var _totalWidth:Number;
		private var _thumbWidth:Number;
		
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _currentPosition:Number;
		
		public function VideoView() 
		{
			super();
			init();
		}
		
		public function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var MCVideoViewClass:Class = assetPx.getGeneralAsset("map", "MCVideoView");
			
			if (_assets == null)
			{
				_assets = new MCVideoViewClass();
				addChild(_assets);
			}
			
			_btnClose = _assets.getChildByName("btn_close") as MovieClip;
			_btnClose.buttonMode = true;
			_btnClose.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
			
			_btnPlay = _assets.getChildByName("btn_play") as MovieClip;
			_btnPlay.buttonMode = true;
			_btnPlay.addEventListener(MouseEvent.CLICK, OnBtnPlayClick);
			
			_btnPause = _assets.getChildByName("btn_pause") as MovieClip;
			_btnPause.buttonMode = true;
			_btnPause.addEventListener(MouseEvent.CLICK, OnBtnPauseClick);
			
			_btnThumb = _assets.mc_thumb.getChildByName("btn_thumb") as MovieClip;
			_btnThumb.buttonMode = true;
			_btnThumb.addEventListener(MouseEvent.MOUSE_DOWN, onBtnThumbDown);
			_btnThumb.addEventListener(MouseEvent.MOUSE_UP, onBtnThumbUp);
			assetPx.stage.addEventListener(MouseEvent.MOUSE_UP, onBtnThumbUp);
			
			_mcContainer = _assets.getChildByName("mc_container") as MovieClip;
			_mcContainer.mouseChildren = false;
			
			//_video = new VideoComponent();
			//_video.addEventListener(VideoComponent.MOVIE_END, onMovieEndEvent);
			//_mcContainer.addChild(_video);
			//_video.componentWidth = _assets.width;
			//_video.componentHeight = _assets.height;
			
			_totalWidth = _assets.mc_thumb.width;
			_thumbWidth = _btnThumb.width;
			
			_currentPosition = 0;
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		public function playVideo(url:String, isSingleMovie:Boolean = false):void
		{
			_currentPosition = 0;
			if (_sound != null && _soundChannel != null)
			{
				_sound.close();
				_sound = null;
				_soundChannel.stop();
				_soundChannel = null;
			}
			if (_mcMovie)
			{
				_mcMovie.gotoAndStop(_mcMovie.totalFrames);
				_mcMovie.parent.removeChild(_mcMovie);
				_mcMovie = null;
			}
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var swf:String = "lesson" + SelectLesson_Mediator.selectedLesson;
			if (isSingleMovie)
			{
				swf = "singleMovieLesson" + SelectLesson_Mediator.selectedLesson;
			}
			var cls:Class = assetPx.getGeneralAsset(swf, url);
			_mcMovie = new cls();
			_mcMovie.gotoAndPlay(1);
			_mcContainer.addChild(_mcMovie);
			var soundCls:Class = assetPx.getGeneralAsset(swf, url + "Sound");
			if (soundCls != null)
			{
				_sound = new soundCls();
				_soundChannel = new SoundChannel();
				_soundChannel = _sound.play();
			}
			//_video.play(url);
		}
		
		private function OnBtnPlayClick(e:MouseEvent = null):void
		{
			//if (_video != null)
			//{
				//_video.resume();
			//}
			_mcMovie.play();
			if (_sound != null && _soundChannel != null)
			{
				_soundChannel = _sound.play(_currentPosition);
			}
		}
		
		private function OnBtnPauseClick(e:MouseEvent = null):void
		{
			//if (_video != null)
			//{
				//_video.pause();
			//}
			_mcMovie.stop();
			if (_sound != null && _soundChannel != null)
			{
				_currentPosition = _soundChannel.position;
				_soundChannel.stop();
			}
		}
		
		private function onUpdate(e:Event):void
		{
			if (!_isDrag)
			{
				//trace("position : " + _video.currentPosition);
				//_btnThumb.x = (_video.currentPosition / _video.duration) * (_totalWidth - _thumbWidth);
				_btnThumb.x = (_mcMovie.currentFrame / _mcMovie.totalFrames) * (_totalWidth - _thumbWidth);
			}
		}
		
		private function onMovieEndEvent(e:Event):void
		{
			
		}
		
		private function onBtnCloseClick(e:MouseEvent):void
		{
			if (this.parent)
			{
				OnBtnPauseClick();
				ApplicationFacade.getInstance().removePopupUI(this);
				//destory();
			}
		}
		
		private function onBtnThumbDown(e:MouseEvent):void
		{
			var _width:Number = _totalWidth - _thumbWidth;
			_btnThumb.startDrag(false, new Rectangle(0, 0, _width, 0));
			_isDrag = true;
		}
		
		private function onBtnThumbUp(e:MouseEvent):void
		{
			if (_isDrag)
			{
				_btnThumb.stopDrag();
				var _width:Number = _totalWidth - _thumbWidth;
				//var progress:Number = (_btnThumb.x / _width) * _video.duration;
				//trace("video seek to " + progress);
				//if (_video != null)
				//{
					//_video.seek(progress);
				//}
				var progress:int = (_btnThumb.x / _width) * _mcMovie.totalFrames;
				_mcMovie.gotoAndPlay(progress);
				if (_sound != null && _soundChannel != null)
				{
					_currentPosition = progress;
					_soundChannel = _sound.play(_currentPosition);
				}
				onFinishTween();
				//TweenLite.to(progress, 0.1, {onComplete:onFinishTween});//resolve when seek video, _video.currentPosition will delay update to correct position
			}
		}
		
		private function onFinishTween():void
		{
			_isDrag = false;
		}
		
		public function pause():void
		{
			OnBtnPauseClick();
		}
		
		public function resume():void
		{
			OnBtnPlayClick();
		}
		
		public function close():void
		{
			//if (_video != null)
			//{
				//_video.close();
			//}
			_currentPosition = 0;
			this.removeEventListener(Event.ENTER_FRAME, onUpdate);
			if (_sound != null && _soundChannel != null)
			{
				_sound = null;
				_soundChannel.stop();
				_soundChannel = null;
			}
			if (_mcMovie != null && _mcMovie.parent)
			{
				_mcMovie.gotoAndStop(_mcMovie.totalFrames);
				_mcMovie.parent.removeChild(_mcMovie);
				_mcMovie = null;
			}
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			close();
		}
		
		public function destory():void
		{
			//if (_video != null)
			//{
				//_video.destroy();
				//_video = null;
				close();
				if (_assets.parent != null)
				{
					_assets.parent.removeChild(_assets);
				}
				_assets = null;
				
			//}
			this.removeEventListener(Event.ENTER_FRAME, onUpdate);
		}
	}

}