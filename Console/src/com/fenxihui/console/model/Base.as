package com.fenxihui.console.model
{
	import com.fenxihui.library.data.DataBase;
	import com.fenxihui.console.utils.RemoteProxy;
	
	import flash.filesystem.File;

	public class Base
	{
		public static function send(type:String, params:Object,moreArg:Object=null):void{
			RemoteProxy.send(type,params,moreArg);
		}
		public static function bind(type:String,func:Function):void{
			RemoteProxy.bind(type,func);
		}
	}
}
