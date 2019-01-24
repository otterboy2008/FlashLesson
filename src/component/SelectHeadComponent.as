package component
{
	import common.BaseComponent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import model.AssetPx;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class SelectHeadComponent extends BaseComponent
	{
		public static const HEAD_CHANGE:String = "head_change";
		
		private var _view:MovieClip;
		
		private var _totalHead:int = 18;
		
		private var _btnConfirm:MovieClip;
		private var _btnCancel:MovieClip;
		
		private var _mcSelect:MovieClip;
		
		private var _tempHead:int = 1;
		
		public function SelectHeadComponent() 
		{
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("common", "MCSelectHead");
			_view = new cls();
			this.addChild(_view);
			
			_mcSelect = _view.getChildByName("mc_select") as MovieClip;
			
			_btnConfirm = _view.getChildByName("btn_confirm") as MovieClip;
			_btnConfirm.buttonMode = true;
			_btnConfirm.addEventListener(MouseEvent.CLICK, onBtnConfirmClick);
			
			_btnCancel = _view.getChildByName("btn_cancel") as MovieClip;
			_btnCancel.buttonMode = true;
			_btnCancel.addEventListener(MouseEvent.CLICK, onBtnCancelClick);
			
			for (var i:int = 1; i <= _totalHead; i++)
			{
				var btn:MovieClip = _view.getChildByName("btn_" + i) as MovieClip;
				btn.index = i;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, onBtnHeadClick);
			}
		}
		
		private function onBtnHeadClick(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			_mcSelect.x = mc.x;
			_mcSelect.y = mc.y;
			_tempHead = e.currentTarget.index;
		}
		
		private function onBtnConfirmClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			sendViewEvent(HEAD_CHANGE, _tempHead);
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		private function onBtnCancelClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function get selectedHead():int
		{
			return _tempHead;
		}
	}

}