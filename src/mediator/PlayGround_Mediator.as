package mediator
{
	import constants.ViewConstant;
	import flash.display.MovieClip;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayGround_Mediator extends Mediator 
	{
		
		private var _view:MovieClip;
		
		public function PlayGround_Mediator(mediatorName:String = null, viewComponent:Object = null):void
		{
			super(ViewConstant.VIEW_PLAYGROUND, viewComponent);
			_view = viewComponent as MovieClip;
		}
		
	}

}