package com.riaidea.text
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;
	
	import mx.controls.SWFLoader;
	import mx.events.ResizeEvent;
	
	import spark.components.Label;
	
	public class ImageRenderer extends Sprite
	{
		public var rtf:RichTextField;
		private var loader:SWFLoader=new SWFLoader;
		private var _source:String;
		
		[Embed(source='assets/image.png')]
		[Bindable]
		private static var DefaultImage:Class;
		
		private var defImg:Bitmap;
		private var tf:TextField;
		
		private var timer:Timer;
		
		private var srcWidth:int,srcHeight:int;

		public function ImageRenderer(){
			loader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			loader.addEventListener(Event.COMPLETE,completeHandler);
			defImg=new DefaultImage;
			trace(defImg.width,defImg.height);
			addChild(defImg);

			var format:TextFormat=new TextFormat;
			format.align=TextFormatAlign.CENTER;
			format.size=13;
			format.color=0xfe6262;
			format.bold=true;
			tf=new TextField;
			tf.defaultTextFormat=format;
			tf.text='100%';
			tf.selectable=false;
			tf.multiline=false;

			var metric:TextLineMetrics=tf.getLineMetrics(0);

			tf.width=width;
			tf.height=metric.height+metric.descent;
			tf.y=(defImg.height-tf.height)/2;
			this.addChild(tf);
		}
		
		private function progressHandler(e:ProgressEvent):void{
			tf.text=int(e.bytesLoaded/e.bytesTotal*100)+'%';
			trace(tf.text);
		}
		
		private function completeHandler(e:Event):void{
			removeChild(defImg);
			srcWidth=loader.content.width;
			srcHeight=loader.content.height;
			addChild(loader.content);
			if(rtf){
				rtf.addEventListener(ResizeEvent.RESIZE,resizeHandler);
				resizeHandler(null);
			}
		}
		private function resizeHandler(e:ResizeEvent):void{
			var format:TextFormat=rtf.textfield.getTextFormat(int(name),int(name)+1);
			var W:int=rtf.width-int(format.leftMargin)-int(format.rightMargin)-4,H:int=rtf.height*0.9;
			var w:int=srcWidth,h:int=srcHeight;
			if(!format.rightMargin){
				trace(W);
				W=W-2;
			}
			if(w>W){
				h*=W/w;
				w=W;
			}
			if(h>H){
				w*=H/h;
				h=H;
			}
			trace('srcWidth:'+srcWidth+',srcHeight:'+srcHeight+',W:'+W+',H:'+H+',w:'+w+',h:'+h);
			loader.content.width=w;
			loader.content.height=h;
			rtf.setPlaceholderSize(this,parseInt(name));
		}

		public function get source():String
		{
			return _source;
		}

		public function set source(value:String):void
		{
			_source = value;
			loader.load(value);
		}
	}
}