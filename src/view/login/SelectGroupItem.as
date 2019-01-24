package view.login
{
	import common.*;
	import VO.GroupVO;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import model.AssetPx;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class SelectGroupItem extends BaseComponent implements IListItem
	{
		
		public function SelectGroupItem() 
		{
			super();
			init();	
		}
		
		private var _assets:MovieClip;
		
		private var _txtGroupName:TextField;

		public function init():void
		{

			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var MCSelectGroup:Class = assetPx.getGeneralAsset("tab", "MCGroupNameItem");
			
			if (_assets == null)
			{
				_assets = new MCSelectGroup();
				_assets.mouseChildren = false;
				addChild(_assets);
			}
			
			_txtGroupName = _assets.getChildByName("txt_name") as TextField;
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
		
		override public function get selected():Boolean 
		{
			return super.selected;
		}
		
		override public function set selected(value:Boolean):void 
		{
			if (selected != value)
			{
				super.selected = value;
			

			}
		}
		
		public function get groupName():String
		{
			return _data.groupName;
		}
		
		public function get groupId():int
		{
			return _data.groupId;
		}
		
		public function update():void
		{
			if (_data)
			{
				_txtGroupName.text = _data.groupName;
			}	
		}
		
		override public function get componentWidth():Number 
		{
			return _assets.width;
		}
		
		override public function get componentHeight():Number 
		{
			return _assets.height;
		}
	}

}