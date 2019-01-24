package view.login
{
	import common.*;
	import VO.ClassVO;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import model.AssetPx;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class SelectClassItem extends BaseComponent implements IListItem
	{
		
		public function SelectClassItem() 
		{
			super();
			init();	
		}
		
		private var _assets:MovieClip;
		
		private var _txtClassName:TextField;

		public function init():void
		{

			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var MCSelectClass:Class = assetPx.getGeneralAsset("tab", "MCClassNameItem");
			
			if (_assets == null)
			{
				_assets = new MCSelectClass();
				_assets.mouseChildren = false;
				addChild(_assets);
			}
			
			_txtClassName = _assets.getChildByName("txt_name") as TextField;
		}
		
		
		private var _data:ClassVO;
		public function get data() : Object
		{
			return _data;
		}
		
		public function set data( value:Object ) : void
		{
			_data = value as ClassVO;
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
		
		public function get className():String
		{
			return _data.className;
		}
		
		public function get classId():int
		{
			return _data.classId;
		}
		
		public function update():void
		{
			if (_data)
			{
				_txtClassName.text = _data.className;
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