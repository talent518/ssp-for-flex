package com.riaidea.text
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import mx.graphics.codec.JPEGEncoder;
	
	public class UploadBitmap
	{
		private var param:String;
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
		
		private var callback:Function;
		public function UploadBitmap(url:String,method:String,data:String)
		{
			param=data;
			urlRequest=new URLRequest(url);
			urlRequest.method=method;
			urlLoader=new URLLoader;
			urlLoader.dataFormat=URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(Event.OPEN, openHandler);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function completeHandler(event:Event):void {
			trace("UploadBitmap completeHandler: " + urlLoader.data);
			var xml:XML=XML(urlLoader.data);
			if(xml){
				if(parseInt(xml.@status.toString())){
					callback(xml.text());
					callback=null;
				}else{
					ShowDialog(xml.text(),false);
				}
			}else{
				ShowDialog('上传失败！',false);
			}
		}
		
		private function openHandler(event:Event):void {
			trace("UploadBitmap openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			trace("UploadBitmap progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("UploadBitmap securityErrorHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			trace("UploadBitmap httpStatusHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("UploadBitmap ioErrorHandler: " + event);
		}

		public function upload(bitmap:BitmapData,callback:Function):void{
			this.callback=callback;
			var picture:String=Base64Encode(new JPEGEncoder(100).encode(bitmap)).replace(new RegExp("[\r\n]+",'ig'),'');
			trace('UploadBitmap:',picture);
			var data:URLVariables = new URLVariables(param);
			data.picture=picture;
			urlRequest.data=data;
			urlLoader.load(urlRequest);
		}
	}
}