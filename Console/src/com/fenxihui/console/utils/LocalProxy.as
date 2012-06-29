package com.fenxihui.console.utils
{
	import com.fenxihui.library.data.DataBase;
	
	import flash.filesystem.File;

	public class LocalProxy
	{
		private static var _instance:LocalProxy=new LocalProxy;

		private var _db:DataBase;

		public function LocalProxy()
		{
			if(_instance){
				throw new Error("LocalProxy can only be accessed through LocalProxy.getInstance()");
				return;
			}
			_db=new DataBase();
			var file:File=File.applicationDirectory.resolvePath("userdata.db");
			if(file.exists)
				_db.open(file);
			else
				trace("数据库文件不存在！");		
		}
		public function execute(sql:String,params:Object=null,callback:Function=null,itemClass:Class=null):*{
			return _db.execute.apply(this,arguments);
		}
		public function count(table:String,where:Object,callback:Function=null):int{
			return _db.count.apply(this,arguments);
		}
		public function select(sql:String,params:Object=null,callback:Function=null):Array{
			return _db.select.apply(this,arguments);
		}
		public function insert(table:String,data:Object,callback:Function=null):int{
			return _db.insert.apply(this,arguments);
		}
		public function update(table:String,data:Object,where:Object,callback:Function=null):int{
			return _db.update.apply(this,arguments);
		}
		public function remove(table:String,where:Object,callback:Function=null):int{
			return _db.remove.apply(this,arguments);
		}
		public static function getInstance():LocalProxy{
			return _instance;
		}
	}
}