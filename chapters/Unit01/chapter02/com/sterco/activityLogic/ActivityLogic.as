package com.sterco.activityLogic{
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.sterco.events.ButtonClass;
	import com.sterco.events.CustomEvents;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import com.coreyoneil.collision.CollisionGroup;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.TextEvent;
	import flash.media.Sound;
	import flash.text.TextFormat;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class ActivityLogic extends MovieClip {
		public var questionIndex:Number = 1;
		private var clipArray:Array;
		private var stageReference:MovieClip;
		private var speedChange:Boolean = true;
		public var findFrameLabel:String="";
		private var rabbitXSteps:Number;
		private var initWolf_X:Number;
		private var initRabbit_X:Number;
		private var initHut_X:Number;
		private var rabbitDestinationX:Number;
		private var moveRabbit:Boolean;
		private var rightAns:Number = 0;
		private var speed:Number;
		private var fastWolfspeed:Number =0;
		private var fastRabbitspeed:Number =0;
		private var gameFinish:Boolean;
		private var questionAttemped:Number = 0;

		var cdk:CollisionGroup;
		private var currentReference:MovieClip;
		private var _nAngle2:Number =0;
		private var _nAngle1:Number =0;

		private var currentCounter:Number = 0;
		private var array:Array;
		var mcClip1:MovieClip;
		var mcClip2:MovieClip;
		var mcClip3:MovieClip;
		private var soundChannel:SoundChannel;
		private var soundObject:Sound;
		private var arrayCounter:Array;
		public var animationArray:Array;
		private var enterState:Number = 0;
		private var intervalState:Number;
		private var switchTimer:Timer = new Timer(2000);
		private var questionToSwitch:Boolean;
		private var textDelayCounter:Number = 0;

		public function ActivityLogic(stageReference:MovieClip) {
			this.stageReference = XMLFunctions.mainReference;

			this.stageReference.addEventListener(Event.ADDED, onStageAdded);
			this.stageReference.hitter_hit.visible = false;
			findFrameLabel = "mcBunny";
			stageReference.displayHint.visible = false;
			stageReference.ani_1.h.visible = false;
			stageReference.ani_2.h.visible = false;
			stageReference.ani_3.h.visible = false;
			stageReference.ani_4.h.visible = false;
			stageReference.ani_5.h.visible = false;
			stageReference.ani_6.h.visible = false;
			stageReference.ani_7.h.visible = false;
			stageReference.ani_8.h.visible = false;
			stageReference.ani_9.h.visible = false;
			stageReference.ani_10.h.visible = false;
			stageReference.ani_11.h.visible = false;
			stageReference.ani_12.h.visible = false;
			ansVisible(stageReference.ani_1);
			ansVisible(stageReference.ani_2);
			ansVisible(stageReference.ani_3);
			ansVisible(stageReference.ani_4);
			ansVisible(stageReference.ani_5);
			ansVisible(stageReference.ani_6);
			ansVisible(stageReference.ani_7);
			ansVisible(stageReference.ani_8);
			ansVisible(stageReference.ani_9);
			ansVisible(stageReference.ani_10);
			ansVisible(stageReference.ani_11);
			ansVisible(stageReference.ani_12);

			animationArray = new Array();
			animationArray.push(stageReference.river_ani);
			animationArray.push(stageReference.ani_7.vapour_ani);
			animationArray.push(stageReference.cloud_ani);
			animationArray.push(stageReference.rain_fall);
			animationArray.push(stageReference.ani_1);
			animationArray.push(stageReference.bird_fly);
			animationArray.push(stageReference.sun_raise);


			this.stageReference.addEventListener(Event.ENTER_FRAME, onHitTest);
			this.stageReference.addEventListener(KeyboardEvent.KEY_UP, onKeyUpEvent);
			this.stageReference.addEventListener(MouseEvent.MOUSE_UP, onMouseUP);
			findLabel(this.stageReference);

		}
		public function _removeEvent() {
			this.stageReference.removeEventListener(Event.ENTER_FRAME, onHitTest);
			this.stageReference.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpEvent);
			this.stageReference.removeEventListener(MouseEvent.MOUSE_UP, onMouseUP);
		}
		private function onMouseUP(evt:MouseEvent):void {
			trace(XMLFunctions.model.mcClip.ans.txt.length +"   "+evt.target.name);
			if (XMLFunctions.model.mcClip.ans.txt.length == 0 && evt.target.name!="txt") {
				XMLFunctions.model.focusEnabledForTextField = false;
				XMLFunctions.model.mcClip.ans.txt.text = "Answer";
			}
		}
		/*private function textEvent(evt):void{
		stageReference.mcSubmit.alpha = 1;
		}*/
		public function onKeyUpEvent(kbEvent:KeyboardEvent):void {
			if (kbEvent.keyCode == 13 && enterState == 0 && XMLFunctions.model.focusEnabledForTextField == true && XMLFunctions.performTest == true) {
				XMLFunctions.model.focusEnabledForTextField = false;
				XMLFunctions.model.mcClip.ans.txt.type = "dynamic";
				displayHintFalse();
				enterState = 1;
				intervalState = setInterval(delayEnterPress, 5000);
				XMLFunctions.model.matchAnswer();
			}
			if (((this.stageReference).stage).focus.name == "txt") {
				XMLFunctions.model.focusEnabledForTextField = true;
			}
		}
		public function delayEnterPress():void {
			XMLFunctions.model.focusEnabledForTextField = true;
			XMLFunctions.model.mcClip.ans.txt.type = "input";
			clearInterval(intervalState);
			enterState = 0;
		}
		private function onHitTest(evt:Event):void {


			var mc:MovieClip = MovieClip(stageReference.getChildByName("ani_" + questionIndex));
			if (mc == null || stageReference.hitter_hit == null || cdk == null) {
				return;
			}
			stageReference.hitter_hit.x = stageReference.mouseX;
			stageReference.hitter_hit.y = stageReference.mouseY;
			if (mc.h != null && stageReference.currentLabel == "mcBunny" && XMLFunctions.activityLogic.findFrameLabel == "" && questionToSwitch == false) {
				//if (mc.h.hitTestPoint(XMLFunctions.model.mcClip.mouseX, XMLFunctions.model.mcClip.mouseY))
				if (cdk.checkCollisions().length>0) {
					if (mc.alreadyHit == undefined) {
						mc.alreadyHit =  true;
						//mc.h.visible = true;
						displayHint(stageReference.displayHint);

					}
				} else {
					stopSound();
					/*if(mc.h.claimed == undefined)
					mc.h.visible = false;*/
					mc.alreadyHit =  undefined;
				}
			}
		}
		public function ansVisible(mc:MovieClip, bool:Boolean = false):void {
			if (bool == false) {
				mc.ans.visible = false;
			} else {
				mc.ans.visible = true;
				mc.h.claimed = true;
				mc.h.visible = true;
			}
		}
		private function displayHint(mc:MovieClip):void {
			stopSound();
			mc.visible = true;
			mc.text2.htmlText = XMLFunctions.XMLObject.framexml.data[0].hint1[0]._innerData;

			mc.text1.htmlText = XMLFunctions.XMLObject.framexml.data[0].hint[questionIndex - 1]._innerData;
			playSound();
		}
		public function displayHintFalse() {
			stopSound();
			stageReference.displayHint.visible = false;
		}
		private function playSound():void {
			//var soundClass:Class = getDefinitionByName("Clip_Sound_" + questionIndex) as Class;
			switch (questionIndex) {
				case 1 :
					soundObject = new Clip_Sound_1();
					break;

				case 2 :
					soundObject = new Clip_Sound_2();
					break;

				case 3 :
					soundObject = new Clip_Sound_3();
					break;


				case 4 :
					soundObject = new Clip_Sound_4();
					break;


				case 5 :
					soundObject = new Clip_Sound_5();
					break;

				case 6 :
					soundObject = new Clip_Sound_6();
					break;

				case 7 :
					soundObject = new Clip_Sound_7();
					break;

				case 8 :
					soundObject = new Clip_Sound_8();
					break;


				case 9 :
					soundObject = new Clip_Sound_9();
					break;


				case 10 :
					soundObject = new Clip_Sound_10();
					break;

				case 11 :
					soundObject = new Clip_Sound_11();
					break;

				case 12 :
					soundObject = new Clip_Sound_12();
					break;
				default :
					break;
			}
			soundChannel = soundObject.play();
			soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
		}
		private function soundComplete(evt:Event):void {
			stopSound();
		}
		private function stopSound():void {
			if (soundChannel != null) {
				soundChannel.stop();
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			}
			stageReference.displayHint.visible = false;

		}
		public function findLabel(mc:MovieClip):void {
			mc.addEventListener(Event.ENTER_FRAME, onFrameLoop);
		}
		private function onFrameLoop(evt:Event):void {
			//trace(evt.currentTarget.currentLabel ,"  &&  ", findFrameLabel);
			if (evt.currentTarget.currentLabel == findFrameLabel) {
				trace(findFrameLabel);
				evt.currentTarget.removeEventListener(Event.ENTER_FRAME, onFrameLoop);
				if (findFrameLabel == "wrong2End" || findFrameLabel == "rightEnd") {
					questionToSwitch = true;

					switchTimer.addEventListener(TimerEvent.TIMER, onSwitchNextQuestion);
					switchTimer.start();

				} else if (findFrameLabel == "wrongEnd") {
					XMLFunctions.model.mcClip.ans.txt.text = "";
					XMLFunctions.model.mcClip.ans.stage.focus = XMLFunctions.model.mcClip.ans.txt;
				} else if (findFrameLabel == "mcBunny") {
					switchToNextQuestion(questionIndex);
				} else if (findFrameLabel == "setAnswer") {
					findFrameLabel = "wrong2End";
					evt.currentTarget.addEventListener(Event.ENTER_FRAME, onFrameLoop);
					XMLFunctions.model.placeRightAnswer();
					return;
				}
				findFrameLabel = "";
			}
		}
		private function onSwitchNextQuestion(evt:TimerEvent):void {
			if (textDelayCounter == 0) {
				textDelayCounter++;
				XMLFunctions.model.placeRightAnswer2();
			} else {
				textDelayCounter = 0;
				questionToSwitch = false;
				XMLFunctions.model.focusEnabledForTextField = false;
				switchTimer.stop();
				questionIndex ++;
				switchToNextQuestion(questionIndex);
			}
		}
		private function switchToNextQuestion(index:Number):void {
			if (index == 13) {
				_removeEvent();
				stopSound();
				XMLFunctions.model.playFinalFeedback();
				//MovieClip(stageReference.getChildByName("ani_12")).visible = false;
			} else {
				// SINGLE LINE MODIFIED BY ABHISHEK ====================== //
				//trace("switched Question Called..................FOR   "+index);
				XMLFunctions.model.processQuestion(questionIndex);
				MovieClip(stageReference.getChildByName("ani_" + questionIndex)).ans.txt.maxChars = 9;
				//MovieClip(stageReference.getChildByName("ani_" + questionIndex)).visible = true;
				//MovieClip(stageReference.getChildByName("ani_" + questionIndex)).h.claimed = true;
				//MovieClip(stageReference.getChildByName("ani_" + questionIndex)).h.visible = true;
			}
		}
		private function onStageAdded(evt:Event):void {
			//trace(evt.target.name +"  "+evt.target.hasOwnProperty("name"))
			if (evt.target.hasOwnProperty("name")) {
				if (evt.target.name == "mc_t1") {
					evt.target.text1.htmlText = XMLFunctions.XMLObject.framexml.data[0].text[0]._innerData;
				}
				if (evt.target.name == "mc_t2") {
					evt.target.text1.htmlText = XMLFunctions.XMLObject.framexml.data[0].text[1]._innerData;
				}
				if (evt.target.name == "mc_t3") {
					evt.target.text1.htmlText = XMLFunctions.XMLObject.framexml.data[0].text[2]._innerData;
				}
				if (evt.target.name == "mc_t4") {
					evt.target.text1.htmlText = XMLFunctions.XMLObject.framexml.data[0].text[3]._innerData;
				}
				if (evt.target.name == "mc_t5") {
					evt.target.text1.htmlText = XMLFunctions.XMLObject.framexml.data[0].text[4]._innerData;
				}
				if (evt.target.name == "right_text") {
					evt.target.htmlText = XMLFunctions.XMLObject.framexml.data[0].feedback[0]._innerData;
				}
				if (evt.target.name == "wrong_text") {
					evt.target.htmlText = XMLFunctions.XMLObject.framexml.data[0].feedback[1]._innerData;
				}
				if (evt.target.name == "wrong2_text") {
					evt.target.htmlText = XMLFunctions.XMLObject.framexml.data[0].feedback[2]._innerData;
				}
				if (evt.target.name == "scoreTxt") {
					evt.target.text = XMLFunctions.model.correctAns +"/"+XMLFunctions.model.totalQuestions;
				}
				if (evt.target.name == "better_text1") {
					evt.target.htmlText = XMLFunctions.XMLObject.framexml.data[0].feedback[4]._innerData;
				}
				if (evt.target.name == "good_text1") {
					evt.target.htmlText = XMLFunctions.XMLObject.framexml.data[0].feedback[5]._innerData;
				}
				if (evt.target.name == "superb_text1") {
					evt.target.htmlText = XMLFunctions.XMLObject.framexml.data[0].feedback[6]._innerData;
				}
				if (evt.target.name == "correct_ans_is") {
					evt.target.htmlText = XMLFunctions.XMLObject.framexml.data[0].feedback[3]._innerData ;
				}
			}
		}
		public function init_Collision(collision_Clip):void {
			cdk = new CollisionGroup(collision_Clip,stageReference.hitter_hit);

		}
	}
}