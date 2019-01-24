package model
{	
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;

	
	import constants.ApplicationConstant;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	
	import spark.primitives.Path;
	public class AssetPx extends ProxyMgr
	{
		public static const NAME:String = "AssetPx";		
	
		private var resourceLd:BulkLoader;
		public var xml:Object={};
		public var basePath:String;
		public var language:String;
		public var stage:DisplayObjectContainer;

		public var swfList:Object={};

		public var loadInfo:Object={};
		
		public function AssetPx(pStage:DisplayObjectContainer,pBasePath:String, planguage:String = 'en'):void
		{
			stage = pStage;
			basePath = pBasePath;
			language = planguage;
			resourceLd = new BulkLoader("loader");
			super(NAME);
		}
		public function getStage():DisplayObject
		{
			return stage;
		}
		public function getSwf(name:String):Loader
		{
			return Loader(swfList[name]);
		}
		
		public function getGeneralAsset(swfName:String, clsName:String):Class
		{
			if (!resourceLd.get(swfName))
			{
				throw new Error("can not find : " + swfName + ".swf");
			}
			var cls:Class = ImageItem(resourceLd.get(swfName)).getDefinitionByName(clsName) as Class;
			//if (!cls) 
			//{
				//throw new Error("can not find class : " + clsName + " from swf: " + swfName + ".swf");
			//}
			return cls;
		}
		
		public function getGeneralXML(type:String):XML
		{
			if( resourceLd.get(type) )
			{
				return resourceLd.getXML(type);
			}
			return null;
		}
		
		public function getGeneralJSON(type:String):Object
		{
			if( resourceLd.get(type) )
			{
				var str:String = resourceLd.getText(type);
				return JSON.parse(str) as Object;
			}
			return null;
		}
		
		public function getLanguage(type:String):String
		{
			if(xml.hasOwnProperty('language_' + type))
			{
				return String(xml['language_' + type].data);
			}
			else
			{
				return "";
			}
		}
		
		public function loadStartResources(connections:int = 3):EventDispatcher
		{
			resourceLd.addEventListener(BulkLoader.COMPLETE, onLoadAssetsComleteEvent);
			resourceLd.addEventListener(BulkLoader.ERROR, onLoadError);
			
			
			var dirPath:String;
			
			//game ui
			dirPath = basePath + "/resources/ui/";
			resourceLd.add(dirPath + "loading.swf", {id:"loading"});
			
			resourceLd.add(dirPath + "common.swf", {id:"common"});
			
			resourceLd.add(dirPath + "login.swf", {id:"login"});
			
			resourceLd.add(dirPath + "tab.swf", {id:"tab"});
			
			resourceLd.add(dirPath + "select_lesson.swf", {id:"select_lesson"});
			
			resourceLd.add(dirPath + "map.swf", {id:"map"});
			
			resourceLd.add(dirPath + "mcList.swf", {id:"mcList"});
			
			dirPath = basePath + "/resources/json/";
			resourceLd.add(dirPath + "lessonList.json", {id:"lesson_json"});
			
			dirPath = basePath + "/resources/video/";
			for (var i:int = 0; i < 16; i++)
			{
				var swfId:String = "lesson" + i;
				var swf:String = "lesson" + i + ".swf";
				resourceLd.add(dirPath + swf, {id:swfId});
				var singleSwfId:String = "singleMovieLesson" + i;
				var singleSwf:String = singleSwfId + ".swf";
				resourceLd.add(dirPath + singleSwf, {id:singleSwfId});
			}
			resourceLd.start(connections);
			
			/*
			//tools
			appDomain=new ApplicationDomain();
			domain.tools=appDomain;			
			resourceLd.add(basePath+dirPath+"tools.swf",{context:new LoaderContext(false,appDomain)});
			
			
			//static.xml
			appDomain=new ApplicationDomain();
			dirPath = "/resources/general/items/";
			resourceLd.add(basePath + dirPath + "static.xml", {id: "static.xml", context:new LoaderContext(false,appDomain)});
			
			//characters
			dirPath="/resources/general/characters/";
			appDomain=new ApplicationDomain();
			domain.characters=appDomain;			
			resourceLd.add(basePath+dirPath+"characters.swf", {id:"characters.swf", context:new LoaderContext(false,appDomain)});
			*/
			return resourceLd;
		}
		
		private function onLoadAssetsComleteEvent(e:Event):void
		{
			trace("load complete");
			var viewPx:ViewPx = retrieveProxy(ViewPx.NAME) as ViewPx;
			viewPx.init();
		}
		
		private function onLoadError(e:Event):void
		{
			
		}
		
		public function defaultErrorHandler(e:IOErrorEvent):void
		{
			sendNotification(ApplicationConstant.RESOURCE_LOAD_ERROR);
		}
		
		public function getStaticItemDefine():XML
		{
			return getGeneralXML('static.xml');
		}
		
		public function getObstacleDefine():XML
		{
			return getGeneralXML('obstacle.xml');
		}

	}
}