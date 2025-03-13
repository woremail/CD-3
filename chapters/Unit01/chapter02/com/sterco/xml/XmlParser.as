package com.sterco.xml{
	
	import flash.events.*;
	import flash.display.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;
	
	public dynamic class XmlParser extends MovieClip{
		
		private var XMLPath:String;
		private var XMLData:XML = new XML();
		public var stageClip:MovieClip;
		var defaultXML:XMLDocument = new XMLDocument();
		private var XmlObject:Object;
		private var activityArray:Array;		
		public var XMLComplete:Boolean;
		
		
		
		public function XmlParser(_strFolderTrack:String = null) {
			
			XMLPath = setXMLFilePath(XMLFunctions.mainReference,_strFolderTrack);
			this.name = "Dynamic";
			this.XMLPath = XMLPath;
			var requestObject:URLRequest = new URLRequest(XMLPath);
			var loaderObject:URLLoader = new URLLoader();
			loaderObject.addEventListener(Event.COMPLETE,XMLLoaded);
			loaderObject.load(requestObject);
		}
		
		
		
		private function XMLLoaded(evt:Event){
			XMLData = XML(evt.target.data);
			defaultXML.parseXML(XMLData.toXMLString());
			parseXML();
			
		}
		
		private function parseXML() {			
			
			this[defaultXML.firstChild.nodeName] = new Object();						
			populate(defaultXML.firstChild,this[defaultXML.firstChild.nodeName]);					
			XMLFunctions.XMLObject = this;			
			dispatchEvent(new Event("XMLRreadingComplete"));
		}
		private function setXMLFilePath(target,_strFolderTrack):String {
			var url;
			url = unescape(target.loaderInfo.url);
			url = url.substr(url.lastIndexOf("/")+1, url.lastIndexOf("."));
			url = url.substr(0, url.indexOf("."))+".xml";		
			
			if(url.search("Interface_final.xml") != -1){// == "Interface_final.xml"){
				url = "setup.xml";
			}
			else{
				if(_strFolderTrack!=null)
				url = _strFolderTrack + url;
			}
			return url;
		}
		private function populate(xmlObj, dataGathererObj){
			var propertyName = "";
			if (xmlObj.hasChildNodes) {
				for (var i = 0; i<xmlObj.childNodes.length; i++) {
					if (xmlObj.childNodes[i].nodeType == 1) {
						propertyName = xmlObj.childNodes[i].nodeName;
						if (dataGathererObj[propertyName] == undefined) {
							dataGathererObj[propertyName] = new Object();
							dataGathererObj[propertyName]._length = 0;
						} 
						else {
							dataGathererObj[propertyName]._length++;
						}
						dataGathererObj[propertyName][dataGathererObj[propertyName]._length] = new Object();
						for (var each in xmlObj.childNodes[i].attributes) {
							dataGathererObj[propertyName][dataGathererObj[propertyName]._length][each] = xmlObj.childNodes[i].attributes[each];
						}
						this.populate(xmlObj.childNodes[i],dataGathererObj[propertyName][dataGathererObj[propertyName]._length]);
					}
					else {						
						dataGathererObj._innerData = xmlObj.childNodes[i].nodeValue;						
					}
				}
			}
		}
	
	}
}