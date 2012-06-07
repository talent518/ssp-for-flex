package com.fenxihui.desktop.utils
{
	import mx.utils.ObjectUtil;

	public class Params
	{
		public static const SERVER_HOST:String="desktop.fenxihui.com";
		public static const SERVER_PORT:uint=8086;
		public static const SOCKET_DELAY:uint=10;

		private static var _instance:Params=new Params;

		private var user:Object=new Object;
		private var _user:Object=new Object;
		private var autoLogin:Boolean=false;
		private var isLogined:Boolean=false;
		private var isRemember:Boolean=false;

		private var infoType:String="";

		private var status_change_event:Function;

		private var profile:Object=new Object;
		private var setting:Object=new Object;
		
		public function Params() {
			if (_instance) {
				throw new Error("Params can only be accessed through Params.params");
				return;
			}
			var result:Array=LocalProxy.getInstance().select("select * from [user] order by [logtime] desc limit 1");
			if(result && result.length>0){
				user=result.shift();
				if(user.password)
					isRemember=true;
				if(user.auth)
					autoLogin=true;
			}
			isLogined=false;
			_user=ObjectUtil.clone(user);
		}

		public static function get params():Params {
			return _instance;
		}

		public static function get autoLogin():Boolean{
			return _instance.autoLogin;
		}
		public static function set autoLogin(value:Boolean):void{
			_instance.autoLogin=value;
		}
		
		public static function get isRemember():Boolean{
			return _instance.isRemember;
		}
		public static function set isRemember(value:Boolean):void{
			_instance.isRemember=value;
		}

		public static function get infoType():String{
			return _instance.infoType;
		}
		public static function set infoType(value:String):void{
			_instance.infoType=value;
		}
		
		public static function get isLogined():Boolean{
			return _instance.isLogined;
		}
		public static function set isLogined(value:Boolean):void{
			if(_instance.isLogined!=value)
				statusChangeEvent(value?1:0);
			_instance.isLogined=value;
		}

		public static function get statusChangeEvent():Function{
			return _instance.status_change_event!=null?_instance.status_change_event:function(status:int):void{
				trace('Status:'+(status==1?'Online':'Offline'));
			};
		}

		public static function set statusChangeEvent(value:Function):void{
			_instance.status_change_event=value;
		}

		public static function get user():Object{
			return _instance.user;
		}
		
		public static function get profile():Object{
			return _instance.profile;
		}
		
		public static function get setting():Object{
			return _instance.setting;
		}
		
		public static function saveUser():void{
			if(ObjectUtil.compare(user,_instance._user,0)){
				trace('save data!');
				var where:Object={uid:user.uid},clone_user:Object=ObjectUtil.clone(user);
				if(!Params.autoLogin)
					clone_user.auth=null;
				if(!_instance.isRemember)
					clone_user.password=null;

				if(LocalProxy.getInstance().count('user',where)>0)
					LocalProxy.getInstance().update('user',clone_user,where);
				else
					LocalProxy.getInstance().insert('user',clone_user);
				_instance._user=ObjectUtil.clone(user);
			}else
				trace('none save data!');
		}
	}
}
