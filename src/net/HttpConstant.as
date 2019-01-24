package net
{
	/**
	 * ...
	 * @author RexJiang
	 */
	public class HttpConstant 
	{
		//education
		public static const GET_SINGLE_EDUCATION:String = "api/edu/info/select";
		public static const GET_ALL_EDUCATION:String = "api/edu/info/list";
		public static const UPDATE_SINGLE_EDUCATION:String = "api/edu/info/update";
		public static const ADD_SINGLE_EDUCATION:String = "api/edu/info/insert";
		public static const DELETE_SINGLE_EDUCATION:String = "api/edu/info/delete";
		
		//teacher
		public static const ADD_SINGLE_TEACHER:String = "api/edu/teacher/insert";
		public static const UPDATE_SINGLE_TEACHER:String = "api/edu/teacher/update";
		public static const GET_SINGLE_TEACHER:String = "api/edu/teacher/select";
		public static const GET_ALL_TEACHER:String = "api/edu/teacher/list";
		public static const DELETE_SINGLE_TEACHER:String = "api/edu/teacher/delete";
		
		//student
		public static const ADD_SINGLE_STUDENT:String = "api/edu/student/insert";
		public static const UPDATE_SINGLE_STUDENT:String = "api/edu/student/update";
		public static const DELETE_SINGLE_STUDENT:String = "api/edu/student/delete";
		public static const GET_SINGLE_STUDENT:String = "api/edu/student/select";
		public static const GET_ALL_STUDENT:String = "api/edu/student/list";
		
		//class
		public static const ADD_SINGLE_CLASS:String = "api/edu/classs/insert";
		public static const UPDATE_SINGLE_CLASS:String = "api/edu/classs/update";
		public static const DELETE_SINGLE_CLASS:String = "api/edu/classs/delete";
		public static const GET_SINGLE_CLASS:String = "api/edu/classs/select";
		public static const GET_ALL_CLASS:String = "api/edu/classs/list";
		public static const GET_CLASS_STUDENTS:String = "api/edu/classs/getStudent";
		
		//active client
		public static const ACTIVE_CLIENT:String = "api/action/client";
		
		//send phone message 
		public static const SEND_SMS:String = "api/sms/";
		
		//lesson Attendance
		public static const LESSON_ATTENDANCE_UP:String = "api/edu/punch/up";
		public static const LESSON_ATTENDANCE_DOWN:String = "api/edu/punch/down";
		
		//password
		public static const CHECK_PASSWORD:String = "api/edu/info/login";
		
		//lesson chapter
		public static const GET_LESSON_CHAPTER:String = "api/edu/punch/getLast";
		public static const UPDATE_LESSON_CHAPTER:String = "api/edu/punch/updateCurrent";
		
		//add group
		public static const ADD_GROUP_STUDENT:String = "api/edu/group/insert";
		public static const DELETE_GROUP_STUDENT:String = "api/edu/group/delete";
		
		//pre use time
		public static const GET_EDUCATION_STATUS:String = "api/edu/info/status";
	}

}