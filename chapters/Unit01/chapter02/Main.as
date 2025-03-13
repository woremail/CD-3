package {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import com.sterco.xml.XmlParser;
	import com.sterco.model.Model;
	import com.sterco.Timer.TimerClass;
	import com.sterco.activityLogic.ActivityLogic;
	import flash.utils.Timer;

	public class Main extends MovieClip {
		private var mainStage:MovieClip;
		private var activity_container:MovieClip;
		private var xmlParser;
		private var XmlObject:Object;
		private var XMLPath:String = "9780199066452_Sst03_Lnw03.xml";
		public var interfaceObject:*;
		public var QTimer:Timer; //= new Timer(1000);
		public var blnPlay;
		public function Main() {
			XMLFunctions.mainReference = this;
			//this.interfaceObject = null;
			XMLFunctions.model = new Model();
			parseXML();
		}
		public function parseXML() {
			xmlParser = new XmlParser();
			xmlParser.addEventListener("XMLRreadingComplete", XMLComplete);
			//////// Calling XML parser to convert xml into objectes;

		}
		private function XMLComplete(evt:Event) {
			trace("Activity Start");
			XMLFunctions.activityLogic = new ActivityLogic(XMLFunctions.mainReference);
			///////////// this keyword is used for refrence stage
			this.gotoAndPlay(2);
		}
		public function setInterface(interfaceRef:*) {
			this.interfaceObject = interfaceRef;
			xmlParser = new XmlParser(interfaceObject.__strFolderTrack);
			xmlParser.addEventListener("XMLRreadingComplete", XMLComplete);
			//objXML = new XMLReader(this, interfaceObject.__strFolderTrack);
			interfaceObject.setPlayables(XMLFunctions.mainReference);
		}
		
		public function reConstruct(){
			if(XMLFunctions.mainReference.currentLabel !="mcBunny")
				XMLFunctions.mainReference.play();
		}
		
		public function destroy() {
			trace("destroy function call");
			XMLFunctions.activityLogic._removeEvent();
		}
	}
}