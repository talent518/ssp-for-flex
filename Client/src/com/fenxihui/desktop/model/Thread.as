package com.fenxihui.desktop.model
{
	import com.fenxihui.desktop.view.Loading;
	import com.fenxihui.desktop.view.window.MainWindow;
	import com.fenxihui.desktop.view.window.InfoWindow;

	public class Thread extends Base
	{
		public static function view(tid:uint,newWindowOpen:Boolean=true):void{
			Loading.show(MainWindow.mainWindow.categoryTree);
			Loading.show(MainWindow.mainWindow.infoTree);
			bind('Thread.View.Succeed',function(request:XML):void{
				if(newWindowOpen){
					with(new InfoWindow){
						open(true);
						nativeWindow.activate();
						nativeWindow.restore();
						nativeWindow.orderToFront();
						center();
						category=request.category;
						info=request.thread;
					}
				}else{
					with(MainWindow.mainWindow.viewInfo){
						category=request.category;
						info=request.thread;
					}
				}
				Loading.hide(MainWindow.mainWindow.categoryTree);
				Loading.hide(MainWindow.mainWindow.infoTree);
			});
			bind('Thread.View.Failed',function(request:XML):void{
				Loading.hide(MainWindow.mainWindow.categoryTree);
				Loading.hide(MainWindow.mainWindow.infoTree);
				ShowDialog(request.text(),false);
			});
			send('Thread.View',{tid:tid});
		}
	}
}