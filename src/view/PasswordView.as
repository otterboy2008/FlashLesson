package view
{
	import common.BaseComponent;
	import constants.GameConstant;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.AssetPx;
	import model.UserPx;
	import net.HttpConstant;
	import net.HttpRequest;
	import view.manager.ClassManagerView;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class PasswordView extends BaseComponent 
	{
		private var _view:MovieClip;
		private var _txtInputPassword:TextField;
		private var _txtHint:TextField;
		
		private var _btnConfirm:MovieClip;
		private var _btnCancel:MovieClip;
		
		private var _passWord:String = "66667";
		
		private static var _classManagerView:ClassManagerView;
		
		public function PasswordView() 
		{
			super();
			init();
		}
		
		public function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("tab", "MCManagerPasswordClass");
			_view = new cls();
			this.addChild(_view);
			
			_txtInputPassword = _view.getChildByName("txt_password") as TextField;
			_txtHint = _view.getChildByName("txt_hint") as TextField;
			
			_btnConfirm = _view.getChildByName("btn_confirm") as MovieClip;
			_btnConfirm.buttonMode = true;
			_btnConfirm.addEventListener(MouseEvent.CLICK, onBtnConfirmClick);
			
			_btnCancel = _view.getChildByName("btn_cancel") as MovieClip;
			_btnCancel.buttonMode = true;
			_btnCancel.addEventListener(MouseEvent.CLICK, onBtnCancelClick);
		}
		
		private function onBtnConfirmClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			if (_txtInputPassword.text.length <= 0)
			{
				_txtHint.text = "密码不能为空!";
				return;
			}
			if (_txtInputPassword.text == _passWord)
			{
				_txtHint.text = "";
				var obj:Object = {};
				obj.data = true;
				onGetPassWordResponse(obj);
			}
			else
			{
				var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
				var eduId:int = userPx.getEduId();
				var password:String = _txtInputPassword.text;
				var json:String = HttpRequest.generatePassword(eduId, password);
				HttpRequest.getInstance().sendHttpRequest(HttpConstant.CHECK_PASSWORD, json, GameConstant.NET_METHOD_POST, onGetPassWordResponse);
				_btnConfirm.mouseEnabled = false;
			}
		}
		
		private function onGetPassWordResponse(resp:Object):void
		{
			if (resp.data == false )
			{
				_txtHint.text = "密码错误，请重新输入!";
				_btnConfirm.mouseEnabled = true;
			}
			else
			{
				_btnConfirm.mouseEnabled = true;
				ApplicationFacade.getInstance().removePopupUI(this);
				clear();
				showClassManagerView();
			}
		}
		
		private function onBtnCancelClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			_btnConfirm.mouseEnabled = true;
			ApplicationFacade.getInstance().removePopupUI(this);
			clear();
		}
		
		public static function showClassManagerView():void
		{
			if (_classManagerView == null)
			{
				_classManagerView = new ClassManagerView();
			}
			_classManagerView.showItemByIndex();
			ApplicationFacade.getInstance().addPopupUI(_classManagerView);
		}
		
		public function clear():void
		{
			_txtInputPassword.text = "";
			_txtHint.text = "";
		}
	}

}