package model
{
	import VO.ClassVO;
	import VO.GroupVO;
	import VO.StudentVO;
	import VO.TeacherVO;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class ClassPx extends ProxyMgr
	{
		public static const NAME:String = "ClassPx";
		
		public static var selectedClassId:int;
		
		private var _classList:Array;
		private var _teacherList:Array;
		
		public function ClassPx()
		{
			super(NAME);
			init();
		}
		
		override public function init():void
		{        
			_classList = new Array();
			_teacherList = new Array();
		}
		
		public function addClassData(classData:ClassVO, needAutoId:Boolean = false):void
		{
			if (needAutoId)
			{
				var len:int = _classList.length;
				classData.classId = len + 1;
			}
			var has:Boolean = false;
			for (var i:int = 0; i < _classList.length; i++)
			{
				if (classData.classId == _classList[i].classId)
				{
					has = true;
				}
			}
			if (!has)
			{
				_classList.push(classData);
			}
		}
		
		public function getClassData(classId:int):ClassVO
		{
			for (var i:int = 0; i < _classList.length; i++)
			{
				if (classId == _classList[i].classId)
				{
					return _classList[i];
				}
			}
			return null;
		}
		
		public function deleteClassData(classData:ClassVO):void
		{
			for (var i:int = 0; i < _classList.length; i++)
			{
				if (classData.classId == _classList[i].classId)
				{
					_classList.splice(i, 1);
				}
			}
		}
		
		public function addStudentData(classId:int, so:StudentVO, needAutoId:Boolean = false):void
		{
			for (var i:int = 0; i < _classList.length; i++)
			{
				if (_classList[i].classId == classId)
				{
					if (needAutoId)
					{
						var len:int = _classList[i].studentList.length;
						so.id = len + 1;
					}
					var has:Boolean = false;
					for (var j:int = 0; j < _classList[i].studentList.length; j++)
					{
						if (_classList[i].studentList[j].id == so.id)
						{
							has = true;
						}
					}
					if (!has)
					{
						_classList[i].studentList.push(so);
					}
				}
			}
		}
		
		public function deleteStudentData(so:StudentVO):void
		{
			for (var i:int = 0; i < _classList.length; i++)
			{
				for (var j:int = 0; j < _classList[i].studentList.length; j++)
				{
					var student:StudentVO = _classList[i].studentList[j];
					if (student.id == so.id)
					{
						_classList[i].studentList.splice(j, 1);
						break;
					}
				}
			}
		}
		
		public function getClassIdWithStudentId(id:int):int
		{
			for (var i:int = 0; i < _classList.length; i++)
			{
				for (var j:int = 0; j < _classList[i].studentList.length; j++)
				{
					var student:StudentVO = _classList[i].studentList[j];
					if (student.id == id)
					{
						return _classList[i].classId;
					}
				}
			}
			return 0;
		}
		
		public function getClassStudentByGroupId(classId:int, groupId:int):Array
		{
			var result:Array = [];
			var allStudents:Vector.<StudentVO> = getClassOfStudentList(classId);
			for (var i:int = 0; i < allStudents.length; i++)
			{
				if (allStudents[i].groupId == groupId)
				{
					result.push(allStudents[i]);
				}
			}
			return result;
		}
		
		public function getClassGroupStudentsTotalScore(classId:int, groupId:int):int
		{
			var total:int = 0;
			var allStudents:Vector.<StudentVO> = getClassOfStudentList(classId);
			for (var i:int = 0; i < allStudents.length; i++)
			{
				if (allStudents[i].groupId == groupId)
				{
					total += allStudents[i].score;
				}
			}
			return total;
		}
		
		public function getClassGroupNameList(classId:int):Array
		{
			var result:Array = [];
			var temp:Array = [];
			var noGroup:Array = [];
			for (var i:int = 0; i < _classList.length; i++)
			{
				if (_classList[i].classId == classId)
				{
					for (var j:int = 0; j < _classList[i].studentList.length; j++)
					{
						var student:StudentVO = _classList[i].studentList[j];
						if (student.groupId != -1 && student.groupName != "")
						{
							if (temp.indexOf(student.groupId) == -1)
							{
								temp.push(student.groupId);
								var groupVo:GroupVO = new GroupVO();
								groupVo.groupId = student.groupId;
								groupVo.groupName = student.groupName;
								groupVo.groupTotalScore = getClassGroupStudentsTotalScore(classId, groupVo.groupId);
								result.push(groupVo);
							}
						}
						else
						{
							if (temp.indexOf(student.groupId) == -1)
							{
								temp.push(student.groupId);
								groupVo = new GroupVO();
								groupVo.groupId = student.groupId;
								groupVo.groupName = "未分组";
								groupVo.groupTotalScore = 0;
								noGroup.push(groupVo);
							}
						}
					}
				}
			}
			result.sortOn("groupTotalScore", Array.NUMERIC);
			return result.reverse().concat(noGroup);
		}
		
		public function deleteClassGroup(classId:int, groupId:int):void
		{
			var allStudents:Vector.<StudentVO> = getClassOfStudentList(classId);
			for (var i:int = 0; i < allStudents.length; i++)
			{
				if (allStudents[i].groupId == groupId)
				{
					allStudents[i].groupId = -1;
					allStudents[i].groupName = "";
				}
			}
		}
		
		public function updateStudentGroupIdAndName(classId:int, studentId:int, groupId:int, groupName:String):void
		{
			var allStudents:Vector.<StudentVO> = getClassOfStudentList(classId);
			for (var i:int = 0; i < allStudents.length; i++)
			{
				if (allStudents[i].id == studentId)
				{
					allStudents[i].groupId = groupId;
					allStudents[i].groupName = groupName;
				}
			}
		}
		
		public function addTeacherData(to:TeacherVO, needAutoId:Boolean = false):void
		{
			if (needAutoId)
			{
				var len:int = _teacherList.length;
				to.teacherId = len + 1;
			}
			var has:Boolean = false;
			for (var i:int = 0; i < _teacherList.length; i++)
			{
				if (_teacherList[i].teacherId == to.teacherId)
				{
					has = true;
				}
			}
			if (!has)
			{
				_teacherList.push(to);
			}
		}
		
		public function deleteTeacherData(to:TeacherVO):void
		{
			for (var i:int = 0; i < _teacherList.length; i++)
			{
				if (_teacherList[i].teacherPhoneNumber == to.teacherPhoneNumber)
				{
					_teacherList.splice(i, 1);
				}
			}
		}
		
		public function getClassOfStudentList(classId:int):Vector.<StudentVO>
		{
			for (var i:int = 0; i < _classList.length; i++)
			{
				if (_classList[i].classId == classId)
				{
					return _classList[i].studentList;
				}
			}
			return null;
		}
		
		public function getSortedClassList():Array
		{
			var result:Array = [];
			var index:int = 0;
			var temp2:Array = [];
			for (var j:int = 0; j < _classList.length; j++)
			{
				if (index < 6)
				{
					temp2.push(_classList[j]);
					index++;
				}
				else
				{
					result.push(temp2);
					temp2 = [];
					index = 0;
					temp2.push(_classList[j]);
					index++;
				}
				if (j == _classList.length - 1)
				{
					result.push(temp2);
				}
			}
			return result;
		}
		
		public function getSortedStudentList(classId:int):Array
		{
			var temp:Vector.<StudentVO> = new Vector.<StudentVO>();
			var result:Array = [];
			for (var i:int = 0; i < _classList.length; i++)
			{
				if (_classList[i].classId == classId)
				{
					temp = _classList[i].studentList;
					break;
				}
			}
			var index:int = 0;
			var temp2:Array = [];
			for (var j:int = 0; j < temp.length; j++)
			{
				if (index < 6)
				{
					temp2.push(temp[j]);
					index++;
				}
				else
				{
					result.push(temp2);
					temp2 = [];
					index = 0;
					temp2.push(temp[j]);
					index++;
				}
				if (j == temp.length - 1)
				{
					result.push(temp2);
				}
			}
			return result;
		}
		
		public function getSortedTeacherList():Array
		{
			var result:Array = [];
			var index:int = 0;
			var temp2:Array = [];
			for (var j:int = 0; j < _teacherList.length; j++)
			{
				if (index < 6)
				{
					temp2.push(_teacherList[j]);
					index++;
				}
				else
				{
					result.push(temp2);
					temp2 = [];
					index = 0;
					temp2.push(_teacherList[j]);
					index++;
				}
				if (j == _teacherList.length - 1)
				{
					result.push(temp2);
				}
			}
			return result;
		}
		
		public function get classList():Array
		{
			return _classList;
		}
		
		public function get teacherList():Array
		{
			return _teacherList;
		}
	}

}