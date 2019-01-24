package
{
	import commands.*;
	import common.BaseComponent;
	import constants.ViewConstant;
	import view.PasswordView;

	import constants.ApplicationConstant;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	
	import model.*;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	

    public class ApplicationFacade extends Facade implements IFacade
	{
		public var modelList:Array = [];
		public var layerList:Object = {};
		
        public static function getInstance():ApplicationFacade 
		{
            if (instance==null )instance = new ApplicationFacade( );
			return instance as ApplicationFacade;
        }
		
        public function init(container:DisplayObjectContainer,basePath:String, language:String = 'en'):void
		{
			registCommands();
			
			registerProxy(new ClassPx());
			registerProxy(new ViewPx());
			registerProxy(new LessonPx());
			registerProxy(new ServerPx());
			registerProxy(new UserPx());
			registerProxy(new SoundPx());
			registerProxy(new AssetPx(container, basePath, language));
			
			initLayerout();
			
			sendNotification(ApplicationConstant.STARTUP);
        }
		
		private function registCommands():void
		{
			registerCommand(ApplicationConstant.ADD_VIEW,AddViewCommand );
			registerCommand(ApplicationConstant.REMOVE_VIEW,RemoveViewCmd);
			registerCommand(ApplicationConstant.ADD_REMOVE_VIEW,AddRemoveCmd);	
			registerCommand(ApplicationConstant.STARTUP, StartupCmd);
			registerCommand(ApplicationConstant.ERROR_CONNECT_TO_SERVER, GeneralServerErrorCmd);
			registerCommand(ApplicationConstant.CALL_SERVER, CallServerCmd);
			registerCommand(ApplicationConstant.WAITING_SERVER, WaitingforServerCommand);
		}
		
		public function initLayerout():void
		{
			var assetPx:AssetPx = retrieveProxy(AssetPx.NAME) as AssetPx;
			
			addLayer("layer_0",0);
			addLayer("layer_1",1);
			addLayer("layer_2",2);
			addLayer("layer_3",3);
			addLayer("layer_4",4);//popup layer
			addLayer("layer_5",5);
			function addLayer(name:String,layer:int):void
			{
				var container:DisplayObjectContainer;
				var sprite:Sprite;
				
				container=DisplayObjectContainer(assetPx.stage);
				while(container.numChildren<=layer)
				{
					container.addChild(new Sprite());
				}
				sprite=Sprite(container.getChildAt(layer));
				sprite.tabEnabled=false;
				layerList[name]=sprite;
			}
		}
		public function getLayer(name:String):DisplayObjectContainer
		{
			return layerList[name];
		}
		
		public function get popupLayer():Sprite
		{
			return getLayer("layer_4") as Sprite;
		}
		
		public function get musicLayer():Sprite
		{
			return getLayer("layer_5") as Sprite;
		}
		
		public function addPopupUI(ui:BaseComponent, needCenter:Boolean = true):void
		{
			popupLayer.removeChildren();
			
			popupLayer.graphics.beginFill(0x000000, 0.5);
			popupLayer.graphics.drawRect(0, 0, popupLayer.stage.width, popupLayer.stage.height);
			popupLayer.graphics.endFill();
			popupLayer.addChild(ui);
			if (needCenter)
			{
				ui.x = (popupLayer.stage.width - ui.width) / 2;
				ui.y = (popupLayer.stage.height - ui.height) / 2;
			}
		}
		
		public function removePopupUI(ui:BaseComponent, needBackToClassManager:Boolean = false):void
		{
			ui.onRemove();
			popupLayer.removeChild(ui);
			popupLayer.graphics.clear();
			if (needBackToClassManager)
			{
				if (!ApplicationFacade.getInstance().hasMediator(ViewConstant.VIEW_LOGIN))
				{
					PasswordView.showClassManagerView();
				}
			}
		}
		
		public function removeAllPopup():void
		{
			popupLayer.graphics.clear();
			popupLayer.removeChildren();
		}
    }
}