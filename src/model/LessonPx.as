package model
{
	import VO.HappyIslandVO;
	import VO.LessonVO;
	import VO.RainbowVO;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class LessonPx extends ProxyMgr
	{
		public static const NAME:String = "LessonPx";
		
		private var _lessonList:Array;
		
		private var _currentLesson:int;
		
		private var _needGroupFunction:Boolean;
		
		private var _sectionId:int;
		
		public function LessonPx() 
		{
			super(NAME);
			_lessonList = new Array();
		}
		
		public function initLessonData(json:Object):void
		{
			_needGroupFunction = json["needGroupFunction"];
			_sectionId = json["section_id"];
			var data:Array = json["lessonList"];
			for (var i:int = 0; i < data.length; i++)
			{
				var lesson:LessonVO = new LessonVO();
				lesson.lessonId = data[i].lessonId;
				lesson.rainBowList = [];
				lesson.happyIslandList = [];
				for (var j:int = 0; j < data[i].rainBow.length; j++)
				{
					var rainbowVo:RainbowVO = new RainbowVO();
					rainbowVo.name = data[i].rainBow[j].id;
					rainbowVo.videoList = data[i].rainBow[j].videoList;
					lesson.rainBowList.push(rainbowVo);
				}
				
				for (var k:int = 0; k < data[i].happyIsland.length; k++)
				{
					var happyVo:HappyIslandVO = new HappyIslandVO();
					happyVo.name = data[i].happyIsland[k].id;
					happyVo.mcIndex = data[i].happyIsland[k].mcIndex;
					happyVo.hitPointCount = data[i].happyIsland[k].hitPointCount;
					happyVo.videoList = data[i].happyIsland[k].videoList;
					lesson.happyIslandList.push(happyVo);
				}
				lesson.worldVideo = data[i].worldVideo;
				lesson.castleVideo = data[i].castleVideo;
				lesson.expandVideo = data[i].expandVideo;
				lesson.classexerciseVideo = data[i].classexerciseVideo;
				if (i == 0)
				{
					lesson.isUnlocked = true;
				}
				_lessonList.push(lesson);
			}
			trace(_lessonList);
		}
		
		public function getLessonData(lessonId:int):LessonVO
		{
			for (var i:int = 0; i < _lessonList.length; i++)
			{
				if (_lessonList[i].lessonId == lessonId)
				{
					return _lessonList[i];
				}
			}
			return null;
		}
		
		public function setCurrentLesson(lesson:int):void
		{
			_currentLesson = lesson;
			for (var i:int = 0; i < _lessonList.length; i++)
			{
				var data:LessonVO = _lessonList[i];
				//default set lesson data
				data.isOver = false;
				data.isUnlocked = false;
				if (i < _currentLesson)
				{
					data.isOver = true;
					data.isUnlocked = true;
				}
				else if (i == _currentLesson)
				{
					data.isUnlocked = true;
				}
				else
				{
					data.isUnlocked = false;
				}
			}
		}
		
		public function get currentLesson():int
		{
			return _currentLesson;
		}
		
		public function get lessonList():Array
		{
			return _lessonList;
		}
		
		public function get needGroupFunction():Boolean
		{
			return _needGroupFunction;
		}
		
		public function get sectionId():int
		{
			return _sectionId;
		}
	}

}