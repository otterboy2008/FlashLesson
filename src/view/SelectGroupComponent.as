package view
{
	import VO.StudentVO;
	import common.BaseComponent;
	import common.CommonListComponent;
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
	import view.login.SelectGroupItem;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class SelectGroupComponent extends BaseComponent 
	{
		public static const SELECT_GROUP_CHANGE:String = "select_group_change";
		
		private var _asset:MovieClip;
		
		private var _txtGroupName:TextField;
		private var _btnExpand:MovieClip;
		
		private var _groupListComponent:CommonListComponent;
	
		private var _isExpand:Boolean;
		
		public static var selectedGroupId:int;
		
		public function SelectGroupComponent() 
		{
			super();
		}
		
		public function init(asset:MovieClip):void
		{
			_asset = asset;
			_txtGroupName = _asset.getChildByName("txt_group_name") as TextField;
			_btnExpand = _asset.getChildByName("btn_expand") as MovieClip;
			_btnExpand.buttonMode = true;
			_btnExpand.addEventListener(MouseEvent.CLICK, onBtnExpandClick);
			
			_groupListComponent = new CommonListComponent();
			_groupListComponent.initList(SelectGroupItem, 2);
			_groupListComponent.componentWidth = 250;
			_groupListComponent.componentHeight = 200;
			//_groupListComponent.addEventListener(CommonListComponent.SELECTION_CHANGE, onListChange);
			_asset.mc_tab_container.addChild(_groupListComponent);
			_asset.mc_tab_container.mouseEnabled = false;
			
			reset();
		}
		
		private function onBtnExpandClick(e:MouseEvent):void
		{
			if (_isExpand)
			{
				_isExpand = false;
				_groupListComponent.visible = false;
			}
			else
			{
				_isExpand = true;
				_groupListComponent.visible = true;
			}
		}
		
		private function onListChange(e:Event):void
		{
			var select:SelectGroupItem = (e.currentTarget as CommonListComponent).selectedItem as SelectGroupItem;
			_txtGroupName.text = select.groupName;
			selectedGroupId = select.groupId;
			_groupListComponent.visible = false;
			
			sendViewEvent(SELECT_GROUP_CHANGE, selectedGroupId);
		}
		
		public function reset():void
		{
			var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
			var groupList:Array = classPx.getClassGroupNameList(ClassPx.selectedClassId);
			if (groupList.length > 0)
			{
				_txtGroupName.text = groupList[0].groupName;
				selectedGroupId = groupList[0].groupId;
			}
			else
			{
				setDefaultTabName();
			}
			_groupListComponent.setDataList(groupList);
			_groupListComponent.visible = false;
			_btnExpand.mouseEnabled = groupList.length > 0;
		}
		
		public function setDefaultTabName(tabName:String = "未分组"):void
		{
			_txtGroupName.text = tabName;
		}		
	}

}