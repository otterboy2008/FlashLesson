package net
{  
    import flash.events.Event;  
    import flash.events.HTTPStatusEvent;  
    import flash.events.IOErrorEvent;  
    import flash.events.ProgressEvent;  
    import flash.events.SecurityErrorEvent;  
    import flash.net.URLLoader;  
    import flash.net.URLLoaderDataFormat;  
    import flash.net.URLRequest;  
    import flash.net.URLRequestMethod;  
    import flash.net.URLVariables;  
    import flash.net.navigateToURL;
	import model.UserPx;
      
    public class HttpRequest
    {
		private static var _instance:HttpRequest;
		
		
		public static function getInstance():HttpRequest 
		{
            if (_instance == null )_instance = new HttpRequest();
			return _instance as HttpRequest;
        }
        
        private var urlStr:String = "http://classssytem.busdream.com/";
		
        //private var urlStr:String = "http://118.24.108.98:8080/classssystem/";
		private var _callBackObj:Object = {};
        
          
        //请求服务端  
        public function sendHttpRequest(type:String, data:String, method:String, callBack:Function = null, classId:int = 0):void
        {  
            var urlLoader:URLLoader = new URLLoader();
            //urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
            //var urlVars:URLVariables = new URLVariables();
            //urlVars.text = data;
            var urlRequest:URLRequest = new URLRequest();
			urlRequest.contentType = "application/json";
            urlRequest.data = data;
			switch(type)
			{
				case HttpConstant.ACTIVE_CLIENT:
					var activeId:String = (ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx).getActiveId();
					urlRequest.url = urlStr + type + "/" + activeId;
					break;
				case HttpConstant.ADD_SINGLE_STUDENT:
					urlRequest.url = urlStr + type + "?classsid=" + classId;
					break;
				//case HttpConstant.CHECK_PASSWORD:
					//var eduId:int = (ApplicationFacade.getInstance().retrieveProxy(UserPx.NAME) as UserPx).getEduId();
					//urlRequest.url = urlStr + type + "?eduid=" + eduId;
					//break;
				default:
					urlRequest.url = urlStr + type;
					break;
			}
			switch(method)
			{
				case "GET":
					urlRequest.method = URLRequestMethod.GET;
					break;
				case "POST":
					urlRequest.method = URLRequestMethod.POST;
					break;
			}
			var key:String = "/" + type;
			_callBackObj[key] = callBack;
            try
            {
                urlLoader.load(urlRequest);
            }
            catch(error:Error)
            {
                trace(error);
            }
            urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
            urlLoader.addEventListener(Event.OPEN, urlLoaderOpenHandler);
            urlLoader.addEventListener(ProgressEvent.PROGRESS, urlLoaderProgressHandler);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
            urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, urlLoaderHttpStatusHandler);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIoErrorHandler);
        }
        
        private function urlLoaderCompleteHandler(e:Event):void
        {
			var resp:Object = JSON.parse(e.target.data);
            trace(e.target.data);
			var msg:String = resp.msg;
			if (_callBackObj[msg] != null)
			{
				_callBackObj[msg](resp);
				_callBackObj[msg] = null;
			}
        }
        
        private function urlLoaderOpenHandler(e:Event):void
        {
           
        }
        
        private function urlLoaderProgressHandler(e:ProgressEvent):void
        {  
            var num:uint = (e.bytesLoaded / e.bytesTotal) * 100;
        }  
        
        private function urlLoaderSecurityErrorHandler(e:SecurityErrorEvent):void
        {  
            trace(e);
        }  
        
        private function urlLoaderHttpStatusHandler(e:HTTPStatusEvent):void
        {  
            trace(e);
        }  
        
        private function urlLoaderIoErrorHandler(e:IOErrorEvent):void
        {  
            trace(e);
        } 
		
		public static function generateActiveClientData(_id:int, _uuid:String, _eduid:String, _isDelete:int = 0):String
		{
			var obj:Object = {};
			obj.id = _id;
			obj.uuid = _uuid;
			obj.eduId = _eduid;
			obj.isDelete = _isDelete;
			var json:String = JSON.stringify(obj);
			return json;
		}
		
		public static function generateEducationData(_id:int,_names:String = "0",_descs:String = "0",_isDelete:int = 0,_isAction:int = 0):String
		{
			var obj:Object = {};
			obj.id = _id;
			obj.names = _names;
			obj.descs = _descs;
			obj.isDelete = _isDelete;
			obj.isAction = _isAction;
			var json:String = JSON.stringify(obj);
			return json;
		}
		
		public static function generateTeacherData(_id:int, _names:String = "0", _phone:String = "0", _isDelete:int = 0, _eduId:int = 0, _headImageId:int = 1,_brithday:String = "1970-01-01"):String
		{
			var obj:Object = {};
			obj.id = _id;
			obj.names = _names;
			obj.phone = _phone;
			obj.isDelete = _isDelete;
			obj.eduId = _eduId;
			obj.headImageId = _headImageId;
			obj.brithday = _brithday;
			var json:String = JSON.stringify(obj);
			return json;
		}
		
		public static function generateStudentData(_id:int, _names:String = "0", _phone:String = "0", _isDelete:int = 0, _eduId:int = 0, _brithday:String = "1970-01-01", _star:int = 0,_headImageId:int = 1):String
		{
			var obj:Object = {};
			obj.id = _id;
			obj.names = _names;
			obj.headImageId = _headImageId;
			obj.phone = _phone;
			obj.isDelete = _isDelete;
			obj.eduId = _eduId;
			obj.brithday = _brithday;
			obj.star = _star;
			var json:String = JSON.stringify(obj);
			return json;
		}
		
		public static function generateClassData(_id:int, _names:String = "0", _descs:String = "0", _isDelete:int = 0, _eduId:int = 0, _isAction:int = 0):String
		{
			var obj:Object = {};
			obj.id = _id;
			obj.names = _names;
			obj.descs = _descs;
			obj.isDelete = _isDelete;
			obj.eduId = _eduId;
			obj.isAction = _isAction;
			var json:String = JSON.stringify(obj);
			return json;
		}
		
		public static function generateSMS(_eduId:int,_uuid:String,_phone:String):String
		{
			return HttpConstant.SEND_SMS + _eduId + "/" + _uuid + "/" + _phone;
		}
		
		public static function generatePassword(_id:int = 0, _names:String = "", _desc:String = "", _isDelete:int = 0, _isAction:int = 0):String
		{
			var obj:Object = {};
			obj.id = _id;
			obj.names = _names;
			obj.desc = _desc;
			obj.isDelete = _isDelete;
			obj.isAction = _isAction;
			var json:String = JSON.stringify(obj);
			return json;
		}
		
		public static function generateLessonAttendanceUp(_classId:int,_sutdentid:Array,_teacherId:int):String
		{
			var obj:Object = {};
			obj.classsid = _classId;
			obj.studentid = _sutdentid;
			obj.teacherId = _teacherId;
			var json:String = JSON.stringify(obj);
			return json;
		}
		
		public static function generateLessonAttendanceDown(_id:int = 0, _sectionId:int = 0, _chapterId:int = 0):String
		{
			var obj:Object = {};
			obj.id = _id;
			obj.sectionId = _sectionId;
			obj.chapterId = _chapterId;
			var json:String = JSON.stringify(obj);
			return json;
		}
		
		public static function generateLessonChapter(_classId:int,_lesson:int = 0):String
		{
			var obj:Object = {};
			obj.classs_id = _classId;
			obj.is_action = _lesson;
			var json:String = JSON.stringify(obj);
			return json;
		}
		
		public static function generateAddStudentGroup(_groupName:String, _studentids:Array):String
		{
			var obj:Object = {};
			obj.group_name = _groupName;
			obj.student_id = _studentids;
			var json:String = JSON.stringify(obj);
			return json;
		}
		
		public static function generateDeleteStudentGroup(_groupid:int):String
		{
			var obj:Object = {};
			obj.group_id = _groupid;
			var json:String = JSON.stringify(obj);
			return json;
		}
		
		public static function generateGetEduStatus(_id:int):String
		{
			var obj:Object = {};
			obj.id = _id;
			var json:String = JSON.stringify(obj);
			return json;
		}
    }  
}  