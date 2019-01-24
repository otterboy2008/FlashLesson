package component
{
	import common.BaseComponent;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import mediator.SelectLesson_Mediator;
	import model.AssetPx;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class MovieComponent extends BaseComponent
	{
		public static const MOVIE_END:String = "movie_end";
		
        private var _mcMovie:MovieClip;
		
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _currentPosition:Number;
		
		public function MovieComponent() 
		{
			super();
		}
		
		override public function updateComponentSize(width:Number , height:Number ):void
		{
			super.updateComponentSize(width, height);
			if (_mcMovie != null)
			{
				_mcMovie.width = width;
				_mcMovie.height = height;
			}
		}
		
		public function play(url:String):void
		{
			close();
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var swf:String = "lesson" + SelectLesson_Mediator.selectedLesson;
			var cls:Class = assetPx.getGeneralAsset(swf, url);
			_mcMovie = new cls();
			_mcMovie.gotoAndPlay(1);
			this.addChild(_mcMovie);
			
			var soundCls:Class = assetPx.getGeneralAsset(swf, url + "Sound");
			if (soundCls != null)
			{
				_sound = new soundCls();
				_soundChannel = new SoundChannel();
				_soundChannel = _sound.play();
			}
		}
		
		public function pause():void
		{
			if (_mcMovie != null)
			{
				_mcMovie.stop();
			}
			if (_sound != null && _soundChannel != null)
			{
				_currentPosition = _soundChannel.position;
				_soundChannel.stop();
			}
		}
		
		public function resume():void
		{
			if (_mcMovie != null)
			{
				_mcMovie.play();
			}
			if (_sound != null && _soundChannel != null)
			{
				_soundChannel = _sound.play(_currentPosition);
			}
		}
		
		public function close():void
		{
			_currentPosition = 0;
			if (_sound != null && _soundChannel != null)
			{
				_sound = null;
				_soundChannel.stop();
				_soundChannel = null;
			}
			if (_mcMovie != null && _mcMovie.parent)
			{
				_mcMovie.gotoAndStop(duration);
				_mcMovie.parent.removeChild(_mcMovie);
				_mcMovie = null;
			}
		}
		
		public function seek(offset:Number):void
		{
			if (_mcMovie != null)
			{
				_mcMovie.gotoAndPlay(offset);
				if (_sound != null && _soundChannel != null)
				{
					_currentPosition = offset;
					_soundChannel = _sound.play(_currentPosition);
				}
			}
		}
		
		public function get duration():Number
		{
			return _mcMovie.totalFrames;
		}
		
		public function get currentPosition():Number
		{
			return _mcMovie.currentFrame;
		}
		
		public function destroy():void 
		{
			close();
		}		
	}

}