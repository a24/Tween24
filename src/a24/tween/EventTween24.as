package a24.tween
{
	import a24.tween.events.Tween24Event;
	import a24.util.Util24;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2011.02.27
	 *
	 */
	public class EventTween24
	{
		/**
		 * EventTween24オブジェクトの mouseEventTweenType 値を normal に定義します。
		 */
		static public const TYPE_NORMAL:String = "normal";
		
		/**
		 * EventTween24オブジェクトの mouseEventTweenType 値を stop に定義します。
		 */
		static public const TYPE_STOP  :String = "stop";
		
		/**
		 * EventTween24オブジェクトの mouseEventTweenType 値を serial に定義します。
		 */
		static public const TYPE_SERIAL:String = "serial";
		
		/**
		 * EventTween24オブジェクトの mouseEventTweenType 値を jump に定義します。
		 */
		static public const TYPE_JUMP  :String = "jump";
		
		static private const _MOUSE_IN:String = "mouseIn";
		static private const _MOUSE_OUTSIDE:String = "mouseOutside";
		static private var _eventTween24ByTarget:Dictionary;
		
		private var _target:*;
		private var _stage:Stage;
		
		private var _rollOverTween       :Tween24;
		private var _rollOutTween        :Tween24;
		private var _mouseOverTween      :Tween24;
		private var _mouseOutTween       :Tween24;
		private var _mouseDownTween      :Tween24;
		private var _mouseUpTween        :Tween24;
		private var _clickTween          :Tween24;
		private var _addedToStageTween   :Tween24;
		private var _removeFromStageTween:Tween24;
		private var _syncAddChildTween   :Tween24;
		private var _syncRemoveChildTween:Tween24;
		private var _mouseInTween        :Tween24;
		private var _mouseOutsideTween   :Tween24;
		private var _eventTweens         :Array;
		
		private var _isRollOver          :Boolean;
		private var _isMouseOver         :Boolean;
		private var _isMouseDown         :Boolean;
		private var _isMouseIn           :Boolean;
		private var _isMouseOutside      :Boolean;
		private var _enabled             :Boolean;
		private var _mouseEventTweenType :String;
		private var _duplicateMouseTween :Boolean;
		
		/**
		 * @private
		 */
		public function EventTween24(target:*)
		{
			_eventTween24ByTarget        ||= new Dictionary();
			_target                        = target;
			_eventTween24ByTarget[_target] = this;
			_enabled                       = true;
			_mouseEventTweenType                = TYPE_NORMAL;
			_duplicateMouseTween = true;
			
			if (_target is DisplayObject) {
				if (!_target.stage) _target.addEventListener(Event.ADDED_TO_STAGE    , _onAdded);
				else                _target.addEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
			}
		}
		
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * 
		 * ADDED & REMOVED
		 * 
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		private function _onAdded(e:Event):void
		{
			_target.removeEventListener(Event.ADDED_TO_STAGE    , _onAdded);
			_target.addEventListener   (Event.REMOVED_FROM_STAGE, _onRemoved);
			
			if (_rollOverTween ) _target.addEventListener(MouseEvent.ROLL_OVER , onInMouseEvent);
			if (_rollOutTween  ) _target.addEventListener(MouseEvent.ROLL_OUT  , onOutMouseEvent);
			if (_mouseOverTween) _target.addEventListener(MouseEvent.MOUSE_OVER, onInMouseEvent);
			if (_mouseOutTween ) _target.addEventListener(MouseEvent.MOUSE_OUT , onOutMouseEvent);
			if (_mouseDownTween) _target.addEventListener(MouseEvent.MOUSE_DOWN, onInMouseEvent);
			if (_mouseUpTween  ) _target.addEventListener(MouseEvent.MOUSE_UP  , onOutMouseEvent);
			if (_clickTween    ) _target.addEventListener(MouseEvent.CLICK     , _onClick);
			if (_mouseInTween || _mouseOutsideTween) {
				_stage = _target.stage;
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			
			if (_addedToStageTween && _enabled) _addedToStageTween.play();
		}
		
		private function _onRemoved(e:Event):void
		{
			_target.addEventListener   (Event.ADDED_TO_STAGE    , _onAdded);
			_target.removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
			
			_target.removeEventListener(MouseEvent.ROLL_OVER , onInMouseEvent);
			_target.removeEventListener(MouseEvent.ROLL_OUT  , onOutMouseEvent);
			_target.removeEventListener(MouseEvent.MOUSE_OVER, onInMouseEvent);
			_target.removeEventListener(MouseEvent.MOUSE_OUT , onOutMouseEvent);
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, onInMouseEvent);
			_target.removeEventListener(MouseEvent.MOUSE_UP  , onOutMouseEvent);
			_target.removeEventListener(MouseEvent.CLICK     , _onClick);
			if (_stage) _stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			if (_addedToStageTween && _enabled) _removeFromStageTween.play();
		}
		
		
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * 
		 * DISPOSE
		 * 
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * メモリを解放します。
		 */
		public function dispose():void
		{
			for (var type:String in _eventTweens) {
				_target.removeEventListener(type, _onEvent);
				_target.removeEventListener(type, _onEventOnce);
				delete _eventTweens[type];
			}
			
			delete _eventTween24ByTarget[_target];
			
			if (_target is DisplayObject) {
				_target.removeEventListener(Event.ADDED_TO_STAGE    , _onAdded);
				_target.removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
				
				_target.removeEventListener(MouseEvent.ROLL_OVER , onInMouseEvent);
				_target.removeEventListener(MouseEvent.ROLL_OUT  , onOutMouseEvent);
				_target.removeEventListener(MouseEvent.MOUSE_OVER, onInMouseEvent);
				_target.removeEventListener(MouseEvent.MOUSE_OUT , onOutMouseEvent);
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, onInMouseEvent);
				_target.removeEventListener(MouseEvent.MOUSE_UP  , onOutMouseEvent);
				_target.removeEventListener(MouseEvent.CLICK     , _onClick);
				if (_stage) _stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				
				_target.buttonMode = false;
			}
			
			_enabled               = false;
			_isRollOver            = false;
			_isMouseOver           = false;
			_isMouseDown           = false;
			_isMouseIn             = false;
			_isMouseOutside        = false;
			
			_addedToStageTween     = null;
			_removeFromStageTween  = null;
			_rollOverTween         = null;
			_rollOutTween          = null;
			_mouseOverTween        = null;
			_mouseOutTween         = null;
			_mouseDownTween        = null;
			_mouseUpTween          = null;
			_mouseInTween          = null;
			_mouseOutsideTween     = null;
			_clickTween            = null;
			_eventTweens           = null;
			_mouseEventTweenType   = null;
			_stage                 = null;
			_target                = null;
		}
		
		
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * 
		 * MOUSE EVENT
		 * 
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * マウスイベントに合わせて再生するトゥイーンを設定します。
		 * @param tween トゥイーン
		 * @param type イベントタイプ
		 */
		public function setMouseEvent(tween:Tween24, type:String):Tween24
		{
			_target.buttonMode = _enabled;
			
			if (type == _MOUSE_IN || type == _MOUSE_OUTSIDE) {
				if (type == _MOUSE_IN) _mouseInTween      = tween;
				else                   _mouseOutsideTween = tween;
				
				if (_target.stage) {
					if (!_stage) {
						_stage = _target.stage;
						_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					}
				}
			}
			else{
				var handler:Function;
				switch (type) {
					case MouseEvent.ROLL_OVER : _rollOverTween  = tween; handler = onInMouseEvent;  break;
					case MouseEvent.ROLL_OUT  : _rollOutTween   = tween; handler = onOutMouseEvent; break;
					case MouseEvent.MOUSE_OVER: _mouseOverTween = tween; handler = onInMouseEvent;  break;
					case MouseEvent.MOUSE_OUT : _mouseOutTween  = tween; handler = onOutMouseEvent; break;
					case MouseEvent.MOUSE_DOWN: _mouseDownTween = tween; handler = onInMouseEvent;  break;
					case MouseEvent.MOUSE_UP  : _mouseUpTween   = tween; handler = onOutMouseEvent; break;
					case MouseEvent.CLICK     : _clickTween     = tween; handler = _onClick;        break;
				}
				
				if (_target.stage) _target.addEventListener(type, handler);
			}
			
			return tween;
		}
		
		/**
		 * マウスイベントに合わせて再生するトゥイーンを解除します。
		 * @param type イベントタイプ
		 */
		public function removeMouseEvent(type:String):void
		{
			var handler:Function;
			switch (type) {
				case MouseEvent.ROLL_OVER : _rollOverTween  = null; handler = onInMouseEvent;  break;
				case MouseEvent.ROLL_OUT  : _rollOutTween   = null; handler = onOutMouseEvent; break;
				case MouseEvent.MOUSE_OVER: _mouseOverTween = null; handler = onInMouseEvent;  break;
				case MouseEvent.MOUSE_OUT : _mouseOutTween  = null; handler = onOutMouseEvent; break;
				case MouseEvent.MOUSE_DOWN: _mouseDownTween = null; handler = onInMouseEvent;  break;
				case MouseEvent.MOUSE_UP  : _mouseUpTween   = null; handler = onOutMouseEvent; break;
				case MouseEvent.CLICK     : _clickTween     = null; handler = _onClick;        break;
			}
			
			if (!_rollOverTween && !_rollOutTween && !_mouseOverTween && !_mouseOutTween &&
				!_mouseDownTween && !_mouseUpTween && !_clickTween) _target.buttonMode = false;
			
			if (_target.stage) _target.removeEventListener(type, handler);
		}
		
		
		
		// ==================================================
		//
		// In MouseEvent
		//
		// --------------------------------------------------
		
		private function onInMouseEvent(e:MouseEvent):void
		{
			if (!_enabled) return;
			
			var inTween:Tween24;
			var outTween:Tween24;
			
			switch (e.type) {
				case MouseEvent.ROLL_OVER : inTween = _rollOverTween;  outTween = _rollOutTween;  _isRollOver  = true; break;
				case MouseEvent.MOUSE_OVER: inTween = _mouseOverTween; outTween = _mouseOutTween; _isMouseOver = true; break;
				case MouseEvent.MOUSE_DOWN: inTween = _mouseDownTween; outTween = _mouseUpTween;  _isMouseDown = true; break;
			}
			
			if (!_duplicateMouseTween && inTween.playing) return;
			
			if ((_mouseEventTweenType == TYPE_STOP || _mouseEventTweenType == TYPE_SERIAL) && outTween) {
				outTween.stop();
			}
			if (inTween.playing) {
				inTween.stop();
				inTween.removeEventListener(Tween24Event.COMPLETE, onInTweenComplete);
			}
			inTween.play();
		}
		
		
		
		// ==================================================
		//
		// Out MouseEvent
		//
		// --------------------------------------------------
		
		private function onOutMouseEvent(e:MouseEvent):void
		{
			if (!_enabled) return;
			
			var inTween:Tween24;
			var outTween:Tween24;
			
			switch (e.type) {
				case MouseEvent.ROLL_OUT : inTween = _rollOverTween;  outTween = _rollOutTween;  _isRollOver  = false; break;
				case MouseEvent.MOUSE_OUT: inTween = _mouseOverTween; outTween = _mouseOutTween; _isMouseOver = false; break;
				case MouseEvent.MOUSE_UP : inTween = _mouseDownTween; outTween = _mouseUpTween;  _isMouseDown = false; break;
			}
			
			// Stop and Play
			if (_mouseEventTweenType == TYPE_STOP && inTween) {
				inTween.stop();
				outTween.play();
			}
			// Complete and Play
			else if (_mouseEventTweenType == TYPE_SERIAL && inTween && inTween.playing) {
				inTween.addEventListener(Tween24Event.COMPLETE, onInTweenComplete);
			}
			// Jump and Play
			else if (_mouseEventTweenType == TYPE_JUMP && inTween && inTween.playing) {
				inTween.addEventListener(Tween24Event.COMPLETE, onInTweenComplete);
				inTween.skip();
			}
			// Play
			else {
				if (outTween.playing) outTween.stop();
				outTween.play();
			}
		}
		
		
		
		// ==================================================
		//
		// OutTween Complete
		//
		// --------------------------------------------------
		
		private function onInTweenComplete(e:Tween24Event):void
		{
			var inTween:Tween24;
			var outTween:Tween24;
			
			switch (e.tween) {
				case _rollOverTween : inTween = _rollOverTween;  outTween = _rollOutTween;  break;
				case _mouseOverTween: inTween = _mouseOverTween; outTween = _mouseOutTween; break;
				case _mouseDownTween: inTween = _mouseDownTween; outTween = _mouseUpTween;  break;
			}
			
			if (inTween) inTween.removeEventListener(Event.COMPLETE, onInTweenComplete);
			if (outTween) {
				if (outTween.playing) outTween.stop();
				outTween.play();
			}
		}
		
		
		
		// ==================================================
		//
		// Click
		//
		// --------------------------------------------------
		
		private function _onClick(e:MouseEvent):void
		{
			if (!_enabled) return;
			if (_clickTween.playing) _clickTween.stop();
			_clickTween.play();
		}
		
		
		
		// ==================================================
		//
		// MouseMove
		//
		// --------------------------------------------------
		
		private function onMouseMove(e:MouseEvent):void
		{
			var t:DisplayObject = _target as DisplayObject;
			var rect:Rectangle = t.getBounds(t);
			if (rect.contains(t.mouseX, t.mouseY)) {
				_isMouseOutside = false;
				if (!_isMouseIn) {
					_isMouseIn = true;
					if (_mouseInTween) _mouseInTween.play()
				}
			}
			else {
				if (_isMouseIn && !_isMouseOutside) {
					_isMouseOutside = true;
					if (_mouseOutsideTween) _mouseOutsideTween.play()
				}
				_isMouseIn = false;
			}
		}
		
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * 
		 * EVENT
		 * 
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * イベントに合わせて再生するトゥイーンを設定します。
		 * @param type イベントタイプ
		 * @param tween トゥイーン
		 * @param once イベントを受信して1回トゥイーンを再生した後、イベントリスナーを解除するか
		 */
		public function setEvent(type:String, tween:Tween24 = null, once:Boolean = false):void
		{
			_eventTweens ||= [];
			_eventTweens[type] = tween;
			if (tween) _target.addEventListener   (type, (once)? _onEventOnce: _onEvent);
			else       _target.removeEventListener(type, (once)? _onEventOnce: _onEvent);
		}
		
		private function _onEvent(e:*):void
		{
			if (!_enabled) return;
			var tween:Tween24 = _eventTweens[e.type];
			if (tween.playing) tween.stop();
			tween.play();
		}
		
		private function _onEventOnce(e:*):void
		{
			if (!_enabled) return;
			_target.removeEventListener(e.type, _onEventOnce);
			var tween:Tween24 = _eventTweens[e.type];
			if (tween.playing) tween.stop();
			tween.play();
		}
		
		
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * 
		 * GETTER & SETTER
		 * 
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * 対象オブジェクトです。
		 */
		public function get target():Object { return _target; }
		
		/**
		 * ロルオーバーイベント受信時に再生されるトゥイーンです。
		 */
		public function get rollOverTween():Tween24 { return _rollOverTween; }
		
		/**
		 * ロルアウトイベント受信時に再生されるトゥイーンです。
		 */
		public function get rollOutTween():Tween24 { return _rollOutTween; }
		
		/**
		 * マウスオーバーイベント受信時に再生されるトゥイーンです。
		 */
		public function get mouseOverTween():Tween24 { return _mouseOverTween; }
		
		/**
		 * マウスアウトイベント受信時に再生されるトゥイーンです。
		 */
		public function get mouseOutTween():Tween24 { return _mouseOutTween; }
		
		/**
		 * マウスダウンイベント受信時に再生されるトゥイーンです。
		 */
		public function get mouseDownTween():Tween24 { return _mouseDownTween; }
		
		/**
		 * マウスアウトイベント受信時に再生されるトゥイーンです。
		 */
		public function get mouseUpTween():Tween24 { return _mouseUpTween; }
		
		/**
		 * クリックイベント受信時に再生されるトゥイーンです。
		 */
		public function get clickTween():Tween24 { return _clickTween; }
		
		/**
		 * ステージ上の表示リストに追加されたイベント受信時に再生されるトゥイーンです。
		 */
		public function get addedToStageTween():Tween24 { return _addedToStageTween; }
		
		/**
		 * ステージ上の表示リストから削除されたイベント受信時に再生されるトゥイーンです。
		 */
		public function get removeFromStageTween():Tween24 { return _removeFromStageTween; }
		
		/**
		 * 表示リストに追加されたイベント受信時に再生されるトゥイーンです。
		 */
		public function get addChildSyncTween():Tween24 { return _syncAddChildTween; }
		
		/**
		 * 表示リストから削除されたイベント受信時に再生されるトゥイーンです。
		 */
		public function get removeChildSyncTween():Tween24 { return _syncRemoveChildTween; }
		
		/**
		 * ロルオーバー中かどうかを取得します。
		 */
		public function get isRollOver():Boolean { return _isRollOver; }
		
		/**
		 * ロルアウト中かどうかを取得します。
		 */
		public function get isMouseOver():Boolean { return _isMouseOver; }
		
		/**
		 * マウスダウン中かどうかを取得します。
		 */
		public function get isMouseDown():Boolean { return _isMouseDown; }
		
		/**
		 * イベントトゥイーンを有効にするか。
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void { _enabled = value; }
		
		/**
		 * マウスイベントのトゥイーンタイプです。
		 */
		public function get mouseEventTweenType():String { return _mouseEventTweenType; }
		public function set mouseEventTweenType(value:String):void { _mouseEventTweenType = value; }
		
		/**
		 * @private
		 * トゥイーンの同時再生を制御します。
		 */
		public function get duplicateMouseTween():Boolean { return _duplicateMouseTween; }
		public function set duplicateMouseTween(value:Boolean):void { _duplicateMouseTween = value; }
		
		
		
		
		
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * 
		 * STATIC PUBLIC
		 * 
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * ロルオーバーイベントに実行するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param ...serialTween トゥイーン
		 * @return Tween24
		 */
		static public function onRollOver(target:InteractiveObject, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target).setMouseEvent(tween, MouseEvent.ROLL_OVER);
			return tween;
		}
		
		/**
		 * ロルアウトイベントに実行するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param ...serialTween トゥイーン
		 * @return Tween24
		 */
		static public function onRollOut(target:InteractiveObject, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target).setMouseEvent(tween, MouseEvent.ROLL_OUT);
			return tween;
		}
		
		/**
		 * マウスオーバーイベントに実行するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param ...serialTween トゥイーン
		 * @return Tween24
		 */
		static public function onMouseOver(target:InteractiveObject, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target).setMouseEvent(tween, MouseEvent.MOUSE_OVER);
			return tween;
		}
		
		/**
		 * マウスアウトイベントに実行するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param ...serialTween トゥイーン
		 * @return Tween24
		 */
		static public function onMouseOut(target:InteractiveObject, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target).setMouseEvent(tween, MouseEvent.MOUSE_OUT);
			return tween;
		}
		
		/**
		 * マウスダウンイベントに実行するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param ...serialTween トゥイーン
		 * @return Tween24
		 */
		static public function onMouseDown(target:InteractiveObject, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target).setMouseEvent(tween, MouseEvent.MOUSE_DOWN);
			return tween;
		}
		
		/**
		 * マウスアップイベントに実行するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param ...serialTween トゥイーン
		 * @return Tween24
		 */
		static public function onMouseUp(target:InteractiveObject, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target).setMouseEvent(tween, MouseEvent.MOUSE_UP);
			return tween;
		}
		
		/**
		 * クリックイベントに実行するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param ...serialTween トゥイーン
		 * @return Tween24
		 */
		static public function onClick(target:InteractiveObject, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target).setMouseEvent(tween, MouseEvent.CLICK);
			return tween;
		}
		
		/**
		 * クリックイベントに開くURLを設定します。
		 * @param target 対象オブジェクト
		 * @param url リンク先URL
		 * @param window ターゲットウィンド
		 * @return Tween24
		 */
		static public function onClickAndGetURL(target:InteractiveObject, url:String, window:String = "_self"):Tween24
		{
			var tween:Tween24 = Tween24.getURL(url, window);
			getInstance(target).setMouseEvent(tween, MouseEvent.CLICK);
			return tween;
		}
		
		/**
		 * ステージ上の表示リストに追加されたときのイベントに実行するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param ...serialTween トゥイーン
		 * @return
		 */
		static public function onAddedToStage(target:DisplayObject, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target)._addedToStageTween = tween;
			return tween;
		}
		
		/**
		 * ステージ上の表示リストから削除されたときのイベントに実行するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param ...serialTween トゥイーン
		 * @return
		 */
		static public function onRemoveFromStage(target:DisplayObject, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target)._removeFromStageTween = tween;
			return tween;
		}
		
		/**
		 * 表示リストに追加されたときのイベントに実行するトゥイーンを設定します。
		 * Tween24 の addChild 系のメソッドを使うことでトゥイーンを同期できます。
		 * @param target 対象オブジェクト
		 * @param ...serialTween トゥイーン
		 * @return
		 */
		static public function syncAddChild(target:DisplayObject, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target)._syncAddChildTween = tween;
			return tween;
		}
		
		/**
		 * 表示リストから削除されたときのイベントに実行するトゥイーンを設定します。
		 * Tween24 の removeChild 系のメソッドを使うことでトゥイーンを同期できます。
		 * @param target 対象オブジェクト
		 * @param ...serialTween トゥイーン
		 * @return
		 */
		static public function syncRemoveChild(target:DisplayObject, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target)._syncRemoveChildTween = tween;
			return tween;
		}
		
		static public function onMouseIn(target:DisplayObject, ...serialTween):Tween24
		{
			return getInstance(target).setMouseEvent(Tween24.serial(serialTween), _MOUSE_IN);
		}
		
		static public function onMouseOutside(target:DisplayObject, ...serialTween):Tween24
		{
			return getInstance(target).setMouseEvent(Tween24.serial(serialTween), _MOUSE_OUTSIDE);
		}
		
		/**
		 * イベントに実行するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param type イベントタイプ
		 * @param ...serialTween トゥイーン
		 * @return Tween24
		 */
		static public function onEvent(target:Object, type:String, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target).setEvent(type, tween);
			return tween;
		}
		
		/**
		 * イベントに一度だけ実行するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param type イベントタイプ
		 * @param ...serialTween トゥイーン
		 * @return Tween24
		 */
		static public function onEventOnce(target:Object, type:String, ...serialTween):Tween24
		{
			var tween:Tween24 = Tween24.serial.apply(Tween24.serial, serialTween);
			getInstance(target).setEvent(type, tween, true);
			return tween;
		}
		
		
		
		// =============================================================================
		//
		// Remove Event
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 設定したロルオーバーイベントを解除します。
		 * @param target 対象オブジェクト
		 */
		static public function removeRollOverTween(target:Object):void { getInstance(target).removeMouseEvent(MouseEvent.ROLL_OVER); }
		
		/**
		 * 設定したロルアウトイベントを解除します。
		 * @param target 対象オブジェクト
		 */
		static public function removeRollOutTween(target:Object):void { getInstance(target).removeMouseEvent(MouseEvent.ROLL_OUT); }
		
		/**
		 * 設定したマウスオーバーイベントを解除します。
		 * @param target 対象オブジェクト
		 */
		static public function removeMouseOverTween(target:Object):void { getInstance(target).removeMouseEvent(MouseEvent.MOUSE_OVER); }
		
		/**
		 * 設定したマウスアウトイベントを解除します。
		 * @param target 対象オブジェクト
		 */
		static public function removeMouseOutTween(target:Object):void { getInstance(target).removeMouseEvent(MouseEvent.MOUSE_OUT); }
		
		/**
		 * 設定したマウスダウンイベントを解除します。
		 * @param target 対象オブジェクト
		 */
		static public function removeMouseDownTween(target:Object):void { getInstance(target).removeMouseEvent(MouseEvent.MOUSE_DOWN); }
		
		/**
		 * 設定したマウスアップイベントを解除します。
		 * @param target 対象オブジェクト
		 */
		static public function removeMouseUpTween(target:Object):void { getInstance(target).removeMouseEvent(MouseEvent.MOUSE_UP); }
		
		/**
		 * 設定したクリックイベントを解除します。
		 * @param target 対象オブジェクト
		 */
		static public function removeClickTween(target:Object):void { getInstance(target).removeMouseEvent(MouseEvent.CLICK); }
		
		/**
		 * 設定したイベントトゥイーンを解除します。
		 * @param target 対象オブジェクト
		 * @param eventType	イベントタイプ
		 */
		static public function removeEventTween(target:Object, eventType:String):void { getInstance(target).setEvent(eventType); }
		
		
		
		// =============================================================================
		//
		// Other
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 設定したイベントトゥイーンの実行を許可するか設定します。
		 * @param enabled 許可するかどうか
		 * @param ...targets 対象オブジェクト
		 * @return
		 */
		static public function enabled(enabled:Boolean, ...targets):void
		{
			targets = Util24.array.compressAndClean(targets);
			
			var evtTween:EventTween24;
			for each (var tar:Object in targets) {
				evtTween = getInstance(tar) || new EventTween24(tar);
				evtTween.enabled = enabled;
				tar.buttonMode = enabled;
			}
		}
		
		/**
		 * マウスイベントのトゥイーンタイプを設定します。
		 * @param type トゥイーンタイプ
		 * @param ...targets 対象オブジェクト
		 */
		static public function setMouseEventTweenType(type:String, ...targets):void
		{
			targets = Util24.array.compressAndClean(targets);
			
			var evtTween:EventTween24;
			for each (var tar:Object in targets) {
				evtTween = getInstance(tar) || new EventTween24(tar);
				evtTween._mouseEventTweenType = type;
			}
		}
		
		/**
		 * 設定したイベントリスナーを全て解除し、インスタンスを破棄します。
		 * @param ...targets 対象オブジェクト
		 */
		static public function dispose(...targets):void
		{
			if (!_eventTween24ByTarget) return;
			targets = Util24.array.compressAndClean(targets);
			
			for each (var tar:Object in targets) {
				var instance:EventTween24 = _eventTween24ByTarget[tar];
				if (instance) instance.dispose();
			}
		}
		
		/**
		 * 指定したコンテナと、コンテナより下の階層にある全てのオブジェクトのイベントリスナーを解除し、インスタンスを破棄します。
		 * @param ...containers	対象コンテナ
		 */
		static public function disposeFullChildren(...containers):void
		{
			if (!_eventTween24ByTarget) return;
			containers = Util24.array.compressAndClean(containers);
			
			var instance:EventTween24;
			for (var target:Object in _eventTween24ByTarget) {
				for each (var container:DisplayObjectContainer in containers) {
					if (target is DisplayObject) {
						if (container.contains(DisplayObject(target))) {
							instance = _eventTween24ByTarget[target];
							if (instance) instance.dispose();
						}
					}
					instance = _eventTween24ByTarget[container];
					if (instance) instance.dispose();
				}
			}
		}
		
		/**
		 * イベントトゥイーンが設定されている EventTween24 インスタンスを取得します。
		 * @param	target	イベントターゲット
		 * @return	EventTween24
		 */
		static public function getInstance(target:Object):EventTween24
		{
			return (_eventTween24ByTarget)? _eventTween24ByTarget[target] || new EventTween24(target) : new EventTween24(target);
		}
		
		/**
		 * @private
		 * @param	target
		 * @return
		 */
		static public function hasInstance(target:Object):EventTween24
		{
			return (_eventTween24ByTarget)? _eventTween24ByTarget[target]: null;
		}
	}
}