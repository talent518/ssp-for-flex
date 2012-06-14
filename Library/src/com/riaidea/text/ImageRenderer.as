package com.riaidea.text
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class ImageRenderer extends Bitmap
	{
		public var source:Object;
		public function ImageRenderer(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}