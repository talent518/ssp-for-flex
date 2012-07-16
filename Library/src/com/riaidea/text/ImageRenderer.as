package com.riaidea.text
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.controls.SWFLoader;
	
	public class ImageRenderer extends Bitmap
	{
		public var rtf:RichTextField;
		private var loader:SWFLoader=new SWFLoader;
		private var _source:String;
		public function ImageRenderer(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
			loader.addEventListener(Event.COMPLETE,completeHandler);
		}
		
		private function completeHandler(e:Event):void{
			var bitmap:Bitmap=(loader.content as Bitmap);
			bitmapData=bitmap.bitmapData.clone();
			if(rtf){
				rtf.setPlaceholderSize(this,parseInt(name));
				trace('setPlaceholderSize',width,height,name);
			}
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