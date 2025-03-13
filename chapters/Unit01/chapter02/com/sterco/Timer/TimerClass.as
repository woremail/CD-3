package com.sterco.Timer
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class TimerClass
	{
		private var timer:Timer;
		public var second:Number = 0;
		private var minute:Number =0;		
		public function TimerClass()
		{
			timer = new Timer(1000,0);
			timer.addEventListener(TimerEvent.TIMER, increasingTimeMinuteSeconds);
		}
		public function increasingTimeMinuteSeconds(evt:TimerEvent):void
		{
			second++;
			if(second>59)
			{
				second= 0;
				minute++;
			}
			
			XMLFunctions.mainReference.timer.min.text = String(minute).length == 1? "0"+minute:minute;
			XMLFunctions.mainReference.timer.sec.text = String(second).length == 1? "0"+second:second;
		}
		
		public function startTimer():void
		{
			timer.start();
		}
		public function pauseTimer():void
		{
			timer.stop();
		}
		public function stopTimer():void
		{
			timer.stop();
		}
		public function resetTimer():void
		{
			stopTimer();
			second = 0;
			minute = 0;			
		}
	}
}