package commands
{
    import flash.display.*;
    
	import constants.ApplicationConstant;
    
    import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    

    public class AddRemoveCmd extends SimpleCommand implements ICommand
    {       
        override public function execute( note:INotification ) : void    
        {
        	var list:Array;
        	list=note.getBody() as Array;
        	sendNotification(ApplicationConstant.REMOVE_VIEW,list[0]);
        	sendNotification(ApplicationConstant.ADD_VIEW,list[1]);
        }
    }
}