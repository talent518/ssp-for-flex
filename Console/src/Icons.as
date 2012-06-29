package
{
	import mx.core.UIComponent;

	public class Icons{
		
		//内容标示图标
		[Embed(source="assets/icon-search.png")]
		[Bindable]
		public static var Search:Class;
		
		//功能图标
		[Embed(source="assets/icon-user.png")]
		[Bindable]
		public static var User:Class;

		[Embed(source="assets/icon-server.png")]
		[Bindable]
		public static var Service:Class;
		
		[Embed(source="assets/icon-count.png")]
		[Bindable]
		public static var Count:Class;
		
		[Embed(source="assets/icon-user-group.png")]
		[Bindable]
		public static var UserGroup:Class;
		
		[Embed(source="assets/icon-serv-group.png")]
		[Bindable]
		public static var ServGroup:Class;

	}
}