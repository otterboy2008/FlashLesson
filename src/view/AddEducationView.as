package view
{
	import common.BaseComponent;
	import component.PreUseComponent;
	import constants.GameConstant;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import model.AssetPx;
	import model.UserPx;
	import net.HttpConstant;
	import net.HttpRequest;
	import flash.system.fscommand;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class AddEducationView extends BaseComponent
	{
		public static const START_PRE_USE:String = "start_pre_use";
		
		private var _view:MovieClip;
		
		private var _txtEducationID:TextField;
		private var _txtEducationCode:TextField;
		private var _txtHint:TextField;
		
		private var _btnConfirm:MovieClip;
		private var _btnCancel:MovieClip;
		private var _btnPreUse:MovieClip;
		
		public function AddEducationView() 
		{
			super();
			init();
		}
		
		public function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("common", "MCAddEducation");
			_view = new cls();
			this.addChild(_view);
			
			_txtEducationID = _view.getChildByName("txt_education_id") as TextField;
			_txtEducationCode = _view.getChildByName("txt_education_code") as TextField;
			
			_txtHint = _view.getChildByName("txt_hint") as TextField;
			
			_btnConfirm = _view.getChildByName("btn_confirm") as MovieClip;
			_btnConfirm.buttonMode = true;
			_btnConfirm.addEventListener(MouseEvent.CLICK, onBtnConfirmClick);
			_btnConfirm.x = (_view.width - _btnConfirm.width) / 2;
			
			_btnCancel = _view.getChildByName("btn_cancel") as MovieClip;
			_btnCancel.buttonMode = true;
			_btnCancel.addEventListener(MouseEvent.CLICK, onBtnCancelClick);
			
			_btnPreUse = _view.getChildByName("btn_preuse") as MovieClip;
			_btnPreUse.buttonMode = true;
			_btnPreUse.addEventListener(MouseEvent.CLICK, onBtnPreUseClick);
			_btnPreUse.visible = false;
		}
		
		private function onBtnConfirmClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			if (_txtEducationID.text == "" || _txtEducationCode.text == "")
			{
				_txtHint.text = "机构ID或授权码不能为空!";
				return;
			}
			var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
			userPx.setActiveId(_txtEducationCode.text);
			userPx.setEduId(int(_txtEducationID.text));
			var userId:String = userPx.getUserId();
			var json:String = HttpRequest.generateActiveClientData(1, userId, _txtEducationID.text);
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.ACTIVE_CLIENT, json, GameConstant.NET_METHOD_POST, onGetActiveClientResponse);
			_btnConfirm.mouseEnabled = false;
		}
		
		private function onBtnPreUseClick(e:MouseEvent):void
		{
			sendViewEvent(START_PRE_USE);
			ApplicationFacade.getInstance().removePopupUI(this);
			clear();
		}
		
		private function onBtnCancelClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			fscommand("quit");
		}
		
		private function onGetActiveClientResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				var so:SharedObject = SharedObject.getLocal("lessonSO");
				var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
				var out:int = resp.data;
				if (out == 0)// normal
				{
					so.data.active = userPx.getActiveId();
					so.data.eduId = userPx.getEduId();
					so.flush();
					ApplicationFacade.getInstance().removePopupUI(this);
					clear();
				}
				else if (out == 1)//preuse
				{
					so.data.active = userPx.getActiveId();
					so.data.eduId = userPx.getEduId();
					so.flush();
					sendViewEvent(START_PRE_USE);
					ApplicationFacade.getInstance().removePopupUI(this);
					clear();
				}
				else
				{
					_txtHint.text = "注册失败，该机构id不可用!";
					_btnConfirm.mouseEnabled = true;
				}
			}
			else
			{
				_txtHint.text = "注册失败，请输入正确的机构ID或者授权码!";
				_btnConfirm.mouseEnabled = true;
			}
		}
		
		public function setCanPreUse(can:Boolean):void
		{
			_btnPreUse.visible = can;
			if (!can)
			{
				_btnConfirm.x = (_view.width - _btnConfirm.width) / 2;
			}
		}
		
		public function setHintText(value:String):void
		{
			_txtHint.text = value;
		}
		
		public function clear():void
		{
			_txtEducationID.text = "";
			_txtEducationCode.text = "";
			_txtHint.text = "";
		}
	}

}