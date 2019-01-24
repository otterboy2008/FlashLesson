package model
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
		
	public class LoaderProxy extends MovieClip
	{
		[Embed(source='resources//ui//loading.swf')]
		private var ldClass:Class;
		
		private var _loadingImg:DisplayObject;
		private var _realLd:Loader;
		private var _isPlay:Boolean = false;
		private var _frame:Object = null;
		private var _scene:String = null;
		private var _getChildren:Array = [];
		public function LoaderProxy(url:String)
		{
			super();
			_loadingImg = new ldClass() as DisplayObject;
			addChild(_loadingImg);
			_realLd = new Loader();
			_realLd.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, eventHandler);
			_realLd.contentLoaderInfo.addEventListener(Event.COMPLETE, resourceComplete);
			_realLd.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventHandler);
			_realLd.load(new URLRequest(url), new LoaderContext(false, new ApplicationDomain()));
		}
		private function eventHandler(e:Event):void
		{
			dispatchEvent(e);
		}
		private function resourceComplete(e:Event):void
		{
			removeChild(_loadingImg);
			_loadingImg = null;
			addChild(_realLd.content);
			if( _frame != null )
			{
				if( _isPlay )
				{
					MovieClip(_realLd.content).gotoAndPlay(_frame, _scene);
				}
				else
				{
					MovieClip(_realLd.content).gotoAndStop(_frame, _scene);
				}
			}
			for( var i:int = 0; i < _getChildren.length; i++)
			{
				if( _getChildren[i].parent != null &&  _getChildren[i].parent != _realLd.content )
				{
					DisplayObjectContainer(_getChildren[i]).addChild(DisplayObjectContainer(_realLd.content).getChildByName(_getChildren[i].name));
				}
			}
			_getChildren = [];
		}
		
		override public function gotoAndPlay(frame:Object, scene:String=null):void
		{
			if( _realLd.content )
			{
				MovieClip(_realLd.content).gotoAndPlay(frame, scene);
			}
			else
			{
				_frame = frame;
				_scene = scene;
				_isPlay = true;
			}
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			if( _realLd.content )
			{
				MovieClip(_realLd.content).gotoAndStop(frame, scene);
			}
			else
			{
				_frame = frame;
				_scene = scene;
				_isPlay = false;
			}
		}
		
		override public function getChildByName(name:String):DisplayObject
		{
			if( _realLd.content )
			{
				return DisplayObjectContainer(_realLd.content).getChildByName(name);
			}
			else
			{
				var holder:MovieClip = new MovieClip();
				holder.name = name;
				_getChildren.push(holder);
				return holder;
			}
		}
		
	}
}