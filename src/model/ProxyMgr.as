package model{	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ProxyMgr extends Proxy implements IProxy{	
		public function ProxyMgr(pName:String){
			 super(pName);
		}	
		public function init():void{
			
		}
		public function retrieveProxy(name:String):IProxy{
			return Facade.getInstance().retrieveProxy(name);
		}
	}
}