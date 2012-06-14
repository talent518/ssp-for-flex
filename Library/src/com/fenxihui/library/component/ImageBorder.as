package com.fenxihui.library.component
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import mx.controls.Image;
	import mx.controls.SWFLoader;
	import mx.events.ResizeEvent;
	import mx.managers.PopUpManager;
	
	[Style(name="cornerRadius", type="uint", inherit="no",theme="halo, spark")]
	[Style(name="borderWeight", type="uint", inherit="no",theme="halo, spark")]
	[Style(name="borderColor", type="uint", format="Color", inherit="no",defaultValue="0x0",theme="halo, spark")]
	[Style(name="borderAlpha", type="Number", format="Length", inherit="no",defaultValue="100",theme="halo, spark")]
	[Style(name="borderVisible", type="Boolean", inherit="no",theme="halo, spark")]

	public class ImageBorder extends Image
	{
		private var _mask:Sprite;
		private var tryTimes:int=0;
		
		[Embed(source="assets/default.png")]
		private static var defImage:Class;

		public function ImageBorder()
		{
			autoLoad=true;
			super();
			
			_mask=new Sprite;
			addChild(_mask);

			addEventListener(ResizeEvent.RESIZE,resizeHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
			addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
		}
		
		protected function errorHandler(e:*):void{
			if(tryTimes<3){
				tryTimes++;
				if(source is String){
					load(source);
				}else{
					source=defImage;
				}
			}
		}
		
		protected function resizeHandler(e:ResizeEvent):void
		{
			var w:Number = e.target.width;
			var h:Number = e.target.height;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x0);
			_mask.graphics.drawRoundRect(0, 0,w,h,getStyle('cornerRadius'), getStyle('cornerRadius'));
			_mask.graphics.endFill();
			mask = _mask;
		}
	}
}