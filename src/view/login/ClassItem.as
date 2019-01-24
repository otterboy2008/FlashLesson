package view.login
{
	import VO.ClassVO;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import common.BaseComponent;
	import common.IListItem;
	import model.AssetPx;
	
	
	
	public class ClassItem extends BaseComponent implements IListItem 
	{
		private var holderRight : Number;
		
		public function ClassItem() 
		{
			super();
			init();		
		}
		
		private var _assets:MovieClip;
		
		private var _txtClassName:TextField;
		private var mc_bg:MovieClip;

		public function init():void
		{

			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var MCClassItem:Class = assetPx.getGeneralAsset("login", "MCClassItem");
			
			if (_assets == null)
			{
				_assets = new MCClassItem();
				_assets.mouseChildren = false;
				addChild(_assets);
			}
			
			_txtClassName = _assets.getChildByName("txt_name") as TextField;
			mc_bg = _assets.getChildByName("mc_bg") as MovieClip;
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
		
		public function update():void
		{
			if (_data)
			{
				_txtClassName.text = _data.className;
			}	
		}
		
		
		override public function get componentHeight():Number 
		{
			return mc_bg.height;
		}
		
		override public function set componentHeight(value:Number):void 
		{
			super.componentHeight = value;
		}
		
	}

}