package commands
{
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import constants.ApplicationConstant;
	public class CallServerCmd extends SimpleCommand
	{
		public function CallServerCmd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var param:Array = notification.getBody() as Array;
			switch(param.length)
			{
				case 1:
					param[0].execute(null, onFault);
					break;
				case 2:
					param[0].execute(param[1], onFault);
					break;
				 case 3:
					 param[0].execute(param[1], param[2]);
					 break;
			}
			
			function onFault(e:*):void
			{
				//handler general server error.
				sendNotification(ApplicationConstant.ERROR_CONNECT_TO_SERVER, e);
			}
		}
	}
}