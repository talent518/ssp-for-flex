package{
	import mx.utils.MD5;

	public function md5(src:String):String{
		return MD5.calculate(src);
	}
}