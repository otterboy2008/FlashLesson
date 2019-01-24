package commands 
{
	import constants.ApplicationConstant;
	import constants.ViewConstant;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author ...
	 */
	public class WaitingforServerCommand extends SimpleCommand 
	{
		
		public function WaitingforServerCommand() 
		{
			super();
		}
		
		override public function execute(notification:INotification):void 
		{
			super.execute(notification);
			var show:Boolean = notification.getBody() as Boolean;
			if (show)
			{
				sendNotification(ApplicationConstant.ADD_VIEW, ViewConstant.VIEW_LOADING);
			}
			else
			{
				sendNotification(ApplicationConstant.REMOVE_VIEW, ViewConstant.VIEW_LOADING);
			}
		}
	}

}