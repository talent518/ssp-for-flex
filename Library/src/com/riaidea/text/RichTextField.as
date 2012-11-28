/**
 * RichTextField
 * @author Alex.li - www.riaidea.com
 * @homepage http://code.google.com/p/richtextfield/
 */

package com.riaidea.text
{
	
	import com.fenxihui.library.component.ImageBorder;
	import com.riaidea.text.plugins.IRTFPlugin;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.ClipboardTransferMode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.ui.ContextMenu;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Image;
	import mx.controls.SWFLoader;
	import mx.core.Container;
	import mx.core.UIComponent;
	
	
	/**
	 * <p>RichTextField是一个基于TextField的图文混编的组件。</p>
	 * <p>众所周知，TextField可以用html的方式来插入图片，但无法有效控制图片的位置且不能实时编辑。RichTextField可以满足这方面的需求。</p>
	 * <p>RichTextField有如下特性：
	 * <br><ul>
	 * <li>在文本末尾追加文本和显示元素。</li>
	 * <li>在文本任何位置替换(删除)文本和显示元素。</li>
	 * <li>支持HTML文本和显示元素的混排。</li>
	 * <li>可动态设置RichTextField的尺寸大小。</li>
	 * <li>可导入和导出XML格式的文本框内容。</li>
	 * </ul></p>
	 * 
	 * 
	 * @example 下面的例子演示了RichTextField基本使用方法：
	 * <listing>
	 var rtf:RichTextField = new RichTextField();			
	 rtf.x = 10;
	 rtf.y = 10;
	 addChild(rtf);
	 
	 //设置rtf的尺寸大小
	 rtf.setSize(500, 400);
	 //设置rtf的类型
	 rtf.type = RichTextField.INPUT;
	 //设置rtf的默认文本格式
	 rtf.defaultTextFormat = new TextFormat("Arial", 12, 0x000000);
	 
	 //追加文本和显示元素到rtf中
	 rtf.append("Hello, World!", [ { index:5, src:SpriteClassA }, { index:13, src:SpriteClassB } ]);
	 //替换指定位置的内容为新的文本和显示元素
	 rtf.replace(8, 13, "世界", [ { src:SpriteClassC } ]);</listing>
	 * 
	 * 
	 * @example 下面是一个RichTextField的内容的XML例子，你可以使用importXML()来导入具有这样格式的XML内容，或用exportXML()导出这样的XML内容方便保存和传输：
	 * <listing>
	 &lt;rtf&gt;
	 &lt;text&gt;Hello, World!&lt;/text&gt;
	 &lt;sprites&gt;
	 &lt;sprite src="SpriteClassA" index="5"/&gt;
	 &lt;sprite src="SpriteClassB" index="13"/&gt;
	 &lt;/sprites&gt;
	 &lt;/rtf&gt;</listing>
	 */
	public class RichTextField extends UIComponent
	{
		private var _textRenderer:TextRenderer;		
		private var _spriteRenderer:SpriteRenderer;	
		private var _formatCalculator:TextField;
		private var _plugins:Array;
		
		private var _placeholder:String;
		private var _placeholderColor:uint;
		private var _placeholderMarginH:int;	
		private var _placeholderMarginV:int;
		
		private var _isHtml:Boolean=false;
		/**
		 * 指示文本字段的显示元素的行高（最大高度）。
		 * @default 0
		 */
		public var lineHeight:int=0;
		/**
		 * 一个布尔值，指示当追加内容到RichTextField后是否自动滚动到最底部。
		 * @default true
		 */
		public var autoScroll:Boolean=false;		
		/**
		 * 用于指定动态类型的RichTextField。
		 */
		public static const DYNAMIC:String = "dynamic";
		/**
		 * 用于指定输入类型的RichTextField。
		 */
		public static const INPUT:String = "input";		
		/**
		 * RichTextField的版本号。
		 */
		public static const version:String = "2.0.2";
		
		/**
		 * RichTextField粘贴位图处理函数
		 * @param byteArray 为ByteArray类型
		 */
		public var uploadBitmap:UploadBitmap;
		
		/**
		 * 构造函数。
		 */
		public function RichTextField()
		{
			super();
			
			//text renderer
			_textRenderer = new TextRenderer();
			addChild(_textRenderer);
			
			//sprite renderer
			_spriteRenderer = new SpriteRenderer(this);
			addChild(_spriteRenderer.container);
			
			type = DYNAMIC;
			
			//default placeholder
			_placeholder = String.fromCharCode(12288);
			_placeholderColor = 0x000000;
			_placeholderMarginH = 2;
			_placeholderMarginV = 0;
			
			//an invisible textfield for calculating placeholder's textFormat
			_formatCalculator = new TextField();			
			_formatCalculator.text = _placeholder;
			
			//make sure that can't input placeholder
			_textRenderer.restrict = "^" + _placeholder;
			
			addEventListener(KeyboardEvent.KEY_DOWN,function(e:KeyboardEvent):void{
				if(e.ctrlKey){
					if(type==INPUT && e.keyCode==Keyboard.X){
						e.preventDefault();
						menuItemHandler('cut');
					}
					if(e.keyCode==Keyboard.C){
						e.preventDefault();
						menuItemHandler('copy');
					}
					if(type==INPUT && e.keyCode==Keyboard.V){
						e.preventDefault();
						menuItemHandler('parse');
					}
					if(e.keyCode==Keyboard.A){
						e.preventDefault();
						menuItemHandler('all');
					}
				}
			});
		}
		private function setContextMenu(isInput:Boolean):void{
			//上下文菜单
			var menu:ContextMenu=new ContextMenu;
			
			var item:NativeMenuItem;
			
			if(isInput){
				item=new NativeMenuItem("剪切");
				item.name="cut";
				item.keyEquivalent='x';
				item.keyEquivalentModifiers=[Keyboard.CONTROL];
				menu.addItem(item);
			}
			
			item=new NativeMenuItem("复制");
			item.name="copy";
			item.keyEquivalent='c';
			item.keyEquivalentModifiers=[Keyboard.CONTROL];
			menu.addItem(item);

			if(isInput){
				item=new NativeMenuItem("粘贴");
				item.name="parse";
				item.keyEquivalent='v';
				item.keyEquivalentModifiers=[Keyboard.CONTROL];
				menu.addItem(item);
			}
			
			item=new NativeMenuItem("",true);
			menu.addItem(item);
			
			if(isInput){
				item=new NativeMenuItem("删除");
				item.name="delete";
				item.keyEquivalent='d';
				item.keyEquivalentModifiers=[Keyboard.CONTROL];
				menu.addItem(item);
			}
			
			item=new NativeMenuItem("全选");
			item.name="all";
			item.keyEquivalent='a';
			item.keyEquivalentModifiers=[Keyboard.CONTROL];
			menu.addItem(item);
			
			menu.addEventListener(Event.SELECT,function(e:Event):void{
				menuItemHandler(e.target.name);
			});
			_textRenderer.contextMenu=menu;
			_spriteRenderer.container.contextMenu=menu;
		}
		private function copyToClipboard():void{
			if(_textRenderer.selectionEndIndex<=_textRenderer.selectionBeginIndex){
				return;
			}
			var rtf:XML=exportXML(_textRenderer.selectionBeginIndex,_textRenderer.selectionEndIndex);
			
			var cb:Clipboard=Clipboard.generalClipboard;
			cb.clear();
			if(_isHtml){
				cb.setData(ClipboardFormats.HTML_FORMAT,rtf.htmlText);
			}else{
				cb.setData(ClipboardFormats.TEXT_FORMAT,rtf.text);
			}
			cb.setData('xml:rtf',rtf);
			trace('rtf:',rtf.toXMLString());
		}
		private function menuItemHandler(key:String):void{
			trace('剪切板操作：',key);
			switch(key){
				case 'cut':
					copyToClipboard();
					_textRenderer.replaceSelectedText("");
					break;
				case 'copy':
					copyToClipboard();
					break;
				case 'parse':
					var cb:Clipboard=Clipboard.generalClipboard;

					trace('ClipBoardFormat:',cb.formats.join(','));

					if(cb.hasFormat('xml:rtf')){
						var rtf:XML=cb.getData('xml:rtf') as XML;
						trace('xml:rtf',rtf.toXMLString());
						importXML(rtf,_textRenderer.selectionBeginIndex,_textRenderer.selectionEndIndex);
						break;
					}
					if(uploadBitmap!=null && cb.hasFormat(ClipboardFormats.BITMAP_FORMAT)){
						uploadBitmap.upload(cb.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData,function(picfile:String):void{
							insertSprite(picfile,_textRenderer.caretIndex);
						});
						break;
					}
					if(cb.hasFormat(ClipboardFormats.HTML_FORMAT)){
						var html:String=cb.getData(ClipboardFormats.HTML_FORMAT) as String;
						trace(ClipboardFormats.HTML_FORMAT,html);
						if(replaceHtml(_textRenderer.selectionBeginIndex,_textRenderer.selectionEndIndex,html)){
							break;
						}
					}
					if(cb.hasFormat(ClipboardFormats.TEXT_FORMAT)){
						var text:String=cb.getData(ClipboardFormats.TEXT_FORMAT) as String;
						trace(ClipboardFormats.TEXT_FORMAT,text);
						replaceText(_textRenderer.selectionBeginIndex,_textRenderer.selectionEndIndex,text);
					}
					break;
				case 'delete':
					_textRenderer.replaceSelectedText("");
					break;
				case 'all':
					_textRenderer.setSelection(0,_textRenderer.length);
					break;
			}
		}
		public function getHtml(beginIndex:int,endIndex:int):String{
			if(beginIndex>=endIndex){
				return "";
			}
			var tf:TextField=new TextField;
			tf.multiline=true;
			tf.htmlText=_textRenderer.htmlText;
			if(endIndex<_textRenderer.length){
				tf.replaceText(endIndex,_textRenderer.length,"");
			}
			if(beginIndex>0){
				tf.replaceText(0,beginIndex,"");
			}
			var html:String=tf.htmlText.split(_placeholder).join("");
			trace('getHtml:',html);
			return html;
		}
		private function isNewlineChar(str:String,i:int):Boolean{
			var code:int=str.charCodeAt(i);
			return code==13 || code==10;
		}
		public function replaceHtml(beginIndex:int,endIndex:int,html:String,newSprites:Array = null):Boolean{
			var tf:TextField=new TextField;
			tf.multiline=true;
			tf.htmlText=html;
			if(!tf.htmlText || !tf.text){
				return false;
			}
			var lines:int=0,i:int=0,j:int;
			while((j=tf.htmlText.indexOf('</P>',i))!=-1){
				lines++;
				i=j+4;
			}
			var rText:String=(lines<tf.numLines?tf.text.substr(0,tf.text.length-1):tf.text);
			trace('html:',rText,tf.htmlText);
			
			var isNewLineBegin:Boolean=isNewlineChar(_textRenderer.text,beginIndex-1);
			
			var isNewLineEnd:Boolean=isNewlineChar(_textRenderer.text,endIndex+(beginIndex==endIndex?0:1));

			var htmlText:String=getHtml(0,beginIndex-(isNewLineBegin?1:0))+tf.htmlText+getHtml(endIndex+(isNewLineEnd?1:0),_textRenderer.length);
			trace(htmlText);
			
			trace('replace before:',isNewLineBegin,isNewLineEnd,_textRenderer.text);

			replaceText(beginIndex,endIndex,rText,newSprites);

			var sprites:Array=_spriteRenderer.export();
			for each(var s:* in sprites){
				trace('sprite:',s.index,s.src);
			}

			var beginSpriteNum:int=0;
			for(i=0;i<=beginIndex;i++){
				if(isSpriteAt(i)){
					beginSpriteNum++;
				}
			}
			var newSpritesLength:int=(newSprites?newSprites.length:0);
			var endSpriteNum:int=beginSpriteNum+newSpritesLength;

			var beginCharIndex:int=beginIndex-1;
			var endCharIndex:int=beginIndex+rText.length+newSpritesLength;
			
			isNewLineBegin=isNewlineChar(_textRenderer.text,beginCharIndex);
			isNewLineEnd=isNewlineChar(_textRenderer.text,endCharIndex);

			var isNewLineBegin2:Boolean=isNewlineChar(_textRenderer.text,beginCharIndex+1);
			
			var isNewLineLast:Boolean=isNewlineChar(_textRenderer.text,_textRenderer.text.length-1);
			
			trace('replace after',isNewLineBegin,isNewLineEnd,_textRenderer.text);
			
			_spriteRenderer.clear();
			_textRenderer.htmlText=htmlText;

			trace('htmlText:',_textRenderer.text);
			if(!isNewLineBegin && isNewlineChar(_textRenderer.text,beginCharIndex-beginSpriteNum)){
				_textRenderer.setSelection(beginCharIndex-beginSpriteNum,beginCharIndex-beginSpriteNum+1);
				_textRenderer.replaceSelectedText("");
				trace('first fixed:',_textRenderer.text);
			}
			if(!isNewLineBegin && isNewlineChar(_textRenderer.text,beginCharIndex-beginSpriteNum+1)){
				_textRenderer.setSelection(beginCharIndex-beginSpriteNum+1,beginCharIndex-beginSpriteNum+2);
				_textRenderer.replaceSelectedText("");
			}
			if(!isNewLineEnd && isNewlineChar(_textRenderer.text,endCharIndex-endSpriteNum)){
				_textRenderer.setSelection(endCharIndex-endSpriteNum,endCharIndex-endSpriteNum+1);
				_textRenderer.replaceSelectedText("");
				trace('second fixed:',_textRenderer.text);
			}
			i=0;
			while((j=_textRenderer.htmlText.indexOf('</P>',i))!=-1){
				lines++;
				i=j+4;
			}
			if(lines<_textRenderer.numLines ||(!isNewLineLast && isNewlineChar(_textRenderer.text,_textRenderer.text.length-1))){
				_textRenderer.setSelection(_textRenderer.text.length-1,_textRenderer.text.length);
				_textRenderer.replaceSelectedText("");
			}
			trace('ok:',_textRenderer.text);
			_textRenderer.setSelection(endCharIndex-endSpriteNum,endCharIndex-endSpriteNum);
			
			insertSprites(sprites,0,_textRenderer.length-1);
			return true;
		}
		
		/**
		 * 一个布尔值，指示文本字段是否以HTML形式插入文本。
		 * @default false
		 */
		public function get isHtml():Boolean
		{
			return _isHtml;
		}
		
		/**
		 * @private
		 */
		public function set isHtml(value:Boolean):void
		{
			_isHtml = value;
			_textRenderer.useRichTextClipboard=value;
		}
		
		/**
		 * 追加newText参数指定的文本和newSprites参数指定的显示元素到文本字段的末尾。
		 * @param	newText 要追加的新文本。
		 * @param	newSprites 要追加的显示元素数组，每个元素包含src和index两个属性，如：{src:sprite, index:1}。
		 * @param	autoWordWrap 指示是否自动换行。
		 * @param	format 应用于追加的新文本的格式。
		 */
		public function append(newText:String, newSprites:Array = null, autoWordWrap:Boolean = false, format:TextFormat = null):void{
			//append text
			var scrollV:int = _textRenderer.scrollV;
			var oldLength:int = _textRenderer.length;
			var textLength:int = 0;

			var isNewline:Boolean=isNewlineChar(_textRenderer.text,oldLength-1);
			
			if (!newText) newText = "";
			if (newText || autoWordWrap){
				if(newText) newText = newText.split("\r").join("\n");
				//plus a newline(\n) only if append as normal text 
				if (autoWordWrap && !_isHtml)
					newText += "\n";
				_textRenderer.recoverDefaultFormat();
				if (_isHtml){
					//make sure the new text have the default text format
					_textRenderer.htmlText += "<p>" + newText + "</p>";				
				}else{
					_textRenderer.appendText(newText);
					if (format == null) format = _textRenderer.defaultTextFormat;
					_textRenderer.setTextFormat(format, oldLength, _textRenderer.length);
				}
				//record text length added
				if (_isHtml || (autoWordWrap && !_isHtml))
					textLength = _textRenderer.length - oldLength - 1;
				else
					textLength = _textRenderer.length - oldLength;
			}

			//append sprites
			var newline:Boolean = _isHtml && (oldLength != 0);
			var i:int,indexes:Array=[];
			if(newSprites){
				for(i=0;i<newSprites.length;i++){
					indexes.push(newSprites[i].index);
				}
				
				if(!isNewline){
					trace('Not is new line!');
					for(i=0;i<newSprites.length;i++){
						newSprites[i].index++;
					}
				}
			}
			trace('insertSprites',oldLength,textLength,indexes.join(','));
			insertSprites(newSprites, oldLength, oldLength + textLength);
			
			//auto scroll			
			if (autoScroll && _textRenderer.scrollV != _textRenderer.maxScrollV) 
			{
				_textRenderer.scrollV = _textRenderer.maxScrollV;
			}else if(!autoScroll && _textRenderer.scrollV != scrollV)
			{
				_textRenderer.scrollV = scrollV;
			}
			
			//if doesn't scroll but have sprites to render, do it
			if (newSprites != null)
				_spriteRenderer.render();
		}
		
		/**
		 * 使用newText和newSprites参数的内容替换startIndex和endIndex参数指定的位置之间的内容。
		 * @param	startIndex 要替换的起始位置。
		 * @param	endIndex 要替换的末位位置。
		 * @param	newText 要替换的新文本。
		 * @param	newSprites 要替换的显示元素数组，每个元素包含src和index两个属性，如：{src:sprite, index:1}。
		 */
		public function replaceText(startIndex:int, endIndex:int, newText:String, newSprites:Array = null):void
		{
			//replace text			
			var oldLength:int = _textRenderer.length;
			var textLength:int = 0;
			if (endIndex > oldLength) endIndex = oldLength;
			newText = newText.split(_placeholder).join("");
			_textRenderer.replaceText(startIndex, endIndex, newText);
			textLength = _textRenderer.length - oldLength + (endIndex - startIndex);
			
			if (textLength > 0)
			{
				_textRenderer.setTextFormat(_textRenderer.defaultTextFormat, startIndex, startIndex + textLength);
			}
			
			//remove sprites which be replaced
			for (var i:int = startIndex; i < endIndex; i++)
			{
				_spriteRenderer.removeSprite(i);
			}
			//adjust sprites after startIndex
			var adjusted:Boolean = _spriteRenderer.adjustSpritesIndex(startIndex+_textRenderer.length - oldLength, _textRenderer.length - oldLength);
			
			//insert sprites
			insertSprites(newSprites, startIndex, startIndex + textLength);

			_textRenderer.setSelection(startIndex+textLength,startIndex+textLength);
			
			//if adjusted or have sprites inserted, do render
			if (adjusted || (newSprites && newSprites.length > 0)) _spriteRenderer.render();
		}
		
		/**
		 * 从参数startIndex指定的索引位置开始，插入若干个由参数newSprites指定的显示元素。
		 * @param	newSprites 要插入的显示元素数组，每个元素包含src和index两个属性，如：{src:sprite, index:1}。
		 * @param	startIndex 要插入显示元素的起始位置。
		 * @param	maxIndex 要插入显示元素的最大索引位置。	
		 * @param	newline 指示是否为文本的新行。	
		 */
		private function insertSprites(newSprites:Array, startIndex:int, maxIndex:int, newline:Boolean = false):void
		{
			if (newSprites == null) return;
			newSprites.sortOn("index", Array.NUMERIC);
			
			for (var i:int = 0; i < newSprites.length; i++)
			{
				var obj:Object = newSprites[i];
				var sprite:Object = obj.src;
				var index:int = obj.index;
				if (obj.index == undefined || index < 0 || index > maxIndex - startIndex) 
				{
					obj.index = maxIndex - startIndex;
					newSprites.splice(i, 1);
					newSprites.push(obj);
					i--;
					continue;
				}
				
				if (newline && index > 0 && index < maxIndex - startIndex)
					index += startIndex + i - 1;
				else
					index += startIndex + i;
				insertSprite(sprite, index, false, obj.cache);
			}
		}
		
		/**
		 * 在参数index指定的索引位置（从零开始）插入由newSprite参数指定的显示元素。
		 * @param	newSprite 要插入的显示元素。其格式包含src和index两个属性，如：{src:sprite, index:1}。
		 * @param	index 要插入的显示元素的索引位置。
		 * @param	autoRender 指示是否自动渲染插入的显示元素。
		 * @param	cache 指示是否对显示元素使用缓存。
		 */
		public function insertSprite(newSprite:Object, index:int = -1, autoRender:Boolean = true, cache:Boolean = false):void
		{
			//verify the index to insert
			if (index < 0 || index > _textRenderer.length) index = _textRenderer.length;
			
			try{
				//create a instance of sprite
				var spriteObj:DisplayObject = getSpriteFromObject(newSprite);
			}catch(e:ReferenceError){
				var bitmap:ImageRenderer=new ImageRenderer;
				bitmap.rtf=this;
				bitmap.name=String(index);
				bitmap.source=String(newSprite);
				insertSprite(bitmap,index,autoRender,cache);
				return;
			}
			
			if (spriteObj == null) throw Error("Specific sprite:" + newSprite + " is not a valid display object!");
			
			if (cache) spriteObj.cacheAsBitmap = true;
			//resize spriteObj if lineHeight is specified
			if (lineHeight > 0 && spriteObj.height > lineHeight)
			{
				var scaleRate:Number = lineHeight / spriteObj.height;
				spriteObj.height = lineHeight;
				spriteObj.width = spriteObj.width * scaleRate;
			}
			//insert a placeholder into textfield by using replaceText method
			_textRenderer.replaceText(index, index, _placeholder);			
			
			setPlaceholderSize(spriteObj,index);	
			
			//adjust sprites index which come after this sprite
			_spriteRenderer.adjustSpritesIndex(index, 1);
			//insert spriteObj to specific index and render it if it's visible
			_spriteRenderer.insertSprite(spriteObj, index);

			spriteObj.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				var i:int=int((e.target as DisplayObject).name);
				_textRenderer.setSelection(i,i+1);
				trace('sprite index:',index,',src:',spriteObj is ImageRenderer?(spriteObj as ImageRenderer).source:getQualifiedClassName(spriteObj));
			});

			//if autoRender, just do it
			if (autoRender) _spriteRenderer.render();
		}
		//set placeholder size
		public function setPlaceholderSize(sprite:DisplayObject,index:int):void{
			_textRenderer.setTextFormat(calcPlaceholderFormat(sprite.width,sprite.height), index, index + 1);	
			_spriteRenderer.render();
		}
		
		private function getSpriteFromObject(obj:Object):DisplayObject
		{
			if (obj is String) 
			{
				var clazz:Class = getDefinitionByName(String(obj)) as Class;
				return new clazz() as DisplayObject;
			}else if (obj is Class)
			{
				return new obj() as DisplayObject;
			}else 
			{
				return obj as DisplayObject;
			}
		}
		
		/**
		 * 计算显示元素的占位符的文本格式（若使用不同的占位符，可重写此方法）。
		 * @param	width 宽度。
		 * @param	height 高度。
		 * @return
		 */
		private function calcPlaceholderFormat(width:Number, height:Number):TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.color = _placeholderColor;
			format.size = height + 2 * _placeholderMarginV;		
			
			//calculate placeholder text metrics with certain size to get actual letterSpacing
			_formatCalculator.setTextFormat(format);
			var metrics:TextLineMetrics = _formatCalculator.getLineMetrics(0);
			
			//letterSpacing is the key value for placeholder
			format.letterSpacing = width - metrics.width + 2 * _placeholderMarginH;
			format.underline = format.italic = format.bold = false;
			return format;
		}
		
		/**
		 * 设置RichTextField的尺寸大小（长和宽）。
		 * @param	width 宽度。
		 * @param	height 高度。
		 */
		override protected function updateDisplayList(w:Number,h:Number):void{
			_textRenderer.width = w;
			_textRenderer.height = h;
			this.scrollRect = new Rectangle(0, 0, w, h);
			_spriteRenderer.render();
		}
		
		/**
		 * 指示index参数指定的索引位置上是否为显示元素。
		 * @param	index 指定的索引位置。
		 * @return
		 */
		public function isSpriteAt(index:int):Boolean
		{
			if (index < 0 || index >= _textRenderer.length) return false;
			return _textRenderer.text.charAt(index) == _placeholder;
		}
		
		private function scrollHandler(e:Event):void 
		{
			_spriteRenderer.render();
		}
		
		private function changeHandler(e:Event):void 
		{
			var index:int = _textRenderer.caretIndex;
			var offset:int = _textRenderer.length - _textRenderer.oldLength;
			if (offset > 0)
			{
				_spriteRenderer.adjustSpritesIndex(index - 1, offset);
			}else
			{
				//remove sprites
				for (var i:int = index; i < index - offset; i++)
				{
					_spriteRenderer.removeSprite(i);
				}
				_spriteRenderer.adjustSpritesIndex(index + offset, offset);
			}
			_spriteRenderer.render();
		}
		
		/**
		 * 清除所有文本和显示元素。
		 */
		public function clear():void{
			if(_textRenderer.maxScrollV>1)
				_textRenderer.scrollV = _textRenderer.maxScrollV;
			_spriteRenderer.clear();
			_textRenderer.clear();
		}
		
		/**
		 * 指示RichTextField的类型。
		 * @default RichTextField.DYNAMIC
		 */
		public function get type():String 
		{ 
			return _textRenderer.type;
		}
		
		public function set type(value:String):void 
		{
			_textRenderer.type = value;
			_textRenderer.addEventListener(Event.SCROLL, scrollHandler);
			if (value == INPUT)
			{
				_textRenderer.addEventListener(Event.CHANGE, changeHandler);
			}
			setContextMenu(_textRenderer.type==INPUT);
		}
		
		/**
		 * TextField实例。
		 */
		public function get textfield():TextField 
		{ 
			return _textRenderer;
		}
		
		/**
		 * 指示显示元素占位符的水平边距。
		 * @default 1
		 */
		public function set placeholderMarginH(value:int):void 
		{
			_placeholderMarginH = value;
		}
		
		/**
		 * 指示显示元素占位符的垂直边距。
		 * @default 0
		 */
		public function set placeholderMarginV(value:int):void 
		{
			_placeholderMarginV = value;
		}
		
		/**
		 * 指示显示元素占位符的颜色。
		 * @default 0xffffff
		 */
		public function set placeholderColor(value:uint):void
		{
			_placeholderColor = value;
		}
		
		/**
		 * 返回文本字段中的内容（包括显示元素的占位符）。
		 */
		public function get content():String
		{
			return _textRenderer.text;
		}
		
		/**
		 * 返回文字字段中的内容长度（包括显示元素的占位符）。
		 */
		public function get contentLength():int
		{
			return _textRenderer.length;
		}
		
		/**
		 * 返回文本字段中的文本（不包括显示元素的占位符）。
		 */
		public function get text():String
		{
			return _textRenderer.text.split(_placeholder).join("");
		}
		
		/**
		 * 返回文字字段中的文本长度（不包括显示元素的占位符）。
		 */
		public function get textLength():int
		{
			return _textRenderer.length - _spriteRenderer.numSprites;
		}
		
		/**
		 * 返回由参数index指定的索引位置的显示元素。
		 * @param	index
		 * @return
		 */
		public function getSprite(index:int):DisplayObject
		{
			return _spriteRenderer.getSprite(index);
		}
		
		/**
		 * 返回RichTextField中显示元素的数量。
		 */
		public function get numSprites():int
		{
			return _spriteRenderer.numSprites;
		}
		
		/**
		 * 指定鼠标指针的位置。
		 */
		public function get caretIndex():int
		{
			return _textRenderer.caretIndex;
		}		
		
		public function set caretIndex(index:int):void
		{
			_textRenderer.setSelection(index, index);
		}
		
		/**
		 * 指定文本字段的默认文本格式。
		 */
		public function get defaultTextFormat():TextFormat
		{
			return _textRenderer.defaultTextFormat;
		}
		
		public function set defaultTextFormat(format:TextFormat):void
		{
			if (format.color != null) _placeholderColor = uint(format.color);
			_textRenderer.defaultTextFormat = format;
		}
		
		/**
		 * 导出XML格式的RichTextField的文本和显示元素内容。
		 * @return
		 */
		public function exportXML(beginIndex:int=0,endIndex:int=0):XML
		{
			var xml:XML =<rtf/>;
			if (_isHtml) 
			{
				xml.htmlText = String(beginIndex==endIndex?_textRenderer.htmlText:getHtml(beginIndex,endIndex)).split(_placeholder).join("");
			}else
			{
				xml.text = String(beginIndex==endIndex?_textRenderer.text:_textRenderer.text.substring(beginIndex,endIndex)).split(_placeholder).join("");
			}
			
			xml.sprites = _spriteRenderer.exportXML(beginIndex,endIndex);
			return xml;
		}
		
		/**
		 * 导入指定XML格式的文本和显示元素内容。
		 * @param	data 具有指定格式的XML内容。
		 */
		public function importXML(data:XML,beginIndex:int=-1,endIndex:int=-1):void
		{
			var content:String = "";		
			if (data.hasOwnProperty("htmlText")) content += data.htmlText;
			if (data.hasOwnProperty("text")) content += data.text;						
			
			var sprites:Array = [];
			for (var i:int = 0; i < data.sprites.sprite.length(); i++)
			{
				var node:XML = data.sprites.sprite[i];
				var sprite:Object = {};
				sprite.src = String(node.@src);
				sprite.index = int(node.@index);
				sprites.push(sprite);
			}
			if(beginIndex!=-1 && endIndex!=-1){
				if(data.hasOwnProperty("htmlText")){
					replaceHtml(beginIndex,endIndex,content,sprites);
				}else{
					replaceText(beginIndex,endIndex,content,sprites);
				}
			}else{
				append(content, sprites);
			}
		}
		
		/**
		 * 为RichTextField增加插件。
		 * @param	plugin 要增加的插件。
		 */
		public function addPlugin(plugin:IRTFPlugin):void
		{			
			plugin.setup(this);
			if (_plugins == null) _plugins = [];	
			_plugins.push(plugin);
		}
	}	
}