package view.reward
{
	import common.*;
	import VO.GroupVO;
	import VO.StudentVO;
	import constants.GameConstant;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.AssetPx;
	import model.ClassPx;
	import model.UserPx;
	import net.HttpConstant;
	import net.HttpRequest;
	import view.SelectClassComponent;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class GroupStudentListItem extends BaseComponent implements IListItem 
	{
		private var _assets:MovieClip;
		
		private var count:int = 33;
		
		private var _txtGroupName:TextField;
		private var _txtGroupScore:TextField;
		private var _btnDelete:MovieClip;
		
		private var _mcItemList:Array;
		
		private var _iconMCList:Array;
		private var _nameTxtList:Array;
		private var _sexMCList:Array;
		private var _rewardTxtList:Array;
		private var _scoreTxtList:Array;
		private var _minusMCList:Array;
		private var _addMCList:Array;
		
		private var _rewardCountList:Array;
		private var _groupId:int;
		private var _groupStudents:Array;
		
		public function GroupStudentListItem() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var MCClassItem:Class = assetPx.getGeneralAsset("tab", "GroupStudentListItem");
			_assets = new MCClassItem();
			addChild(_assets);
			
			_txtGroupName = _assets.getChildByName("txt_group_name") as TextField;
			_txtGroupScore = _assets.getChildByName("txt_group_score") as TextField;
			_btnDelete = _assets.getChildByName("btn_delete") as MovieClip;
			_btnDelete.buttonMode = true;
			_btnDelete.addEventListener(MouseEvent.CLICK, onBtnDeleteClick);
			
			_mcItemList = [];
			_iconMCList = [];
			_nameTxtList = [];
			_sexMCList = [];
			_rewardTxtList = [];
			_scoreTxtList = [];
			_minusMCList = [];
			_addMCList = [];
			_rewardCountList = [];
			
			for (var i:int = 0; i < count; i++)
			{
				var item:MovieClip = _assets.getChildByName("mc_item_" + i) as MovieClip;
				item.mc_sex.gotoAndStop(1);
				item.mc_icon.gotoAndStop(1);
				_iconMCList.push(item.mc_icon);
				_nameTxtList.push(item.txt_name);
				_sexMCList.push(item.mc_sex);
				_rewardTxtList.push(item.txt_reward);
				_scoreTxtList.push(item.txt_score);
				_minusMCList.push(item.btn_minus);
				_addMCList.push(item.btn_add);
				item.btn_minus.buttonMode = true;
				item.btn_minus.index = i;
				item.btn_minus.addEventListener(MouseEvent.CLICK, onBtnMinusClick);
				item.btn_add.buttonMode = true;
				item.btn_add.index = i;
				item.btn_add.addEventListener(MouseEvent.CLICK, onBtnAddClick);
				_mcItemList.push(item);
				
				_rewardCountList[i] = 0;
			}
		}
		
		private function onBtnMinusClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			var index:int = e.currentTarget.index;
			var score:int = int(_scoreTxtList[index].text);
			score--;
			_rewardCountList[index]--;
			var needUpdate:Boolean = true;
			if (score < 0)
			{
				score = 0;
				needUpdate = false;
			}
			if (_rewardCountList[index] < 0)
			{
				_rewardCountList[index] = 0;
				needUpdate = false;
			}
			_scoreTxtList[index].text = score.toString();
			_rewardTxtList[index].text = _rewardCountList[index].toString();
			if (needUpdate)
			{
				if (_groupStudents != null)
				{
					_groupStudents[index].score = score;
					updateStudentInfo(_groupStudents[index]);
				}
			}
		}
		
		private function onBtnAddClick(e:MouseEvent):void
		{
			soundPx.playSfx();
			var index:int = e.currentTarget.index;
			var score:int = int(_scoreTxtList[index].text);
			score++;
			_rewardCountList[index]++;
			_scoreTxtList[index].text = score.toString();
			_rewardTxtList[index].text = _rewardCountList[index].toString();
			if (_groupStudents != null)
			{
				_groupStudents[index].score = score;
				updateStudentInfo(_groupStudents[index]);
			}
		}
		
		private function onBtnDeleteClick(e:MouseEvent):void
		{
			var json:String = HttpRequest.generateDeleteStudentGroup(_groupId);
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.DELETE_GROUP_STUDENT, json, GameConstant.NET_METHOD_POST, onGetDeleteGroupResponse);
		}
		
		private function onGetDeleteGroupResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				trace("delete complete");
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				classPx.deleteClassGroup(ClassPx.selectedClassId, _groupId);
				sendViewEvent(CommonListComponent.ITEM_UPDATE, null, true);
			}
		}
		
		private var _data:GroupVO;
		public function get data() : Object
		{
			return _data;
		}
		
		public function set data( value:Object ) : void
		{
			_data = value as GroupVO;
			update();
		}
		
		public function update():void
		{
			if (_data)
			{
				var classPx:ClassPx = ApplicationFacade.getInstance().retrieveProxy(ClassPx.NAME) as ClassPx;
				_groupId = _data.groupId;
				_txtGroupName.text = _data.groupName;
				_txtGroupScore.text = classPx.getClassGroupStudentsTotalScore(ClassPx.selectedClassId, _groupId).toString();
				_groupStudents = classPx.getClassStudentByGroupId(ClassPx.selectedClassId, _groupId);
				for (var i:int = 0; i < count; i++)
				{
					if (i < _groupStudents.length)
					{
						_nameTxtList[i].text = _groupStudents[i].name;
						_iconMCList[i].gotoAndStop(_groupStudents[i].head);
						var sex:int = _groupStudents[i].sex + 1;
						_sexMCList[i].gotoAndStop(sex);
						_scoreTxtList[i].text = _groupStudents[i].score;
						_mcItemList[i].visible = true;
					}
					else
					{
						_mcItemList[i].visible = false;
					}
				}
			}	
		}
		
		private function updateStudentInfo(so:StudentVO):void
		{
			var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
			var json:String = HttpRequest.generateStudentData(so.id, so.name, so.phone, 0, userPx.getEduId(), so.sex.toString(), so.score, so.head);
			HttpRequest.getInstance().sendHttpRequest(HttpConstant.UPDATE_SINGLE_STUDENT, json, GameConstant.NET_METHOD_POST, onGetUpdateStudentResponse);
		}
		
		private function onGetUpdateStudentResponse(resp:Object):void
		{
			if (resp.result == 0)
			{
				trace("update student success");
			}
		}
		
		override public function get componentHeight():Number 
		{
			var h:Number = 0;
			for (var i:int = _mcItemList.length - 1; i >= 0; i--)
			{
				if (_mcItemList[i].visible)
				{
					h = _mcItemList[i].y + _mcItemList[i].height + 5;
					break;
				}
			}
			return h;
		}
	}
}