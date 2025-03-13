package com.sterco.model{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextFormat;
	import flash.display.DisplayObject;

	public class Model {
		private var rightQuestion:String;
		private var rightFeedback:String;
		private var wrongFeedback:String;

		public var mcClip:MovieClip;
		public var mcSubmit:MovieClip;
		private var currentIndex:Number;
		private var numberOfAttempt:Number = 0;

		public var correctAns:Number = 0;
		public var totalQuestions:Number = 12;

		public var animationIndex:Number = 0;
		public var rawString:String;
		public var _rightAns:String = null;
		public var ansArr = new Array();
		public var focusEnabledForTextField:Boolean;
		public function Model() {

		}
		public function processQuestion(index:Number) {
			currentIndex = index;
			numberOfAttempt = 0;
			mcClip = MovieClip(XMLFunctions.mainReference.getChildByName("ani_" + (index-1)));
			mcSubmit = MovieClip(XMLFunctions.mainReference.getChildByName("mcSubmit"));
			//trace(mcClip + "--------------------nitesh----------------------------------------mcClip");
			if (mcClip!=null) {
				mcClip.h.visible = false;
			}
			mcClip = MovieClip(XMLFunctions.mainReference.getChildByName("ani_" + (index)));
			if (mcClip != null) {
				focusEnabledForTextField = false;
				XMLFunctions.performTest = true;
				XMLFunctions.activityLogic.init_Collision(DisplayObject(mcClip.h));
				mcClip.ans.txt.addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
				var correctAnswer:String = XMLFunctions.XMLObject.framexml.data[0].text[currentIndex + 4]._innerData;
				rawString = strReplace(correctAnswer, "<b>", "");
				rawString = strReplace(rawString, "</b>", "");
				mcClip.ans.txt.maxChars = rawString.length;
				mcClip.ans.txt.restrict="a-z";
				XMLFunctions.activityLogic.ansVisible(mcClip, true);
				mcClip.h.visible = true;
				mcClip.alreadyHit = undefined;
				mcClip.ans.txt.addEventListener(Event.CHANGE,textChangeEvent);
				ansArr = rawString.split("|");
				_rightAns = null;
			}
		}
		private function textChangeEvent(evt) {
			if (mcSubmit.alpha<1) {
				mcSubmit.buttonMode = true;
				mcSubmit.mouseChildren = false;
				mcSubmit.addEventListener(MouseEvent.CLICK,mcSubmitClickEvent);
			}
			mcSubmit.alpha = 1;
		}
		private function mcSubmitClickEvent(evt) {
			matchAnswer();
		}
		private function handleFocusIn(evt:FocusEvent) {
			if (evt.currentTarget.text.toLowerCase() == "answer") {
				focusEnabledForTextField = true;
				var tf:TextFormat = new TextFormat();
				tf.bold = true;
				evt.currentTarget.defaultTextFormat = tf;
				evt.currentTarget.text = "";
			}
		}
		public function matchAnswer():void {
			var enteredValues:String = String(mcClip.ans.txt.text).toLocaleLowerCase();
			if (ansArr.length>1) {
				enteredValues = checkcDoubleCase(rawString,enteredValues);
			}
			if (rawString.toLocaleLowerCase() == enteredValues) {
				XMLFunctions.mainReference.mcBunny.gotoAndPlay("right");
				XMLFunctions.activityLogic.findFrameLabel = "rightEnd";
				//XMLFunctions.activityLogic.questionIndex++;
				XMLFunctions.activityLogic.findLabel(XMLFunctions.mainReference.mcBunny);
				correctAns++;
				placeRightAnswer();
				playOrStopAnimation();
				XMLFunctions.performTest =false;
				focusEnabledForTextField = false;
			} else {
				if (numberOfAttempt == 0) {
					numberOfAttempt ++;
					XMLFunctions.mainReference.mcBunny.gotoAndPlay("wrong");
					XMLFunctions.activityLogic.findFrameLabel = "wrongEnd";
					XMLFunctions.activityLogic.findLabel(XMLFunctions.mainReference.mcBunny);
				} else {
					XMLFunctions.mainReference.mcBunny.gotoAndPlay("wrong2");
					XMLFunctions.activityLogic.findFrameLabel = "setAnswer";

					XMLFunctions.activityLogic.findLabel(XMLFunctions.mainReference.mcBunny);
					numberOfAttempt = 0;
					stopPreviousAnimation();
					XMLFunctions.performTest =false;
					focusEnabledForTextField = false;
				}
				//_rightAns = null;
			}
			mcSubmit.buttonMode = false;
			mcSubmit.removeEventListener(MouseEvent.CLICK,mcSubmitClickEvent);
			mcSubmit.alpha = .5;
		}
		private function checkcDoubleCase(_rawStr,_str) {
			var str = "";
			var _arr = _rawStr.split("|");
			for (var i=0; i<_arr.length; i++) {
				if (_arr[i].toLocaleLowerCase()==_str) {
					str = _str;
					_rightAns = _str;
					rawString = _str;
					break;
				}
			}
			return str;
		}
		public function stopPreviousAnimation():void {
			if (animationIndex > 0) {
				animationIndex --;
				MovieClip(XMLFunctions.activityLogic.animationArray[animationIndex]).gotoAndStop(1);
			}
		}
		public function returnAnimationStatus(mcClip:MovieClip,playOrStop:Number = 1):void {
			if (mcClip.currentFrame == 1) {
				if (playOrStop == 1) {
					mcClip.gotoAndStop(4);
				} else {
					mcClip.gotoAndPlay(2);
				}
			}
		}
		public function playOrStopAnimation():void {
			var previousClip:MovieClip;
			switch (correctAns) {
				case 2 :
					MovieClip(XMLFunctions.activityLogic.animationArray[0]).gotoAndStop(4);
					animationIndex = 1;
					break;
				case 3 :
					previousClip = MovieClip(XMLFunctions.activityLogic.animationArray[0]);
					returnAnimationStatus(previousClip);
					break;
				case 4 :
					previousClip = MovieClip(XMLFunctions.activityLogic.animationArray[0]);
					returnAnimationStatus(previousClip);
					MovieClip(XMLFunctions.activityLogic.animationArray[1]).gotoAndPlay(2);
					animationIndex = 2;
					break;
				case 5 :
					previousClip = MovieClip(XMLFunctions.activityLogic.animationArray[1]);
					returnAnimationStatus(previousClip, 0);
					break;
				case 6 :
					previousClip = MovieClip(XMLFunctions.activityLogic.animationArray[1]);
					returnAnimationStatus(previousClip, 0);

					MovieClip(XMLFunctions.activityLogic.animationArray[2]).gotoAndPlay(2);
					animationIndex = 3;
					break;
				case 7 :
					previousClip = MovieClip(XMLFunctions.activityLogic.animationArray[2]);
					returnAnimationStatus(previousClip, 0);
					break;
				case 8 :
					previousClip = MovieClip(XMLFunctions.activityLogic.animationArray[2]);
					returnAnimationStatus(previousClip, 0);
					MovieClip(XMLFunctions.activityLogic.animationArray[3]).gotoAndStop(4);
					animationIndex = 4;
					break;
				case 9 :
					previousClip = MovieClip(XMLFunctions.activityLogic.animationArray[3]);
					returnAnimationStatus(previousClip);
					break;
				case 10 :
					previousClip = MovieClip(XMLFunctions.activityLogic.animationArray[3]);
					returnAnimationStatus(previousClip);

					MovieClip(XMLFunctions.activityLogic.animationArray[4]).gotoAndStop(4);
					animationIndex = 5;
					break;
				case 9 :
					previousClip = MovieClip(XMLFunctions.activityLogic.animationArray[4]);
					returnAnimationStatus(previousClip);
					break;
				case 12 :
					previousClip = MovieClip(XMLFunctions.activityLogic.animationArray[4]);
					returnAnimationStatus(previousClip);

					MovieClip(XMLFunctions.activityLogic.animationArray[5]).gotoAndPlay(2);
					MovieClip(XMLFunctions.activityLogic.animationArray[6]).gotoAndPlay(2);
					animationIndex = 6;
					break;
				default :
					break;

			}
		}
		public function playFinalFeedback():void {
			mcClip.h.visible = false;
			mcClip.alreadyHit = undefined;
			var lessThanHalf:Number = ( totalQuestions / 2);
			if (correctAns < lessThanHalf) {
				XMLFunctions.mainReference.mcBunny.gotoAndPlay("candobetter");
			} else if (correctAns == totalQuestions) {
				XMLFunctions.mainReference.mcBunny.gotoAndPlay("marvellous");
			} else if (correctAns > lessThanHalf) {
				XMLFunctions.mainReference.mcBunny.gotoAndPlay("goodjob");
			}
		}
		public function placeRightAnswer():void {
			mcClip.ans.txt.type = "dynamic";
			mcClip.ans.txt.selectable = false;
			if (_rightAns) {
				mcClip.ans.txt.htmlText = "<b>"+_rightAns+"</b>";
			} else {
				mcClip.ans.txt.htmlText = String(XMLFunctions.XMLObject.framexml.data[0].text[currentIndex + 4]._innerData).toLowerCase().split("|")[0];
			}
			mcClip.mcH.gotoAndPlay(2);
			mcClip.gotoAndStop(3);
		}
		public function placeRightAnswer2():void {
			mcClip.ans.txt.type = "dynamic";
			mcClip.ans.txt.selectable = false;
			if (_rightAns) {
				mcClip.ans.txt.htmlText = "<b>"+_rightAns+"</b>";
			} else {
				mcClip.ans.txt.htmlText = String(XMLFunctions.XMLObject.framexml.data[0].text[currentIndex + 4]._innerData).toLowerCase().split("|")[0];
			}
			mcClip.gotoAndStop(3);
		}
		public function returnRightAns():String {
			return rawString;
		}
		private function strReplace(str:String, search:String, replace:String):String {
			return str.split(search).join(replace);
		}
	}
}