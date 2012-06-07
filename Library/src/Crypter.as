package
{
	import flash.utils.ByteArray;

	public class Crypter
	{
		public static function encode(str:String,key:String,expiry:uint=0):String{
			return coder(str,key,false,expiry);
		}
		
		public static function decode(str:String,key:String,expiry:uint=0):String{
			return coder(str,key,true,expiry);
		}
		
		private static function coder(string:String,key:String,mode:Boolean,expiry:uint=0):String{
			
			var ckey_length:uint = 4;	// 随机密钥长度 取值 0-32;
			// 加入随机密钥，可以令密文无任何规律，即便是原文和密钥完全相同，加密结果也会每次不同，增大破解难度。
			// 取值越大，密文变动规律越大，密文变化 = 16 的 $ckey_length 次方
			// 当此值为 0 时，则不产生随机密钥
			
			key = md5(key);
			var keya:String = md5(key.substr(0, 16));
			var keyb:String = md5(key.substr(16, 16));
			var keyc:String = ckey_length ? (mode? string.substr(0,ckey_length): md5(String(time())).substr(-ckey_length)):'';

			var cryptkey:String = keya+md5(keya+keyc);
			var key_length:uint = cryptkey.length;
			
			var stringByteArray:ByteArray=new ByteArray,resultByteArray:ByteArray=new ByteArray;
			if(mode)
				stringByteArray.writeBytes(Base64Decode(string.substr(ckey_length),false));
			else
				stringByteArray.writeUTFBytes(String(repeat('0',10)+(expiry ? expiry + time():0)).substr(-10)+md5(string+keyb).substr(0,16)+string);

			var string_length:uint = stringByteArray.length;
			
			var result:String = '';
			var box:Array = new Array();
			var rndkey:Array = new Array();
			var i:uint,j:uint,a:uint,tmp:*;
			
			for(i = 0; i <= 255; i++) {
				rndkey[i] = cryptkey.charCodeAt(i % key_length);
				box[i]=i;
			}
			
			for(j = i = 0; i < 256; i++) {
				j = (j + box[i] + rndkey[i]) % 256;
				tmp = box[i];
				box[i] = box[j];
				box[j] = tmp;
			}
			
			for(a = j = i = 0; i < string_length; i++) {
				a = (a + 1) % 256;
				j = (j + box[a]) % 256;
				tmp = box[a];
				box[a] = box[j];
				box[j] = tmp;
				resultByteArray.writeByte(stringByteArray[i] ^ (box[(box[a] + box[j]) % 256]));
			}
			if(mode){
				result=resultByteArray.toString();
				if((Number(result.substr(0, 10)) == 0 || Number(result.substr(0, 10)) - time() > 0) && result.substr(10, 16) == md5(result.substr(26)+keyb).substr(0, 16)) {
					return result.substr(26);
				} else {
					return '';
				}
			} else {
				return keyc+Base64Encode(resultByteArray);//.replace('=', '');
			}
		}

		private static function time():uint{
			return uint(new Date().time/100);
		}
		private static function repeat(str:String,len:uint):String{
			var result:String='';
			for(var i:uint=0;i<len;i++){
				result+=str;
			}
			return result;
		}
	}
}