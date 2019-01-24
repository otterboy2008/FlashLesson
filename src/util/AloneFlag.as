package util
{
	/**
	 * 生成唯一的标识字符串符号，利用本地的最详细的日期时间以及随机数，
	 * 在一定程度上，避免了出现相同字符串的可能性
	 * @author RexJiang
	 */
	public class AloneFlag
	{
		//生成随机数的次数
		private static var COUNT:int = 3;
		//生成随机数的最大值
		private static var MAX_NUMBER:int = 10000;
		
		/**
		 * 可以传进一个唯一id，也可以不传，都会自行产生
		 * 连接3次随机，那么相同概率是1000*1000*1000可能性非常小
		 * 更别说其他的日期了
		 * @param id:唯一标识
		 * @return str:唯一标识
		 */
		public static function getStringFlag():String
		{
			var date:Date = new Date();
			var str:String = String(date.getFullYear()) + String(date.getMonth() + 1);
			str = str + String(date.getDate()) + String(date.getHours());
			str = str + String(date.getMilliseconds()) + String(date.getMinutes());
			for (var i:int = 0; i < COUNT; i++)
			{
				str = str + String(Math.floor(Math.random() * MAX_NUMBER));
			}
			//if (id != undefined || id != null)
			//{
				//str = str + id;
			//}
			return str;
		}
	}
}