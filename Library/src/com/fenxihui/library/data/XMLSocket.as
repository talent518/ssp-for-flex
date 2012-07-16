package com.fenxihui.library.data
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.osmf.events.TimeEvent;

	public class XMLSocket {
		
		public static const CONNECT:String='connect';
		public static const CLOSE:String='close';
		public static const DATA:String='data';
		public static const ERROR:String='error';
		public static const PROGRESS:String='progress';
		public static const RETRY:String='retry';
		
		private var _host:String;
		private var _port:uint;
		private var socket:Socket;
		
		private var connectTime:Number;
		private var connectDelay:Number;
		
		private var delay:Number;
		public var retrys:Number=0;
		private var _retrys:Number=0;
		
		private var events:Array;
		
		private var recvBuffer:ByteArray=new ByteArray(),recvLength:int=0,recvedLength:int=0;
		
		public function get host():String{
			return _host;
		}
		
		public function get port():uint{
			return _port;
		}
		
		public function XMLSocket(host:String="localhost",port:uint=8080,delay:uint=1,retryTimes:uint=30) {
			_host=host;
			_port=port;

			socket = new Socket();
			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(Event.CONNECT, connectHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, dataHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);

			events=new Array();

			this.delay=(delay>0?delay:1)*100;
			retrys=retryTimes;
		}
		
		public function connect():void{
			if(connected){
				return;
			}
			if(retrys>0 && _retrys==retrys){
				trigger(RETRY,[{}]);
			}
			connectTime=new Date().time;
			socket.connect(_host,_port);
			_retrys++;
		}
		
		public function close():void{
			socket.close();
		}
		
		public function get connected():Boolean{
			return socket.connected;
		}

		public function bind(type:String,func:Function):void{
			events[type]=func;
		}
		public function trigger(type:String,args:Array):void{
			if(typeof(events[type])=='function')
				events[type].apply(null,args);
			else
				trace(args);
		}

		public function send(xml:XML):void {
			var prettyIndent:int=XML.prettyIndent,prettyPrinting:Boolean=XML.prettyPrinting;
			XML.prettyIndent=0;
			XML.prettyPrinting=true;
			var bytes:ByteArray=new ByteArray();
			var strXML:String=xml.toXMLString();
			if(strXML.length<=0){
				trace('strXML.length',strXML.length);
				return;
			}
			bytes.writeInt(strXML.length);
			bytes.writeUTFBytes(strXML);
			socket.writeBytes(bytes);
			socket.flush();
			bytes=null;
			XML.prettyIndent=prettyIndent;
			XML.prettyPrinting=prettyPrinting;
		}
		
		public function clearBuffer():void{
			recvBuffer.clear();
			recvedLength=0;
			recvLength=0;
		}
		
		private function closeHandler(event:Event):void {
			//trace("closeHandler: " + event);
			trigger(CLOSE,[event]);
			setTimeout(function():void{
				connect();
			},0);
		}
		
		private function connectHandler(event:Event):void {
			//trace("connectHandler: " + event);
			connectDelay=(new Date().time)-connectTime;
			trace('Connect delay',connectDelay+'ms',(connectDelay/1000).toFixed(3)+'s');
			_retrys=0;
			trigger(CONNECT,[event]);
		}
		
		private function dataHandler(event:ProgressEvent):void {
			//循环读取数据，socket的bytesAvailable对象存放了服务器传来的所有数据
			while(socket.bytesAvailable)
			{
				if(recvedLength==0){
					if(socket.bytesAvailable<4){
						return;
					}
					recvLength=socket.readInt();
					if(recvLength<=0 || recvLength==0x47455420){
						recvLength=0;
						return;
					}
					socket.readBytes(recvBuffer,recvedLength,socket.bytesAvailable>recvLength?recvLength:socket.bytesAvailable);
				}else{
					socket.readBytes(recvBuffer,recvedLength,socket.bytesAvailable>recvLength-recvedLength?recvLength-recvedLength:socket.bytesAvailable);
				}
				recvedLength=recvBuffer.length;
				if(recvLength==recvedLength){
					trigger(DATA,[XMLList(recvBuffer.readUTFBytes(recvLength))]);
					recvBuffer.clear();
					recvedLength=0;
					recvLength=0;
				}else{
					trace('recvBuffer:',recvBuffer.toString());
				}
			}
			if(recvedLength>0){
				trigger(PROGRESS,[event]);
			}
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			//trace("ioErrorHandler: " + event);
			trigger(ERROR,[event]);
			setTimeout(function():void{
				connect();
			},delay);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
			trigger(ERROR,[event]);
			setTimeout(function():void{
				connect();
			},delay);
		}
	}
}