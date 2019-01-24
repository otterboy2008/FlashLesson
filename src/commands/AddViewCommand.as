package commands
{
    import VO.ViewVO;
	import model.ViewPx;
    import flash.display.*;
    import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.IMediator;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
	
    public class AddViewCommand extends SimpleCommand implements ICommand
	{
       
        override public function execute( note:INotification ):void
		{
        	var viewPx:ViewPx;
        	var viewVO:ViewVO;
        	var mediator:IMediator;
        	
        	var name:String;
        	var mc:MovieClip;
        		
        	name=note.getBody() as String;
        	if(facade.hasMediator(name)){
        		return;
        	}
        	viewPx=facade.retrieveProxy(ViewPx.NAME) as ViewPx;
        	viewVO=viewPx.getView(name);
			
			mc=new (viewVO.display);
			
			mediator=new (viewVO.mediator)(name,mc);
			
			ApplicationFacade(facade).getLayer(viewVO.layer).addChild(mc);
			facade.registerMediator(mediator);
        }
    }
}