package view
{
	import VO.TeacherVO;
	import common.BaseComponent;
	import component.SelectHeadComponent;
	import constants.GameConstant;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.AssetPx;
	import model.ClassPx;
	import model.UserPx;
	import net.HttpConstant;
	import net.HttpRequest;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class AddTeacherView extends BaseComponent 
	{
		public static const ADD_TEACHER_SUCCESS:String = "add_teacher_success";
		
		private var _view:MovieClip;
		
		private var _txtInputName:TextField;
		private var _txtInputPhone:TextField;
		private var _txtInputCode:TextField;
		
		private var _txtHint:TextField;
		
		private var _btnChange:MovieClip;
		private var _mcHead:MovieClip;
		private var _btnSend:MovieClip;
		private var _btnVerified:MovieClip;
		private var _btnConfirm:MovieClip;
		private var _btnCancel:MovieClip;
		
		private var _yanzhenma:String;
		
		private var _selectHeadComponent:SelectHeadComponent;
		private var _head:int = 1;
		
		public function AddTeacherView() 
		{
			super();
			init();
		}
		
		public function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("common", "MCAddTeacher");
			_view = new cls();
			this.addChild(_view);
			
			_txtInputName = _view.getChildByName("txt_input_name") as TextField;
			_txtInputPhone = _view.getChildByName("txt_input_phone") as TextField;
			_txtInputPhone.restrict = "0-9";
			_txtInputCode = _view.getChildByName("txt_input_code") as TextField;
			
			_txtHint = _view.getChildByName("txt_hint") as TextField;
			_mcHead = _view.getChildByName("head_icon") as MovieClip;
			_mcHead.gotoAndStop(1);
			
			_selectHeadComponent = new SelectHeadComponent();
			_selectHeadComponent.addEventListener(SelectHeadComponent.HEAD_CHANGE, onHeadChangeEvent);
			
			_btnChange = _view.getChildByName("btn_change") as MovieClip;
			_btnChange.buttonMode = true;
			_btnChange.addEventListener(MouseEvent.CLICK, onBtnChangeClick);
			
			//_btnVerified = _view.getChildByName("btn_verified") as MovieClip;
			//_btnVerified.buttonMode = true;
			//_btnVerified.addEventListener(MouseEvent.CLICK, onBtnVerifiedClick);
			//_btnVerified.visible = false;
			
			_btnSend = _view.getChildByName("btn_send") as MovieClip;
			_btnSend.buttonMode = true;
			_btnSend.addEventListener(MouseEvent.CLICK, onBtnSendClick);
			
			_btnConfirm = _view.getChildByName("btn_confirm") as MovieClip;
			_btnConfirm.buttonMode = true;
			_btnConfirm.addEventListener(MouseEvent.CLICK, onBtnConfirmClick);
			
			_btnCancel = _view.getChildByName("btn_cancel") as MovieClip;
			_btnCancel.buttonMode = true;
			_btnCancel.addEventListener(MouseEvent.CLICK, onBtnCancelClick);
		}
		
		private function onBtnVerifiedClick(e:MouseEvent):void
		{
			//verified yan zhen ma
			//HttpRequest.getInstance().sendHttpRequest("verified", GameConstant.NET_METHOD_GET);
		}
		
		private function onBtnSendClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			if (_txtInputPhone.text.length < 11)
			{
				_txtHint.text = "手机号长度错误，请重新输入!";
				return;
			}
			_txtHint.text = "";
			var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
			var eduId:int = userPx.getEduId();
			var uuid:String = userPx.getUserId();
			var phone:String = _txtInputPhone.text;
			HttpRequest.getInstance().sendHttpRequest(HttpRequest.generateSMS(eduId, uuid, phone), "", GameConstant.NET_METHOD_GET, onGetSMSResponse);
		}
		
		private function onGetSMSResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				_yanzhenma = resp.data;
				trace(_yanzhenma);
				//_txtInputCode.text = yanzhengma;
			}
		}
		
		private function onHeadChangeEvent(e:Event):void
		{
			_head = _selectHeadComponent.selectedHead;
			_mcHead.gotoAndStop(_head);
		}
		
		private function onBtnChangeClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			this.addChild(_selectHeadComponent);
			_selectHeadComponent.x = _mcHead.x + _mcHead.width + 30;
			_selectHeadComponent.y = _mcHead.y;
		}
		
		private function onBtnConfirmClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			if (_txtInputCode.text != _yanzhenma)
			{
				_txtHint.text = "验证码错误，请重新输入!";
				return;
			}
			_txtHint.text = "";
			var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
			var json:String = HttpRequest.generateTeacherData(1, _txtInputName.text, _txtInputPhone.text, 0, userPx.getEduId(), _head);
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.ADD_SINGLE_TEACHER, json, GameConstant.NET_METHOD_POST, onGetAddTeacherResponse);
			_btnConfirm.mouseEnabled = false;
		}
		
		private function onGetAddTeacherResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
				var teacher:TeacherVO = new TeacherVO();
				teacher.teacherId = resp.data;
				teacher.head = _head;
				teacher.eduId = userPx.getEduId();
				teacher.classTeacher = _txtInputName.text;
				teacher.teacherPhoneNumber = _txtInputPhone.text;
				
				classPx.addTeacherData(teacher);
				
				sendViewEvent(ADD_TEACHER_SUCCESS);
				onBtnCancelClick();
			}
			else
			{
				_txtHint.text = String(resp.result);
				_btnConfirm.mouseEnabled = true;
			}
		}
		
		private function onBtnCancelClick(e:MouseEvent = null):void
		{
			if (e != null)
			{
				soundPx.playSfx();
			}
			ApplicationFacade.getInstance().removePopupUI(this, true);
			clear();
		}
		
		public function clear():void
		{
			_txtInputName.text = "";
			_txtInputCode.text = "";
			_txtInputPhone.text = "";
			_txtHint.text = "";
		}
		
	}

}