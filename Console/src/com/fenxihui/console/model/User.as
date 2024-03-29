package com.fenxihui.console.model
{
	import com.fenxihui.console.utils.LocalProxy;
	import com.fenxihui.console.utils.Params;
	import com.fenxihui.console.utils.RemoteProxy;
	import com.fenxihui.console.view.Loading;
	import com.fenxihui.console.view.window.LoginWindow;
	import com.fenxihui.console.view.window.LostPasswdWindow;
	import com.fenxihui.console.view.window.MainWindow;
	import com.fenxihui.console.view.window.UserAddWindow;
	import com.fenxihui.library.component.Window;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	
	import mx.controls.Alert;
	import mx.formatters.Formatter;
	import mx.utils.ObjectUtil;
	
	import spark.components.WindowedApplication;

	public class User extends Base
	{
		public static function login(username:String,password:String,remember:Boolean=false,autoLogin:Boolean=false):void{
			var user:Object=Params.user;
			user.auth=null;
			user.username=username;
			user.password=password;
			Params.autoLogin=autoLogin;
			Params.isRemember=(remember || autoLogin);
			relogin(false);
		}
		public static function relogin(isLogined:Boolean=true):void{
			if(!Params.isLogined && isLogined){
				return;
			}
			trace('logining...');
			Params.statusChangeEvent=function(status:int):void{
				if(status==-1){
					login_failed(XML('<response>登录失败！网络连接失败</response>'));
					Params.statusChangeEvent=null;
				}
			};

			Loading.show(LoginWindow.loginWindow);
			var user:Object=Params.user;
			bind('User.Login.Succeed',login_succeed);
			bind('User.Login.Failed',login_failed);
			bind('User.Logout',Logout);
			var params:Object=(user.auth?{auth:user.auth}:{username:user.username,password:user.password});
			params.timezone=-(new Date()).timezoneOffset*60;
			trace(params.timezone);
			send('User.Login',params);
		}
		private static function login_succeed(request:XML):void{
			trace('Login succeed');
			Loading.hide();
			var user:Object=Params.user;
			if(Params.autoLogin)
				user.auth=request.user.@auth.toString();
			else
				user.auth=null;
			user.uid=uint(request.user.@uid.toString());
			user.username=request.user.@username.toString();
			//if(Params.autoLogin)
			//	user.password=request.user.@password.toString();
			user.email=request.user.@email.toString();

			user.minavatar=request.user.@minavatar.toString();
			user.midavatar=request.user.@midavatar.toString();
			user.maxavatar=request.user.@maxavatar.toString();

			user.prevlogtime=request.user.@prevlogtime.toString();
			user.logtime=request.user.@logtime.toString();

			var setting:Object=Params.setting;
			setting.servday=request.user.setting.@servday.toString();

			var profile:Object=Params.profile;
			profile.nickname=request.user.profile.@nickname.toString();
			profile.sex=uint(request.user.profile.@sex.toString())?true:false;
			profile.signature=request.user.profile.@signature.toString();

			if(!Params.isLogined){
				Params.isLogined=true;
				Params.saveUser();
				LoginWindow.remove();
				with(MainWindow.mainWindow){
					open(true);
					activate();
					restore();
					orderToFront();
					center();
				}
			}
			MainWindow.user=ObjectUtil.clone(user);
			MainWindow.profile=ObjectUtil.clone(profile);
			MainWindow.setting=ObjectUtil.clone(setting);
			Main.setIconMenu(true);
		}
		private static function login_failed(request:XML):void{
			trace('Login failed');
			Loading.hide();
			Params.isLogined=false;
			if(request.@type.length()){
				Params.user.auth=null;
				Params.user.password=null;
				Params.saveUser();
			}
			Main.setIconMenu(false);
			MainWindow.remove();
			ShowDialog(request.text(),false,function():void{
				with(LoginWindow.loginWindow){
					open(true);
					nativeWindow.visible = true;
					nativeWindow.activate();
					nativeWindow.restore();
					nativeWindow.orderToFront();
					center();
				}
			});
		}
		public static function Logout():void{
			trace(Params.isLogined);
			if(Params.isLogined==false)
				return;
			Params.isLogined=false;
			trace('logoutting...');
			if(RemoteProxy.connected){
				bind('User.Logout.Succeed',logout_succeed);
				bind('User.Logout.Failed',logout_failed);
				send('User.Logout',{time:(new Date()).valueOf()});
			}else{
				logout_succeed(null);
			}
		}
		private static function logout_succeed(request:XML):void{
			trace('Logout succeed');
			MainWindow.remove();
			Main.setIconMenu(false);
			with(LoginWindow.loginWindow){
				open(true);
				nativeWindow.visible = true;
				nativeWindow.activate();
				nativeWindow.restore();
				nativeWindow.orderToFront();
				center();
			}
		}
		private static function logout_failed(request:XML):void{
			trace('Logout failed');
		}
		public static function lostpasswd(username:String,email:String):void{
			Loading.show(LostPasswdWindow.lostPasswdWindow);
			bind('User.Lostpasswd.Succeed',lostpasswd_succeed);
			bind('User.Lostpasswd.Failed',lostpasswd_failed);
			send('User.Lostpasswd',{username:username,email:email});
		}
		private static function lostpasswd_succeed(request:XML):void{
			Loading.hide(LostPasswdWindow.lostPasswdWindow);
			LostPasswdWindow.remove();
			Params.user.username=request.@username.toString();
			ShowDialog(request.text(),true,function():void{
				with(LoginWindow.loginWindow){
					open(true);
					nativeWindow.visible = true;
					nativeWindow.activate();
					nativeWindow.restore();
					nativeWindow.orderToFront();
					center();
				}
			});
		}
		private static function lostpasswd_failed(request:XML):void{
			Loading.hide(LostPasswdWindow.lostPasswdWindow);
			ShowDialog(request.text(),false);
		}
		public static function profile(data:Object):void{
			bind('User.Profile.Succeed',profile_succeed);
			send('User.Profile',data);
		}
		
		private static function profile_succeed(request:XML):void
		{
			ShowDialog(request.text(),true);
		}
		public static function setting(data:Object):void{
			bind('User.Setting.Succeed',setting_succeed);
			send('User.Setting',data);
		}
		
		private static function setting_succeed(request:XML):void
		{
			ShowDialog(request.text(),true);
		}
	}
}
