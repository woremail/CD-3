package org.sterco.utils{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	public class scrollBar extends MovieClip {
		private var _mcContent:MovieClip;
		private var _mcContentMask:MovieClip;
		private var _mcTimeLine:MovieClip;
		private var _mcSlider:MovieClip;
		private var _mcTrack:MovieClip;
		private var _mcUpBtn:MovieClip;
		private var _mcDownBtn:MovieClip;
		private var _useBtn:Boolean = false;
		private var _scrollObj:scrollBar;
		private var _nSliderClickDiff:Number;
		private var speed:Number = 20;
		private var _moveWheel:Boolean = false;
		private var mouseListener:Object = new Object();
		public function scrollBar() {
			_scrollObj = this;
		}
		public function init($timeLine:MovieClip, $content:MovieClip, $contentMask:MovieClip, $slider:MovieClip, $track:MovieClip, $upBtn:MovieClip, $downBtn:MovieClip, $allowWheel:Boolean) {
			_mcContentMask = $contentMask;
			_mcTimeLine = $timeLine;
			_mcContent= $content;
			_mcSlider = $slider;
			_mcTrack = $track;
			_moveWheel = $allowWheel;
			_mcSlider.y = _mcTrack.y;
			if (!(($upBtn == null) || ($downBtn == null))) {
				_mcDownBtn = $downBtn;
				_mcUpBtn   = $upBtn;
				_useBtn  = true;
			}
			enableScroller();
		}
		private function enableScroller() {
			_mcTrack.visible = true;
			_mcSlider.visible = true;
			_mcSlider.buttonMode = true;
			_mcSlider.addEventListener(MouseEvent.MOUSE_DOWN,startSlide);
			_mcTimeLine.stage.addEventListener(MouseEvent.MOUSE_UP,stopSlide);
			if (_useBtn) {
				_mcUpBtn.visible = true;
				_mcDownBtn.visible = true;
				_mcUpBtn.buttonMode = true;
				_mcDownBtn.buttonMode = true;
				_mcUpBtn.addEventListener(MouseEvent.CLICK,moveUp);
				_mcDownBtn.addEventListener(MouseEvent.CLICK,moveDown);
			}
			if (_moveWheel) {
				_mcContent.addEventListener(MouseEvent.MOUSE_OVER,fMouseOver);
				_mcContent.addEventListener(MouseEvent.MOUSE_OUT,fMouseOut);
			}
		}
		private function fMouseOver(evt) {
			_mcTimeLine.addEventListener(MouseEvent.MOUSE_WHEEL,wheelSlide);
		}
		private function fMouseOut(evt) {
			_mcTimeLine.removeEventListener(MouseEvent.MOUSE_WHEEL,wheelSlide);
		}
		private function disableScroller() {
			_mcUpBtn.visible = false;
			_mcTrack.visible = false;
			_mcSlider.visible = false;
			_mcDownBtn.visible = false;
		}
		private function startSlide(evt:MouseEvent) {
			_nSliderClickDiff = mouseY - _mcSlider.y;
			_mcTimeLine.addEventListener(MouseEvent.MOUSE_MOVE,keepSliding);
		}
		private function stopSlide(evt:MouseEvent) {
			_mcTimeLine.removeEventListener(MouseEvent.MOUSE_MOVE,keepSliding);
		}
		private function wheelSlide(evt:MouseEvent) {
			var top:Number = _scrollObj._mcTrack.y;
			var bottom:Number = _mcTrack.y + _mcTrack.height - _mcSlider.height;
			if (evt.delta > 1) {
				var moveVal:Number = (_mcContent.height-_mcContentMask.height)/(_mcTrack.height - _mcSlider.height);
				if (_mcContent.y + speed < _mcContentMask.y) {
					if (_mcSlider.y <= top) {
						_mcSlider.y = top;
					} else {
						_mcSlider.y -= speed/moveVal;
					}
					_mcContent.y += speed;
				} else {
					_mcSlider.y = top;
					_mcContent.y = _mcContentMask.y;
				}
			}
			if (evt.delta < 1) {
				var finalContentPos:Number = _mcContentMask.height-_mcContent.height+_mcContentMask.y;
				moveVal = (_mcContent.height-_mcContentMask.height)/(_mcTrack.height - _mcSlider.height);
				if ((_mcContent.y - speed) > finalContentPos) {
					if (_mcSlider.y >= bottom) {
						_mcSlider.y = bottom;
					} else {
						_mcSlider.y += speed/moveVal;
					}
					_mcContent.y -= speed;
				} else {
					_mcSlider.y = bottom;
					_mcContent.y = finalContentPos;
				}
			}
		}
		private function keepSliding(evt:MouseEvent) {
			var minY:Number = _mcTrack.y;
			var maxY:Number = _mcTrack.y + _mcTrack.height - _mcSlider.height;
			if (mouseY < minY + _nSliderClickDiff) {
				_mcSlider.y = minY;
			} else if (mouseY >= maxY + _nSliderClickDiff) {
				_mcSlider.y = maxY;
			} else {
				_mcSlider.y = mouseY - _nSliderClickDiff;
			}
			updateContentPosition();
		}
		private function moveUp(evt:MouseEvent) {
			var Speed:Number = 2;
			var minY:Number = _mcTrack.y;
			var maxY:Number = _mcTrack.y + _mcTrack.height - _mcSlider.height;
			if (_mcSlider.y - Speed < minY) {
				_mcSlider.y = minY;
			} else {
				_mcSlider.y = _mcSlider.y - Speed;
			}
			updateContentPosition();
		}
		private function moveDown(evt:MouseEvent) {
			var Speed:Number = 2;
			var minY:Number = _mcTrack.y;
			var maxY:Number = _mcTrack.y + _mcTrack.height - _mcSlider.height;
			if (_mcSlider.y + Speed >= maxY) {
				_mcSlider.y = maxY;
			} else {
				_mcSlider.y = _mcSlider.y + Speed;
			}
			updateContentPosition();
		}
		private function updateContentPosition() {
			var _scrollPercent:Number =  100 / (_mcTrack.height - _mcSlider.height)  * ( _mcSlider.y - _mcTrack.y);
			var newContentY:Number = _mcContentMask.y + (_mcContentMask.height - _mcContent.height) / 100 * _scrollPercent;
			_mcContent.y = newContentY;
		}
	}
}