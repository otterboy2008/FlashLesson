package model{	
	import VO.ViewVO;
	
	import constants.ApplicationConstant;
	
	import flash.display.*;
	import flash.events.*;
	
	import mediator.*;
	
	import constants.ViewConstant;
	

    public class ViewPx extends ProxyMgr
	{
        public static const NAME:String = "ViewPx";
		private var viewList:Object={};
		
        public function ViewPx()
		{
            super(NAME);
        }
		override public function init():void
		{
		   registerView(ViewConstant.VIEW_LOADING, 			getAppView("loading", "MCLoadingIcon"), 			Loading_Mediator, 2);
		   registerView(ViewConstant.VIEW_LOGIN, 			getAppView("login", "MCLoginPage"), 				Login_Mediator);
		   registerView(ViewConstant.VIEW_SELECT_LESSON, 	getAppView("select_lesson", "MCSelectLesson"), 		SelectLesson_Mediator);
		   registerView(ViewConstant.VIEW_MAP, 				getAppView("map", "MCMainMap"), 					Map_Mediator);
		   registerView(ViewConstant.VIEW_NAVIGATE, 		getAppView("common", "MCNavigate"), 				Navigate_Mediator, 5);
		   
		   
		   sendNotification(ApplicationConstant.ADD_VIEW, ViewConstant.VIEW_LOGIN);
		   
		   var soundPx:SoundPx = ApplicationFacade.getInstance().retrieveProxy(SoundPx.NAME) as SoundPx;
			soundPx.initSound();
		   //sendNotification(ApplicationConstant.WAITING_SERVER, true);
		}
		
		private function getAppView(domain:String, name:String):Class
		{
			var assetPx:AssetPx = retrieveProxy(AssetPx.NAME) as AssetPx;
			return assetPx.getGeneralAsset(domain, name);
		}
		
		public function registerView(name:String,display:Class,mediator:Class,layer:int = 1):void
		{
			viewList[name] = new ViewVO(display, mediator, "layer_" + layer);
		}	
		
		public function getView(name:String):ViewVO
		{
			return viewList[name];
		} 
		
		public function removeAll():void
		{
			var value:String;
			
			for(value in viewList)
			{
				sendNotification(ApplicationConstant.REMOVE_VIEW, value);
			}
		}  
	}
}