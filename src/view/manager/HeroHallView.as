package view.manager
{
	import common.BaseComponent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import model.AssetPx;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class HeroHallView extends BaseComponent 
	{
		private var _view:MovieClip;
		private var _btnClose:MovieClip;
		
		public function HeroHallView() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var  assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("common", "MCHeroHall");
			_view = new cls();
			addChild(_view);
			
			_btnClose = _view.getChildByName("btn_close") as MovieClip;
			_btnClose.buttonMode = true;
			_btnClose.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
		}
		
		private function onBtnCloseClick(e:MouseEvent):void
		{
			ApplicationFacade.getInstance().removePopupUI(this);
		}
	}

}