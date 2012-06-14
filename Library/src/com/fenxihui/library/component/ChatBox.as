package com.fenxihui.library.component
{
	import com.riaidea.text.RichTextField;
	
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	import mx.managers.FocusManager;
	import mx.managers.IFocusManagerComponent;
	
	public class ChatBox extends UIComponent implements IFocusManagerComponent
	{
		private var _rtf:RichTextField;
		private var _scrollBar:UIScrollBar;
		
		public function get contentLength():int{
			return textField.length;
		}
		
		public function get lineHeight():int{
			return _rtf.lineHeight;
		}
		public function set lineHeight(value:int):void{
			_rtf.lineHeight=value;
		}
		
		public function set autoScroll(value:Boolean):void{
			_rtf.autoScroll=value;
		}
		
		public function set placeholderMarginH(value:int):void{
			_rtf.placeholderMarginH=value;
		}
		public function set placeholderMarginV(value:int):void{
			_rtf.placeholderMarginV=value;
		}
		
		public function get textField():TextField{
			return _rtf.textfield;
		}
		
		public function get defaultTextFormat():TextFormat{
			return _rtf.defaultTextFormat;
		}
		
		public function set defaultTextFormat(format:TextFormat):void{
			_rtf.defaultTextFormat=format;
		}
		
		public function get caretIndex():int{
			return _rtf.caretIndex;
		}		
		public function set caretIndex(index:int):void{
			_rtf.caretIndex=index;
		}
		
		public function get type():String{
			return _rtf.type;
		}		
		public function set type(value:String):void{
			_rtf.type=value;
			if(_rtf.type==RichTextField.INPUT){
				focusEnabled=true;
				tabEnabled=true;
				tabChildren=true;
				mouseFocusEnabled=true;
			}
		}
		
		public function ChatBox(){
			super();
			_rtf=new RichTextField;
			_rtf.html=true;
			_rtf.placeholderColor=0xffffff;
			_rtf.placeholderMarginH=2;
			_rtf.placeholderMarginV=0;
			addChild(_rtf);
			_scrollBar=new UIScrollBar;
			_scrollBar.scrollTarget=_rtf.textfield;
			_scrollBar.percentHeight=100;
			addChild(_scrollBar);
		}
		
		override protected function focusInHandler(event:FocusEvent):void{
			super.focusInHandler(event);
			if(_rtf.type==RichTextField.INPUT){
				stage.focus=_rtf.textfield;
				drawFocus(true);
			}
		}

		override protected function updateDisplayList(w:Number,h:Number):void{
			super.updateDisplayList(w,h);
			_scrollBar.width=15;
			_scrollBar.x=w-_scrollBar.width;
			_scrollBar.y=0;
			_scrollBar.height=h;
			_scrollBar.update();

			_rtf.x=_rtf.y=0;
			_rtf.width=w-_scrollBar.width;
			_rtf.height=h;
		}
		
		public function append(newText:String, newSprites:Array = null, autoWordWrap:Boolean = false, format:TextFormat = null):void{
			_rtf.append(newText,newSprites,autoWordWrap,format);
		}
		
		public function insertSprite(newSprite:Object, index:int = -1, autoRender:Boolean = true, cache:Boolean = false):void{
			_rtf.insertSprite(newSprite,index,autoRender,cache);
		}
		
		public function isSpriteAt(index:int):Boolean{
			return _rtf.isSpriteAt(index);
		}
		
		public function exportXML():XML{
			return _rtf.exportXML();
		}
		public function importXML(data:XML):void{
			_rtf.importXML(data);
		}
		
		public function clear():void{
			_rtf.clear();
		}
	}
}