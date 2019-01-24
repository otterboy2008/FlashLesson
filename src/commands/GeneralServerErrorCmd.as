package commands
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GeneralServerErrorCmd extends SimpleCommand
	{
		public function GeneralServerErrorCmd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
		}
	}
}