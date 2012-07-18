package com.fenxihui.console.utils
{
	import com.fenxihui.console.model.User;
	import com.fenxihui.console.view.Loading;
	import com.fenxihui.library.data.XMLSocket;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.formatters.DateFormatter;
	
	public class RemoteProxy
	{
		private static var _instance:RemoteProxy=new RemoteProxy;
		
		private var timerPing:Timer;
		private var timers:Array;
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
			
			timerPing=new Timer(30000);
			timerPing.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
				socket.send(<request type="Connect.Ping"/>);
			});
			timers=new Array();
			sendQueues=new Array();
			events=new Array();

			socket=new XMLSocket(Params.SERVER_HOST,Params.SERVER_PORT,Params.SOCKET_DELAY,Params.SOCKET_TRY);
			socket.bind(XMLSocket.DATA,Receive);
			socket.bind(XMLSocket.CONNECT,function(e:Object):void{
				trace('Connected',sendQueues.length);
				timerPing.reset();
				timerPing.start();

				var chars:String='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',i:uint;
				for(i=0;i<128;i++)
					sendKey+=chars.charAt(Math.random()*chars.length);
				socket.send(XML('<request type="Connect.Key">'+sendKey+'</request>'));

				Params.statusChangeEvent(0);
			});
			socket.bind(XMLSocket.CLOSE,function(e:Object):void{
				receiveKey=sendKey='';
				Params.statusChangeEvent(0);
				timerPing.reset();
			});
			socket.bind(XMLSocket.ERROR,function(e:Object):void{
				Params.statusChangeEvent(0);
				timerPing.reset();
			});
			socket.bind(XMLSocket.PROGRESS,function(e:Object):void{
				trace('Progressing');
			});
			socket.bind(XMLSocket.RETRY,function(e:Object):void{
				sendQueues=new Array();
				Params.statusChangeEvent(-1);
			});
			socket.connect();
		}
		
		private function Receive(xmlist:XMLList):void
		{
			var type:String,_xml:XML;
			for each(var xml:XML in xmlist){
				switch(xml.@type.toString()){
					case 'Connect.Key':
						receiveKey=xml.text();
						
						User.relogin();
						while(sendQueues.length>0)
							socket.send(XML('<request type="Connect.Data">'+Crypter.encode(sendQueues.shift().toXMLString(),sendKey)+'</request>'));
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
					case 'Connect.Ping':
						var df:DateFormatter=new DateFormatter;
						df.formatString='HH:NN:SS';
						trace('Ping Time',df.format(new Date()));
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
			if(typeof(_instance.events[type])=='function'){
				_instance.events[type].call(null,xml);
				
				var _type:String=type.substring(0,type.lastIndexOf('.'));
				if(_instance.timers[_type]){
					(_instance.timers[_type] as Timer).reset();
					delete _instance.timers[_type];
				}
			}else
				trace(type,xml.toXMLString());
		}
		public static function send(type:String,params:Object,moreArg:Object=null):void{
			var data:Object={"@type":type,"params":params};
			for(var k:String in moreArg)
				data[k]=moreArg[k];
			var xml:XML=ObjectToXML(data,"request");
			if(!_instance.socket.connected){
				_instance.socket.connect();
			}
			if(_instance.socket.connected){
				_instance.timerPing.reset();
				_instance.timerPing.start();
				_instance.socket.send(XML('<request type="Connect.Data">'+Crypter.encode(xml.toXMLString(),_instance.sendKey)+'</request>'));
				if(!_instance.timers[type] && _instance.events[type+'.Failed']){
					var timerTimeOut:Timer=new Timer(1000,10);
					timerTimeOut.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void{
						_instance.socket.clearBuffer();
						var xml:XML=<response>服务器没有响应！请稍后重试！</response>;
						xml.@type=type+'.Failed';
						trigger(type+'.Failed',xml);
					});
					timerTimeOut.start();
					_instance.timers[type]=timerTimeOut;
				}
			}else{
				_instance.sendQueues.push(xml);
				_instance.socket.connect();
			}
		}
	}
}