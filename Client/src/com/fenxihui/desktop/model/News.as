package com.fenxihui.desktop.model
{
	import com.fenxihui.desktop.view.Loading;
	import com.fenxihui.desktop.view.window.InfoWindow;
	import com.fenxihui.desktop.view.window.MainWindow;

	public class News extends Base
	{
		public static function view(aid:uint,newWindowOpen:Boolean=true):void{
			Loading.show(MainWindow.mainWindow.categoryTree);
			Loading.show(MainWindow.mainWindow.infoTree);
			bind('News.View.Succeed',function(request:XML):void{
				if(newWindowOpen){
					with(new InfoWindow){
						open(true);
						nativeWindow.activate();
						nativeWindow.restore();
						nativeWindow.orderToFront();
						center();
						category=request.category;
						info=request.news;
					}
				}else{
					with(MainWindow.mainWindow.viewInfo){
						category=request.category;
						info=request.news;
					}
				}
				Loading.hide(MainWindow.mainWindow.categoryTree);
				Loading.hide(MainWindow.mainWindow.infoTree);
			});
			bind('News.View.Failed',function(request:XML):void{
				Loading.hide(MainWindow.mainWindow.categoryTree);
				Loading.hide(MainWindow.mainWindow.infoTree);
				ShowDialog(request.text(),false);
			});
			send('News.View',{aid:aid});
		}
	}
}