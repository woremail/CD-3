package com.sterco.events
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.sterco.events.CustomEvents;
	public class ButtonClass extends MovieClip
	{
		
		public function ButtonClass(object:DisplayObject, option:String = null)
		{
			var mcClip:MovieClip = MovieClip(object);
						
			mcClip.addEventListener(MouseEvent.CLICK, onClick);
			//mcClip.addEventListener(MouseEvent.ROLL_OVER, onRoll);
			//mcClip.addEventListener(MouseEvent.ROLL_OUT, onOut);
			mcClip.buttonMode = true;
			
		}
		
		private function onClick(evt:MouseEvent)
		{		
			//trace(evt.currentTarget.name)
			trace("ok")
			dispatchEvent(new CustomEvents("CLICKED",false,false,evt.currentTarget.name));
		}
		private function onRoll(evt:MouseEvent)
		{
			dispatchEvent(new Event(XMLFunctions.ROLL));
		}
		private function onOut(evt:MouseEvent)
		{
			dispatchEvent(new Event(XMLFunctions.OUT));
		}
	}
}