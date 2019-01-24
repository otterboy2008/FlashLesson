package commands
{	
	import constants.ApplicationConstant;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import model.AssetPx;
	import model.UserPx;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class StartupCmd extends SimpleCommand
	{
		public function StartupCmd()
		{
			super();
		}
		
		/**
		 * load some necessary resource before game start
		 * 
		 */
		override public function execute(notification:INotification):void
		{
			var assetPx:AssetPx = facade.retrieveProxy(AssetPx.NAME) as AssetPx;
			assetPx.loadStartResources();
		}
	}
}