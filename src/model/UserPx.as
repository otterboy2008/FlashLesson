package model
{    
	import VO.UserVO;
	
	public class UserPx extends ProxyMgr
	{
		public static const NAME:String = "UserPx";	
		
		private var _userVo:UserVO;
		
		public function UserPx()
		{
			super(NAME);
			init();
		}
		
		override public function init():void
		{        
			_userVo = new UserVO();
		}
		
		public function setUserId(id:String):void
		{
			_userVo.userId = id;
		}
		
		public function getUserId():String
		{
			return _userVo.userId;
		}
		
		public function setEduId(id:int):void
		{
			_userVo.eduId = id;
		}
		
		public function getEduId():int
		{
			return _userVo.eduId;
		}
		
		public function setActiveId(id:String):void
		{
			_userVo.activeId = id;
		}
		
		public function getActiveId():String
		{
			return _userVo.activeId;
		}
	}
}