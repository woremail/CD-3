package com.sterco.events
{
	import flash.events.Event;
	public class CustomEvents extends Event
	{
		public var argument:*;
		public function CustomEvents(type:String,bubbles:Boolean = false,cancelable:Boolean = false, ...cArgument:*)
		{
			super(type,bubbles,cancelable);
			argument = cArgument;
		}
		override public function clone():Event
		{
			return new CustomEvents(type,bubbles,cancelable,argument);
		}
	}
}