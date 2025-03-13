package org.sterco.xml{
	
	import flash.events.*;
	import flash.display.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;
	
	public dynamic class XMLReader extends MovieClip{
		
		private var XMLPath:String = "setup.xml";
		private var XMLData:XML = new XML();
		private var _mcTimeLine;
		var defaultXML:XMLDocument = new XMLDocument();
		//defaultXML.ignoreWhite = true;
		
		public function XMLReader(target,_strFolderTrack:String = null) {
			_mcTimeLine = target;
			XMLPath = setXMLFilePath(target,_strFolderTrack);
			var requestObject:URLRequest = new URLRequest(XMLPath);
			var loaderObject:URLLoader = new URLLoader();
			loaderObject.addEventListener(Event.COMPLETE,XMLLoaded);
			loaderObject.load(requestObject);
		}
		
		private function setXMLFilePath(target,_strFolderTrack) {
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
		
			/*if (_level0.__strXml != undefined) {			
				__nMode = 1;
				__strFolderName = _level0.__strFolderTrack;
				url = _level0.__strFolderTrack+"/"+url;
				return url;
			}*/
			//trace("uyrl in objxml isssss      "+url);
			return url;
		}
		
		private function XMLLoaded(evt:Event){
			XMLData = XML(evt.target.data);
			defaultXML.parseXML(XMLData.toXMLString());
			parseXML();
		}
		
		private function parseXML() {
			
			this[defaultXML.firstChild.nodeName] = new Object();
			populate(defaultXML.firstChild,this[defaultXML.firstChild.nodeName]);			
			//dispatchEvent(new Event("xmlReady",true));
			_mcTimeLine.play();
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