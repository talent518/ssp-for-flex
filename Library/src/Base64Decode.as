// ActionScript file
package{
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	
	public function Base64Decode(cipherStr:String,returnString:Boolean=true):*{
		var base64de:Base64Decoder=new Base64Decoder;
		base64de.decode(cipherStr);
		return returnString?base64de.toByteArray().toString():base64de.toByteArray();
	}
}