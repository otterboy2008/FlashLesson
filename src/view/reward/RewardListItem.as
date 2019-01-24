package view.reward
{
	import common.*;
	import VO.StudentVO;
	import constants.GameConstant;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import model.AssetPx;
	import model.UserPx;
	import net.HttpConstant;
	import net.HttpRequest;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class RewardListItem extends BaseComponent implements IListItem 
	{
		private var _assets:MovieClip;
		
		private var count:int = 6;
		
		private var _mcItemList:Array;
		
		private var _iconMCList:Array;
		private var _nameTxtList:Array;
		private var _sexMCList:Array;
		private var _rewardTxtList:Array;
		private var _scoreTxtList:Array;
		private var _minusMCList:Array;
		private var _addMCList:Array;
		
		private var _rewardCountList:Array;
		
		public function RewardListItem() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var MCClassItem:Class = assetPx.getGeneralAsset("tab", "RewardListItem");
			_assets = new MCClassItem();
			addChild(_assets);
			
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
			_data[index].score = score;
			if (needUpdate)
			{
				updateStudentInfo(_data[index]);
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
			_data[index].score = score;
			updateStudentInfo(_data[index]);
		}
		
		private var _data:Array;
		public function get data() : Object
		{
			return _data;
		}
		
		public function set data( value:Object ) : void
		{
			_data = value as Array;
			update();
		}
		
		public function update():void
		{
			if (_data)
			{
				for (var i:int = 0; i < count; i++)
				{
					if (i < _data.length)
					{
						_nameTxtList[i].text = _data[i].name;
						_iconMCList[i].gotoAndStop(_data[i].head);
						var sex:int = _data[i].sex + 1;
						_sexMCList[i].gotoAndStop(sex);
						_scoreTxtList[i].text = _data[i].score;
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
			return _assets.height;
		}
	}
}