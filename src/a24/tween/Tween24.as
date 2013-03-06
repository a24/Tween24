/*
 * 
 * Tween24 2.1α
 * Copyright (c) 2010-2013 Atsushi Kaga (http://package.a24.cat/)
 * 
 * 
 * Licensed under the MIT License
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */

package a24.tween
{	
	import a24.tween.core.plugins.PluginTween24Property;
	import a24.tween.core.plugins.PulginTween24;
	import a24.tween.core.updaters.ObjectUpdater;
	import a24.tween.core.updaters.colors.BrightUpdater;
	import a24.tween.core.updaters.colors.ColorReversalUpdater;
	import a24.tween.core.updaters.colors.ColorUpdater;
	import a24.tween.core.updaters.colors.ContrastUpdater;
	import a24.tween.core.updaters.display.DisplayObjectUpdater;
	import a24.tween.core.updaters.display.TimelineUpdater;
	import a24.tween.core.updaters.filters.BlurFilterUpdater;
	import a24.tween.core.updaters.filters.DropShadowFilterUpdater;
	import a24.tween.core.updaters.filters.GlowFilterUpdater;
	import a24.tween.core.updaters.filters.SaturationUpdater;
	import a24.tween.core.updaters.filters.SharpUpdater;
	import a24.tween.events.Tween24Event;
	import a24.tween.plugins.proxy.PluginProxy;
	import a24.util.Align24;
	import a24.util.Util24;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	/**
	 * トゥイーン再生時に送出されます。
	 */
	[Event(name = "play", type = "a24.tween.events.Tween24Event")]
	
	/**
	 * トゥイーン遅延中に送出されます。
	 */
	[Event(name = "delay", type = "a24.tween.events.Tween24Event")]
	
	/**
	 * トゥイーン開始時に送出されます。
	 */
	[Event(name = "init", type = "a24.tween.events.Tween24Event")]
	
	/**
	 * トゥイーン一時停止時に送出されます。
	 */
	[Event(name = "pause", type = "a24.tween.events.Tween24Event")]
	
	/**
	 * トゥイーンスキップ時に送出されます。
	 */
	[Event(name = "skip", type = "a24.tween.events.Tween24Event")]
	
	/**
	 * トゥイーン停止時に送出されます。
	 */
	[Event(name = "stop", type = "a24.tween.events.Tween24Event")]
	
	/**
	 * トゥイーン実行中に送出されます。
	 */
	[Event(name = "update", type = "a24.tween.events.Tween24Event")]
	
	/**
	 * トゥイーン完了時に送出されます。
	 */
	[Event(name = "complete", type = "a24.tween.events.Tween24Event")]
	
	
	/**
	 *
	 * @author Atsushi Kaga
	 * @version 2.0.1+
	 * @since 2010.10.30
	 * @see http://package.a24.cat/tween24/
	 *
	 */
	public class Tween24 implements IEventDispatcher
	{
		// =============================================================================
		//
		// Static
		//
		// -----------------------------------------------------------------------------
		
		static public const VERSION:String = "2.1α";
		
		static private var _numTotalTween      :int;
		static private var _numPlayingTween    :int;
		static private var _numPlayedTween     :int;
		static private var _numTotalManualTween:int;
		
		static private var _engine         :Sprite;
		static private var _runing         :Boolean;
		static private var _stage          :Stage;
		static private var _globalTimeScale:Number;
		static private var _debugMode      :Boolean;
		
		static private var _ease:Ease24            = new Ease24();
		static private var _defaultEasing:Function = Ease24._Linear;
		static private var _plugin:PluginProxy     = new PluginProxy();
		static private var _aligin:Align24         = new Align24();
		static private var _nowTime:Number;
		
		// Tweens
		static private var _tweensById           :Array;
		static private var _tweensByGroup        :Array;
		static private var _playingTweensByTarget:Dictionary;
		static private var _pausingTweensByTarget:Dictionary;
		static private var _pausingAllTweens     :Dictionary;
		static private var _manualTweens         :Dictionary;
		static private var _firstTween           :Tween24;
		static private var _endTween             :Tween24;
		
		// Type
		static private const _TYPE_TWEEN         :String = "tween";
		static private const _TYPE_SERIAL        :String = "serial";
		static private const _TYPE_PARALLEL      :String = "parallel";
		static private const _TYPE_LOOP          :String = "loop";
		static private const _TYPE_LAG           :String = "lag";
		static private const _TYPE_PROP          :String = "prop";
		static private const _TYPE_WAIT          :String = "wait";
		static private const _TYPE_JUMP          :String = "jump";
		static private const _TYPE_TWEEN_FUNC    :String = "tweenFunc";
		static private const _TYPE_IF_CASE       :String = "ifCase";
		static private const _TYPE_TWEEN_COUNT   :String = "tweenCount";
		static private const _TYPE_WAIT_COUNT    :String = "waitCount";
		static private const _TYPE_FUNC_COUNT    :String = "funcCount";
		
		static private const _TYPE_ACTION       :String = "action";
		static private const _TYPE_FUNC         :String = "func";
		static private const _TYPE_FUNC_AND_WAIT:String = "funcAndWait";
		static private const _TYPE_WAIT_EVENT   :String = "waitEvent";
		static private const _TYPE_ALL_PAUSE    :String = "pauseAllTweens";
		static private const _TYPE_RANDOM       :String = "randome";
		
		// Debug
		static private const _TRACE_PLAY  :Boolean = false;
		static private const _TRACE_PAUSE :Boolean = false;
		static private const _TRACE_STOP  :Boolean = false;
		static private const _TRACE_INIT  :Boolean = false;
		static private const _TRACE_UPDATE:Boolean = false;
		static private const _TRACE_NEXT  :Boolean = false;
		static private const _TRACE_REMOVE:Boolean = false;
		
		
		// =============================================================================
		//
		// Private
		//
		// -----------------------------------------------------------------------------
		
		// Params
		private var _target        :Array;
		private var _targetSingle  :Object;
		private var _time          :Number;
		private var _easing        :Function;
		private var _totalTime     :Number;
		private var _delayTime     :Number;
		private var _startTime     :Number;
		private var _completeTime  :Number;
		private var _timeScale     :Number;
		private var _totalTimeScale:Number;
		private var _progress      :Number;
		private var _progressDelay :Number;
		private var _uniqueId      :int;
		private var _uniquePlayId  :int;
		private var _manualPlayId  :int;
		
		// Single
		private var _type          :String;
		private var _actionName    :String;
		private var _loopCount     :int;
		private var _loopCurrent   :int;
		private var _serialTween   :Tween24;
		private var _parallelTweens:Array;
		private var _randomTween   :Tween24;
		private var _randomTweens  :Array;
		private var _action        :Function;
		private var _id            :String;
		private var _group         :Array;
		private var _level         :int;
		private var _velocity      :Number;
		
		private var _numChildren        :int;
		private var _numCompleteChildren:int;
		
		private var _prevList:Tween24;
		private var _nextList:Tween24;
		
		// Flag
		private var _parentTrigger  :Boolean;
		private var _playing        :Boolean;
		private var _delaying       :Boolean;
		private var _pausing        :Boolean;
		private var _inited         :Boolean;
		private var _played         :Boolean;
		private var _completed      :Boolean;
		private var _skipped        :Boolean;
		private var _actioned       :Boolean;
		private var _nextTweenPlayed:Boolean;
		private var _isJump         :Boolean;
		private var _isFilter       :Boolean;
		private var _isRemoveParent :Boolean;
		private var _isDebug        :Boolean;
		
		// Tween
		private var _nextTween         :Tween24;
		private var _rootTween         :Tween24;
		private var _parentTween       :Tween24;
		private var _playingChildTweens:Dictionary;
		private var _pausingChildTweens:Dictionary;
		
		// Event
		private var _eventDispatcher   :EventDispatcher;
		private var _dispatchPlay      :Boolean;
		private var _dispatchDelay     :Boolean;
		private var _dispatchInit      :Boolean;
		private var _dispatchPause     :Boolean;
		private var _dispatchSkip      :Boolean;
		private var _dispatchStop      :Boolean;
		private var _dispatchUpdate    :Boolean;
		private var _dispatchComplete  :Boolean;
		
		
		// =============================================================================
		//
		// Tween Prop
		//
		// -----------------------------------------------------------------------------
		
		// Event Handler
		private var _onPlay      :Function;
		private var _onPlayArgs  :Array;
		private var _onDelay     :Function;
		private var _onDelayArgs :Array;
		private var _onInit      :Function;
		private var _onInitArgs  :Array;
		private var _onUpdate    :Function;
		private var _onUpdateArgs:Array;
		private var _onPause     :Function;
		private var _onPauseArgs :Array;
		private var _onSkip      :Function;
		private var _onSkipArgs  :Array;
		private var _onStop      :Function;
		private var _onStopArgs  :Array;
		private var _onComp      :Function;
		private var _onCompArgs  :Array;
		
		// Updater
		private var _displayUpdater :DisplayObjectUpdater;
		private var _displayUpdaters:Dictionary;
		private var _objectUpdater  :ObjectUpdater;
		private var _objectUpdaters :Dictionary;
		
		// FilterUpdater
		private var _blurUpdater       :BlurFilterUpdater;
		private var _blurUpdaters      :Dictionary;
		private var _glowUpdater       :GlowFilterUpdater;
		private var _glowUpdaters      :Dictionary;
		private var _dropShadowUpdater :DropShadowFilterUpdater;
		private var _dropShadowUpdaters:Dictionary;
		
		// SpecialUpdater
		private var _brightUpdater        :BrightUpdater;
		private var _brightUpdaters       :Dictionary;
		private var _contrastUpdater      :ContrastUpdater;
		private var _contrastUpdaters     :Dictionary;
		private var _colorUpdater         :ColorUpdater;
		private var _colorUpdaters        :Dictionary;
		private var _saturationUpdater    :SaturationUpdater;
		private var _saturationUpdaters   :Dictionary;
		private var _timelineUpdater      :TimelineUpdater;
		private var _timelineUpdaters     :Dictionary;
		private var _colorReversalUpdater :ColorReversalUpdater;
		private var _colorReversalUpdaters:Dictionary;
		private var _sharpUpdater         :SharpUpdater;
		private var _sharpUpdaters        :Dictionary;
		
		// Wait Event
		private var _dispatcher:IEventDispatcher;
		private var _eventType :String;
		
		// Tween Func
		private var _tweenFunc     :Function;
		private var _tweenStartArgs:Array;
		private var _tweenDeltaArgs:Array;
		private var _tweenCompArgs :Array;
		
		// If Case
		private var _useIfCase       :Boolean;
		private var _ifCaseChildTween:Tween24;
		private var _ifCaseTrueTween :Tween24;
		private var _ifCaseFalseTween:Tween24;
		private var _ifCaseBoolean   :Boolean;
		
		// If Case by Prop
		private var _ifCaseTarget  :Object;
		private var _ifCasePropName:String;
		
		// Plugin
		private var _pluginProperty:PluginTween24Property;
		
		// Manual
		private var _isManual:Boolean;
		
		// Count
		private var _totalCount  :int;
		private var _currentCount:int;
		private var _delayCount  :int;
		private var _delayCurrentCount:int;
		
		
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * CONSTRUCTOR
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * Tween24インスタンスを生成します。
		 * @param target ターゲット
		 * @param time 時間
		 * @param easing イージング
		 * @param params パラメータ
		 */
		public function Tween24(target:* = null, time:Number = 0, easing:Function = null, params:Object = null)
		{
			if (target is Array) _target       = target.concat();
			else                 _targetSingle = target;
			
			_time           = time;
			_easing         = easing || _defaultEasing;
			_delayTime      = 0;
			_totalTime      = _time;
			_progress       = 0;
			_progressDelay  = 0;
			_timeScale      = 1;
			_totalTimeScale = 1;
			
			_uniqueId = _numTotalTween;
			_numTotalTween ++;
			
			// Object updater
			if (params) {
				if (_targetSingle) {
					_objectUpdater = new ObjectUpdater(_targetSingle);
					_objectUpdater.setProp(params);
				}
				else {
					_objectUpdaters = new Dictionary();
					for each(var t:* in _target) {
						var updater:ObjectUpdater = new ObjectUpdater(t);
						updater.setProp(params);
						_objectUpdaters[t] = updater;
					}
				}
			}
			
			// Plugin
			if (target is PluginTween24Property) {
				_pluginProperty = target as PluginTween24Property;
			}
			
			// Init
			if (!_engine) {
				_engine                = new Sprite();
				_pausingAllTweens      = new Dictionary();
				_tweensById            = [];
				_tweensByGroup         = [];
				_playingTweensByTarget = new Dictionary();
				_pausingTweensByTarget = new Dictionary();
				_manualTweens          = new Dictionary();
				_globalTimeScale     ||= 1;
			}
		}
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * PLAY
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * トゥイーンを再生します。
		 */
		public function play(debugMode:Boolean = false):void
		{
			_isDebug = debugMode;
			_rootTween           = this;
			_parentTween         = null;
			
			// Plugin
			if (_pluginProperty) _pluginProperty.atPlay();
			
			// Time
			if (!_firstTween) _nowTime = getTimer();
			
			play2();
		}
		
		/**
		 * トゥイーンを手動モードで再生します。manualUpdate()を呼び出すことで任意のタイミングでトゥイーンをアップデートします。
		 */
		public function manualPlay():void
		{
			if (_playing) return;
			
			_isManual = true;
			_manualPlayId = _numTotalManualTween;
			_manualTweens[_manualPlayId] = this;
			_numTotalManualTween ++;
			play();
		}
		
		private function play2():void
		{
			if (_TRACE_PLAY) trace( "Tween24.play2", this );
			
			if (_playing) stop2();
			if (!_pausing) _numCompleteChildren = 0;
			
			_playing = true;
			_skipped = false;
			_completed = false;
			_uniquePlayId = _numPlayedTween;
			_numPlayingTween ++;
			_numPlayedTween ++;
			
			// Set parent tween
			if (!_rootTween) {
				_level = 0;
				if (_parentTween) _rootTween = _parentTween._rootTween || _parentTween;
			}
			
			// Add to PlayingTweens
			if (_targetSingle) {
				_playingTweensByTarget[_targetSingle] ||= new Dictionary();
				_playingTweensByTarget[_targetSingle][_uniquePlayId] = this;
			}
			else {
				for each (var tar:Object in _target)  {
					_playingTweensByTarget[tar] ||= new Dictionary();
					_playingTweensByTarget[tar][_uniquePlayId] = this;
				}
			}
			
			// If child tween
			if (_parentTween) {
				_level = _parentTween._level + 1;
				_parentTween._playingChildTweens ||= new Dictionary();
				_parentTween._playingChildTweens[_uniquePlayId] = this;
			}
			
			// Resume pausing tween
			if (_pausing) {
				_pausing = false;
				if (_pausingChildTweens) {
					for each (var tw:Tween24 in _pausingChildTweens) {
						if (tw != this) {
							tw.play2();
							delete _pausingChildTweens[tw._uniquePlayId];
						}
					}
				}
			}
			
			// Add linkd list
			if (!_rootTween._isManual && this == _rootTween) {
				_firstTween ||= this;
				_prevList = _endTween;
				if (_endTween && _endTween != this) _endTween._nextList = this;
				_endTween = this;
			}
			
			// Time & Event init
			updateTime();
			updateEventTrigger();
			
			// Debug output
			if (debugMode || _rootTween._isDebug) debugTrace("play");
			
			// onPlay
			if (_onPlay != null) {
				if (_onPlayArgs) _onPlay.apply(_onPlay, _onPlayArgs);
				else             _onPlay();
			}
			
			// Event dispatch
			if (_dispatchPlay) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.PLAY));
			
			// Update
			if (_rootTween._isManual) { 
				if (_type != _TYPE_TWEEN && _type != _TYPE_TWEEN_FUNC && _type != _TYPE_TWEEN_COUNT && _type != _TYPE_WAIT && _type != _TYPE_WAIT_COUNT) {
					update();
				}
			}
			else if (_type != _TYPE_TWEEN_COUNT && _type != _TYPE_FUNC_COUNT && _type != _TYPE_WAIT_COUNT) update();
			
			// Start engine
			if (!_runing) startEngine();
		}
		
		private function updateTime():void
		{
			// Time scale
			_totalTimeScale = _timeScale;
			if (_parentTween) _totalTimeScale *= _parentTween._totalTimeScale;
			
			var ts:Number = _totalTimeScale * _globalTimeScale;
			var st:Number = _delayTime * (1 - _progressDelay) * 1000 * ts;
			
			switch (_type) {
				// Child tween
				case _TYPE_TWEEN:
				case _TYPE_PROP:
				case _TYPE_TWEEN_FUNC:
				case _TYPE_WAIT:
				case _TYPE_JUMP:
					_completeTime = _time * 1000 * ts;
					_startTime    = _nowTime + st - (_completeTime * _progress);
					break;
				
				// Parent tween
				case _TYPE_SERIAL:
				case _TYPE_LOOP:
				case _TYPE_PARALLEL:
				case _TYPE_RANDOM:
					_startTime    = _nowTime + st;
					_completeTime = 0;
					break;
				
				// Action tween
				default:
					_startTime    = _nowTime + st;
					_completeTime = 0;
					break;
			}
			
			// Child tween
			if (_playingChildTweens) {
				for each (var tween:Tween24 in _playingChildTweens) tween.updateTime();
			}
		}
		
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * PAUSE
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * トゥイーンを一時停止します。
		 */
		public function pause():void
		{
			if (!_playing) return;
			
			// If roo tween
			if (_rootTween == this) {
				// Remove linked list
				removeFromLinkedList();
			}
			
			pause2();
		}
		
		private function pause2():void
		{
			if (_type == _TYPE_ALL_PAUSE) return;
			
			_numPlayingTween --;
			
			_playing = false;
			_pausing = true;
			
			// If child tween
			if (_rootTween != this) {
				delete _parentTween._playingChildTweens[_uniquePlayId];
				_parentTween._pausingChildTweens ||= new Dictionary();
				_parentTween._pausingChildTweens[_uniquePlayId] = this;
			}
			
			// If parent tween
			if (_playingChildTweens) {
				for each (var tween:Tween24 in _playingChildTweens) {
					tween.pause2();
				}
			}
			
			if (_target) {
				for each (var tar:Object in _target) {
					// Remove from playingTweens
					removeFromDictionaryInDictionary(_playingTweensByTarget, tar, _uniquePlayId);
					
					// Add to pusingTweens
					_pausingTweensByTarget[tar] ||= new Dictionary();
					_pausingTweensByTarget[tar][_uniquePlayId] = this;
				}
			}
			
			// Add pausingAllTwens
			_pausingAllTweens[this] = this;
			
			// Plugin
			if (_pluginProperty) _pluginProperty.atPause();
			
			// onPause
			if (_onPause != null) {
				if (_onPauseArgs) _onPause.apply(_onPause, _onPauseArgs);
				else              _onPause();
			}
			
			// Event Dispatch
			if (_dispatchPause) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.PAUSE));
		}
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * STOP
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * トゥイーンを停止します。
		 */
		public function stop():void
		{
			stop2();
			
			// Plugin
			if (_pluginProperty) _pluginProperty.atStop();
			
			// onStop
			if (_onStop != null) {
				if (_onStopArgs) _onStop.apply(_onStop, _onStopArgs);
				else             _onStop();
			}
			
			// Event Dispatch
			if (_dispatchStop) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.STOP));
		}
		
		private function stop2():void
		{
			if (_TRACE_STOP) trace( "Tween24.stop2", this );
			
			removeTweens();
			
			if (this == _rootTween) {
				// Stop PlayingChildTweens
				stopByDictionary(_playingChildTweens);
				
				// Stop PausingChildTweens
				stopByDictionary(_pausingChildTweens);
			}
		}
		
		private function stopByDictionary(dict:Dictionary):void
		{
			for each (var tween:Tween24 in dict) tween.stop2();
		}
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * SKIP & TIME SCALE
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * トゥイーンをスキップし、完了状態にします。
		 */
		public function skip():void
		{
			_skipped = true;
			update();
		}
		
		/**
		 * トゥイーンのカウント数をスキップします。
		 * @param num スキップするカウント数
		 */		
		public function skipCount(num:uint = 1):void
		{
			if (_isManual) {
				if (_delayCount) {
					if (_delayCurrentCount != _delayCount) {
						_delayCurrentCount += num;
						if (_delayCurrentCount > _delayCount) {
							_currentCount += _delayCurrentCount - _delayCount;
							_delayCurrentCount = _delayCount;
						}
					}
					else {
						_currentCount += num;
					}
				}
				else {
					_currentCount += num;
				}
			}
		}
		
		/**
		 * タイムスケールを変更します。
		 * @param timeScale タイムスケール
		 * 
		 */		
		public function setTimeScale(timeScale:Number):void
		{
			_timeScale = timeScale;
			updateTime();
		}
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * REMOVE
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		private function removeTweens():void
		{
			if (_TRACE_REMOVE) trace( "Tween24.removeTweens", this );
			
			_numPlayingTween --;
			
			// If manual play
			if (_isManual) delete _manualTweens[_manualPlayId];
			
			_played   = _playing = _inited = _pausing = _actioned = _nextTweenPlayed = _isManual = false;
			_progress = _progressDelay = 0;
			_currentCount = 0;
			_delayCurrentCount = 0;
			
			// Remove Event Dispatcher
			if (_dispatcher) _dispatcher.removeEventListener(_eventType, funcComplete);
			
			if (_targetSingle) {
				// Remove from PlayingTweens & PausingTweens
				removeFromDictionaryInDictionary(_playingTweensByTarget, _targetSingle, _uniquePlayId);
				removeFromDictionaryInDictionary(_pausingTweensByTarget, _targetSingle, _uniquePlayId);
			}
			else {
				for each (var tar:* in _target) {
					// Remove from PlayingTweens & PausingTweens
					removeFromDictionaryInDictionary(_playingTweensByTarget, tar, _uniquePlayId);
					removeFromDictionaryInDictionary(_pausingTweensByTarget, tar, _uniquePlayId);
				}
			}
			
			// If root tween
			if (_rootTween == this) removeFromLinkedList();
			// Remove from Parent
			else if (_parentTween) delete _parentTween._playingChildTweens[_uniquePlayId];
		}
		
		private function removeFromLinkedList():void
		{
			// Update prev and next tween
			if (_prevList) _prevList._nextList = _nextList;
			if (_nextList) _nextList._prevList = _prevList;
			
			// Update first and end tween
			if (_firstTween == this) _firstTween = _nextList;
			if (_endTween   == this) _endTween   = _prevList;
			_prevList = _nextList = null;
		}
		
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * INIT
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		private function initParams():void
		{
			if (_TRACE_INIT) trace( "Tween24.initParams", this );
			
			_inited = true;
			
			if (_targetSingle)                      initParams2(_targetSingle);
			else for each (var t:Object in _target) initParams2(t);
			
			function initParams2(tar:Object):void {
				
				// Display
				if      (_displayUpdater)  _displayUpdater.init();
				else if (_displayUpdaters) _displayUpdaters[tar].init();
				
				// Object
				if      (_objectUpdater)  _objectUpdater.init();
				else if (_objectUpdaters) _objectUpdaters[tar].init();
				
				// Filter
				if (_isFilter) {
					if (tar is DisplayObject) {
						var filters:Array = tar.filters;
						var bf:BlurFilter;
						var gf:GlowFilter;
						var df:DropShadowFilter;
						var cf:ColorMatrixFilter;
						var cv:ConvolutionFilter;
						
						if (filters) {
							for each (var f:BitmapFilter in filters) {
								if      (f is BlurFilter)        bf = f as BlurFilter;
								else if (f is GlowFilter)        gf = f as GlowFilter;
								else if (f is DropShadowFilter)  df = f as DropShadowFilter;
								else if (f is ColorMatrixFilter) cf = f as ColorMatrixFilter;
								else if (f is ConvolutionFilter) cv = f as ConvolutionFilter;
							}
						}
						
						if (_targetSingle) {
							if (_blurUpdater)       _blurUpdater      .init(_targetSingle, bf || new BlurFilter(0, 0, 1));
							if (_glowUpdater)       _glowUpdater      .init(_targetSingle, gf || new GlowFilter(0));
							if (_dropShadowUpdater) _dropShadowUpdater.init(_targetSingle, df || new DropShadowFilter());
							if (_sharpUpdater)      _sharpUpdater     .init(_targetSingle, cv || new ConvolutionFilter());
							if (_saturationUpdater) _saturationUpdater.init(_targetSingle, cf || new ColorMatrixFilter());
						}
						else {
							if (_blurUpdater)       {
								_blurUpdaters ||= new Dictionary();
								_blurUpdaters[tar] = _blurUpdater.clone().init(tar, bf || new BlurFilter(0, 0, 1));
							}
							if (_glowUpdater)       {
								_glowUpdaters ||= new Dictionary();
								_glowUpdaters[tar] = _glowUpdater.clone().init(tar, gf || new GlowFilter(0));
							}
							if (_dropShadowUpdater) {
								_dropShadowUpdaters ||= new Dictionary();
								_dropShadowUpdaters[tar] = _dropShadowUpdater.clone().init(tar, df || new DropShadowFilter());
							}
							if (_saturationUpdater) {
								_saturationUpdaters ||= new Dictionary();
								_saturationUpdaters[tar] = _saturationUpdater.clone().init(tar, cf || new ColorMatrixFilter());
							}
							if (_sharpUpdater) {
								_sharpUpdaters ||= new Dictionary();
								_sharpUpdaters[tar] = _sharpUpdater.clone().init(tar, cv || new ConvolutionFilter());
							}
						}
					}
					
					// Color
					if (tar is DisplayObject) {
						if (_targetSingle) {
							if (_brightUpdater)        _brightUpdater       .init(_targetSingle as DisplayObject);
							if (_contrastUpdater)      _contrastUpdater     .init(_targetSingle as DisplayObject);
							if (_colorUpdater)         _colorUpdater        .init(_targetSingle as DisplayObject);
							if (_colorReversalUpdater) _colorReversalUpdater.init(_targetSingle as DisplayObject);
							if (_timelineUpdater)      _timelineUpdater     .init(_targetSingle as MovieClip);
						}
						else {
							if (_brightUpdater) {
								_brightUpdaters ||= new Dictionary();
								_brightUpdaters[tar] = _brightUpdater.clone().init(tar as DisplayObject);
							}
							if (_contrastUpdater) {
								_contrastUpdaters ||= new Dictionary();
								_contrastUpdaters[tar] = _contrastUpdater.clone().init(tar as DisplayObject);
							}
							if (_colorUpdater) {
								_colorUpdaters ||= new Dictionary();
								_colorUpdaters[tar] = _colorUpdater.clone().init(tar as DisplayObject);
							}
							if (_colorReversalUpdater) {
								_colorReversalUpdaters ||= new Dictionary();
								_colorReversalUpdaters[tar] = _colorReversalUpdater.clone().init(tar as DisplayObject);
							}
							if (_timelineUpdater && tar is MovieClip) {
								_timelineUpdaters ||= new Dictionary();
								_timelineUpdaters[tar] = _timelineUpdater.clone().init(tar as MovieClip);
							}
						}
					}
				}
			}
			
			overwrite();
		}
		
		private function overwrite():void
		{
			var tweens:Dictionary;
			var tween:Tween24;
			
			if (_targetSingle) {
				tweens = _playingTweensByTarget[_targetSingle];
				for each (tween in tweens) {
					if (tween != this) {
						if (_displayUpdater       && tween._displayUpdater)       tween._displayUpdater      .overwrite(_displayUpdater);
						if (_blurUpdater          && tween._blurUpdater)          tween._blurUpdater         .overwrite(_blurUpdater);
						if (_glowUpdater          && tween._glowUpdater)          tween._glowUpdater         .overwrite(_glowUpdater);
						if (_dropShadowUpdater    && tween._dropShadowUpdater)    tween._dropShadowUpdater   .overwrite(_dropShadowUpdater);
						if (_sharpUpdater         && tween._sharpUpdater)         tween._sharpUpdater        .overwrite(_sharpUpdater);
						if (_saturationUpdater    && tween._saturationUpdater)    tween._saturationUpdater   .overwrite(_saturationUpdater);
						if (_brightUpdater        && tween._brightUpdater)        tween._brightUpdater       .overwrite(_brightUpdater);
						if (_contrastUpdater      && tween._contrastUpdater)      tween._contrastUpdater     .overwrite(_contrastUpdater);
						if (_colorUpdater         && tween._colorUpdater)         tween._colorUpdater        .overwrite(_colorUpdater);
						if (_colorReversalUpdater && tween._colorReversalUpdater) tween._colorReversalUpdater.overwrite(_colorReversalUpdater);
						if (_timelineUpdater      && tween._timelineUpdater)      tween._timelineUpdater     .overwrite(_timelineUpdater);
						if (_objectUpdater        && tween._objectUpdater)        tween._objectUpdater       .overwrite(_objectUpdater);
					}
				}
				return;
			}
			
			for each (var tar:Object in _target)
			{
				tweens = _playingTweensByTarget[tar];
				for each (tween in tweens)
				{
					if (tween != this) {
						//Display & Object
						if (_displayUpdaters && tween._displayUpdaters && _displayUpdaters[tar]) tween._displayUpdaters[tar].overwrite(_displayUpdaters[tar]);
						if (_objectUpdaters  && tween._objectUpdaters  && _objectUpdaters [tar]) tween._objectUpdaters [tar].overwrite(_objectUpdaters [tar]);
						
						// Filter & Special
						if (_isFilter) {
							if (_blurUpdaters          && tween._blurUpdaters          && _blurUpdaters         [tar]) tween._blurUpdaters         [tar] = null; // Blur
							if (_glowUpdaters          && tween._glowUpdaters          && _glowUpdaters         [tar]) tween._glowUpdaters         [tar] = null; // Glow
							if (_dropShadowUpdaters    && tween._dropShadowUpdaters    && _dropShadowUpdaters   [tar]) tween._dropShadowUpdaters   [tar] = null; // DropShadow
							if (_sharpUpdaters         && tween._sharpUpdaters         && _sharpUpdaters        [tar]) tween._sharpUpdaters        [tar] = null; // Sharp
							if (_brightUpdaters        && tween._brightUpdaters        && _brightUpdaters       [tar]) tween._brightUpdaters       [tar] = null; // Bright
							if (_contrastUpdaters      && tween._contrastUpdaters      && _contrastUpdaters     [tar]) tween._contrastUpdaters     [tar] = null; // Contrast
							if (_colorUpdaters         && tween._colorUpdaters         && _colorUpdaters        [tar]) tween._colorUpdaters        [tar] = null; // Color
							if (_saturationUpdaters    && tween._saturationUpdaters    && _saturationUpdaters   [tar]) tween._saturationUpdaters   [tar] = null; // Saturation
							if (_colorReversalUpdaters && tween._colorReversalUpdaters && _colorReversalUpdaters[tar]) tween._colorReversalUpdaters[tar] = null; // ColorReversals
							if (_timelineUpdaters      && tween._timelineUpdaters      && _timelineUpdaters     [tar]) tween._timelineUpdaters     [tar] = null; // Frame
						}
					}
				}
			}
		}
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * UPDATE
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * トゥイーンを手動でアップデートします。トゥイーンは manualPlay()で再生されている必要があります。
		 * @param num アップデート回数
		 */		
		public function manualUpdate(num:int = 1):void
		{
			if (_isManual && _playing) {
				_nowTime = getTimer();
				update();
			}
		}
		
		private function update():void
		{
			if (_TRACE_UPDATE) trace( "Tween24.update", this);
			
			// Time
			var t:Number = _nowTime - _startTime;
			
			//------------------------------
			// Skip
			//------------------------------
			if (_skipped || (_parentTween && _parentTween._skipped) || (_rootTween && _rootTween._skipped)) {
				_progressDelay = 1;
				_progress = 1;
				_skipped = true;
				
				// onSkip
				if (_onSkip != null) {
					if (_onSkipArgs) _onSkip.apply(_onSkip, _onSkipArgs);
					else             _onSkip();
				}
				
				// Event Dispatch
				if (_dispatchSkip) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.SKIP));
			}
			else {
				//------------------------------
				// Count Tween
				//------------------------------
				if (_type == _TYPE_TWEEN_COUNT || _type == _TYPE_WAIT_COUNT || _type == _TYPE_FUNC_COUNT) {
					// Delay Progress
					if (!_delayCount) {
						_progressDelay = 1;
					}
					else if (_progressDelay < 1) {
						_delayCurrentCount ++;
						_progress      = 0;
						_progressDelay = _delayCurrentCount / _delayCount;
						if      (_progressDelay > 1) _progressDelay = 1;
						else if (_progressDelay < 0) _progressDelay = 0;
					}
					// Progress
					if (_progressDelay == 1) {
						_currentCount ++;
						
						if (_totalCount == 0) {
							_progress = 1;
						}
						else {
							_progress = _currentCount / _totalCount;
							if      (_progress > 1) _progress = 1;
							else if (_progress < 0) _progress = 0;
						}
					}
				}
				//------------------------------
				// Other Tween
				//------------------------------
				else {
					// Delay progress
					if (!_delayTime || (_type == _TYPE_LOOP && _loopCurrent > 0)) {
						_progressDelay = 1;
					}
					else if (_progressDelay < 1) {
						_progress      = 0;
						_progressDelay = (_delayTime)? 1 + (t / (_delayTime * 1000)): 1;
						if      (_progressDelay > 1) _progressDelay = 1;
						else if (_progressDelay < 0) _progressDelay = 0;
					}
					// Progress
					if (_progressDelay == 1) {
						if (_completeTime == 0) {
							_progress = 1;
						}
						else {
							_progress = t / _completeTime;
							if      (_progress > 1) _progress = 1;
							else if (_progress < 0) _progress = 0;
						}
					}
				}
			}
			
			
			// =============================================================================
			//
			// Delay
			//
			// -----------------------------------------------------------------------------
			
			if (_progressDelay < 1) {
				_delaying = true;
				
				// Plugin
				if (_pluginProperty) _pluginProperty.atDelay();
				
				// onDelay
				if (_onDelay != null) {
					if (_onDelayArgs) _onDelay.apply(_onDelay, _onDelayArgs);
					else              _onDelay();
				}
				
				// Event Dispatch
				if (_dispatchDelay) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.DELAY));
				return;
			}
			_delaying = false;
			
			
			// =============================================================================
			//
			// Init
			//
			// -----------------------------------------------------------------------------
			
			if (!_inited) {
				// Plugin
				if (_pluginProperty) _pluginProperty.atInit();
				
				initParams();
				
				// onInit
				if (_onInit != null) {
					if (_onInitArgs) _onInit.apply(_onInit, _onInitArgs);
					else             _onInit();
				}
				
				// Velocity
				if (!isNaN(_velocity)) {
					_time = _displayUpdater.getDistance() / _velocity;
					updateTime();
					update();
					return;
				}
				
				// Event Dispatch
				if (_dispatchInit) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.INIT));
			}
			
			
			// =============================================================================
			//
			// Single Target
			//
			// -----------------------------------------------------------------------------
			
			var tar:Object, ta:DisplayObject, prog:Number, pm:Object, spm:Object, dpm:Object, pname:String;
			
			if (_targetSingle) {
				if (_progress < 1) {
					// Param
					prog = _easing(_progress, 0, 1, 1);
					
					// Object update
					if (_objectUpdater) _objectUpdater.update(prog);
					
					// Display update
					if (_displayUpdater) _displayUpdater.update(prog);
					
					// Filter & Special update
					if (_isFilter) {
						if (_blurUpdater)          _blurUpdater         .update(prog); // Blur
						if (_glowUpdater)          _glowUpdater         .update(prog); // Glow
						if (_dropShadowUpdater)    _dropShadowUpdater   .update(prog); // DropShadow
						if (_sharpUpdater)         _sharpUpdater        .update(prog); // Sharp
						if (_brightUpdater)        _brightUpdater       .update(prog); // Bright
						if (_contrastUpdater)      _contrastUpdater     .update(prog); // Contrast
						if (_colorUpdater)         _colorUpdater        .update(prog); // Color
						if (_saturationUpdater)    _saturationUpdater   .update(prog); // Saturation
						if (_colorReversalUpdater) _colorReversalUpdater.update(prog); // ColorReversals
						if (_timelineUpdater)      _timelineUpdater     .update(prog); // Frame
					}
					
					// Plugin
					if (_pluginProperty) _pluginProperty.atUpdate();
					
					// onUpdate
					if (_onUpdate != null) {
						if (_onUpdateArgs) _onUpdate.apply(_onUpdate, _onUpdateArgs);
						else               _onUpdate();
					}
					
					// Event Dispatch
					if (_dispatchUpdate) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.UPDATE));
				}
				// Complete
				else if (_type == _TYPE_TWEEN || _type == _TYPE_PROP || _type == _TYPE_TWEEN_COUNT) {
					tweenComplete();
				}
			}
				
			// =============================================================================
			//
			// Multi Targets
			//
			// -----------------------------------------------------------------------------
			else if (_target)
			{
				if (_progress < 1) {
					for each (tar in _target) {
						prog = _easing(_progress, 0, 1, 1);
						
						// Object update
						if (_objectUpdaters && _objectUpdaters[tar]) _objectUpdaters[tar].update();
						
						// Point
						if (_displayUpdaters && _displayUpdaters[tar]) _displayUpdaters[tar].update(prog);
						
						// Filter & Special
						if (_isFilter) {
							if (_blurUpdaters          && _blurUpdaters         [tar]) _blurUpdaters         [tar].update(prog); // Blur
							if (_glowUpdaters          && _glowUpdaters         [tar]) _glowUpdaters         [tar].update(prog); // Glow
							if (_dropShadowUpdaters    && _dropShadowUpdaters   [tar]) _dropShadowUpdaters   [tar].update(prog); // DropShadow
							if (_sharpUpdaters         && _sharpUpdaters        [tar]) _sharpUpdaters        [tar].update(prog); // Sharp
							if (_brightUpdaters        && _brightUpdaters       [tar]) _brightUpdaters       [tar].update(prog); // Bright
							if (_contrastUpdaters      && _contrastUpdaters     [tar]) _contrastUpdaters     [tar].update(prog); // Contrast
							if (_colorUpdaters         && _colorUpdaters        [tar]) _colorUpdaters        [tar].update(prog); // Color
							if (_saturationUpdaters    && _saturationUpdaters   [tar]) _saturationUpdaters   [tar].update(prog); // Saturation
							if (_colorReversalUpdaters && _colorReversalUpdaters[tar]) _colorReversalUpdaters[tar].update(prog); // ColorReversals
							if (_timelineUpdaters      && _timelineUpdaters     [tar]) _timelineUpdaters     [tar].update(prog); // Frame
						}
						
						// onUpdate
						if (_onUpdate != null) {
							if (_onUpdateArgs) _onUpdate.apply(_onUpdate, _onUpdateArgs);
							else               _onUpdate();
						}
						
						// Event Dispatch
						if (_dispatchUpdate) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.UPDATE));
					}
				}
				// Complete
				else {
					tweenComplete();
				}
			}
			else if (_type == _TYPE_TWEEN || _type == _TYPE_TWEEN_COUNT) {
				if (_progress < 1) {
					// onUpdate
					if (_onUpdate != null) {
						if (_onUpdateArgs) _onUpdate.apply(_onUpdate, _onUpdateArgs);
						else               _onUpdate();
					}
					
					// Event Dispatch
					if (_dispatchUpdate) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.UPDATE));
				}
				// Complete
				else {
					tweenComplete();
				}
			}
			
			
			// =============================================================================
			//
			// Serial & Loop
			//
			// -----------------------------------------------------------------------------
			
			else if (_type == _TYPE_SERIAL || _type == _TYPE_LOOP) {
				// Play child tween
				if (!_played) {
					_played = true;
					_serialTween.play2();
				}
				// Update child tween
				else {
					for each (var stw:Tween24 in _playingChildTweens) {
						stw.update();
					}
				}
				
				// onUpdate
				if (_onUpdate != null) {
					if (_onUpdateArgs) _onUpdate.apply(_onUpdate, _onUpdateArgs);
					else               _onUpdate();
				}
				
				// Event Dispatch
				if (_dispatchUpdate) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.UPDATE));
				
				// Complete
				if (_numChildren == _numCompleteChildren) actionComplete();
			}
			
			
			// =============================================================================
			//
			// Parallel & Lag
			//
			// -----------------------------------------------------------------------------
			
			else if (_type == _TYPE_PARALLEL || _type == _TYPE_LAG) {
				// Play child tween
				var ptw:Tween24;
				if (!_played) {
					_played = true;
					for each (ptw in _parallelTweens) ptw.play2();
				}
				// Update child tween
				else {
					for each (ptw in _playingChildTweens) ptw.update();
				}
				
				// onUpdate
				if (_onUpdate != null) {
					if (_onUpdateArgs) _onUpdate.apply(_onUpdate, _onUpdateArgs);
					else               _onUpdate();
				}
				
				// Event Dispatch
				if (_dispatchUpdate) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.UPDATE));
				
				// Complete
				if (_numChildren == _numCompleteChildren) actionComplete();
			}
			
			
			// =============================================================================
			//
			// If Case
			//
			// -----------------------------------------------------------------------------
			
			else if (_type == _TYPE_IF_CASE) {
				// onUpdate
				if (_onUpdate != null) {
					if (_onUpdateArgs) _onUpdate.apply(_onUpdate, _onUpdateArgs);
					else               _onUpdate();
				}
				
				// Event Dispatch
				if (_dispatchUpdate) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.UPDATE));
				
				// Play
				if (!_played) {
					_played = true;
					if (_ifCaseTarget) _ifCaseBoolean = _ifCaseTarget[_ifCasePropName];
					
					if (_ifCaseBoolean) {
						if (_ifCaseTrueTween) _ifCaseTrueTween.play2();
						else actionComplete();
					}
					else {
						if (_ifCaseFalseTween) _ifCaseFalseTween.play2();
						else actionComplete();
					}
				}
				// Update child tween
				else {
					if (_ifCaseBoolean) {
						if (_ifCaseTrueTween) _ifCaseTrueTween.update();
					}
					else {
						if (_ifCaseFalseTween) _ifCaseFalseTween.update();
					}
				}
				
				// Complete
				if (_numChildren == _numCompleteChildren) actionComplete();
			}
			
			
			// =============================================================================
			//
			// Random
			//
			// -----------------------------------------------------------------------------
			
			else if (_type == _TYPE_RANDOM) {
				// Play child tween
				if (!_played) {
					_played = true;
					var index:int = int(_randomTweens.length * Math.random());
					_randomTween = _randomTweens[index];
					_randomTween.play2();
				}
				// Update child tween
				else {
					_randomTween.update();
				}
				
				// onUpdate
				if (_onUpdate != null) {
					if (_onUpdateArgs) _onUpdate.apply(_onUpdate, _onUpdateArgs);
					else               _onUpdate();
				}
				
				// Event Dispatch
				if (_dispatchUpdate) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.UPDATE));
				
				// Complete
				if (_numChildren == _numCompleteChildren) actionComplete();
			}
			
			
			// =============================================================================
			//
			// Wait & Jump & CountWait
			//
			// -----------------------------------------------------------------------------
			
			else if (_type == _TYPE_WAIT || _type == _TYPE_JUMP || _type == _TYPE_WAIT_COUNT) {
				// onUpdate
				if (_onUpdate != null) {
					if (_onUpdateArgs) _onUpdate.apply(_onUpdate, _onUpdateArgs);
					else               _onUpdate();
				}
				// Event Dispatch
				if (_dispatchUpdate) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.UPDATE));
				
				// Complete
				if (_progress == 1) actionComplete();
			}
			
			
			// =============================================================================
			//
			// TweenFunc & CountFunc
			//
			// -----------------------------------------------------------------------------
			
			else if (_type == _TYPE_TWEEN_FUNC || _type == _TYPE_FUNC_COUNT) {
				var args:Array = [];
				var len:int = _tweenStartArgs.length;
				prog = _easing(_progress, 0, 1, 1);
				for (var i:int = 0; i < len; i++) args.push(_tweenStartArgs[i] + _tweenDeltaArgs[i] * prog);
				_tweenFunc.apply(_tweenFunc, args);
				
				// onUpdate
				if (_onUpdate != null) {
					if (_onUpdateArgs) _onUpdate.apply(_onUpdate, _onUpdateArgs);
					else               _onUpdate();
				}
				
				// Event Dispatch
				if (_dispatchUpdate) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.UPDATE));
				
				// Complete
				if (_progress == 1) tweenComplete();
			}
			
			
			// =============================================================================
			//
			// Action
			//
			// -----------------------------------------------------------------------------
			else {
				if (!_actioned) {
					_actioned = true;
					
					// onUpdate
					if (_onUpdate != null) {
						if (_onUpdateArgs) _onUpdate.apply(_onUpdate, _onUpdateArgs);
						else               _onUpdate();
					}
					
					// Event Dispatch
					if (_dispatchUpdate) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.UPDATE));
					
					// Complete
					if (_progress == 1) actionComplete();
				}
				else {
					// Wait event
					if (_type == _TYPE_FUNC_AND_WAIT || _type == _TYPE_WAIT_EVENT) {
						// Skip
						if ((_parentTween && _parentTween._skipped) || (_rootTween && _rootTween._skipped)) {
							funcComplete(null);
						}
					}
				}
			}
		}
		
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * COMPLETE
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		// =============================================================================
		//
		// Tween Complete
		//
		// -----------------------------------------------------------------------------
		
		private function tweenComplete():void
		{
			var pname:String;
			var pm:Object, sp:Object, dp:Object;
			
			// Update
			if (_targetSingle) {
				// Display & Object
				if (_displayUpdater) _displayUpdater.complete();
				if (_objectUpdater)  _objectUpdater .complete();
				
				// Filter & Special
				if (_isFilter) {
					if (_blurUpdater         ) _blurUpdater         .complete(); // Blur
					if (_glowUpdater         ) _glowUpdater         .complete(); // Glow
					if (_dropShadowUpdater   ) _dropShadowUpdater   .complete(); // DropShadow
					if (_sharpUpdater        ) _sharpUpdater        .complete(); // Sharp
					if (_brightUpdater       ) _brightUpdater       .complete(); // Bright
					if (_contrastUpdater     ) _contrastUpdater     .complete(); // Contrast
					if (_colorUpdater        ) _colorUpdater        .complete(); // Color
					if (_saturationUpdater   ) _saturationUpdater   .complete(); // Saturation
					if (_timelineUpdater     ) _timelineUpdater     .complete(); // Frame
					if (_colorReversalUpdater) _colorReversalUpdater.complete(); // ColorReversals
				}
			}
			else {
				for each (var tar:Object in _target)
				{
					// Display & Object
					if (_displayUpdaters && _displayUpdaters[tar]) _displayUpdaters[tar].complete();
					if (_objectUpdaters && _objectUpdaters[tar]) _objectUpdaters[tar].complete();
					
					// Filter & Special Prop
					if (_isFilter) {
						if (_blurUpdaters          && _blurUpdaters         [tar]) _blurUpdaters         [tar].complete(); // Blur
						if (_glowUpdaters          && _glowUpdaters         [tar]) _glowUpdaters         [tar].complete(); // Glow
						if (_dropShadowUpdaters    && _dropShadowUpdaters   [tar]) _dropShadowUpdaters   [tar].complete(); // DropShadow
						if (_sharpUpdaters         && _sharpUpdaters        [tar]) _sharpUpdaters        [tar].complete(); // Sharp
						if (_brightUpdaters        && _brightUpdaters       [tar]) _brightUpdaters       [tar].complete(); // Bright
						if (_contrastUpdaters      && _contrastUpdaters     [tar]) _contrastUpdaters     [tar].complete(); // Contrast
						if (_colorUpdaters         && _colorUpdaters        [tar]) _colorUpdaters        [tar].complete(); // Color
						if (_saturationUpdaters    && _saturationUpdaters   [tar]) _saturationUpdaters   [tar].complete(); // Saturation
						if (_timelineUpdaters      && _timelineUpdaters     [tar]) _timelineUpdaters     [tar].complete(); // Frame
						if (_colorReversalUpdaters && _colorReversalUpdaters[tar]) _colorReversalUpdaters[tar].complete(); // ColorReversals
					}
				}
			}
			
			// Action
			if (_action != null) _action();
			
			// Plugin
			if (_pluginProperty) _pluginProperty.atComplete();
			
			// onUpdate
			if (_onUpdate != null) {
				if (_onUpdateArgs) _onUpdate.apply(_onUpdate, _onUpdateArgs);
				else               _onUpdate();
			}
			
			// Event Dispatch
			if (_dispatchUpdate) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.UPDATE));
			
			playNextTween();
		}
		
		
		// =============================================================================
		//
		// Action Complete
		//
		// -----------------------------------------------------------------------------
		
		private function actionComplete():void
		{
			//trace( "Tween24.actionComplete", this );
			
			// Add Event Dispatcher
			if (_dispatcher) _dispatcher.addEventListener(_eventType, funcComplete);
			
			// Action
			if (_action != null) _action();
			
			if (!_dispatcher) playNextTween();
		}
		
		// Actoin Function Complete
		private function funcComplete(e:*):void
		{
			_dispatcher.removeEventListener(_eventType, funcComplete);
			playNextTween();
		}
		
		
		// =============================================================================
		//
		// Play Next Tween
		//
		// -----------------------------------------------------------------------------
		
		private function playNextTween():void
		{
			if (_TRACE_NEXT) trace( "Tween24.playNextTween", this );
			
			// Loop Tween
			if (_type == _TYPE_LOOP) {
				_loopCurrent ++;
				
				// Looping
				if (!_loopCount || _loopCount != _loopCurrent) {
					_played = _actioned = _nextTweenPlayed = false;
					_progress = 0;
					play2();
				}
				// Loop complete
				else {
					// Debug output
					if (debugMode || _rootTween._isDebug) trace("[comp] " + this);
					
					// Count up
					_completed = true;
					if (_parentTween && _parentTween._numChildren > _parentTween._numCompleteChildren) _parentTween._numCompleteChildren ++;
					
					stop2();
					_loopCurrent = 0;
					
					// onComplete
					if (_onCompArgs && _onCompArgs.length) _onComp.apply(_onComp, _onCompArgs);
					else if (_onComp != null) _onComp();
					
					// Event Dispatch
					if (_dispatchComplete) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.COMPLETE));
					
					// Play newxt tween
					if (_nextTween) {
						_nextTweenPlayed = true;
						_nextTween.play2();
					}
				}
			}
			
			// Else Tween
			else {
				// Debug output
				if (debugMode || (_rootTween && _rootTween._isDebug)) debugTrace("comp");
				
				// Count up
				_completed = true;
				if (_parentTween && _parentTween._numChildren > _parentTween._numCompleteChildren) _parentTween._numCompleteChildren ++;
				
				var isParentComplete:Boolean;
				
				// onComplete
				if (_onCompArgs && _onCompArgs.length) _onComp.apply(_onComp, _onCompArgs);
				else if (_onComp != null) _onComp();
				
				// Event Dispatch
				if (_dispatchComplete) _eventDispatcher.dispatchEvent(new Tween24Event(this, Tween24Event.COMPLETE));
				
				// Next tween play
				var next:Tween24 = (!_nextTweenPlayed && _nextTween)? _nextTween: null;
				removeTweens();
				if (next) next.play2();
				
				// Play parent next tween
				if (_parentTrigger) {
					var parentNextTween:Tween24 = (_parentTween)? _parentTween._nextTween: null;
					if (parentNextTween && !_parentTween._completed) {
						_parentTween._nextTweenPlayed = true;
						if (parentNextTween._type != _TYPE_LOOP) parentNextTween.play2();
					}
				}
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
		 * イベント通知を受けるインスタンスを取得します。
		 * @return EventDispatcher
		 */
		public function getDispatcher():EventDispatcher
		{
			return _eventDispatcher || (_eventDispatcher = new EventDispatcher());
		}
		
		/**
		 * リスナーを設定します。
		 * @param type イベントタイプ
		 * @param listener ハンドラ関数
		 * @param useCapture バブリング段階で動作するか
		 * @param priority 優先度レベル
		 * @param useWeakReference 参照の強さ
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			getDispatcher().addEventListener(type, listener, useCapture, priority, useWeakReference);
			updateEventTrigger();
		}
		
		/**
		 * リスナーを削除します。
		 * @param type イベントタイプ
		 * @param listener ハンドラ関数
		 * @param useCapture バブリング段階で動作するか
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			getDispatcher().removeEventListener(type, listener, useCapture);
			updateEventTrigger();
		}
		
		/**
		 * EventDispatcher オブジェクトに、特定のイベントタイプに対して登録されたリスナーがあるかどうかを確認します。
		 * @param type イベントタイプ
		 * @return 指定したタイプのリスナーが登録されている場合は true、それ以外の場合は false
		 */
		public function hasEventListener(type:String):Boolean
		{
			return getDispatcher().hasEventListener(type);
		}
		
		/**
		 * イベントをイベントフローに送出します。
		 * @param event イベントフローに送出されるイベントオブジェクト
		 * @return true を返します（イベントで preventDefault() が呼び出されない限り）。呼び出された場合は false を返します。
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return getDispatcher().dispatchEvent(event);
		}
		
		/**
		 * 指定されたイベントタイプについて、この EventDispatcher オブジェクトまたはその祖先にイベントリスナーが登録されているかどうかを確認します。
		 * @param type イベントのタイプ
		 * @return 指定したタイプのリスナーがトリガーされた場合は true、それ以外の場合は false です。
		 */
		public function willTrigger(type:String):Boolean
		{
			return getDispatcher().willTrigger(type);
		}
		
		/**
		 * 送信するイベントのフラグを立てます。
		 */
		private function updateEventTrigger():void
		{
			if (!_eventDispatcher) return;
			
			_dispatchPlay     = _eventDispatcher.willTrigger(Tween24Event.PLAY);
			_dispatchDelay    = _eventDispatcher.willTrigger(Tween24Event.DELAY);
			_dispatchInit     = _eventDispatcher.willTrigger(Tween24Event.INIT);
			_dispatchUpdate   = _eventDispatcher.willTrigger(Tween24Event.UPDATE);
			_dispatchPause    = _eventDispatcher.willTrigger(Tween24Event.PAUSE);
			_dispatchSkip     = _eventDispatcher.willTrigger(Tween24Event.SKIP);
			_dispatchStop     = _eventDispatcher.willTrigger(Tween24Event.STOP);
			_dispatchComplete = _eventDispatcher.willTrigger(Tween24Event.COMPLETE);
		}
		
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * PROPERTY METHODS
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		private function setDisplayObjectUpdater2(propName:String, propName2:String, value:*, value2:*):Tween24
		{
			return setDisplayObjectUpdater(propName, value).setDisplayObjectUpdater(propName2, value2);
		}
		
		private function setDisplayObjectUpdater3(propName:String, propName2:String, propName3:String, value:*, value2:*, value3:*):Tween24
		{
			return setDisplayObjectUpdater(propName, value).setDisplayObjectUpdater(propName2, value2).setDisplayObjectUpdater(propName3, value3);
		}
		
		private function setDisplayObjectUpdater(propName:String, value:*):Tween24
		{
			if (_targetSingle) {
				if (!_displayUpdater) _displayUpdater = new DisplayObjectUpdater(_targetSingle);
				setValue(_displayUpdater, _targetSingle);
			}
			else {
				if (!_displayUpdaters) _displayUpdaters = new Dictionary();
				for each (var tar:Object in _target) {
					var updater:DisplayObjectUpdater = _displayUpdaters[tar] || (_displayUpdaters[tar] = new DisplayObjectUpdater(tar));
					setValue(updater, tar);
				}
			}
			
			function setValue(updater:DisplayObjectUpdater, t:Object):void
			{
				switch (propName) {
					case "x"          : updater.x           = value; break;
					case "y"          : updater.y           = value; break;
					case "z"          : updater.z           = value; break;
					case "$x"         : updater.set$x(value); break;
					case "$y"         : updater.set$y(value); break;
					case "$y"         : updater.z           = t.z + value; break;
					case "$$x"        : updater.$$x         = value; break;
					case "$$y"        : updater.$$y         = value; break;
					case "$$z"        : updater.$$z         = value; break;
					
					case "alpha"      : updater.alpha       = value; break;
					case "$alpha"     : updater.alpha       = t.alpha + value; break;
					case "$$alpha"    : updater.$$alpha     = value; break;
					
					case "rotation"   : updater.rotation    = value; break;
					case "rotationX"  : updater.rotationX   = value; break;
					case "rotationY"  : updater.rotationY   = value; break;
					case "rotationZ"  : updater.rotationZ   = value; break;
					case "$rotation"  : updater.rotation    = t.rotation  + value; updater.$rotation  = value; break;
					case "$rotationX" : updater.rotationX   = t.rotationX + value; updater.$rotationX = value; break;
					case "$rotationY" : updater.rotationY   = t.rotationY + value; updater.$rotationY = value; break;
					case "$rotationZ" : updater.rotationZ   = t.rotationZ + value; updater.$rotationZ = value; break;
					case "$$rotation" : updater.$$rotation  = value; break;
					case "$$rotationX": updater.$$rotationX = value; break;
					case "$$rotationY": updater.$$rotationY = value; break;
					case "$$rotationZ": updater.$$rotationZ = value; break;
					
					case "width"      : updater.width       = value; break;
					case "height"     : updater.height      = value; break;
					case "$width"     : updater.width       = t.width  + value; break;
					case "$height"    : updater.height      = t.height + value; break;
					case "$$width"    : updater.$$width     = value; break;
					case "$$height"   : updater.$$height    = value; break;
					
					case "scaleX"     : updater.scaleX      = value; break;
					case "scaleY"     : updater.scaleY      = value; break;
					case "scaleZ"     : updater.scaleZ      = value; break;
					case "$scaleX"    : updater.scaleX      = t.scaleX + value; break;
					case "$scaleY"    : updater.scaleY      = t.scaleY + value; break;
					case "$scaleZ"    : updater.scaleZ      = t.scaleZ + value; break;
					case "$$scaleX"   : updater.$$scaleX    = value; break;
					case "$$scaleY"   : updater.$$scaleY    = value; break;
					case "$$scaleZ"   : updater.$$scaleZ    = value; break;
					
					case "globalX"    : updater.globalX     = value; break;
					case "globalY"    : updater.globalY     = value; break;
					case "fadeIn"     : updater.fadeIn      = value; break;
					case "fadeOut"    : updater.fadeOut     = value; break;
					case "align"      : updater.align       = value; updater.update$xy(); break;
					case "alignX"     : updater.alignX      = value; updater.update$xy(); break;
					case "alignY"     : updater.alignY      = value; updater.update$xy(); break;
					case "alignScaleX": updater.alignScaleX = value; updater.update$xy(); break;
					case "alignScaleY": updater.alignScaleY = value; updater.update$xy(); break;
					
					case "localX"      : updater.localX       = value; break;
					case "localY"      : updater.localY       = value; break;
					case "localXTarget": updater.localXTarget = value; break;
					case "localYTarget": updater.localYTarget = value; break;
					case "localTarget" : updater.localXTarget = updater.localYTarget = value; break;
					
					case "randomMinX"  : updater.randomMinX   = value; break;
					case "randomMaxX"  : updater.randomMaxX   = value; break;
					case "randomMinY"  : updater.randomMinY   = value; break;
					case "randomMaxY"  : updater.randomMaxY   = value; break;
					case "randomMinZ"  : updater.randomMinZ   = value; break;
					case "randomMaxZ"  : updater.randomMaxZ   = value; break;
					case "randomMinXY" : updater.randomMinX   = updater.randomMinY = value; break;
					case "randomMaxXY" : updater.randomMaxX   = updater.randomMaxY = value; break;
					case "randomMinXYZ": updater.randomMinX   = updater.randomMinY = updater.randomMinZ = value; break;
					case "randomMaxXYZ": updater.randomMaxX   = updater.randomMaxY = updater.randomMaxZ = value; break;
					case "randomRound" : updater.randomRound  = value; break;
					
					case "blendMode"    : updater.blendMode     = value; break;
					case "useLayerBlend": updater.useLayerBlend = value; break;
					case "mouseEnabled" : updater.mouseEnabled  = value; break;
					case "mouseChildren": updater.mouseChildren = value; break;
					case "buttonEnabled": updater.mouseEnabled  = updater.mouseChildren = value; break;
				}
			}
			return this;
		}
		
		private function setDisplayObjectUpdaterBezier(propName:String, x:Number, y:Number):Tween24
		{
			if (_targetSingle) {
				if (!_displayUpdater) _displayUpdater = new DisplayObjectUpdater(_targetSingle);
				setBezier(_displayUpdater, _targetSingle);
			}
			else {
				if (!_displayUpdaters) _displayUpdaters = new Dictionary();
				for each (var tar:Object in _target) {
					var updater:DisplayObjectUpdater = _displayUpdaters[tar] || (_displayUpdaters[tar] = new DisplayObjectUpdater(tar));
					setBezier(updater, tar);
				}
			}
			
			function setBezier(updater:DisplayObjectUpdater, t:Object):void {
				switch (propName) {
					case "bezier"  : updater.bezier  (x, y); break;
					case "$bezier" : updater.bezier  (t.x + x, t.y + y); break;
					case "$$bezier": updater.$$bezier(x, y); break;
				}
			}
			return this;
		}
		
		
		// =============================================================================
		//
		// Prop X
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするX座標を設定します。
		 * @param x X座標
		 * @return Tween24
		 */
		public function x(x:Number):Tween24 { return setDisplayObjectUpdater("x", x); }
		
		/**
		 * 目標とするX座標を、現在の値を基準に設定します。
		 * @param x X座標
		 * @return Tween24
		 */
		public function $x(x:Number):Tween24 { return setDisplayObjectUpdater("$x", x); }
		
		/**
		 * 目標とするX座標を、トゥイーン直前の値を基準に設定します。
		 * @param x X座標
		 * @return Tween24
		 */
		public function $$x(x:Number):Tween24 { return setDisplayObjectUpdater("$$x", x); }
		
		
		// =============================================================================
		//
		// Prop Y
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするY座標を設定します。
		 * @param y Y座標
		 * @return Tween24
		 */
		public function y(y:Number):Tween24 { return setDisplayObjectUpdater("y", y); }
		
		/**
		 * 目標とするY座標を、現在の値を基準に設定します。
		 * @param y Y座標
		 * @return Tween24
		 */
		public function $y(y:Number):Tween24 { return setDisplayObjectUpdater("$y", y); }
		
		/**
		 * 目標とするY座標を、トゥイーン直前の値を基準に設定します。
		 * @param y Y座標
		 * @return Tween24
		 */
		public function $$y(y:Number):Tween24 { return setDisplayObjectUpdater("$$y", y); }
		
		
		// =============================================================================
		//
		// Prop Z
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするZ座標を設定します。
		 * @param z Z座標
		 * @return Tween24
		 */
		public function z(z:Number):Tween24 { return setDisplayObjectUpdater("z", z); }
		
		/**
		 * 目標とするZ座標を、現在の値を基準に設定します。
		 * @param z Z座標
		 * @return Tween24
		 */
		public function $z(z:Number):Tween24 { return setDisplayObjectUpdater("$z", z); }
		
		/**
		 * 目標とするZ座標を、トゥイーン直前の値を基準に設定します。
		 * @param z Z座標
		 * @return Tween24
		 */
		public function $$z(z:Number):Tween24 { return setDisplayObjectUpdater("$$z", z); }
		
		
		// =============================================================================
		//
		// Prop X, Y
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするX、Y座標をまとめて設定します。
		 * @param x X座標
		 * @param y Y座標
		 * @return Tween24
		 */
		public function xy(x:Number, y:Number):Tween24 { return setDisplayObjectUpdater2("x", "y", x, y); }
		
		/**
		 * 目標とするX、Y座標を、現在の値を基準にまとめて設定します。
		 * @param x X座標
		 * @param y Y座標
		 * @return Tween24
		 */
		public function $xy(x:Number, y:Number):Tween24 { return setDisplayObjectUpdater2("$x", "$y", x, y); }
		
		/**
		 * 目標とするX、Y座標を、トゥイーン直前の値を基準にまとめて設定します。
		 * @param x X座標
		 * @param y Y座標
		 * @return Tween24
		 */
		public function $$xy(x:Number, y:Number):Tween24 { return setDisplayObjectUpdater2("$$x", "$$y", x, y); }
		
		
		// =============================================================================
		//
		// Prpo X, Y, Z
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするX,Y,Z座標をまとめて設定します。
		 * @param x X座標
		 * @param y Y座標
		 * @param z Z座標
		 * @return Tween24
		 */
		public function xyz(x:Number, y:Number, z:Number):Tween24 { return setDisplayObjectUpdater3("x", "y", "z", x, y, z); }
		
		/**
		 * 目標とするX,Y,Z座標を、現在の値を基準にまとめて設定します。
		 * @param x X座標
		 * @param y Y座標
		 * @param z Z座標
		 * @return Tween24
		 */
		public function $xyz(x:Number, y:Number, z:Number):Tween24 { return setDisplayObjectUpdater3("$x", "$y", "$z", x, y, z); }
		
		/**
		 * 目標とするX,Y,Z座標を、トゥイーン直前の値を基準にまとめて設定します。
		 * @param x X座標
		 * @param y Y座標
		 * @param z Z座標
		 * @return Tween24
		 */
		public function $$xyz(x:Number, y:Number, z:Number):Tween24 { return setDisplayObjectUpdater3("$$x", "$$y", "$$z", x, y, z); }
		
		
		// =============================================================================
		//
		// Prop Alpha
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とする透明度を設定します。
		 * @param alpha 透明度
		 * @return Tween24
		 */
		public function alpha(alpha:Number):Tween24 { return setDisplayObjectUpdater("alpha", alpha); }
		
		/**
		 * 目標透明度を、現在の値を基準に設定します。
		 * @param alpha 透明度
		 * @return Tween24
		 */
		public function $alpha(alpha:Number):Tween24 { return setDisplayObjectUpdater("$alpha", alpha); }
		
		/**
		 * 目標とする透明度を、トゥイーン直前の値を基準に設定します。
		 * @param alpha 透明度
		 * @return Tween24
		 */
		public function $$alpha(alpha:Number):Tween24 { return setDisplayObjectUpdater("$$alpha", alpha); }
		
		
		// =============================================================================
		//
		// Prop Rotation
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とする回転角度を設定します。
		 * @param rotation 角度
		 * @return Tween24
		 */
		public function rotation(rotation:Number):Tween24 { return setDisplayObjectUpdater("rotation", rotation); }
		
		/**
		 * 目標とする回転角度を、現在の値を基準に設定します。
		 * @param rotation 角度
		 * @return Tween24
		 */
		public function $rotation(rotation:Number):Tween24 { return setDisplayObjectUpdater("$rotation", rotation); }
		
		/**
		 * 目標とする回転角度を、トゥイーン直前の値を基準に設定します。
		 * @param rotation 角度
		 * @return Tween24
		 */
		public function $$rotation(rotation:Number):Tween24 { return setDisplayObjectUpdater("$$rotation", rotation); }
		
		
		// =============================================================================
		//
		// Prop RotationX
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするX軸の回転角を設定します。
		 * @param rotationX 角度
		 * @return Tween24
		 */
		public function rotationX(rotationX:Number):Tween24 { return setDisplayObjectUpdater("rotationX", rotationX); }
		
		/**
		 * 目標とするX軸の回転角を、現在の値を基準に設定します。
		 * @param rotationX 角度
		 * @return Tween24
		 */
		public function $rotationX(rotationX:Number):Tween24 { return setDisplayObjectUpdater("$rotationX", rotationX); }
		
		/**
		 * 目標とするX軸の回転角を、トゥイーン直前の値を基準に設定します。
		 * @param rotationX 角度
		 * @return Tween24
		 */
		public function $$rotationX(rotationX:Number):Tween24 { return setDisplayObjectUpdater("$$rotationX", rotationX); }
		
		
		
		// =============================================================================
		//
		// Prop RotationY
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするY軸の回転角を設定します。
		 * @param rotationY 角度
		 * @return Tween24
		 */
		public function rotationY(rotationY:Number):Tween24 { return setDisplayObjectUpdater("rotationY", rotationY); }
		
		/**
		 * 目標とするY軸の回転角を、現在の値を基準に設定します。
		 * @param rotationY 角度
		 * @return Tween24
		 */
		public function $rotationY(rotationY:Number):Tween24 { return setDisplayObjectUpdater("$rotationY", rotationY); }
		
		/**
		 * 目標とするY軸の回転角を、トゥイーン直前の値を基準に設定します。
		 * @param rotationY 角度
		 * @return Tween24
		 */
		public function $$rotationY(rotationY:Number):Tween24 { return setDisplayObjectUpdater("$$rotationY", rotationY); }
		
		
		// =============================================================================
		//
		// Tween RotationZ
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするZ軸の回転角を設定します。
		 * @param rotationZ 角度
		 * @return Tween24
		 */
		public function rotationZ(rotationZ:Number):Tween24 { return setDisplayObjectUpdater("rotationZ", rotationZ); }
		
		/**
		 * 目標とするZ軸の回転角を、現在の値を基準に設定します。
		 * @param rotationZ 角度
		 * @return Tween24
		 */
		public function $rotationZ(rotationZ:Number):Tween24 { return setDisplayObjectUpdater("$rotationZ", rotationZ); }
		
		/**
		 * 目標とするZ軸の回転角を、トゥイーン直前の値を基準に設定します。
		 * @param rotationZ 角度
		 * @return Tween24
		 */
		public function $$rotationZ(rotationZ:Number):Tween24 { return setDisplayObjectUpdater("$$rotationZ", rotationZ); }
		
		
		// =============================================================================
		//
		// Prop RotationX, Y
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするX,Y軸の回転角を設定します。
		 * @param rotationX 角度
		 * @param rotationY 角度
		 * @return Tween24
		 */
		public function rotationXY(rotationX:Number, rotationY:Number):Tween24 { return setDisplayObjectUpdater2("rotationX", "rotationY", rotationX, rotationY); }
		
		/**
		 * 目標とするX,Y軸の回転角を、現在の値を基準に設定します。
		 * @param rotationX 角度
		 * @param rotationY 角度
		 * @return Tween24
		 */
		public function $rotationXY(rotationX:Number, rotationY:Number):Tween24 { return setDisplayObjectUpdater2("$rotationX", "$rotationY", rotationX, rotationY); }
		
		/**
		 * 目標とするX,Y軸の回転角を、トゥイーン直前の値を基準に設定します。
		 * @param rotationX 角度
		 * @param rotationY 角度
		 * @return Tween24
		 */
		public function $$rotationXY(rotationX:Number, rotationY:Number):Tween24 { return setDisplayObjectUpdater2("$$rotationX", "$$rotationY", rotationX, rotationY); }
		
		
		// =============================================================================
		//
		// Prop RotationX, Y, Z
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするX,Y,Z軸の回転角を設定します。
		 * @param rotationX 角度
		 * @param rotationY 角度
		 * @param rotationZ 角度
		 * @return Tween24
		 */
		public function rotationXYZ(rotationX:Number, rotationY:Number, rotationZ:Number):Tween24 { return setDisplayObjectUpdater3("rotationX", "rotationY", "rotationZ", rotationX, rotationY, rotationZ); }
		
		/**
		 * 目標とするX,Y,Z軸の回転角を、現在の値を基準に設定します。
		 * @param rotationX 角度
		 * @param rotationY 角度
		 * @param rotationZ 角度
		 * @return Tween24
		 */
		public function $rotationXYZ(rotationX:Number, rotationY:Number, rotationZ:Number):Tween24 { return setDisplayObjectUpdater3("$rotationX", "$rotationY", "$rotationZ", rotationX, rotationY, rotationZ); }
		
		/**
		 * 目標とするX,Y,Z軸の回転角を、トゥイーン直前の値を基準に設定します。
		 * @param rotationX 角度
		 * @param rotationY 角度
		 * @param rotationZ 角度
		 * @return Tween24
		 */
		public function $$rotationXYZ(rotationX:Number, rotationY:Number, rotationZ:Number):Tween24 { return setDisplayObjectUpdater3("$$rotationX", "$$rotationY", "$$rotationZ", rotationX, rotationY, rotationZ); }
		
		
		// =============================================================================
		//
		// Prop Width, Height
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とする幅を設定します。
		 * @param width 幅
		 * @return Tween24
		 */
		public function width(width:Number):Tween24 { return setDisplayObjectUpdater("width", width); }
		
		/**
		 * 目標とする幅を、現在の値を基準に設定します。
		 * @param width 幅
		 * @return Tween24
		 */
		public function $width(width:Number):Tween24 { return setDisplayObjectUpdater("$width", width); }
		
		/**
		 * 目標とする幅を、トゥイーン直前の値を基準に設定します。
		 * @param width 幅
		 * @return Tween24
		 */
		public function $$width(width:Number):Tween24 { return setDisplayObjectUpdater("$$width", width); }
		
		/**
		 * 目標とする高さを設定します。
		 * @param height 高さ
		 * @return Tween24
		 */
		public function height(height:Number):Tween24 { return setDisplayObjectUpdater("height", height); }
		
		/**
		 * 目標とする高さを、現在の値を基準に設定します。
		 * @param height 高さ
		 * @return Tween24
		 */
		public function $height(height:Number):Tween24 { return setDisplayObjectUpdater("$height", height); }
		
		/**
		 * 目標とする高さを、トゥイーン直前の値を基準に設定します。
		 * @param height 高さ
		 * @return Tween24
		 */
		public function $$height(height:Number):Tween24 { return setDisplayObjectUpdater("$$height", height); }
		
		
		// =============================================================================
		//
		// Prop ScaleX
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とする水平スケールを設定します。
		 * @param scaleX 水平方向のスケール
		 * @return Tween24
		 */
		public function scaleX(scaleX:Number):Tween24 { return setDisplayObjectUpdater("scaleX", scaleX); }
		
		/**
		 * 目標とする水平スケールを、現在の値を基準に設定します。
		 * @param scaleX 水平方向のスケール
		 * @return Tween24
		 */
		public function $scaleX(scaleX:Number):Tween24 { return setDisplayObjectUpdater("$scaleX", scaleX); }
		
		/**
		 * 目標とする水平スケールを、トゥイーン直前の値を基準に設定します。
		 * @param scaleX 水平方向のスケール
		 * @return Tween24
		 */
		public function $$scaleX(scaleX:Number):Tween24 { return setDisplayObjectUpdater("$$scaleX", scaleX); }
		
		
		// =============================================================================
		//
		// Prop ScaleY
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とする垂直スケールを設定します。
		 * @param scaleY 垂直方向のスケール
		 * @return Tween24
		 */
		public function scaleY(scaleY:Number):Tween24 { return setDisplayObjectUpdater("scaleY", scaleY); }
		
		/**
		 * 目標とする垂直スケールを、現在の値を基準に設定します。
		 * @param scaleY 垂直方向のスケール
		 * @return Tween24
		 */
		public function $scaleY(scaleY:Number):Tween24 { return setDisplayObjectUpdater("$scaleY", scaleY); }
		
		/**
		 * 目標とする垂直スケールを、トゥイーン直前の値を基準に設定します。
		 * @param scaleY 垂直方向のスケール
		 * @return Tween24
		 */
		public function $$scaleY(scaleY:Number):Tween24 { return setDisplayObjectUpdater("$$scaleY", scaleY); }
		
		
		// =============================================================================
		//
		// Prop ScaleZ
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とする奥行スケールを設定します。
		 * @param scaleZ 奥行方向のスケール
		 * @return Tween24
		 */
		public function scaleZ(scaleZ:Number):Tween24 { return setDisplayObjectUpdater("scaleZ", scaleZ); }
		
		/**
		 * 目標とする奥行スケールを、現在の値を基準に設定します。
		 * @param scaleZ 奥行方向のスケール
		 * @return Tween24
		 */
		public function $scaleZ(scaleZ:Number):Tween24 { return setDisplayObjectUpdater("$scaleZ", scaleZ); }
		
		/**
		 * 目標とする奥行スケールを、トゥイーン直前の値を基準に設定します。
		 * @param scaleZ 奥行方向のスケール
		 * @return Tween24
		 */
		public function $$scaleZ(scaleZ:Number):Tween24 { return setDisplayObjectUpdater("$$scaleZ", scaleZ); }
		
		
		// =============================================================================
		//
		// Prop Scale X, Y
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とする水平・垂直スケールを設定します。
		 * @param scaleX 水平方向のスケール
		 * @param scaleY 垂直方向のスケール
		 * @return Tween24
		 */
		public function scaleXY(scaleX:Number, scaleY:Number):Tween24 { return setDisplayObjectUpdater2("scaleX", "scaleY", scaleX, scaleY); }
		
		/**
		 * 目標とする水平・垂直スケールを、現在の値を基準に設定します。
		 * @param scaleX 水平方向のスケール
		 * @param scaleY 垂直方向のスケール
		 * @return Tween24
		 */
		public function $scaleXY(scaleX:Number, scaleY:Number):Tween24 { return setDisplayObjectUpdater2("$scaleX", "$scaleY", scaleX, scaleY); }
		
		/**
		 * 目標とする水平・垂直スケールを、トゥイーン直前の値を基準に設定します。
		 * @param scaleX 水平方向のスケール
		 * @param scaleY 垂直方向のスケール
		 * @return Tween24
		 */
		public function $$scaleXY(scaleX:Number, scaleY:Number):Tween24 { return setDisplayObjectUpdater2("$$scaleX", "$$scaleY", scaleX, scaleY); }
		
		/**
		 * 目標とするスケールを設定します。
		 * @param scale スケール
		 * @return Tween24
		 */
		public function scale(scale:Number):Tween24 { return setDisplayObjectUpdater2("scaleX", "scaleY", scale, scale); }
		
		
		// =============================================================================
		//
		// Prop Scale X, Y, Z
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とする水平・垂直スケールを設定します。
		 * @param scaleX 水平方向のスケール
		 * @param scaleY 垂直方向のスケール
		 * @param scaleZ 奥行き方向のスケール
		 * @return Tween24
		 */
		public function scaleXYZ(scaleX:Number, scaleY:Number, scaleZ:Number):Tween24 { return setDisplayObjectUpdater3("scaleX", "scaleY", "scaleZ", scaleX, scaleY, scaleZ); }
		
		/**
		 * 目標とする水平・垂直スケールを、現在の値を基準に設定します。
		 * @param scaleX 水平方向のスケール
		 * @param scaleY 垂直方向のスケール
		 * @param scaleZ 奥行き方向のスケール
		 * @return Tween24
		 */
		public function $scaleXYZ(scaleX:Number, scaleY:Number, scaleZ:Number):Tween24 { return setDisplayObjectUpdater3("$scaleX", "$scaleY", "$scaleZ", scaleX, scaleY, scaleZ); }
		
		/**
		 * 目標とする水平・垂直スケールを、トゥイーン直前の値を基準に設定します。
		 * @param scaleX 水平方向のスケール
		 * @param scaleY 垂直方向のスケール
		 * @param scaleZ 奥行き方向のスケール
		 * @return Tween24
		 */
		public function $$scaleXYZ(scaleX:Number, scaleY:Number, scaleZ:Number):Tween24 { return setDisplayObjectUpdater3("$$scaleX", "$$scaleY", "$$scaleZ", scaleX, scaleY, scaleZ); }
		
		
		// =============================================================================
		//
		// Prop Global & Local X, Y
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするX座標を、ステージ基準で設定します。
		 * @param x グローバルX座標
		 * @return Tween24
		 */
		public function globalX(x:Number):Tween24 { return setDisplayObjectUpdater("globalX", x); }
		
		/**
		 * 目標とするY座標を、ステージ基準で設定します。
		 * @param y グローバルY座標
		 * @return Tween24
		 */
		public function globalY(y:Number):Tween24 { return setDisplayObjectUpdater("globalY", y); }
		
		/**
		 * 目標とするX,Y座標を、ステージ基準で設定します。
		 * @param x グローバルX座標
		 * @param y グローバルY座標
		 * @return Tween24
		 */
		public function globalXY(x:Number, y:Number):Tween24 { return setDisplayObjectUpdater2("globalX", "globalY", x, y); }
		
		/**
		 * 目標とするX座標を、指定したオブジェクト基準で設定します。
		 * @param x ローカルX座標
		 * @return Tween24
		 */
		public function localX(localTarget:DisplayObject, x:Number):Tween24 { return setDisplayObjectUpdater2("localXTarget", "localX", localTarget, x); }
		
		/**
		 * 目標とするY座標を、指定したオブジェクト基準で設定します。
		 * @param y ローカルY座標
		 * @return Tween24
		 */
		public function localY(localTarget:DisplayObject, y:Number):Tween24 { return setDisplayObjectUpdater2("localYTarget", "localY", localTarget, y); }
		
		/**
		 * 目標とするX,Y座標を、指定したオブジェクト基準で設定します。
		 * @param x ローカルX座標
		 * @param y ローカルY座標
		 * @return Tween24
		 */
		public function localXY(localTarget:DisplayObject, x:Number, y:Number):Tween24 { return setDisplayObjectUpdater3("localTarget", "localX", "localY", localTarget, x, y); }
		
		
		// =============================================================================
		//
		// Prop FadeIn / FadeOut / Visible
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とする透明度を 1 に設定し、トゥイーン開始時に visible を true に設定します。
		 * @param useLayerBlend トゥイーン中のブレンドモードをレイヤーに設定するか
		 * @return Tween24
		 */
		public function fadeIn(useLayerBlend:Boolean = false):Tween24 { return setDisplayObjectUpdater3("alpha", "fadeIn", "useLayerBlend", 1, true, useLayerBlend); }
		
		/**
		 * 目標とする透明度を 0 に設定し、トゥイーン完了時に visible を false に設定します。
		 * @param useLayerBlend トゥイーン中のブレンドモードをレイヤーに設定するか
		 * @return Tween24
		 */
		public function fadeOut(useLayerBlend:Boolean = false):Tween24 { return setDisplayObjectUpdater3("alpha", "fadeOut", "useLayerBlend", 0, true, useLayerBlend); }
		
		/**
		 * 目標とする可視状態を設定します。 true が指定された場合はトゥイーン開始時に、 false が指定された場合トゥイーン終了時に設定されます。
		 * @param visible 可視状態
		 * @return Tween24
		 */
		public function visible(visible:Boolean):Tween24
		{
			if (visible) setDisplayObjectUpdater("fadeIn" , true);
			else         setDisplayObjectUpdater("fadeOut", true);
			return this;
		}
		
		
		// =============================================================================
		//
		// MouseEnabled / MouseChildren
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * マウスイベントを有効にするかを設定します。
		 * @param enabled 有効にするか
		 * @return Tween24
		 */
		public function mouseEnabled(enabled:Boolean):Tween24
		{
			return setDisplayObjectUpdater("mouseEnabled", enabled);
		}
		
		/**
		 * オブジェクトの子に対してマウスイベントを有効にするかを設定します。
		 * @param enabled 有効にするか
		 * @return Tween24
		 */
		public function mouseChildren(enabled:Boolean):Tween24
		{
			return setDisplayObjectUpdater("mouseChildren", enabled);
		}
		
		/**
		 * オブジェクトとその子に対してマウスを有効にするかを設定します。
		 * @param enabled 有効にするか
		 * @return Tween24
		 */
		public function buttonEnabled(enabled:Boolean):Tween24
		{
			return setDisplayObjectUpdater("buttonEnabled", enabled);
		}
		
		
		// =============================================================================
		//
		// Prop Align
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * オブジェクトの基準点を擬似的に変更します。
		 * @param align 基準点
		 * @return Tween24
		 */
		public function align(align:uint):Tween24 { return setDisplayObjectUpdater("align", align); }
		
		/**
		 * オブジェクトのX軸の基準点の座標を擬似的に変更します。
		 * @param alignX X軸の基準点座標
		 * @return Tween24
		 */
		public function alignX(alignX:Number):Tween24 { return setDisplayObjectUpdater("alignX", alignX); }
		
		/**
		 * オブジェクトのY軸の基準点を擬似的に変更します。
		 * @param alignY Y軸の基準点座標
		 * @return Tween24
		 */
		public function alignY(alignY:Number):Tween24 { return setDisplayObjectUpdater("alignY", alignY); }
		
		/**
		 * オブジェクトの基準点の座標を擬似的に変更します。
		 * @param alignX X軸の基準点座標
		 * @param alignY Y軸の基準点座標
		 * @return Tween24
		 */
		public function alignXY(alignX:Number, alignY:Number):Tween24 { return setDisplayObjectUpdater2("alignX", "alignY", alignX, alignY); }
		
		/**
		 * オブジェクトの基準点をX軸のスケール値を元に擬似的に変更します。
		 * @param scaleX 基準点となるX軸のスケール値
		 * @return Tween24
		 */
		public function alignByScaleX(scaleX:Number):Tween24 { return setDisplayObjectUpdater("alignScaleX", scaleX); }
		
		/**
		 * オブジェクトの基準点をY軸のスケール値を元に擬似的に変更します。
		 * @param scaleY 基準点となるY軸のスケール値
		 * @return Tween24
		 */
		public function alignByScaleY(scaleY:Number):Tween24 { return setDisplayObjectUpdater("alignScaleY", scaleY); }
		
		/**
		 * オブジェクトの基準点をスケール値を元に擬似的に変更します。
		 * @param scaleX 基準点となるX軸のスケール値
		 * @param scaleY 基準点となるY軸のスケール値
		 * @return Tween24
		 */
		public function alignByScaleXY(scaleX:Number, scaleY:Number):Tween24 { return setDisplayObjectUpdater2("alignScaleX", "alignScaleY", scaleX, scaleY); }
		
		/**
		 * オブジェクトの基準点をスケール値を元に擬似的に変更します。
		 * @param scale 基準点となるXY軸のスケール値
		 * @return Tween24
		 */
		public function alignByScale(scale:Number):Tween24 { return setDisplayObjectUpdater2("alignScaleX", "alignScaleY", scale, scale); }
		
		
		// =============================================================================
		//
		// Prop Bezier $ Random
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * トゥイーンのベジェ曲線のアンカーポイントを設定します。
		 * @param x	アンカーポイントX座標
		 * @param y	アンカーポイントY座標
		 * @return Tween24
		 */
		public function bezier(x:Number, y:Number):Tween24 { return setDisplayObjectUpdaterBezier("bezier", x, y); }
		
		/**
		 * トゥイーンのベジェ曲線のアンカーポイントを、現在の座標を基準に設定します。
		 * @param x	アンカーポイントX座標
		 * @param y	アンカーポイントY座標
		 * @return Tween24
		 */
		public function $bezier(x:Number, y:Number):Tween24 { return setDisplayObjectUpdaterBezier("$bezier", x, y); }
		
		/**
		 * トゥイーンのベジェ曲線のアンカーポイントを、、トゥイーン直前の値を基準に設定します。
		 * @param x	アンカーポイントX座標
		 * @param y	アンカーポイントY座標
		 * @return Tween24
		 */
		public function $$bezier(x:Number, y:Number):Tween24 { return setDisplayObjectUpdaterBezier("$$bezier", x, y); }
		
		/**
		 * 目標X座標に、ランダム性を付加します。
		 * @param minRandomX 乱数の最小値
		 * @param maxRandomX 乱数の最大値
		 * @param round 四捨五入して整数値にするか
		 * @return Tween24
		 */
		public function randomX(minRandomX:Number, maxRandomX:Number, round:Boolean = true):Tween24 { return setDisplayObjectUpdater3("randomMinX", "randomMaxX", "randomRound", minRandomX, maxRandomX, round); }
		
		/**
		 * 目標Y座標に、ランダム性を付加します。
		 * @param minRandomY 乱数の最小値
		 * @param maxRandomY 乱数の最大値
		 * @param round 四捨五入して整数値にするか
		 * @return Tween24
		 */
		public function randomY(minRandomY:Number, maxRandomY:Number, round:Boolean = true):Tween24 { return setDisplayObjectUpdater3("randomMinY", "randomMaxY", "randomRound", minRandomY, maxRandomY, round); }
		
		/**
		 * 目標Z座標に、ランダム性を付加します。
		 * @param minRandomZ 乱数の最小値
		 * @param maxRandomZ 乱数の最大値
		 * @param round 四捨五入して整数値にするか
		 * @return Tween24
		 */
		public function randomZ(minRandomZ:Number, maxRandomZ:Number, round:Boolean = true):Tween24 { return setDisplayObjectUpdater3("randomMinZ", "randomMaxZ", "randomRound", minRandomZ, maxRandomZ, round); }
		
		/**
		 * 目標X,Y座標に、ランダム性を付加します。
		 * @param minRandom 乱数の最小値
		 * @param maxRandom 乱数の最大値
		 * @param round 四捨五入して整数値にするか
		 * @return Tween24
		 */
		
		public function randomXY(minRandom:Number, maxRandom:Number, round:Boolean = true):Tween24 { return setDisplayObjectUpdater3("randomMinXY", "randomMaxXY", "randomRound", minRandom, maxRandom, round); }
		/**
		 * 目標X,Y,Z座標に、ランダム性を付加します。
		 * @param minRandom 乱数の最小値
		 * @param maxRandom 乱数の最大値
		 * @param round 四捨五入して整数値にするか
		 * @return Tween24
		 */		
		public function randomXYZ(minRandom:Number, maxRandom:Number, round:Boolean = true):Tween24 { return setDisplayObjectUpdater3("randomMinXYZ", "randomMaxXYZ", "randomRound", minRandom, maxRandom, round); }
		
		
		// =============================================================================
		//
		// Prop Frame
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするタイムラインのフレームを設定します。
		 * @param frame	フレーム数
		 * @return Tween24
		 */
		public function frame(frame:int):Tween24
		{
			_isFilter = true;
			_timelineUpdaters ||= new Dictionary();
			_timelineUpdater ||= new TimelineUpdater();
			_timelineUpdater.setProp(frame);
			return this;
		}
		
		
		// =============================================================================
		//
		// Prop BlurFilter
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするブラーフィルタのパラメータを設定します。
		 * @param blurX	水平方向のぼかし量(デフォルト値:4.0)
		 * @param blurY	垂直方向のぼかし量(デフォルト値:4.0)
		 * @param quality ぼかしの実行回数(デフォルト値:1)
		 * @return Tween24
		 */
		public function blur(blurX:Number = NaN, blurY:Number = NaN, quality:Number = NaN):Tween24
		{
			_isFilter = true;
			_blurUpdater ||= new BlurFilterUpdater();
			_blurUpdater.setProp(blurX, blurY, quality);
			return this;
		}
		
		/**
		 * 目標とするブラーフィルタのパラメータを設定します。
		 * @param blurX	水平方向のぼかし量
		 * @return Tween24
		 */
		public function blurX(blurX:Number):Tween24
		{
			_isFilter = true;
			_blurUpdater ||= new BlurFilterUpdater();
			_blurUpdater.blurX = blurX;
			return this;
		}
		
		/**
		 * 目標とするブラーフィルタのパラメータを設定します。
		 * @param blurY	垂直方向のぼかし量
		 * @return Tween24
		 */
		public function blurY(blurY:Number):Tween24
		{
			_isFilter = true;
			_blurUpdater ||= new BlurFilterUpdater();
			_blurUpdater.blurY = blurY;
			return this;
		}
		
		/**
		 * 目標とするブラーフィルタのパラメータを設定します。
		 * @param blurX	水平方向のぼかし量
		 * @param blurY	垂直方向のぼかし量
		 * @return Tween24
		 */
		public function blurXY(blurX:Number, blurY:Number):Tween24
		{
			_isFilter = true;
			_blurUpdater  ||= new BlurFilterUpdater();
			_blurUpdater.blurX = blurX;
			_blurUpdater.blurY = blurY;
			return this;
		}
		
		/**
		 * 目標とするブラーフィルタのパラメータを設定します。
		 * @param quality ぼかしの実行回数
		 * @return Tween24
		 */
		public function blurQuality(quality:int):Tween24
		{
			_isFilter = true;
			_blurUpdater  ||= new BlurFilterUpdater();
			_blurUpdater.quality = quality;
			return this;
		}
		
		
		// =============================================================================
		//
		// Prop GlowFilter
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするグローフィルタのパラメータを設定します。
		 * @param color グローのカラー(デフォルト値:0xFF0000)
		 * @param alpha カラーの透明度(デフォルト値:1.0)
		 * @param blurX 水平方向のぼかし量(デフォルト値:6.0)
		 * @param blurY 垂直方向のぼかし量(デフォルト値:6.0)
		 * @param strength インプリントの強さ(デフォルト値:2.0)
		 * @param quality ぼかしの実行回数(デフォルト値:1)
		 * @return Tween24
		 */
		public function glow(color:Number = NaN, alpha:Number = NaN, blurX:Number = NaN, blurY:Number = NaN, strength:Number = NaN, quality:Number = NaN):Tween24
		{
			_isFilter = true;
			_glowUpdater  ||= new GlowFilterUpdater();
			_glowUpdater.setProp(color, alpha, blurX, blurY, strength, quality);
			return this;
		}
		
		/**
		 * 目標とするグローフィルタのパラメータを設定します。
		 * @param color	グローのカラー
		 * @return Tween24
		 */
		public function glowColor(color:Number):Tween24
		{
			_isFilter = true;
			_glowUpdater  ||= new GlowFilterUpdater();
			_glowUpdater.color = color;
			return this;
		}
		
		/**
		 * 目標とするグローフィルタのパラメータを設定します。
		 * @param alpha	カラーの透明度
		 * @return Tween24
		 */
		public function glowAlpha(alpha:Number):Tween24
		{
			_isFilter = true;
			_glowUpdater  ||= new GlowFilterUpdater();
			_glowUpdater.alpha = alpha;
			return this;
		}
		
		/**
		 * 目標とするグローフィルタのパラメータを設定します。
		 * @param blurX	水平方向のぼかし量
		 * @return Tween24
		 */
		public function glowBlurX(blurX:Number):Tween24
		{
			_isFilter = true;
			_glowUpdater  ||= new GlowFilterUpdater();
			_glowUpdater.blurX = blurX;
			return this;
		}
		
		/**
		 * 目標とするグローフィルタのパラメータを設定します。
		 * @param blurY	垂直方向のぼかし量
		 * @return Tween24
		 */
		public function glowBlurY(blurY:Number):Tween24
		{
			_isFilter = true;
			_glowUpdater  ||= new GlowFilterUpdater();
			_glowUpdater.blurY = blurY;
			return this;
		}
		
		/**
		 * 目標とするグローフィルタのパラメータを設定します。
		 * @param blurX	水平方向のぼかし量
		 * @param blurY	垂直方向のぼかし量
		 * @return Tween24
		 */
		public function glowBlurXY(blurX:Number, blurY:Number):Tween24
		{
			_isFilter = true;
			_glowUpdater  ||= new GlowFilterUpdater();
			_glowUpdater.blurX = blurX;
			_glowUpdater.blurY = blurY;
			return this;
		}
		
		/**
		 * 目標とするグローフィルタのパラメータを設定します。
		 * @param strength インプリントの強さ
		 * @return Tween24
		 */
		public function glowStrength(strength:int):Tween24
		{
			_isFilter = true;
			_glowUpdater  ||= new GlowFilterUpdater();
			_glowUpdater.strength = strength;
			return this;
		}
		
		/**
		 * 目標とするグローフィルタのパラメータを設定します。
		 * @param quality ぼかしの実行回数
		 * @return Tween24
		 */
		public function glowQuality(quality:int):Tween24
		{
			_isFilter = true;
			_glowUpdater  ||= new GlowFilterUpdater();
			_glowUpdater.quality = quality;
			return this;
		}
		
		/**
		 * 目標とするグローフィルタのパラメータを設定します。
		 * @param inner 内側グローかどうか
		 * @return Tween24
		 */
		public function glowInner(inner:Boolean):Tween24
		{
			_isFilter = true;
			_glowUpdater  ||= new GlowFilterUpdater();
			_glowUpdater.inner = inner;
			return this;
		}
		
		/**
		 * 目標とするグローフィルタのパラメータを設定します。
		 * @param inner	ノックアウト効果を適用するか
		 * @return Tween24
		 */
		public function glowKnockout(knockout:Boolean):Tween24
		{
			_isFilter = true;
			_glowUpdater  ||= new GlowFilterUpdater();
			_glowUpdater.knockout = knockout;
			return this;
		}
		
		
		// =============================================================================
		//
		// Prop DropShadowFilter
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param distance シャドウのオフセット距離(デフォルト値:4.0)
		 * @param angle シャドウの角度(デフォルト値:45)
		 * @param color シャドウのカラー(デフォルト値:0x000000)
		 * @param alpha カラーの透明度(デフォルト値:1.0)
		 * @param blurX 垂直方向のぼかし量(デフォルト値:4.0)
		 * @param blurY 垂直方向のぼかし量(デフォルト値:4.0)
		 * @param strength インプリントの強さ(デフォルト値:1.0)
		 * @param quality ぼかしの実行回数(デフォルト値:1)
		 * @return Tween24
		 */
		public function dropShadow(distance:Number = NaN, angle:Number = NaN, color:Number = NaN, alpha:Number = NaN, blurX:Number = NaN, blurY:Number = NaN, strength:Number = NaN, quality:Number = NaN):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.setProp(distance, angle, color, alpha, blurX, blurY, strength, quality);
			return this;
		}
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param distance シャドウのオフセット距離
		 * @return Tween24
		 */
		public function dropShadowDistance(distance:Number):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.distance = distance;
			return this;
		}
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param angle シャドウの角度
		 * @return Tween24
		 */
		public function dropShadowAngle(angle:Number):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.angle = angle;
			return this;
		}
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param color シャドウのカラー
		 * @return Tween24
		 */
		public function dropShadowColor(color:Number):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.color = color;
			return this;
		}
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param alpha カラーの透明度
		 * @return Tween24
		 */
		public function dropShadowAlpha(alpha:Number):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.alpha = alpha;
			return this;
		}
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param blurX 垂直方向のぼかし量
		 * @return Tween24
		 */
		public function dropShadowBlurX(blurX:Number):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.blurX = blurX;
			return this;
		}
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param blurY	垂直方向のぼかし量
		 * @return Tween24
		 */
		public function dropShadowBlurY(blurY:Number):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.blurY = blurY;
			return this;
		}
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param blurX	垂直方向のぼかし量
		 * @return Tween24
		 */
		public function dropShadowBlurXY(blurX:Number, blurY:Number):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.blurX = blurX;
			_dropShadowUpdater.blurY = blurY;
			return this;
		}
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param strength インプリントの強さ
		 * @return Tween24
		 */
		public function dropShadowStrength(strength:Number):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.strength = strength;
			return this;
		}
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param quality ぼかしの実行回数
		 * @return Tween24
		 */
		public function dropShadowQuality(quality:Number):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.quality = quality;
			return this;
		}
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param inner	内側グローかどうか
		 * @return Tween24
		 */
		public function dropShadowInner(inner:Boolean):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.inner = inner;
			return this;
		}
		
		/**
		 * 目標とするドロップシャドウフィルタのパラメータを設定します。
		 * @param inner ノックアウト効果を適用するか
		 * @return Tween24
		 */
		public function dropShadowKnockout(knockout:Boolean):Tween24
		{
			_isFilter = true;
			_dropShadowUpdater ||= new DropShadowFilterUpdater();
			_dropShadowUpdater.knockout = knockout;
			return this;
		}
		
		
		// =============================================================================
		//
		// Prop Brightness / Contrast / Saturation
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とする明るさの値を設定します。
		 * @param brightness 明るさ(-2.55 - 2.55)
		 * @return Tween24
		 */
		public function bright(brightness:Number):Tween24
		{
			_isFilter = true;
			_brightUpdater ||= new BrightUpdater();
			_brightUpdater.setProp(brightness);
			return this;
		}
		
		/**
		 * 目標とするコントラストの値を設定します。
		 * @param contrast コントラスト
		 * @return Tween24
		 */
		public function contrast(contrast:Number):Tween24
		{
			_isFilter = true;
			_contrastUpdater ||= new ContrastUpdater();
			_contrastUpdater.setProp(contrast);
			return this;
		}
		
		/**
		 * 目標とする彩度を設定します。
		 * @param saturation 彩度(0 - 1.0)
		 * @return Tween24
		 */
		public function saturation(saturation:Number):Tween24
		{
			_isFilter = true;
			_saturationUpdater ||= new SaturationUpdater();
			_saturationUpdater.setProp(saturation);
			return this;
		}
		
		/**
		 * 目標とするシャープネスを設定します。
		 * @param sharpness シャープネス
		 * @return Tween24
		 */
		public function sharp(sharpness:Number):Tween24
		{
			_isFilter = true;
			_sharpUpdater ||= new SharpUpdater();
			_sharpUpdater.setProp(sharpness);
			return this;
		}
		
		
		// =============================================================================
		//
		// Prop Color
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 目標とする着色のパラメータを設定します。
		 * @param color	着色カラー
		 * @param alpha	カラーの透明度
		 * @return Tween24
		 */
		public function color(color:Number = NaN, alpha:Number = 1):Tween24
		{
			_isFilter = true;
			var clear:Boolean = isNaN(color);
			if (clear) alpha = 0;
			_colorUpdater  ||= new ColorUpdater();
			_colorUpdater.setProp(color, alpha, clear);
			return this;
		}
		
		/**
		 * 目標とする着色の透明度を設定します。
		 * (場合によって色値に微量の誤差が生じるため、正確な色値を保持したい場合はcolor()メソッドの使用を推奨します。)
		 * @param alpha	カラーの透明度
		 * @return Tween24
		 */
		public function colorAlpha(alpha:Number):Tween24
		{
			_isFilter = true;
			_colorUpdater  ||= new ColorUpdater();
			_colorUpdater.setProp(NaN, alpha, isNaN(alpha));
			return this;
		}
		
		/**
		 * 目標とする色反転値を設定します。
		 * @param value	反転値（-1 - 1）
		 * @return Tween24
		 */
		public function colorReversal(value:Number):Tween24
		{
			_isFilter = true;
			_colorReversalUpdater  ||= new ColorReversalUpdater();
			_colorReversalUpdater.setProp(value);
			return this;
		}
		
		
		
		// =============================================================================
		//
		// Event
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * トゥイーン再生時に実行する関数を設定します。
		 * @param func 実行関数
		 * @param ...args 引数
		 * @return Tween24
		 */
		public function onPlay(func:Function, ...args):Tween24
		{
			_onPlay = func;
			_onPlayArgs = args;
			return this;
		}
		
		/**
		 * トゥイーン遅延中に実行する関数を設定します。
		 * @param func 実行関数
		 * @param ...args 引数
		 * @return Tween24
		 */
		public function onDelay(func:Function, ...args):Tween24
		{
			_onDelay = func;
			_onDelayArgs = args;
			return this;
		}
		
		/**
		 * トゥイーン開始時に実行する関数を設定します。
		 * @param func 実行関数
		 * @param ...args 引数
		 * @return Tween24
		 */
		public function onInit(func:Function, ...args):Tween24
		{
			_onInit = func;
			_onInitArgs = args;
			return this;
		}
		
		/**
		 * トゥイーン実行中に実行する関数を設定します。
		 * @param func 実行関数
		 * @param ...args 引数
		 * @return Tween24
		 */
		public function onUpdate(func:Function, ...args):Tween24
		{
			_onUpdate = func;
			_onUpdateArgs = args;
			return this;
		}
		
		/**
		 * トゥイーン一時停止時に実行する関数を設定します。
		 * @param func 実行関数
		 * @param ...args 引数
		 * @return Tween24
		 */
		public function onPause(func:Function, ...args):Tween24
		{
			_onPause = func;
			_onPauseArgs = args;
			return this;
		}
		
		/**
		 * トゥイーン一時停止時に実行する関数を設定します。
		 * @param func 実行関数
		 * @param ...args 引数
		 * @return Tween24
		 */
		public function onSkip(func:Function, ...args):Tween24
		{
			_onSkip = func;
			_onSkipArgs = args;
			return this;
		}
		
		/**
		 * トゥイーン停止時に実行する関数を設定します。
		 * @param func 実行関数
		 * @param ...args 引数
		 * @return Tween24
		 */
		public function onStop(func:Function, ...args):Tween24
		{
			_onStop = func;
			_onStopArgs = args;
			return this;
		}
		
		/**
		 * トゥイーン完了時に実行する関数を設定します。
		 * @param func 実行関数
		 * @param ...args 引数
		 * @return Tween24
		 */
		public function onComplete(func:Function, ...args):Tween24
		{
			_onComp = func;
			_onCompArgs = args;
			return this;
		}
		
		
		// =============================================================================
		//
		// Prop Etc
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * トゥイーンの遅延時間を設定します。
		 * @param time 遅延時間
		 * @return Tween24
		 */
		public function delay(time:Number):Tween24
		{
			_delayTime += time;
			_totalTime += _delayTime;
			return this;
		}
		
		/**
		 * トゥイーンの遅延回数を設定します。
		 * @param count 遅延回数
		 * @return Tween24
		 */
		public function delayCount(count:uint):Tween24
		{
			_delayCount += count;
			return this;
		}
		
		/**
		 * 次のトゥイーンに移行するトリガートゥイーンに設定します。
		 * @return Tween24
		 */
		public function jump():Tween24
		{
			_isJump = true;
			return this;
		}
		
		/**
		 * IDを設定します。IDを設定しておくと、IDを元にトゥーンを制御できるようになります。
		 * @param id トゥイーンID名
		 * @return Tween24
		 */
		public function id(id:String):Tween24
		{
			_id = id;
			_tweensById[_id] = this;
			return this;
		}
		
		/**
		 * グループのIDを設定します。IDを設定しておくと、IDを元に複数のトゥーンをまとめて制御できるようになります。
		 * @param id トゥイーングループ名
		 * @return Tween24
		 */
		public function group(...id):Tween24
		{
			_group ||= [];
			_group = _group.concat(id);
			
			for each (var i:String in id) {
				_tweensByGroup[i] ||= [];
				_tweensByGroup[i].push(this);
			}
			return this;
		}
		
		/**
		 * トゥイーン完了時に、親の表示リストから削除します。
		 * @return Tween24
		 */
		public function andRemoveChild():Tween24
		{
			_isRemoveParent = true;
			_action = function():void { Util24.display.removeChild(_targetSingle || _target); };
			return this;
		}
		
		public function timeScale(timeScale:Number):Tween24
		{
			_timeScale = timeScale;
			return this;
		}
		
		/**
		 * トゥイーンするパラメータを追加します。
		 * @param params
		 */
		public function addParam(pramName:String, value:*):void
		{
			if (_targetSingle) {
				_objectUpdater ||= new ObjectUpdater(_targetSingle);
				_objectUpdater.addProp(pramName, value);
			}
			else {
				_objectUpdaters ||= new Dictionary();
				for each(var t:* in _target) {
					var updater:ObjectUpdater = _objectUpdaters[t] || new ObjectUpdater(t);
					updater.addProp(pramName, value);
					_objectUpdaters[t] = updater;
				}
			}
		}
		
		
		
		
		// =============================================================================
		//
		// to String
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 文字列を返します。
		 * @return
		 */
		public function toString():String
		{
			var params:String = '';
			params += formatToString("type", _actionName || _type);
			
			// Target
			if (_targetSingle) {
				params += ' target:';
				if (_targetSingle is DisplayObject) params += '"' + _targetSingle.name + '"';
				else               params += _targetSingle;
			}
			else if (_target) {
				params += formatToString('target', _target, "name");
			}
			
			// Time
			if (_time) params += formatToString("time", _time);
			
			// Filter
			if (_blurUpdater)       params += _blurUpdater      .toString();
			if (_glowUpdater)       params += _glowUpdater      .toString();
			if (_dropShadowUpdater) params += _dropShadowUpdater.toString();
			if (_saturationUpdater) params += _saturationUpdater.toString();
			if (_brightUpdater)     params += _brightUpdater    .toString();
			if (_colorUpdater)      params += _colorUpdater     .toString();
			if (_contrastUpdater)   params += _contrastUpdater  .toString();
			if (_timelineUpdater)   params += _timelineUpdater  .toString();
			
			// ID & Group
			if (_id)    params += formatToString("id", _id);
			if (_group) params += formatToString("group", _group);
			
			return '[Tween24' + params + ']';
			//return '[Tween24 ' + _uniqueId + params + ']';
		}
		
		private function formatToString(label:String, value:*, paramNmae:String = null):String
		{
			if      (value is String) value = '"' + value + '"';
			else if (value is Array)  {
				if (paramNmae) {
					var vs:Array = [];
					for each (var v:Object in value) vs.push(v[paramNmae]);
					if (vs[0] is String)  value = '["' + vs.join('", "') + '"]';
					else value = '[' + vs + ']';
				}
				else {
					if (value[0] is String) value = '["' + value.join('", "') + '"]';
				}
			}
			return ' ' + label + ':' + value;
		}
		
		private function debugTrace(label:String):void
		{
			var tab:String = "";
			for (var i:int = 0; i < _level; i++) tab += "    ";
			trace(tab + "[" + label + "]" + toString());
		}
		
		
		
		
		
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * STATIC PUBLIC
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		
		// =============================================================================
		//
		// Tween / Prop / TweenFunc
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * トゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param time 時間
		 * @param easing イージング関数
		 * @param params カスタムパラメータ
		 * @return Tween24
		 */
		static public function tween(target:Object, time:Number, easing:Function = null, params:Object = null):Tween24
		{
			var tween:Tween24 = new Tween24(target, time, easing, params);
			tween._type = _TYPE_TWEEN;
			tween._actionName = "tween";
			return tween;
		}
		
		/**
		 * プロパティを設定します。
		 * @param target 対象オブジェクト
		 * @param params カスタムパラメータ
		 * @return Tween24
		 */
		static public function prop(target:Object, params:Object = null):Tween24
		{
			var tween:Tween24 = new Tween24(target, 0, null, params);
			tween._type = _TYPE_PROP;
			tween._actionName = "prop";
			return tween;
		}
		
		/**
		 * 引数の値をトゥイーンさせ、指定された関数を実行します。
		 * @param func 実行する関数
		 * @param time 時間
		 * @param startArgs 初期の引数
		 * @param compArgs 目標の引数
		 * @param easing イージング関数
		 * @return Tween24
		 */
		static public function tweenFunc(func:Function, time:Number, startArgs:Array, compArgs:Array, easing:Function = null):Tween24
		{
			var tween:Tween24 = new Tween24(null, time, easing);
			tween._type = _TYPE_TWEEN_FUNC;
			tween._actionName = "tweenFunc";
			tween._tweenFunc = func;
			tween._tweenStartArgs = startArgs;
			tween._tweenCompArgs = compArgs;
			tween._tweenDeltaArgs = [];
			
			var len:int = startArgs.length;
			for (var i:int = 0; i < len; i++) tween._tweenDeltaArgs.push(compArgs[i] - startArgs[i]);
			
			return tween;
			
		}
		
		/**
		 * トゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param velocity 1秒辺りの移動する距離
		 * @param easing イージング関数
		 * @param params カスタムパラメータ
		 * @return Tween24
		 */
		static public function tweenVelocity(target:Object, velocity:Number, easing:Function = null, params:Object = null):Tween24
		{
			var tween:Tween24 = new Tween24(target, 999, easing, params);
			tween._type = _TYPE_TWEEN;
			tween._actionName = "tweenVelocity";
			tween._velocity = velocity;
			return tween;
		}
		
		
		
		
		// =============================================================================
		//
		// Count Tween
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * アップデート回数に応じて再生されるトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param count カウント数
		 * @param easing イージング関数
		 * @param params カスタムパラメータ
		 * @return Tween24
		 */
		static public function tweenCount(target:Object, count:int, easing:Function = null, params:Object = null):Tween24
		{
			var tween:Tween24 = new Tween24(target, NaN, easing);
			tween._type = _TYPE_TWEEN_COUNT;
			tween._actionName = "tweenCount";
			tween._totalCount = count;
			return tween;
		}
		
		/**
		 * アップデート回数に応じて待機するトゥイーンを設定します。
		 * @param count カウント数
		 * @return Tween24
		 */
		static public function waitCount(count:uint):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_WAIT_COUNT;
			tween._actionName = "waitCount";
			tween._totalCount = count;
			return tween;
		}
		
		/**
		 * アップデート回数に応じて引数の値をトゥイーンさせ、指定された関数を実行します。
		 * @param func 実行する関数
		 * @param time 時間
		 * @param startArgs 初期の引数
		 * @param compArgs 目標の引数
		 * @param easing イージング関数
		 * @return Tween24
		 */
		static public function funcCount(func:Function, count:uint, startArgs:Array, compArgs:Array, easing:Function = null):Tween24
		{
			var tween:Tween24 = new Tween24(null, NaN, easing);
			tween._type = _TYPE_FUNC_COUNT;
			tween._actionName = "funcCount";
			tween._tweenFunc = func;
			tween._tweenStartArgs = startArgs;
			tween._tweenCompArgs = compArgs;
			tween._tweenDeltaArgs = [];
			tween._totalCount = count;
			
			var len:int = startArgs.length;
			for (var i:int = 0; i < len; i++) tween._tweenDeltaArgs.push(compArgs[i] - startArgs[i]);
			return tween;
			
		}
		
		
		// =============================================================================
		//
		// Serial Tween
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 順番に実行するトゥイーンを設定します。
		 * @param ...tweens トゥイーンたち
		 * @return Tween24
		 */
		static public function serial(...tween):Tween24
		{
			var parent:Tween24 = new Tween24();
			parent._type = _TYPE_SERIAL;
			parent._actionName = "serial";
			tween = replacePlugin(tween);
			
			var totalTime:Number = 0;
			var len:int  = tween.length;
			var jump:Boolean;
			
			for (var i:int = 0; i < len; i++)
			{
				var tw:Tween24 = tween[i];
				
				tw._nextTween   = tween[i + 1];
				tw._parentTween = parent;
				
				if (tw._isJump) {
					totalTime = tw._totalTime + tw._delayTime;
					tw._parentTrigger = true;
					jump = true;
				}
				else if (!jump) {
					totalTime += tw._totalTime;
				}
			}
			if (!jump) tw._parentTrigger = true;
			
			parent._totalTime   = totalTime;
			parent._serialTween = tween[0];
			parent._numChildren = tween.length;
			return parent;
		}
		
		
		// =============================================================================
		//
		// Parallel Tween
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 同時に実行するトゥイーンを設定します。
		 * @param ...tweens トゥイーンたち
		 * @return Tween24
		 */
		static public function parallel(...tween):Tween24
		{
			var parent:Tween24 = new Tween24();
			parent._type = _TYPE_PARALLEL;
			parent._actionName = "parallel";
			tween = replacePlugin(tween);
			
			var totalTime1:Number = 0;
			
			for each (var tw:Tween24 in tween) {
				tw._parentTween = parent;
				
				if (tw._isJump) {
					totalTime1        = tw._totalTime + tw._delayTime;
					tw._parentTrigger = true;
				}
			}
			
			parent._totalTime = totalTime1;
			parent._parallelTweens = tween;
			parent._numChildren = tween.length;
			return parent;
		}
		
		
		// =============================================================================
		//
		// Lag Tween
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 時間差で再生するトゥイーンを設定します。
		 * @param delay 遅延時間
		 * @param ...tweens トゥイーンたち
		 * @return Tween24
		 */
		static public function lag(delay:Number, ...tweens):Tween24
		{
			tweens = replacePlugin(tweens);
			
			var childTweens:Array = [];
			for each (var tween:Tween24 in tweens)
			{
				var l:int = tween._target.length;
				for (var i:int = 0; i < l; i++)
				{
					var tar:Object = tween._target[i];
					var newTween:Tween24 = new Tween24(tar, tween._time, tween._easing);
					newTween._type = tween._type;
					newTween.delay(tween._delayTime + delay * i);
					
					if (tween._displayUpdaters) newTween._displayUpdater = tween._displayUpdaters[tar];
					
					var bl:BlurFilterUpdater       = tween._blurUpdater;
					var gw:GlowFilterUpdater       = tween._glowUpdater;
					var ds:DropShadowFilterUpdater = tween._dropShadowUpdater;
					var br:BrightUpdater           = tween._brightUpdater;
					var co:ContrastUpdater         = tween._contrastUpdater;
					var cl:ColorUpdater            = tween._colorUpdater;
					var sa:SaturationUpdater       = tween._saturationUpdater;
					var fr:TimelineUpdater         = tween._timelineUpdater;
					var cr:ColorReversalUpdater    = tween._colorReversalUpdater;
					var sh:SharpUpdater            = tween._sharpUpdater;
					
					// Filter & Special
					if (bl) newTween.blur(bl.blurX, bl.blurY, bl.quality); // Blur
					if (gw) newTween.glow(gw.color, gw.alpha, gw.blurX, gw.blurY, gw.strength, gw.quality); // Glow
					if (ds) newTween.dropShadow(ds.distance, ds.angle, ds.color, ds.alpha, ds.blurX, ds.blurY, ds.strength, ds.quality); // DropShadow
					if (br) newTween.bright(br.brightness); // Brightness
					if (co) newTween.contrast(co.contrast); // Contrast
					if (cl) newTween.color(cl.color, cl.alpha); // Color
					if (sa) newTween.saturation(sa.saturation); // Saturation
					if (fr) newTween.frame(fr.frame); // Frame
					if (cr) newTween.colorReversal(cr.value); // ColorReversal
					if (sh) newTween.sharp(sh.sharpness); // Sharp
					
					// Function
					if (tween._onPlay   != null) newTween.onPlay    (tween._onPlay  , tween._onPlayArgs);
					if (tween._onDelay  != null) newTween.onDelay   (tween._onDelay , tween._onDelayArgs);
					if (tween._onInit   != null) newTween.onInit    (tween._onInit  , tween._onInitArgs);
					if (tween._onUpdate != null) newTween.onUpdate  (tween._onUpdate, tween._onUpdateArgs);
					if (tween._onPause  != null) newTween.onPause   (tween._onPause , tween._onPauseArgs);
					if (tween._onStop   != null) newTween.onStop    (tween._onStop  , tween._onStopArgs);
					if (tween._onSkip   != null) newTween.onSkip    (tween._onSkip  , tween._onSkipArgs);
					if (tween._onComp   != null) newTween.onComplete(tween._onComp  , tween._onCompArgs);
					
					// Remove Child
					if (tween._isRemoveParent) newTween.andRemoveChild();
					
					childTweens.push(newTween);
				}
			}
			
			var lag:Tween24 = Tween24.parallel(childTweens);
			lag._type = _TYPE_LAG;
			lag._actionName = "lag";
			return lag;
		}
		
		
		// =============================================================================
		//
		// Loop Tween
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 繰返し再生するトゥイーンを設定します。引数で渡したトゥイーンはserialトゥイーンとして再生されます。
		 * @param loopCount 再生回数
		 * @param ...tween トゥイーンたち
		 * @return
		 */
		static public function loop(loopCount:int, ...tween):Tween24
		{
			var parent:Tween24 = new Tween24();
			parent._type = _TYPE_LOOP;
			parent._actionName = "loop";
			tween = replacePlugin(tween);
			
			var totalTime:Number = 0;
			var len:int  = tween.length;
			var jump:Boolean;
			
			for (var i:int = 0; i < len; i++)
			{
				var tw:Tween24  = tween[i];
				tw._nextTween   = tween[i + 1];
				tw._parentTween = parent;
				totalTime      += tw._totalTime;
			}
			
			parent._totalTime   = totalTime;
			parent._serialTween = tween[0];
			parent._numChildren = tween.length;
			parent._loopCount   = loopCount;
			
			return parent;
		}
		
		
		// =============================================================================
		//
		// If Case
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * フラグに応じて再生するトゥイーンを設定します。
		 * @param flag フラグ
		 * @param trueTween フラグがtrueの時に再生するトゥイーン
		 * @param falseTween フラグがfalseの時に再生するトゥイーン
		 * @return Tween24
		 */
		static public function ifCase(flag:*, trueTween:* = null, falseTween:* = null):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_IF_CASE;
			tween._actionName = "ifCase";
			tween._useIfCase = true;
			tween._numChildren = 1;
			tween._ifCaseBoolean = Boolean(flag);
			tween._ifCaseTrueTween = (trueTween is PulginTween24)? PulginTween24(trueTween).getTween24(): trueTween;
			tween._ifCaseFalseTween = (falseTween is PulginTween24)? PulginTween24(falseTween).getTween24(): falseTween;
			
			tween._ifCaseTrueTween._parentTween   = tween;
			if (falseTween) {
				tween._ifCaseFalseTween._parentTween   = tween;
			}
			
			return tween;
		}
		
		/**
		 * 指定した対象のプロパティ値に応じて再生するトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param porpName プロパティ名
		 * @param trueTween フラグがtrueの時に再生するトゥイーン
		 * @param falseTween フラグがfalseの時に再生するトゥイーン
		 * @return Tween24
		 */
		static public function ifCaseByProp(target:*, porpName:String, trueTween:Tween24 = null, falseTween:Tween24 = null):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_IF_CASE;
			tween._actionName = "ifCaseByProp";
			tween._useIfCase = true;
			tween._numChildren = 1;
			tween._ifCaseTarget = target;
			tween._ifCasePropName = porpName;
			tween._ifCaseTrueTween = trueTween;
			tween._ifCaseFalseTween = falseTween;
			
			tween._ifCaseTrueTween._parentTween   = tween;
			tween._ifCaseTrueTween._parentTrigger = true;
			if (falseTween) {
				tween._ifCaseFalseTween._parentTween   = tween;
				tween._ifCaseFalseTween._parentTrigger = true;
			}
			
			return tween;
		}
		
		/**
		 * 複数のトゥイーンの中からランダムで1つ再生します。
		 * @param ...tweens トゥイーンたち
		 * @return Tween24
		 */
		static public function random(...tweens):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_RANDOM;
			tween._actionName = "random";
			tween._randomTweens = tweens;
			tween._numChildren = 1;
			
			for each (var t:Tween24 in tweens) t._parentTween = tween;
			return tween;
		}
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * TWEEN CONTROL
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * 再生中のトゥイーンを操作します。
		 * @param funcName 実行関数
		 * @param ...args 引数
		 */
		static private function eachFuncInPlayingTweens(funcName:String, ...args):void
		{
			if (_firstTween) {
				var tween:Tween24 = _firstTween, next:Tween24;
				do {
					next = tween._nextList;
					if (!args.length) tween[funcName]();
					else tween[funcName].apply(tween, args);
				} while ((tween = next) != null);
			}
		}
		
		/**
		 * 一時停止中のトゥイーンを操作します。
		 * @param funcName 実行関数
		 * @param ...args 引数
		 */
		static private function eachFuncInPausingTweens(funcName:String, ...args):void
		{
			for each (var tween:Tween24 in _pausingAllTweens) {
				if (!args.length) tween[funcName]();
				else tween[funcName].apply(tween, args);
			}
		}
		
		/**
		 * 複数のトゥイーンを一度に操作するトゥイーンを返します。
		 * @param actionName アクション名
		 * @param tweens トゥイーンたち
		 * @param funcName 実行する関数名
		 * @param ...args 引数
		 * @return Tween24
		 */
		static private function getControlTween(actionName:String, tweens:Array, funcName:String, ...args):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = actionName;
			tween._action = function():void {
				for each (var tw:Tween24 in tweens) {
					if (!args.length) tw[funcName]();
					else tw[funcName].apply(tw, args);
				}
			};
			return tween;
		}
		
		/**
		 * 複数のトゥイーンを一度に操作するトゥイーンを返します。
		 * @param actionName アクション名
		 * @param getFunc 操作されるトゥイーンを取得する関数
		 * @param getArgs トゥイーンを取得する関数の引数
		 * @param funcName 操作関数名
		 * @param ...args 引数
		 * @return Tween24
		 */
		static private function getControlTweenBy(actionName:String, getFunc:Function, getArgs:Array, funcName:String, ...args):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = actionName;
			tween._action = function():void {
				for each (var tw:Tween24 in getFunc.apply(this, getArgs)) {
					if (!args.length) tw[funcName]();
					else tw[funcName].apply(tw, args);
				}
			};
			return tween;
		}
		
		
		// =============================================================================
		//
		// by ID
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 指定したIDのトゥイーンを再生します。 ※複数ID指定可
		 * @param id トゥイーンID
		 * @return Tween24
		 */
		static public function playById(...id):Tween24
		{
			return getControlTweenBy("playById", getTweenArrayById, id, "play");
		}
		
		/**
		 * 指定したIDのトゥイーンを一時停止します。 ※複数ID指定可
		 * @param id トゥイーンID
		 * @return Tween24
		 */
		static public function pauseById(...id):Tween24
		{
			return getControlTweenBy("pauseById", getTweenArrayById, id, "pause");
		}
		
		/**
		 * 指定したIDのトゥイーンをスキップします。 ※複数ID指定可
		 * @param ...id トゥイーンID
		 * @return Tween24
		 */
		static public function skipById(...id):Tween24
		{
			return getControlTweenBy("skipById", getTweenArrayById, id, "skip");
		}
		
		/**
		 * 指定したIDのトゥイーンを停止します。 ※複数ID指定可
		 * @param ...id トゥイーンID
		 * @return Tween24
		 */
		static public function stopById(...id):Tween24
		{
			return getControlTweenBy("stopById", getTweenArrayById, id, "stop");
		}
		
		/**
		 * 指定したIDのトゥイーンのタイムスケールを変更します。 ※複数ID指定可
		 * @param ...id トゥイーンID
		 * @return Tween24
		 */
		static public function setGlobalTimeScaleById(timeScale:Number, ...id):Tween24
		{
			return getControlTweenBy("setGlobalTimeScaleById", getTweenArrayById, id, "setTimeScale", timeScale);
		}
		
		/**
		 * 指定したIDのトゥイーンの  manualPlay() を実行します。 ※複数ID指定可
		 * @param ...id トゥイーンID
		 * @return Tween24
		 */
		static public function manualPlayById(...id):Tween24
		{
			return getControlTweenBy("manualPlayById", getTweenArrayById, id, "manualPlay");
		}
		
		/**
		 * 指定したIDのトゥイーンの  manualUpdate() を実行します。 ※複数ID指定可
		 * @param ...id トゥイーンID
		 * @return Tween24
		 */
		static public function manualUpdateById(...id):Tween24
		{
			return getControlTweenBy("manualUpdateById", getTweenArrayById, id, "manualUpdate");
		}
		
		/**
		 * 登録したIDトゥイーンを解放します。
		 * @param ...id トゥイーンID
		 * @return Tween24
		 */
		static public function disposeIdTween(...id):Tween24
		{
			var tween:Tween24  = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "disposeIdTween";
			tween._action = function():void { for each (var i:String in id) delete _tweensById[i]; };
			return tween;
		}
		
		
		// =============================================================================
		//
		// by Group
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 指定したグループトゥイーンを再生します。 ※複数グループ指定可
		 * @param ...id グループID
		 * @return Tween24
		 */
		static public function playByGroup(...id):Tween24
		{
			return getControlTweenBy("playByGroup", getTweenArrayByGroup, id, "play");
		}
		
		/**
		 * 指定したグループトゥイーンを一時停止します。 ※複数グループ指定可
		 * @param ...id グループID
		 * @return Tween24
		 */
		static public function pauseByGroup(...id):Tween24
		{
			return getControlTweenBy("pauseByGroup", getTweenArrayByGroup, id, "pause");
		}
		
		/**
		 * 指定したグループトゥイーンをスキップします。 ※複数グループ指定可
		 * @param ...id グループID
		 * @return Tween24
		 */
		static public function skipByGroup(...id):Tween24
		{
			return getControlTweenBy("skipByGroup", getTweenArrayByGroup, id, "skip");
		}
		
		/**
		 * 指定したグループトゥイーンを停止します。 ※複数グループ指定可
		 * @param ...id グループID
		 * @return Tween24
		 */
		static public function stopByGroup(...id):Tween24
		{
			return getControlTweenBy("stopByGroup", getTweenArrayByGroup, id, "stop");
		}
		
		/**
		 * 指定したグループトゥイーンのタイムスケールを変更します。 ※複数グループ指定可
		 * @param timeScale タイムスケール
		 * @param ...id グループID
		 * @return
		 */
		static public function setGlobalTimeScaleByGroup(timeScale:Number, ...id):Tween24
		{
			return getControlTweenBy("setGlobalTimeScaleByGroup", getTweenArrayByGroup, id, "setTimeScale", timeScale);
		}
		
		/**
		 * 指定したグループのトゥイーンの  manualPlay() を実行します。 ※複数グループ指定可
		 * @param ...id グループID
		 * @return Tween24
		 */
		static public function manualPlayByGroup(...id):Tween24
		{
			return getControlTweenBy("manualPlayByGroup", getTweenArrayByGroup, id, "manualPlay");
		}
		
		/**
		 * 指定したグループのトゥイーンの  manualUpdate() を実行します。 ※複数グループ指定可
		 * @param ...id グループID
		 * @return Tween24
		 */
		static public function manualUpdateByGroup(...id):Tween24
		{
			return getControlTweenBy("manualUpdateByGroup", getTweenArrayByGroup, id, "manualUpdate");
		}
		
		/**
		 * 登録したグループトゥイーンを解放します。 ※複数グループ指定可
		 * @param ...id グループID
		 * @return Tween24
		 */
		static public function disposeGroupTweens(...id):Tween24
		{
			var tween:Tween24  = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "disposeGroupTweens";
			tween._action = function():void { for each (var i:String in id) delete _tweensByGroup[i]; };
			return tween;
		}
		
		
		// =============================================================================
		//
		// by Target
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 指定したオブジェクトが関連しているトゥイーンを一時停止します。 ※複数ターゲット指定可
		 * @param ...target ターゲット
		 * @return Tween24
		 */
		static public function pauseByTarget(...target):Tween24
		{
			return getControlTweenBy("pauseByTarget", getPlayingTweenArrayByTarget, target, "pause");
		}
		
		/**
		 * 指定したオブジェクトが関連しているトゥイーンを停止します。 ※複数ターゲット指定可
		 * @param ...target ターゲット
		 * @return Tween24
		 */
		static public function stopByTarget(...target):Tween24
		{
			return getControlTweenBy("stopByTarget", getTweenArrayByTarget, target, "stop");
		}
		
		/**
		 * 指定したオブジェクトが関連しているトゥイーンのタイムスケールを変更します。 ※複数オブジェクト指定可
		 * @param timeScale タイムスケール
		 * @param ...target ターゲット
		 * @return Tween24
		 */
		static public function setGlobalTimeScaleByTarget(timeScale:Number, ...target):Tween24
		{
			return getControlTweenBy("setGlobalTimeScaleByTarget", getTweenArrayByTarget, target, "setTimeScale", timeScale);
		}
		
		
		
		/**
		 * 子オブジェクトに関連するトゥイーンを全て一時停止します。
		 * @param container 親コンテナ
		 * @return Tween24
		 */		
		static public function pauseChildTweens(...container):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "pauseChildTweens";
			tween._action = function():void {
				container = Util24.array.compressAndClean(container);
				for each (var cont:DisplayObjectContainer in container) {
					var childrend:Array = Util24.display.getAllChildren(cont);
					for each (var target:DisplayObject in childrend) {
						var list:Array = getTweenArrayByTarget(target);
						for each (var t:Tween24 in list) t.pause();
					}
				}
			};
			return tween;
		}
		
		/**
		 * 子オブジェクトに関連する一時停止中のトゥイーンを全て再開します。
		 * @param container 親コンテナ
		 * @return Tween24
		 */		
		static public function resumeChildTweens(...container):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "resumeChildTweens";
			tween._action = function():void {
				container = Util24.array.compressAndClean(container);
				for each (var cont:DisplayObjectContainer in container) {
					var childrend:Array = Util24.display.getAllChildren(cont);
					for each (var target:DisplayObject in childrend) {
						var list:Array = getTweenArrayByTarget(target);
						for each (var t:Tween24 in list) if (t.pausing) t.play2();
					}
				}
			};
			return tween;
		}
		
		/**
		 * 子オブジェクトに関連する再生中、もしくは一時停止中のトゥイーンを全てスキップします。
		 * @param container 親コンテナ
		 * @return Tween24
		 */		
		static public function skipChildTweens(...container):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "skipChildTweens";
			tween._action = function():void {
				for each (var t:Tween24 in getAllChildrenTweens(container)) t.skip();
			};
			return tween;
		}
		
		/**
		 * 子オブジェクトに関連するトゥイーンを全て停止します。
		 * @param container 親コンテナ
		 * @return Tween24
		 */		
		static public function stopChildTweens(...container):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "stopChildTweens";
			tween._action = function():void {
				container = Util24.array.compressAndClean(container);
				for each (var cont:DisplayObjectContainer in container) {
					var childrend:Array = Util24.display.getAllChildren(cont);
					for each (var target:DisplayObject in childrend) {
						var list:Array = getTweenArrayByTarget(target);
						for each (var t:Tween24 in list) t.stop();
					}
				}
			};
			return tween;
		}
		
		static private function getAllChildrenTweens(container:Array):Array
		{
			container = Util24.array.compressAndClean(container);
			var list:Array = [];
			var result:Array = [];
			for each (var cont:DisplayObjectContainer in container) {
				var tweens:Array = getChildrenTween(cont);
				if (tweens) list.push(tweens);
			}
			result = result.concat.apply(result, list);
			return (result.length)? result: null;
		}
		
		static private function getChildrenTween(container:DisplayObjectContainer):Array
		{
			var tweens:Array;
			var list:Array = [];
			var result:Array = [];
			var children:Array = Util24.display.getAllChildren(container);
			for each (var target:DisplayObject in children) {
				if (target is DisplayObjectContainer) tweens = getChildrenTween(target as DisplayObjectContainer);
				else tweens = getTweenArrayByTarget(target);
				if (tweens) list.push(tweens);
			}
			tweens = getTweenArrayByTarget(container);
			if (tweens) list.push(tweens);
			result = result.concat.apply(result, list);
			return result;
		}
		
		
		// =============================================================================
		//
		// by Array
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 指定した配列内にあるトゥイーンを再生します。 ※複数オブジェクト指定可
		 * @param ...tweens トゥイーンの配列
		 * @return Tween24
		 */
		static public function playByArray(...tweens):Tween24
		{
			return getControlTween("playByArray", Util24.array.compressAndClean(tweens), "play");
		}
		
		/**
		 * 指定した配列内にあるトゥイーンを一時停止します。 ※複数オブジェクト指定可
		 * @param ...tweens トゥイーンの配列
		 * @return Tween24
		 */
		static public function pauseByArray(...tweens):Tween24
		{
			return getControlTween("pauseByArray", Util24.array.compressAndClean(tweens), "pause");
		}
		
		/**
		 * 指定した配列内にあるトゥイーンをスキップします。 ※複数オブジェクト指定可
		 * @param ...tweens トゥイーンの配列
		 * @return Tween24
		 */
		static public function skipByArray(...tweens):Tween24
		{
			return getControlTween("skipByArray", Util24.array.compressAndClean(tweens), "skip");
		}
		
		/**
		 * 指定した配列内にあるトゥイーンを停止します。 ※複数オブジェクト指定可
		 * @param ...tweens トゥイーンの配列
		 * @return Tween24
		 */
		static public function stopByArray(...tweens):Tween24
		{
			return getControlTween("stopByArray", Util24.array.compressAndClean(tweens), "stop");
		}
		
		/**
		 * 指定した配列内にあるトゥイーンのタイムスケールを変更します。 ※複数オブジェクト指定可
		 * @param timeScale タイムスケール
		 * @param ...tweens トゥイーンの配列
		 * @return Tween24
		 */
		static public function setGlobalTimeScaleByArray(timeScale:Number, ...tweens):Tween24
		{
			return getControlTween("setGlobalTimeScaleByArray", Util24.array.compressAndClean(tweens), "setTimeScale", timeScale);
		}
		
		/**
		 * 指定した配列内にあるトゥイーンの  manualPlay() を実行します。 ※複数オブジェクト指定可
		 * @param ...tweens トゥイーンの配列
		 * @return Tween24
		 */
		static public function manualPlayByArray(...tweens):Tween24
		{
			return getControlTween("manualPlayByArray", Util24.array.compressAndClean(tweens), "manualPlay");
		}
		
		/**
		 * 指定した配列内にあるトゥイーンの  manualUpdate() を実行します。 ※複数オブジェクト指定可
		 * @param ...tweens トゥイーンの配列
		 * @return Tween24
		 */
		static public function manualUpdateByArray(...tweens):Tween24
		{
			return getControlTween("manualUpdateByArray", Util24.array.compressAndClean(tweens), "manualUpdate");
		}
		
		
		// =============================================================================
		//
		// by All
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 再生中の全てのトゥイーンを一時停止します。
		 * @return Tween24
		 */
		static public function pauseAllTweens():Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ALL_PAUSE;
			tween._actionName = "pauseAllTweens";
			tween._action = function():void {
				eachFuncInPlayingTweens("pause");
			};
			return tween;
		}
		
		/**
		 * 一時停止中の全てのトゥイーンを再開します。
		 * @return Tween24
		 */
		static public function resumeAllTweens():Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "resumeAllTweens";
			tween._action = function():void { eachFuncInPausingTweens("play2"); };
			return tween;
		}
		
		/**
		 * 再生、一時停止中の全てのトゥイーンをスキップします。
		 * @return Tween24
		 */
		static public function skipAllTweens():Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "skipAllTweens";
			tween._action = function():void {
				eachFuncInPlayingTweens("skip");
				eachFuncInPausingTweens("skip");
			};
			return tween;
		}
		
		/**
		 * 再生、一時停止中の全てのトゥイーンを停止します。
		 * @return Tween24
		 */
		static public function stopAllTweens():Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "stopAllTweens";
			tween._action = function():void {
				eachFuncInPlayingTweens("stop");
				eachFuncInPausingTweens("stop");
			};
			return tween;
		}
		
		/**
		 * マニュアル再生中の全てのトゥイーンに manualUpdate() を実行します。
		 * @return Tween24
		 */	
		static public function manualUpdateAllTweens(num:uint = 1):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "manualUpdateAllTweens";
			tween._action = function():void {
				for each (var t:Tween24 in _manualTweens) {
					t.manualUpdate(num);
				}
			};
			return tween;
		}
		
		/**
		 * マニュアル再生中の全てのカウントトゥイーンに skipCount() を実行します。
		 * @return Tween24
		 */	
		static public function skipCountAllManualTweens(num:uint = 1):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "skipCountAllManualTweens";
			tween._action = function():void {
				for each (var t:Tween24 in _manualTweens) {
					t.skipCount(num);
				}
			};
			return tween;
		}
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * GET TWEEN
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		// =============================================================================
		//
		// by ID
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 指定したIDのトゥイーンを取得します。
		 * @param id トゥイーンID
		 * @return Tween24
		 */
		static public function getTweenById(id:String):Tween24
		{
			return _tweensById[id];
		}
		
		/**
		 * 指定したIDのトゥイーンを配列で取得します。
		 * @param id トゥイーンID
		 * @return Array
		 */
		static public function getTweenArrayById(...id):Array
		{
			var result:Array = [];
			for each (var i:String in id) result.push(_tweensById[i]);
			return Util24.array.clean(result);
		}
		
		
		// =============================================================================
		//
		// by Group
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * グループ指定したトゥイーンをパラレルトゥイーンとして取得します。
		 * @param id グループID
		 * @return Tween24
		 */
		static public function getGroupTween(id:String):Tween24
		{
			return parallel.apply(parallel, _tweensByGroup[id]);
		}
		
		/**
		 * 指定したグループのトゥイーンを配列で取得します。
		 * @param id グループID
		 * @return Array
		 */
		static public function getTweenArrayByGroup(...id):Array
		{
			var result:Array = [];
			for each (var i:String in id) result = result.concat(_tweensByGroup[i]);
			return Util24.array.clean(result);
		}
		
		
		// =============================================================================
		//
		// by Target
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 指定したオブジェクトが関連している再生中のトゥイーンインスタンスを取得します。 ※複数オブジェクト指定可
		 * @param target 対象オブジェクト
		 * @return Array
		 */		
		static public function getPlayingTweenArrayByTarget(...target):Array
		{
			var result:Array = [];
			for each (var t:* in target) {
				for each (var tw:Tween24 in _playingTweensByTarget[t]) result.push(tw);
			}
			return (result.length)? Util24.array.clean(result): null;
		}
		
		/**
		 * 指定したオブジェクトが関連している一時停止中のトゥイーンインスタンスを取得します。 ※複数オブジェクト指定可
		 * @param target 対象オブジェクト
		 * @return Array
		 */
		static public function getPausingTweenArrayByTarget(...target):Array
		{
			var result:Array = [];
			for each (var t:* in target) {
				for each (var tw:Tween24 in _pausingTweensByTarget[t]) result.push(tw);
			}
			return (result.length)? Util24.array.clean(result): null;
		}
		
		/**
		 * 指定したオブジェクトが関連しているトゥイーンインスタンスを取得します。 ※複数オブジェクト指定可
		 * @param target 対象オブジェクト
		 * @return Array
		 */		
		static private function getTweenArrayByTarget(...target):Array
		{
			var result:Array = [];
			for each (var t:* in target) {
				var tw:Tween24;
				for each (tw in _playingTweensByTarget[t]) result.push(tw);
				for each (tw in _pausingTweensByTarget[t]) result.push(tw);
			}
			return (result.length)? Util24.array.clean(result): null;
		}
		
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 * 
		 * ACTION
		 * 
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		// =============================================================================
		//
		// Display
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 子オブジェクトを追加します。 ※複数子オブジェクト指定可
		 * @param container 親コンテナ
		 * @param child 追加するオブジェクト
		 * @return Tween24
		 */
		static public function addChild(container:DisplayObjectContainer, ...children):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "addChild";
			return setSyncAddTween(tween, children, Util24.display.addChild, container, Util24.array.compressAndClean(children));
		}
		
		/**
		 * 指定した深度に、子オブジェクトを追加します。
		 * @param containerr 親コンテナ
		 * @param child 追加するオブジェクト
		 * @return Tween24
		 */
		static public function addChildAt(container:DisplayObjectContainer, child:DisplayObject, index:int):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "addChildAt";
			return setSyncAddTween(tween, [child], Util24.display.addChildAt, container, child, index);
		}
		
		/**
		 * 指定したターゲットの前面に、子オブジェクトを追加します。
		 * @param container 親コンテナ
		 * @param child 追加するオブジェクト
		 * @param target 基準になるオブジェクト
		 * @return Tween24
		 */
		static public function addChildAtFront(child:DisplayObject, target:DisplayObject):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "addChildAtFront";
			return setSyncAddTween(tween, [child], Util24.display.addChildAtFront, child, target);
		}
		
		/**
		 * 指定したターゲットの背面に、子オブジェクトを追加します。
		 * @param container 親コンテナ
		 * @param child 追加するオブジェクト
		 * @param target 基準になるオブジェクト
		 * @return Tween24
		 */
		static public function addChildAtBack(child:DisplayObject, target:DisplayObject):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "addChildAtBack";
			return setSyncAddTween(tween, [child], Util24.display.addChildAtBack, child, target);
		}
		
		static private function setSyncAddTween(tween:Tween24, children:Array, func:Function, ...args):Tween24
		{
			tween.addEventListener(Tween24Event.INIT, function():void {
				tween.removeEventListener(Tween24Event.INIT, arguments.callee);
				
				var eventTween:EventTween24;
				var syncTween:Tween24;
				var syncTweens:Array;
				var waitTween:Tween24;
				children = Util24.array.compressAndClean(children);
				
				// Get sync tween
				for each (var child:DisplayObject in children) {
					eventTween = EventTween24.hasInstance(child);
					syncTween = eventTween? eventTween.addChildSyncTween: null;
					if (syncTween) {
						syncTweens ||= [];
						syncTweens.push(syncTween);
					}
				}
				
				// Create wait tween
				if (syncTweens) {
					waitTween = parallel.apply(parallel, syncTweens);
					waitTween._dispatchComplete = true;
					tween._dispatcher = waitTween.getDispatcher();
					tween._eventType = Tween24Event.COMPLETE;
				}
				
				// Wait tween play
				tween._action = function():void {
					func.apply(func, args);
					if (waitTween) waitTween.play();
				};
			});
			return tween;
		}
		
		/**
		 * 子オブジェクトを削除します。 ※複数オブジェクト指定可
		 * @param child 削除するオブジェクト
		 * @return Tween24
		 */
		static public function removeChild(...children):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "removeChild";
			return setSyncRemoveTween(tween, Util24.array.compressAndClean(children));
		}
		
		/**
		 * 指定した名前の子オブジェクトを削除します。 ※複数名前指定可
		 * @param container 親コンテナ
		 * @param ...names 名前
		 * @return Tween24
		 */
		static public function removeChildByName(container:DisplayObjectContainer, ...name):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "removeChildByName";
			return setSyncRemoveTween(tween, null, Util24.display.getChildrenByName, container, Util24.array.compressAndClean(name));
		}
		
		/**
		 * 指定した深度にある子オブジェクトを削除します。 ※複数深度指定可
		 * @param container 親コンテナ
		 * @param ...index 深度
		 * @return Tween24
		 */
		static public function removeChildAt(container:DisplayObjectContainer, ...index):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "removeChildAt";
			return setSyncRemoveTween(tween, null, Util24.display.getChildrenAt, container, Util24.array.compressAndClean(index));
		}
		
		/**
		 * 子オブジェクトを全て削除します。 ※複数指定可
		 * @param container 親コンテナ
		 * @return Tween24
		 */
		static public function removeAllChildren(...containers):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "removeAllChildren";
			return setSyncRemoveTween(tween, null, Util24.display.getAllChildren, containers);
		}
		
		static private function setSyncRemoveTween(tween:Tween24, children:Array, getChildFunc:Function = null, ...args):Tween24
		{
			tween.addEventListener(Tween24Event.INIT, function():void {
				tween.removeEventListener(Tween24Event.INIT, arguments.callee);
				
				var eventTween:EventTween24;
				var syncTween:Tween24;
				var syncTweens:Array;
				var waitTween:Tween24;
				
				// Get children
				if (!children) children = getChildFunc.apply(getChildFunc, args);
				children = Util24.array.compressAndClean(children);
				
				// Get sync tween
				for each (var child:DisplayObject in children) {
					eventTween = EventTween24.hasInstance(child);
					syncTween = eventTween? eventTween.removeChildSyncTween: null;
					
					if (syncTween) {
						syncTweens ||= [];
						syncTweens.push(syncTween);
						
						// Complete sync tween
						syncTween.addEventListener(Tween24Event.COMPLETE, function():void {
							Util24.display.removeChild(child);
							syncTween.removeEventListener(Tween24Event.COMPLETE, arguments.callee);
						});
					}
				}
				
				// Create wait tween
				if (syncTweens) {
					waitTween = parallel.apply(parallel, syncTweens);
					waitTween._dispatchComplete = true;
					tween._dispatcher = waitTween.getDispatcher();
					tween._eventType = Tween24Event.COMPLETE;
				}
				
				// Wait tween play
				tween._action = function():void {
					if (waitTween) waitTween.play();
					else Util24.display.removeChild(children);
				};
			});
			
			return tween;
		}
		
		/**
		 * オブジェクトを最前面に配置します。
		 * @param target 対象オブジェクト
		 * @return Tween24
		 */
		static public function setFrontChild(child:DisplayObject):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "swapFrontChild";
			tween._action = function():void { Util24.display.setFrontChild(child); };
			return tween;
		}
		
		/**
		 * オブジェクトの深度を変更します。
		 * @param target 対象オブジェクト
		 * @param index 深度
		 * @return Tween24
		 */
		static public function setChildIndex(child:DisplayObject, index:int):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "swapChildIndex";
			tween._action = function():void { Util24.display.setChildIndex(child, index); };
			return tween;
		}
		
		/**
		 * オブジェクトに設定されているフィルタを全て解除します。 ※複数ターゲット指定可
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function removeFilters(...target):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "removeFilters";
			tween._action = function():void { Util24.display.removeFilters(target); };
			return tween;
		}
		
		/**
		 * 可視状態を設定します。 ※複数ターゲット指定可
		 * @param visible 有効にするか
		 * @param target 対象オブジェクト
		 * @return Tween24
		 */
		static public function visible(visible:Boolean, ...target):Tween24
		{
			var tween:Tween24 = new Tween24(Util24.array.compressAndClean(target));
			tween._type = _TYPE_PROP;
			tween._actionName = "visible";
			tween.visible(visible);
			return tween;
		}
		
		
		// =============================================================================
		//
		// Timeline
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 指定したフレームから、タイムラインを再生します。 ※複数ターゲット指定可
		 * @param frame 移動フレーム
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function gotoAndPlay(frame:*, ...target):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "gotoAndPlay";
			tween._action = function():void { Util24.timeline.gotoAndPlay(frame, Util24.array.compress(target)); };
			return tween;
		}
		
		/**
		 * 指定したフレームにタイムラインを移動し、停止します。 ※複数ターゲット指定可
		 * @param frame 移動フレーム
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function gotoAndStop(frame:*, ...target):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "gotoAndStop";
			tween._action = function():void { Util24.timeline.gotoAndStop(frame, Util24.array.compress(target)); };
			return tween;
		}
		
		
		// =============================================================================
		//
		// Mask
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * マスクを設定します。マスクオブジェクトは自動的に対象と同じ階層の表示リストに追加されます。
		 * @param target マスクターゲット
		 * @param masker マスクオブジェクト
		 * @return Tween24
		 */
		static public function addMask(target:DisplayObject, masker:DisplayObject):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "addMask";
			tween._action = function():void { Util24.display.addMask(target, masker); };
			return tween;
		}
		
		/**
		 * マスクを解除します。マスクオブジェクトは自動的に表示リストから削除されます。
		 * @param target マスクターゲット
		 * @return Tween24
		 */
		static public function removeMask(target:DisplayObject):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "removeMask";
			tween._action = function():void { Util24.display.removeMask(target); };
			return tween;
		}
		
		
		// =============================================================================
		//
		// Func / Wait
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 関数を実行します。
		 * @param func 実行する関数です。
		 * @param args 関数に渡す引数です。
		 * @return Tween24
		 */
		static public function func(func:Function, ...args):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_FUNC;
			tween._actionName = "func";
			tween._action = function():void { func.apply(func, args); };
			return tween;
		}
		
		/**
		 * 関数を実行し、イベントを受け取るまで待機します。
		 * @param dispatcher 処理の終了イベントを発行するインスタンスです。
		 * @param eventType 発行されるイベントの種類です。
		 * @param func 実行する関数です。
		 * @param args 関数に渡す引数の配列です。
		 * @return Tween24
		 */
		static public function funcAndWaitEvent(dispatcher:IEventDispatcher, eventType:String, func:Function, ...args):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_FUNC_AND_WAIT;
			tween._actionName = "funcAndWaitEvent";
			tween._action = function():void { func.apply(func, args); };
			tween._dispatcher = dispatcher;
			tween._eventType = eventType;
			return tween;
		}
		
		/**
		 * 指定した時間だけ待機します。
		 * @param time 待機時間
		 * @return Tween24
		 */
		static public function wait(time:Number):Tween24
		{
			var tween:Tween24 = new Tween24(null, time);
			tween._type = _TYPE_WAIT;
			tween._actionName = "wait";
			return tween;
		}
		
		/**
		 * イベントを受け取るまで待機します。
		 * @param dispatcher イベントターゲット
		 * @param eventType イベントタイプ
		 * @return Tween24
		 */
		static public function waitEvent(dispatcher:IEventDispatcher, eventType:String):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_WAIT_EVENT;
			tween._actionName = "waitEvent";
			tween._dispatcher = dispatcher;
			tween._eventType = eventType;
			return tween;
		}
		
		
		// =============================================================================
		//
		// Mouse
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * マウスイベントを有効にするかを設定します。 ※複数ターゲット指定可
		 * @param enabled 有効にするか
		 * @param target 対象オブジェクト
		 * @return Tween24
		 */
		static public function mouseEnabled(enable:Boolean, ...target):Tween24
		{
			var tween:Tween24 = new Tween24(Util24.array.compressAndClean(target));
			tween._type = _TYPE_PROP;
			tween._actionName = "mouseEnabled";
			tween.addParam("mouseEnabled", enable);
			return tween;
		}
		
		/**
		 * オブジェクトの子に対してマウスイベントを有効にするかを設定します。 ※複数ターゲット指定可
		 * @param enabled 有効にするか
		 * @param target 対象オブジェクト
		 * @return Tween24
		 */
		static public function mouseChildren(enable:Boolean, ...target):Tween24
		{
			var tween:Tween24 = new Tween24(Util24.array.compressAndClean(target));
			tween._type = _TYPE_PROP;
			tween._actionName = "mouseChildren";
			tween.addParam("mouseChildren", enable);
			return tween;
		}
		
		/**
		 * オブジェクトとその子に対してマウスを有効にするかを設定します。 ※複数ターゲット指定可
		 * @param enabled 有効にするか
		 * @param target 対象オブジェクト
		 * @return Tween24
		 */
		static public function buttonEnabled(enable:Boolean, ...target):Tween24
		{
			var tween:Tween24 = new Tween24(Util24.array.compressAndClean(target));
			tween._type = _TYPE_PROP;
			tween._actionName = "buttonEnabled";
			tween.addParam("mouseEnabled", enable);
			tween.addParam("mouseChildren", enable);
			return tween;
		}
		
		/**
		 * ボタンモードを設定します。 ※複数ターゲット指定可
		 * @param enabled 有効にするか
		 * @param target 対象オブジェクト
		 * @return Tween24
		 */
		static public function buttonMode(enable:Boolean, ...target):Tween24
		{
			var tween:Tween24 = new Tween24(Util24.array.compressAndClean(target));
			tween._type = _TYPE_PROP;
			tween._actionName = "buttonMode";
			tween.addParam("buttonMode", enable);
			return tween;
		}
		
		/**
		 * ブレンドモードを設定します。 ※複数ターゲット指定可
		 * @param blendMode ブレンドモード
		 * @param target 対象オブジェクト
		 * @return Tween24
		 * 
		 */		
		static public function blendMode(blendMode:String, ...target):Tween24
		{
			var tween:Tween24 = new Tween24(Util24.array.compressAndClean(target));
			tween._type = _TYPE_PROP;
			tween._actionName = "blendMode";
			tween.setDisplayObjectUpdater("blendMode", blendMode);
			return tween;
		}
		
		
		// =============================================================================
		//
		// Trace
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * メッセージを出力します。
		 * @param ...messages 出力メッセージ
		 * @return Tween24
		 */
		static public function traceLog(...messages):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "traceLog";
			tween._action = function():void { trace.apply(trace, messages); };
			return tween;
		}
		
		/**
		 * オブジェクトのプロパティを出力します。 ※複数プロパティ名指定可
		 * @param target 出力ターゲット
		 * @param label ラベル
		 * @param ...propNames プロパティ名
		 * @return Tween24
		 */
		static public function traceProp(target:Object, label:String, ...propNames):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "traceProp";
			tween._action = function():void {
				var mes:String = " [";
				var len:int = propNames.length;
				for (var i:int = 0; i < len; i++)  {
					var key:String = propNames[i];
					mes += key + ":" + target[key] + ", ";
				}
				trace(label + mes.slice(0, mes.length - 2) + "]");
			};
			return tween;
		}
		
		
		// =============================================================================
		//
		// Etc
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 指定した時間待機した後、次の親トゥイーンを実行します。
		 * @param time 待機時間
		 * @return Tween24
		 */
		static public function jump(time:Number):Tween24
		{
			var tween:Tween24 = new Tween24(null, time).jump();
			tween._type = _TYPE_JUMP;
			tween._actionName = "jump";
			return tween;
		}
		
		/**
		 * イベントを送信します。
		 * @param target イベントターゲット
		 * @param event 送信イベント
		 * @return Tween24
		 */
		static public function eventDispatch(target:IEventDispatcher, event:Event):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "eventDispatch";
			tween._action = function():void { target.dispatchEvent(event); };
			return tween;
		}
		
		/**
		 * URLを開きます。
		 * @param url リンク先URL
		 * @param window ターゲットウィンド
		 * @return Tween24
		 */
		static public function getURL(url:String, window:String = "_self"):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "getURL";
			tween._action = function():void { navigateToURL(new URLRequest(url), window); };
			return tween;
		}
		
		/**
		 * フォーカスを設定します。ターゲットがTextFieldの場合、入力されているテキストの末尾にキャレットが設定されます。
		 * @param target フォーカスターゲット
		 * @return Tween24
		 */
		static public function setFocus(target:InteractiveObject):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "setFocus";
			tween._action = function():void {
				if (target.stage) {
					target.stage.focus = target;
					if (target is TextField) {
						var tf:TextField = target as TextField;
						tf.setSelection(tf.length, tf.length);
					}
				}
			};
			return tween;
		}
		
		/**
		 * レンダリング品質を変更します。
		 * @param stage ステージインスタンス
		 * @param quality クオリティ
		 */
		static public function stageQuality(stage:Stage, quality:String):Tween24
		{
			_stage = stage || _stage;
			
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "stageQuality";
			tween._action = function():void {
				if (_stage) _stage.quality = quality;
			};
			return tween;
		}
		
		/**
		 * トゥイーンのグローバルタイムスケールを設定します。
		 * @param scale タイムスケール
		 * @return Tween24
		 */
		static public function changeGlobalTimeScale(scale:Number):Tween24
		{
			var tween:Tween24 = new Tween24();
			tween._type = _TYPE_ACTION;
			tween._actionName = "changeGlobalTimeScale";
			tween._action = function():void { globalTimeScale = scale; };
			return tween;
		}
		
		
		
		
		
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * ENGINE
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		static private function startEngine():void
		{
			_runing = true;
			_engine.addEventListener(Event.ENTER_FRAME, rendering);
		}
		
		static private function stopEngine():void
		{
			_runing = false;
			_engine.removeEventListener(Event.ENTER_FRAME, rendering);
		}
		
		static private function rendering(e:Event = null):void
		{
			//trace("---------------------");
			
			if (!_firstTween) {
				_endTween = null;
				stopEngine();
				return;
			}
			else {
				var tween:Tween24 = _firstTween, next:Tween24 = tween._nextList;
				_nowTime = getTimer();
				do {
					next = tween._nextList;
					tween.update();
				} while ((tween = next) != null);
			}
		}
		
		
		
		
		
		/*
		 * ===============================================================================================
		 *
		 *
		 * UTIL FUNCTION
		 *
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		
		static private function removeFromDictionaryInDictionary(dict:Dictionary, key:*, value:*):void
		{
			var d:Dictionary = dict[key];
			var f:Boolean;
			if (d) delete d[value];
			for (var k:* in d) f = true;
			if (!f) delete dict[key];
		}
		
		static private function replacePlugin(tweens:Array):Array
		{
			tweens = Util24.array.compressAndClean(tweens);
			var result:Array = [];
			for each (var tween:* in tweens) {
				if      (tween is PulginTween24) result.push(PulginTween24(tween).getTween24());
				else if (tween is Function)      result.push(Tween24.func(tween));
				else result.push(tween);
			}
			return result;
		}
		
		static private function clone(source:Object):*
		{
			var ba:ByteArray = new ByteArray();
			ba.writeObject(source);
			ba.position = 0;
			return (ba.readObject());
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
		 * 再生中かどうかを取得します。
		 */
		public function get playing():Boolean { return _playing; }
		
		/**
		 * 一時停止中かどうかを取得します。
		 */
		public function get pausing():Boolean { return _pausing; }
		
		/**
		 * イージンを指定します。
		 */
		static public function get ease():Ease24 { return _ease; }
		
		/**
		 * デフォルトでトゥイーンに設定されるイージングです。初期値は Linear です。
		 */
		static public function get defaultEasing():Function{ return _defaultEasing; }
		static public function set defaultEasing(value:Function):void { _defaultEasing = value; }
		
		/**
		 * 全てのトゥイーンに影響するタイムスケールです。
		 */
		static public function get globalTimeScale():Number { return _globalTimeScale; }
		static public function set globalTimeScale(value:Number):void 
		{
			_globalTimeScale = value;
			eachFuncInPlayingTweens("updateTime");
		}
		
		/**
		 * プラグインを呼び出します。
		 */
		static public function get plugin():PluginProxy { return _plugin; }
		
		/**
		 * 基準点を指定します。
		 */
		static public function get aligin():Align24 { return _aligin; }
		
		/**
		 * デバッグログを許可します。
		 */
		static public function get debugMode():Boolean{ return _debugMode; }
		static public function set debugMode(value:Boolean):void { _debugMode = value; }
	}
}