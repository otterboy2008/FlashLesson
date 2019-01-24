package component
{
	import common.BaseComponent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.system.fscommand;
	import flash.text.TextField;
	import model.AssetPx;
	import view.AddEducationView;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class PreUseComponent extends BaseComponent
	{
		private var _mcHint:MovieClip;
		private var _txtHint:TextField;
		
		private var _btnRegister:MovieClip;
		private var _btnCancel:MovieClip;

		public function PreUseComponent() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("common", "MCPreUse");
			_mcHint = new cls();
			addChild(_mcHint);
			
			_txtHint = _mcHint.mc.getChildByName("txt_hint") as TextField;
			
			_btnRegister = _mcHint.getChildByName("btn_register") as MovieClip;
			_btnRegister.buttonMode = true;
			_btnRegister.addEventListener(MouseEvent.CLICK, onBtnRegisterClick);
			_btnRegister.visible = false;
			
			_btnCancel = _mcHint.getChildByName("btn_cancel") as MovieClip;
			_btnCancel.buttonMode = true;
			_btnCancel.addEventListener(MouseEvent.CLICK, onBtnCancelClick);
			_btnCancel.visible = false;
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		private function onBtnRegisterClick(e:MouseEvent):void
		{
			if (this.parent)
			{
				this.graphics.clear();
				this.parent.removeChild(this);
			}
			var addEduView:AddEducationView = new AddEducationView();
			addEduView.setCanPreUse(false);
			ApplicationFacade.getInstance().addPopupUI(addEduView);
		}
		
		private function onBtnCancelClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			fscommand("quit");
		}
		
		public function setText(str:String, expire:Boolean = false):void
		{
			_txtHint.text = str;
			this.mouseChildren = expire;
			this.mouseEnabled = expire;
			_btnRegister.visible = expire;
			_btnCancel.visible = expire;
			if (expire)
			{
				this.graphics.beginFill(0x000000, 0.5);
				this.graphics.drawRect( -this.x, -this.y, stage.width, stage.height);
				this.graphics.endFill();
			}
			else
			{
				this.graphics.clear();
			}
		}
	}

}