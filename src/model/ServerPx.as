package model
{
    
    import flash.display.*;
    import flash.events.*;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.utils.*;
    
    
    public class ServerPx extends ProxyMgr
	{
        public static const NAME:String = "ServerPx";
		
		public static const VERSION:String="1.11.9";		
		public static var serverTime:Number=0;
		
		private const EXCUTE_COUNT:String="4";
			
		public var userList:Array=[];
		public var appUser:int;
		public var userData:Object={};		
		public var initFlag:Boolean=false;
		public var initCount:int;
		public var initList:Array=[];       
		public var eventDispatcher:EventDispatcher=new EventDispatcher();
		public var errNum:int;
		public var rawData:Object={};			
		public var updateTimer:Timer=new Timer(120000,0);		
		public var skuList:Array=[];
		public var equipInitCount:int;
		public var equipUpgradeCount:int;
		
		public static var saveTimeStamp:Number;
		
        public function ServerPx()
		{
            super(NAME);	
        }
     }
}
