package com.fenxihui.library.data
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.MouseEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class DataBase
	{
		private var conn:SQLConnection;
		private var is_async:Boolean=false;
		
		public function DataBase()
		{
			conn=new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN,function(e:SQLEvent):void{
				trace("打开数据库成功！");
			});
			conn.addEventListener(SQLEvent.CLOSE,function(e:SQLEvent):void{
				trace("关闭数据库成功！");
			});
			conn.addEventListener(SQLErrorEvent.ERROR,function(e:SQLErrorEvent):void{
				trace("打开数据库失败！",e.error.message,e.error.details);
			});
		}
		
		public function get isOpened():Boolean
		{
			return conn.connected;
		}
		
		public function get isAsync():Boolean
		{
			return is_async;
		}
		
		public function open(reference:File=null, openMode:String="create", autoCompact:Boolean=false, pageSize:int=1024, encryptionKey:ByteArray=null):void{
			is_async=false;
			conn.open.apply(this,arguments);//conn.open(reference,openMode,autoCompact,pageSize,encryptionKey);
		}
		public function openAsync(reference:File=null, openMode:String="create", autoCompact:Boolean=false, pageSize:int=1024, encryptionKey:ByteArray=null):void{
			is_async=true;
			conn.openAsync.apply(this,arguments);//conn.openAsync(reference,openMode,autoCompact,pageSize,encryptionKey);
		}
		public function close():void{
			if(conn.connected)
				conn.close.call(arguments);
		}
		
		public function execute(sql:String,params:Object=null,callback:Function=null,itemClass:Class=null):*{
			if(!conn.connected){
				trace("未连接到数据库",sql,params);
				return null;
			}
			var r:*=null;
			var state:SQLStatement = new SQLStatement();
			state.sqlConnection = conn;
			state.text = sql;
			if(params!=null){
				for(var key:String in params)
					state.parameters['@'+key]=params[key];
			}
			if(itemClass!=null)
				state.itemClass=itemClass;
			if(is_async){
				if(callback!=null){
					state.addEventListener(SQLEvent.RESULT,function(e:SQLEvent):void{
						callback(state.getResult());
					});
					state.addEventListener(SQLErrorEvent.ERROR,function(e:SQLErrorEvent):void{
						callback(e.error.message);
					});
				}
				state.execute();
			}else{
				try{
					state.execute();
					r=state.getResult();
				}catch(e:SQLError){
					trace(sql,e.message,e.details);
					r=e.message;
				}
			}
			return r;
		}
		
		public function count(table:String,where:Object,callback:Function=null):int{
			var keys:Array=[];
			for(var key:String in where)
				keys.push("["+key+"]=@"+key);
			var sql:String="SELECT count(*) FROM ["+table+"] WHERE "+keys.join(' AND ');
			if(is_async){
				execute(sql,where,function(e:*):void{
					if(e is SQLResult)
						callback(e.data.shift()['count(*)']);
					else
						callback(0);
				});
				return -1;
			}else{
				var result:*=execute(sql,where);
				return result is SQLResult?uint(result.data.shift()['count(*)']):0;
			}
		}
		
		public function select(sql:String,params:Object=null,callback:Function=null):Array{
			if(is_async){
				execute(sql,params,function(e:*):void{
					if(e is SQLResult)
						callback(e.data);
					else
						callback(null);
				});
				return null;
			}else{
				var result:*=execute(sql,params);
				return result is SQLResult?result.data:null;
			}
		}
		
		public function insert(table:String,data:Object,callback:Function=null):int{
			var keys:Array=[];
			for(var key:String in data)
				keys.push(key);
			var sql:String="INSERT INTO ["+table+"] (["+keys.join('],[')+"])VALUES(@"+keys.join(',@')+")";
			if(is_async){
				execute(sql,data,function(e:*):void{
					if(e is SQLResult)
						callback(e.lastInsertRowID);
					else
						callback(0);
				});
				return -1;
			}else{
				var result:*=execute(sql,data);
				return result is SQLResult?result.lastInsertRowID:0;
			}
		}
		
		public function update(table:String,data:Object,where:Object,callback:Function=null):int{
			var keys:Array=[],wheres:Array=[],key:String;
			for(key in data)
				keys.push("["+key+"]=@"+key);
			for(key in where){
				data[key]=where[key];
				wheres.push("["+key+"]=@"+key);
			}
			var sql:String="UPDATE ["+table+"] SET "+keys.join(',')+" WHERE "+wheres.join(' AND ');
			if(is_async){
				execute(sql,data,function(e:*):void{
					if(e is SQLResult)
						callback(e.lastInsertRowID);
					else
						callback(0);
				});
				return -1;
			}else{
				var result:*=execute(sql,data);
				return result is SQLResult?result.rowsAffected:0;
			}
		}
		
		public function remove(table:String,where:Object,callback:Function=null):int{
			var keys:Array=[];
			for(var key:String in where)
				keys.push("["+key+"]=@"+key);
			var sql:String="DELETE FROM ["+table+"] WHERE "+keys.join(' AND ');
			if(is_async){
				execute(sql,where,function(e:*):void{
					if(e is SQLResult)
						callback(e.lastInsertRowID);
					else
						callback(0);
				});
				return -1;
			}else{
				var result:*=execute(sql,where);
				return result is SQLResult?result.rowsAffected:0;
			}
		}
	}
}