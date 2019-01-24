package component
{
	import common.BaseComponent;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class VideoComponent extends BaseComponent
	{
		public static const MOVIE_END:String = "movie_end";
		
        private var _netConnection:NetConnection;
        private var _netStream:NetStream;
		private var _video:Video;
		private var _videoURL:String;
		
		private var _duration:Number;
		
		public function VideoComponent() 
		{
			super();
		}
		
		override public function updateComponentSize(width:Number , height:Number ):void
		{
			super.updateComponentSize(width, height);
			
			if (_video)
			{
				_video.width = _componentWidth;
				_video.height = _componentHeight;
			}
			
		}
		
		public function play(url:String):void
		{
			if ( _netConnection != null )
			{
				destroy();
			}
			
			_videoURL = url;

			_netConnection = new NetConnection();
			
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_netConnection.connect(null);
			_netConnection.client = { onBWDone:onBWDoneHandle, onMetaData:onMetaDataHandle, onXMPData:onXMPDataHandle, onPlayStatus:onPlayStatusHandle };
		}
		
		public function pause():void
		{
			if (_netStream != null)
			{
				_netStream.pause();
			}
		}
		
		public function resume():void
		{
			if (_netStream != null)
			{
				_netStream.resume();
			}
		}
		
		public function close():void
		{
			if (_netStream != null)
			{
				_netStream.close();
			}
		}
		
		public function seek(offset:Number):void
		{
			if (_netStream != null)
			{
				_netStream.seek(offset);
			}
		}
		
        private function netStatusHandler(event:NetStatusEvent):void 
		{
			//trace("video code :: " + event.info.code);
            switch (event.info.code)
			{
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Unable to locate video: " + _videoURL);
                    break;
				case "NetStream.Play.Stop":
					
					break;
            }
        }

        private function connectStream():void 
		{
			_netStream = new NetStream(_netConnection);
            _netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            _netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_netStream.client = { onBWDone:onBWDoneHandle, onMetaData:onMetaDataHandle, onXMPData:onXMPDataHandle, onPlayStatus:onPlayStatusHandle };
            _video = new Video(_componentWidth, _componentHeight);
			_video.smoothing = true;
            _video.attachNetStream(_netStream);
            _netStream.play(_videoURL);
            addChild(_video);
        }
		
		private function onMetaDataHandle(info:Object):void
		{
			_duration = info.duration;
			trace("duration : " + info.duration);
		}
		
		private function onBWDoneHandle(... rest):void
		{
			var p_bw:Number;
			if (rest.length > 0) p_bw = rest[0];
			trace("bandwidth = " + p_bw + " Kbps.");
		}
		
		private function onXMPDataHandle(...rest):void
		{

		}
		
		private function onPlayStatusHandle(info:Object):void
		{
			sendViewEvent(MOVIE_END, null, true);
		}

        private function securityErrorHandler(event:SecurityErrorEvent):void
		{
            trace("securityErrorHandler: " + event);
        }
        
        private function asyncErrorHandler(event:AsyncErrorEvent):void 
		{
            //ignore AsyncErrorEvent events
        }
		
		public function get duration():Number
		{
			return _duration;
		}
		
		public function get currentPosition():Number
		{
			return _netStream.time;
		}
		
		public function destroy():void 
		{
			if (_netConnection)
			{
				_netConnection.close();
				_netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				_netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_netConnection = null;
			}
			if (_netStream)
			{
				_netStream.close();
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				_netStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				_netStream = null;
			}
			if (_video)
			{
				_video.clear();
				if (_video.parent)
				{
					_video.parent.removeChild(_video);
				}
				_video = null;
			}
		}		
	}

}