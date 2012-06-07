package
{
	import com.fenxihui.library.component.Dialog;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.core.Window;
	import mx.managers.PopUpManager;

	public function ShowDialog(message:String,type:Boolean=true,callback:Function=null):void{
		var dialog:Dialog=new Dialog();
		dialog.showType=(type?Dialog.SUCCEED:Dialog.FAILED);
		dialog.title=(type?'成功提示':'失败提醒');
		dialog.message=message;
		dialog.open(true);
		dialog.nativeWindow.addEventListener(Event.CLOSE,function(e:Event):void{
			dialog=null;
			if(callback!=null)
				callback();
		});
		dialog.nativeWindow.addEventListener(Event.DEACTIVATE,function(e:Event):void{
			dialog.setFocus();
			dialog.nativeWindow.activate();
		});
		dialog.center();
		dialog.setFocus();
	}
}