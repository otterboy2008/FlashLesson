package view.login
{
	import VO.ClassVO;
	import VO.TeacherVO;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import common.BaseComponent;
	import common.IListItem;
	import model.AssetPx;
	
	
	
	public class TeacherItem extends BaseComponent implements IListItem 
	{		
		public function TeacherItem() 
		{
			super();
			init();		
		}
		
		private var _assets:MovieClip;
		
		private var _txtTeacherName:TextField;
		private var mc_bg:MovieClip;
				
		public function init():void
		{

			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var MCTeacherItem:Class = assetPx.getGeneralAsset("login", "MCTeacherItem");
			
			if (_assets == null)
			{
				_assets = new MCTeacherItem();
				_assets.mouseChildren = false;
				addChild(_assets);
			}
			
			_txtTeacherName = _assets.getChildByName("txt_name") as TextField;
			mc_bg = _assets.getChildByName("mc_bg") as MovieClip;
		}
		
		
		private var _data:TeacherVO;
		public function get data() : Object
		{
			return _data;
		}
		
		public function set data( value:Object ) : void
		{
			_data = value as TeacherVO;
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
		
		public function get teacherName():String
		{
			return _data.classTeacher;
		}
		
		public function update():void
		{
			if (_data)
			{
				_txtTeacherName.text = _data.classTeacher;
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