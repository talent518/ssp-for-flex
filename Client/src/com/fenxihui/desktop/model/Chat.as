package com.fenxihui.desktop.model
{
	public class Chat
	{
		public static function send(uid:uint,message:XML):void{
			Base.bind('Chat.Send.Succeed',send_succeed);
			Base.bind('Chat.Send.Failed',send_failed);
			message.setName('message');
			Base.send('Chat.Send',{uid:uid},{message:message});
		}
		public static function send_succeed(request:XML):void{
		}
		public static function send_failed(request:XML):void{
		}
	}
}