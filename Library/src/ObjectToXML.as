// ActionScript file
package{

	public function ObjectToXML(obj:Object,name:String="root"):XML{
		var _xml:XML=new XML("<"+name+"/>");
		if(obj==null)
			return _xml;
		
		for(var k:String in obj)
			_xml[k]=(typeof(obj[k])=='object' && obj[k]!=null?ObjectToXML(obj[k],k):obj[k]);
		return _xml;
	}
	
}