package view
{
	import VO.ClassVO;
	import VO.StudentVO;
	import common.BaseComponent;
	import common.CommonListComponent;
	import constants.GameConstant;
	import flash.display.MovieClip;
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
	public class AddClassView extends BaseComponent
	{
		public static const ADD_CLASS_SUCCESS:String = "add_class_success";
		
		private var _view:MovieClip;
		
		private var _txtInputClass:TextField;
		
		private var _btnConfirm:MovieClip;
		private var _btnCancel:MovieClip;
		
		public function AddClassView() 
		{
			super();
			init();
		}
		
		public function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var cls:Class = assetPx.getGeneralAsset("common", "MCAddClass");
			_view = new cls();
			this.addChild(_view);
			
			_txtInputClass = _view.getChildByName("txt_input_class") as TextField;
			
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
			var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
			var json:String = HttpRequest.generateClassData(1, _txtInputClass.text, "0", 0, userPx.getEduId());
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.ADD_SINGLE_CLASS, json, GameConstant.NET_METHOD_POST, onGetAddClassResponse);
			_btnConfirm.mouseEnabled = false;
		}
		
		private function onGetAddClassResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
				var classVo:ClassVO = new ClassVO();
				classVo.classId = resp.data;
				classVo.desc = "";
				classVo.eduId = userPx.getEduId();
				classVo.className = _txtInputClass.text;
				classVo.studentList = new Vector.<StudentVO>();
				
				classPx.addClassData(classVo);
				
				sendViewEvent(ADD_CLASS_SUCCESS);
				_btnConfirm.mouseEnabled = true;
				ApplicationFacade.getInstance().removePopupUI(this, true);
				clear();
			}
			else
			{
				_btnConfirm.mouseEnabled = true;
			}
		}
		
		private function onBtnCancelClick(e:MouseEvent = null):void
		{
			soundPx.playSfx();
			_btnConfirm.mouseEnabled = true;
			ApplicationFacade.getInstance().removePopupUI(this, true);
			clear();
		}
		
		public function clear():void
		{
			_txtInputClass.text = "";
		}
	}

}