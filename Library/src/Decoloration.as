package{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	public function Decoloration(display:DisplayObject):void
	{
		var red:Number = 0.3086;
		var green:Number = 0.694;
		var blue:Number = 0.0820; //这三个值是提供标准的黑白效果
		var unColorFilter:ColorMatrixFilter=new ColorMatrixFilter([
			red, green, blue, 0, 0,
			red, green, blue, 0, 0,
			red, green, blue, 0, 0,
			0, 0, 0, 1, 0
		]);
		//var bitmap:Bitmap=new icon;
		display.filters=[unColorFilter];
		//img.source=bitmap;
	}
}