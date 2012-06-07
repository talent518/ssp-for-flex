// ActionScript file
package{
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Encoder;

	public function Base64Encode(plainBytes:*):String{
		var base64en:Base64Encoder=new Base64Encoder;
		if(typeof(plainBytes)=='string')
			base64en.encodeUTFBytes(plainBytes);
		else
			base64en.encodeBytes(plainBytes);
		return base64en.toString();
	}
}