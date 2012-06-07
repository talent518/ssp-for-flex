package com.fenxihui.desktop.view.component
{
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.display.Sprite;
	
	import spark.components.Label;
	
	[Style(name="borderWeight", inherit="no", type="uint",defaultValue="1")]
	[Style(name="borderColor" , type="uint", format="Color", inherit="no",defaultValue="0x999999" )]
	[Style(name="borderAlpha" , type="Number", format="Length", inherit="no",defaultValue="100")]
	[Style(name="borderVisible" , type="Boolean", format="Boolean", inherit="no",defaultValue="true")]
	
	public class ChamferAngleButton extends Label
	{
		private var _mask:Sprite;

		public function ChamferAngleButton()
		{
			super();
			_mask=new Sprite;
			addChild(_mask);
		}
		
		public var notActiveLeft:uint=0;
		public var leftTop:uint=0;
		public var leftBottom:uint=0;
		public var rightTop:uint=0;
		public var rightBottom:uint=0;
		public var notActiveRight:uint=0;

		private var _paddingLeft:uint;
		private var _paddingRight:uint;
		
		private var _actived:Boolean=false;
		
		public function get actived():Boolean{
			return _actived;
		}
		public function set actived(value:Boolean):void{
			if(_actived!=value){
				_actived=value;
				invalidateDisplayList();
			}
		}

		protected override function updateDisplayList(w:Number,h:Number):void{
			var _w:Number;
			if(_actived){
				_w=Math.max(leftTop,leftBottom)+Math.max(rightTop,rightBottom);
			}else{
				_w=notActiveRight;
			}

			var backgroundAlpha:Number=getStyle('backgroundAlpha');
			setStyle('backgroundAlpha',0);
			super.updateDisplayList(w-_w,h);
			setStyle('backgroundAlpha',backgroundAlpha);

			var commands:Vector.<int>=new Vector.<int>();   
			var datas:Vector.<Number>=new Vector.<Number>();
			var lineto:int=GraphicsPathCommand.LINE_TO; //命令：画线到
			var moveto:int=GraphicsPathCommand.MOVE_TO; //命令：移动到
			if(_actived){
				commands.push(moveto,lineto,lineto,lineto,lineto,lineto,lineto,lineto,lineto);
				datas.push(leftTop,0,
					w-rightTop,0,
					w,rightTop,
					w,h-rightBottom,
					w-rightBottom,h,
					leftBottom,h,
					0,h-leftBottom,
					0,leftTop,
					leftTop,0
				); //图形1 顺时针描述路径
			}else{
				commands.push(moveto,lineto,lineto,lineto,lineto);
				datas.push(leftTop,0,
					w-notActiveRight,0,
					w-notActiveRight,h,
					notActiveLeft,h,
					leftTop,0
				); //图形1 顺时针描述路径
			}
			graphics.clear();
			
			if(getStyle('borderVisible')){
				graphics.lineStyle(getStyle('borderWeight')*2,getStyle('borderColor'),getStyle('borderAlpha'));
			}
			
			graphics.beginFill(getStyle('backgroundColor'),backgroundAlpha);
			graphics.drawPath(commands,datas,GraphicsPathWinding.NON_ZERO);
			graphics.endFill();

			graphics.drawPath(commands,datas,GraphicsPathWinding.NON_ZERO);

			_mask.graphics.clear();
			_mask.graphics.beginFill(0x0);
			_mask.graphics.drawPath(commands,datas,GraphicsPathWinding.NON_ZERO);   
			_mask.graphics.endFill();
			mask = _mask;
		}
	}
}