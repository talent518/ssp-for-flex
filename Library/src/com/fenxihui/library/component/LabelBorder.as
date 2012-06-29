package com.fenxihui.library.component
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import mx.styles.*;
	
	import spark.components.Label;
	
	[Style(name="cornerRadius", type="uint", inherit="no",defaultValue=5)]
	[Style(name="borderWeight", type="uint", inherit="no",defaultValue=1)]
	[Style(name="borderColor", type="uint", format="Color", inherit="no",defaultValue=0x960003)]
	[Style(name="borderAlpha", type="Number", format="Length", inherit="no",defaultValue=100)]
	[Style(name="borderVisible", type="Boolean", inherit="no",defaultValue=true)]
	
	[DefaultProperty("borderColor",0x960003)]
	[DefaultProperty("backgroundColor",0xb60003)]
	[DefaultProperty("backgroundAlpha",1.0)]
	
	public class LabelBorder extends Label
	{
		private var _mask:Sprite; 
		private var _backgroundAlpha:Number;

		public function LabelBorder()
		{
			super();
			_mask=new Sprite;
			addChild(_mask);
		}
		
		override public function set enabled(value:Boolean):void{
			super.enabled=value;
			mouseEnabled=value;
			mouseFocusEnabled=value;
			mouseChildren=value;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void{
			_backgroundAlpha=getStyle('backgroundAlpha');
			setStyle('backgroundAlpha',0);
			super.updateDisplayList(w,h);
			setStyle('backgroundAlpha',_backgroundAlpha);
			
			var cornerRadius:Number=getStyle('cornerRadius')*2;
			
			graphics.clear();
			graphics.beginFill(getStyle('backgroundColor'),_backgroundAlpha);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			
			if(getStyle('borderVisible')){
				graphics.lineStyle(getStyle('borderWeight')*2,getStyle('borderColor'),getStyle('borderAlpha'));
				graphics.drawRoundRect(0,0,w,h,cornerRadius,cornerRadius);
			}
			
			if(cornerRadius>0){
				_mask.graphics.beginFill(0x0);
				_mask.graphics.drawRoundRect(0, 0,w,h,cornerRadius, cornerRadius);
				_mask.graphics.endFill();
				mask = _mask;
			}
		}
	}
}