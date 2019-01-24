package mediator
{
	import constants.ViewConstant;
	import flash.display.MovieClip;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author RexJiang
	 */
	public class Loading_Mediator extends Mediator 
	{		
		private var _view:MovieClip;
		
		public function Loading_Mediator(mediatorName:String=null, viewComponent:Object=null) 
		{
			super(ViewConstant.VIEW_LOADING, viewComponent);
			_view = viewComponent as MovieClip;
			_view.graphics.beginFill(0xCCCCCC, 0.6);
			_view.graphics.drawRect( -960, -540, 1920, 1080);
			_view.graphics.endFill();
			_view.x = 960;
			_view.y = 540;
		}
		
	}

}