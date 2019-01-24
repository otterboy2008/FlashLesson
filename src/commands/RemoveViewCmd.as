package commands{
    import flash.display.*;
    import model.*;
    import VO.ViewVO;
    import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.IMediator;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.facade.Facade;
	

    public class RemoveViewCmd extends SimpleCommand implements ICommand{       
        override public function execute( note:INotification ):void    {
        	var viewPx:ViewPx;
        	var viewVO:ViewVO;
        	var mediator:IMediator;
        	var name:String;
        	
        	name=note.getBody() as String;
			if(!facade.hasMediator(name)){
				return;        		
			} 
        	viewPx=retrieveProxy(ViewPx.NAME ) as ViewPx;
        	viewVO=viewPx.getView(name); 
        	    	
			mediator=facade.retrieveMediator(name) as IMediator;
			
			ApplicationFacade(facade).getLayer(viewVO.layer).removeChild(DisplayObject(mediator.getViewComponent()));
			mediator.onRemove();
			facade.removeMediator(name);
        }
		public function retrieveProxy(name:String):IProxy{
			return Facade.getInstance().retrieveProxy(name);
		}
    }
}