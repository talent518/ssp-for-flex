package com.fenxihui.desktop.utils
{
	import com.fenxihui.desktop.model.User;
	import com.fenxihui.desktop.view.Loading;
	import com.fenxihui.library.data.XMLSocket;
	
	public class RemoteProxy
	{
		public static const LOGIN:String='login';
		public static const INIT:String='init';
		public static const SETTING:String='setting';
		public static const REMIND:String='remind';
		public static const CHAT:String='chat';
		
		private static var _instance:RemoteProxy=new RemoteProxy;
		
		private var sendQueues:Array;
		private var events:Array;
		private var socket:XMLSocket;
		
		private var receiveKey:String='',sendKey:String='';

		public function RemoteProxy()
		{
			if(_instance){
				throw new Error("RemoteProxy can only be accessed through RemoteProxy.getInstance()");
				return;
			}
			sendQueues=new Array();
			events=new Array();

			socket=new XMLSocket(Params.SERVER_HOST,Params.SERVER_PORT,Params.SOCKET_DELAY);
			socket.bind(XMLSocket.DATA,Receive);
			socket.bind(XMLSocket.CONNECT,function(e:Object):void{
				trace('Connected',sendQueues.length);

				var chars:String='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',i:uint;
				for(i=0;i<128;i++)
					sendKey+=chars.charAt(Math.random()*chars.length);
				socket.send(XML('<request type="Connect.Key">'+sendKey+'</request>'));

				Params.statusChangeEvent(0);
				User.relogin();
				while(sendQueues.length>0)
					socket.send(XML('<request type="Connect.Data">'+Crypter.encode(sendQueues.shift().toXMLString(),sendKey)+'</request>'));
			});
			socket.bind(XMLSocket.CLOSE,function(e:Object):void{
				receiveKey=sendKey='';
				trace('Closed');
				Params.statusChangeEvent(0);
			});
			socket.bind(XMLSocket.ERROR,function(e:Object):void{
				trace('Errored');
				Params.statusChangeEvent(0);
			});
			socket.bind(XMLSocket.PROGRESS,function(e:Object):void{
				trace('Progressing');
			});
			socket.bind(XMLSocket.RETRY,function(e:Object):void{
				trace('Retried');
				sendQueues=new Array();
				Params.statusChangeEvent(-1);
			});
			socket.connect();
		}
		
		private function Receive(xmlist:XMLList):void
		{
			var type:String,_xml:XML;
			trace(xmlist);
			for each(var xml:XML in xmlist){
				switch(xml.@type.toString()){
					case 'Connect.Key':
						receiveKey=xml.text();
						break;
					case 'Connect.Data':
						if(receiveKey.length>0){
							_xml=XML(Crypter.decode(xml.text(),receiveKey));
							if(_xml!=null)
								trigger(_xml.@type.toString(),_xml);
						}else{
							trace('Connect Key is empty.');
						}
						break;
					default:
						trace('Received:',xml.toXMLString());
				}
			}
		}
		public static function get connected():Boolean{
			return _instance.socket.connected;
		}
		public static function bind(type:String,func:Function):void{
			_instance.events[type]=func;
		}
		public static function trigger(type:String,xml:XML):void{
			if(typeof(_instance.events[type])=='function')
				_instance.events[type].call(null,xml);
			else
				trace(type,xml);
		}
		public static function send(type:String,params:Object,moreArg:Object=null):void{
			var data:Object={"@type":type,"params":params};
			for(var k:String in moreArg)
				data[k]=moreArg[k];
			var xml:XML=ObjectToXML(data,"request");
			if(_instance.socket.connected){
				_instance.socket.send(XML('<request type="Connect.Data">'+Crypter.encode(xml.toXMLString(),_instance.sendKey)+'</request>'));
			}else{
				_instance.sendQueues.push(xml);
				_instance.socket.connect();
			}
		}
	}
}