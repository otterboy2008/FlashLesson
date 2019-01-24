package view
{
	import VO.StudentVO;
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
	public class AddStudentView extends BaseComponent
	{
		private var _view:MovieClip;
		
		private var _txtName:TextField;
		private var _txtPhone:TextField;
		private var _txtHint:TextField;
		
		private var _mcHead:MovieClip;
		private var _btnChange:MovieClip;
		
		private var _mcSex:MovieClip;
		private var _btnMale:MovieClip;
		private var _btnFemale:MovieClip;
		
		private var _btnConfirm:MovieClip;
		private var _btnCancel:MovieClip;
		
		private var _selectHeadComponent:SelectHeadComponent;
		
		private var _sex:int = 0;//0 male 1 female
		private var _head:int = 1;
		
		public function AddStudentView() 
		{
			super();
			init();
		}
		
		public function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("common", "MCAddStudent");
			_view = new cls();
			this.addChild(_view);
			
			_txtName = _view.getChildByName("txt_name") as TextField;
			_txtPhone = _view.getChildByName("txt_phone") as TextField;
			_txtPhone.restrict = "0-9";
			_txtHint = _view.getChildByName("txt_hint") as TextField;
			
			_mcHead = _view.getChildByName("head_icon") as MovieClip;
			_mcHead.gotoAndStop(1);
			_mcSex = _view.getChildByName("mc_sex") as MovieClip;
			
			_btnChange = _view.getChildByName("btn_change") as MovieClip;
			_btnChange.buttonMode = true;
			_btnChange.addEventListener(MouseEvent.CLICK, onBtnChangeClick);
			
			_selectHeadComponent = new SelectHeadComponent();
			_selectHeadComponent.addEventListener(SelectHeadComponent.HEAD_CHANGE, onHeadChangeEvent);
			
			_btnMale = _view.getChildByName("btn_male") as MovieClip;
			_btnMale.buttonMode = true;
			_btnMale.addEventListener(MouseEvent.CLICK, onBtnMaleClick);
			
			_btnFemale = _view.getChildByName("btn_female") as MovieClip;
			_btnFemale.buttonMode = true;
			_btnFemale.addEventListener(MouseEvent.CLICK, onBtnFemaleClick);
			
			_btnConfirm = _view.getChildByName("btn_confirm") as MovieClip;
			_btnConfirm.buttonMode = true;
			_btnConfirm.addEventListener(MouseEvent.CLICK, onBtnConfirmClick);
			
			_btnCancel = _view.getChildByName("btn_cancel") as MovieClip;
			_btnCancel.buttonMode = true;
			_btnCancel.addEventListener(MouseEvent.CLICK, onBtnCancelClick);
		}
		
		private function onBtnMaleClick(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			_mcSex.x = mc.x - _mcSex.width;
			_sex = 0;
		}
		
		private function onBtnFemaleClick(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			_mcSex.x = mc.x - _mcSex.width;
			_sex = 1;
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
			if (_txtPhone.text.length != 11)
			{
				_txtHint.text = "手机号长度错误，请重新输入!";
				return;
			}
			_txtHint.text = "";
			var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var classId:int = ClassPx.selectedClassId;
			var json:String = HttpRequest.generateStudentData(1, _txtName.text, _txtPhone.text, 0, userPx.getEduId(), _sex.toString(), 0, _head);
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.ADD_SINGLE_STUDENT, json, GameConstant.NET_METHOD_POST, onGetAddStudentResponse, classId);
			_btnConfirm.mouseEnabled = false;
		}
		
		private function onBtnCancelClick(e:MouseEvent = null):void
		{
			if (e != null)
			{
				soundPx.playSfx();
			}
			_btnConfirm.mouseEnabled = true;
			ApplicationFacade.getInstance().removePopupUI(this, true);
			clear();
		}
		
		private function onGetAddStudentResponse(resp:Object):void
		{
			if (resp.result == 0 && resp.data > 0)
			{
				var student:StudentVO = new StudentVO();
				student.id = resp.data;
				student.name = _txtName.text;
				student.phone = _txtPhone.text;
				student.sex = _sex;
				student.head = _head;
				student.score = 0;
				student.groupId = -1;
				student.groupName = "";
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				var classId:int = ClassPx.selectedClassId;
				classPx.addStudentData(classId, student);
				
				onBtnCancelClick();
			}
			else
			{
				_txtHint.text = "添加学生失败，请重新尝试！";
				_btnConfirm.mouseEnabled = true;
			}
		}
		
		public function clear():void
		{
			_txtName.text = "";
			_txtPhone.text = "";
		}
	}

}