package
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import model.UserPx;
	import util.AloneFlag;
	
	[SWF(width="1920", height="1080", frameRate="30", backgroundColor="#000000")]
	public class Main extends Sprite
	{
		public function Main()
		{
			contextMenu = new ContextMenu();
			//contextMenu.hideBuiltInItems();
			Security.allowDomain("*");
			
			var basePath:String = "..";
			var language:String = 'en';
			
			var sprite:Sprite = new Sprite();
			
			sprite.tabChildren = false;
			sprite.scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			stage.addChild(sprite);
			ApplicationFacade.getInstance().init(sprite, basePath, language);
			
			
			var so:SharedObject = SharedObject.getLocal("lessonSO");
			var id:String = so.data.id;
			var eduId:int = so.data.eduId;
			if (id == "" || id == null)
			{
				id = AloneFlag.getStringFlag();
				so.data.id = id;
				so.flush();
			}
			
			var userPx:UserPx = ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx;
			userPx.setUserId(id);
			userPx.setEduId(eduId);
			
			var userId:String = (ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx).getUserId();
			trace("uuid : " + userId);
			
			var educationId:int = (ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx).getEduId();
			trace("eduid : " + educationId);

			//stage.displayState = StageDisplayState.FULL_SCREEN;
		}
	}
}