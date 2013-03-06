package a24.tween.plugins 
{
	import a24.tween.core.plugins.PulginTween24;
	import a24.tween.Tween24;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	/**
	 *
	 * Sound や SoundTransform を操作するプラグインです。 
	 * @author	Atsushi Kaga
	 * @since   2011.12.28
	 *
	 */
	public class SoundPlugin extends PulginTween24
	{
		static private var _properties:Array;
		private var _property:SoundTween24Property;
		
		/**
		 * @param property
		 * @private
		 */
		public function SoundPlugin(property:SoundTween24Property) 
		{
			_property = property;
		}
		
		
		/*
		 * ===============================================================================================
		 * PUBLIC FUNCTION
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * ボリュームを設定します。(0 - 1)
		 * @param volume ボリューム
		 * @return SoundPlugin
		 */
		public function volume(volume:Number):SoundPlugin
		{
			addParam("volume", volume);
			return this;
		}
		
		/**
		 * サウンドの左から右へのパンを設定します。(-1 - 1)
		 * @param pan パン
		 * @return SoundPlugin
		 */
		public function pan(pan:Number):SoundPlugin
		{
			addParam("pan", pan);
			return this;
		}
		
		/**
		 * 左スピーカーで再生する左入力データの量を設定します。（0 - 1）
		 * @param leftToLeft データの量
		 * @return SoundPlugin
		 */
		public function leftToLeft(leftToLeft:Number):SoundPlugin
		{
			addParam("leftToLeft", leftToLeft);
			return this;
		}
		
		/**
		 * 右スピーカーで再生する左入力データの量を設定します。（0 - 1）
		 * @param leftToRight データの量
		 * @return SoundPlugin
		 */
		public function leftToRight(leftToRight:Number):SoundPlugin
		{
			addParam("leftToRight", leftToRight);
			return this;
		}
		
		/**
		 * 左スピーカーで再生する右入力データの量を設定します。（0 - 1）
		 * @param rightToLeft データの量
		 * @return SoundPlugin
		 */
		public function rightToLeft(rightToLeft:Number):SoundPlugin
		{
			addParam("rightToLeft", rightToLeft);
			return this;
		}
		
		/**
		 * 右スピーカーで再生する右入力データの量を設定します。（0 - 1）
		 * @param rightToRight データの量
		 * @return SoundPlugin
		 */
		public function rightToRight(rightToRight:Number):SoundPlugin
		{
			addParam("rightToRight", rightToRight);
			return this;
		}
		
		
		/*
		 * ===============================================================================================
		 * STATIC PUBLIC FUNCTION
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * サウンドを登録します。
		 * @param id サウンドのID
		 * @param sound サウンドインスタンス
		 * @param defaultVolume デフォルトのボリューム（ここで設定したボリュームを1としてトゥイーンします）
		 */
		static public function addSound(id:String, sound:Sound, defaultVolume:Number = 1):void
		{
			_properties ||= [];
			_properties[id] = new SoundTween24Property(id, sound, defaultVolume);
		}
		
		/**
		 * 登録したサウンドを解除します。
		 * @param id サウンドのID
		 */
		static public function removeSound(id:String):void
		{
			if (_properties) {
				var prop:SoundTween24Property = _properties[id];
				if (prop) prop.dispose();
				delete _properties[id];
			}
		}
		
		/**
		 * SoundTransform のプロパティのトゥイーンを設定します。
		 * @param id addSound メソッドで登録したサウンドID
		 * @param time 時間
		 * @param easing イージング
		 * @return SoundPlugin
		 */
		static public function tween(id:String, time:Number, easing:Function = null):SoundPlugin
		{
			var plugin:SoundPlugin = new SoundPlugin(_properties[id]);
			plugin.setTween(plugin._property, time, easing);
			return plugin;
		}
		
		/**
		 * SoundTransform のプロパティを設定します。
		 * @param id addSound メソッドで登録したサウンドID
		 * @return SoundPlugin
		 */
		static public function prop(id:String):SoundPlugin
		{
			var plugin:SoundPlugin = new SoundPlugin(_properties[id]);
			plugin.setProp(plugin._property);
			return plugin;
		}
		
		/**
		 * サウンドを再生します。
		 * @param id addSound メソッドで登録したサウンドID
		 * @param startTime 再生を開始する初期位置 (ミリ秒単位) 
		 * @param loops 繰り返す回数
		 * @param sndTransform サウンドチャンネルに割り当てられた初期 SoundTransform オブジェクト
		 * @return SoundPlugin
		 */
		static public function playSound(id:String, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundPlugin
		{
			var plugin:SoundPlugin = new SoundPlugin(_properties[id]);
			plugin._tween = Tween24.func(plugin._property.play, startTime, loops, sndTransform);
			return plugin;
		}
		
		/**
		 * サウンドを停止します。
		 * @param id addSound メソッドで登録したサウンドID
		 * @return SoundPlugin
		 */
		static public function stopSound(id:String):SoundPlugin
		{
			var plugin:SoundPlugin = new SoundPlugin(_properties[id]);
			plugin._tween = Tween24.func(plugin._property.stop);
			return plugin;
		}
		
		
		/*
		 * ===============================================================================================
		 * DELAY & EVENT
		 * -----------------------------------------------------------------------------------------------
		 */
		public function delay(time:Number):SoundPlugin { _tween.delay(time); return this; }
		public function onPlay    (func:Function, ...args):SoundPlugin { args.unshift(func); _tween.onPlay    .apply(_tween, args); return this; }
		public function onDelay   (func:Function, ...args):SoundPlugin { args.unshift(func); _tween.onDelay   .apply(_tween, args); return this; }
		public function onInit    (func:Function, ...args):SoundPlugin { args.unshift(func); _tween.onInit    .apply(_tween, args); return this; }
		public function onUpdate  (func:Function, ...args):SoundPlugin { args.unshift(func); _tween.onUpdate  .apply(_tween, args); return this; }
		public function onPause   (func:Function, ...args):SoundPlugin { args.unshift(func); _tween.onPause   .apply(_tween, args); return this; }
		public function onStop    (func:Function, ...args):SoundPlugin { args.unshift(func); _tween.onStop    .apply(_tween, args); return this; }
		public function onComplete(func:Function, ...args):SoundPlugin { args.unshift(func); _tween.onComplete.apply(_tween, args); return this; }
	}
}


import a24.tween.core.plugins.PluginTween24Property;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

internal class SoundTween24Property extends PluginTween24Property
{
	private var _id:String;
	private var _sound:Sound;
	private var _soundChannel:SoundChannel;
	private var _soundTransform:SoundTransform;
	private var _defaultVolume:Number;
	private var _volume:Number;
	private var _pan:Number;
	private var _leftToLeft:Number;
	private var _leftToRight:Number;
	private var _rightToLeft:Number;
	private var _rightToRight:Number;
	
	public function SoundTween24Property(id:String, sound:Sound, defaultVolume:Number = 1) 
	{
		_id            = id;
		_sound         = sound;
		_defaultVolume = defaultVolume;
	}
	
	
	/*
	 * ===============================================================================================
	 * PUBLIC
	 * -----------------------------------------------------------------------------------------------
	 */
	public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):void
	{
		if (_soundChannel) _soundChannel.stop();
		_soundChannel = _sound.play(startTime, loops, sndTransform);
		
		_soundTransform ||= _soundChannel.soundTransform;
		if (isNaN(_volume))       _volume       = _soundTransform.volume;
		if (isNaN(_pan))          _pan          = _soundTransform.pan;
		if (isNaN(_leftToLeft))   _leftToLeft   = _soundTransform.leftToLeft;
		if (isNaN(_leftToRight))  _leftToRight  = _soundTransform.leftToRight;
		if (isNaN(_rightToLeft))  _rightToLeft  = _soundTransform.rightToLeft;
		if (isNaN(_rightToRight)) _rightToRight = _soundTransform.rightToRight;
		
		// Set volume
		_soundTransform.volume = _volume * _defaultVolume;
		_soundChannel.soundTransform = _soundTransform;
	}
	
	public function stop():void
	{
		if (_soundChannel) _soundChannel.stop();
	}
	
	public function dispose():void
	{
		_id             = null;
		_sound          = null;
		_soundChannel   = null;
		_soundTransform = null;
		_defaultVolume  = NaN;
		_volume         = NaN;
		_pan            = NaN;
		_leftToLeft     = NaN;
		_leftToRight    = NaN;
		_rightToLeft    = NaN;
		_rightToRight   = NaN;
	}
	
	
	/*
	 * ===============================================================================================
	 * EVENT HANDLER
	 * -----------------------------------------------------------------------------------------------
	 */
	override public function atUpdate():void 
	{
		if (_soundChannel) _soundChannel.soundTransform = _soundTransform;
	}
	
	override public function atComplete():void 
	{
		atUpdate();
	}
	
	
	/*
	 * ===============================================================================================
	 * GETTER & SETTER
	 * -----------------------------------------------------------------------------------------------
	 */
	public function get volume():Number { return _volume; }
	public function set volume(value:Number):void 
	{
		_volume = value;
		if (_soundTransform) _soundTransform.volume = value * _defaultVolume;
	}
	
	public function get pan():Number { return _pan; }
	public function set pan(value:Number):void 
	{
		_pan = value;
		if (_soundTransform) _soundTransform.pan = value;
	}
	
	public function get leftToLeft():Number { return _leftToLeft; }
	public function set leftToLeft(value:Number):void 
	{
		_leftToLeft = value;
		if (_soundTransform) _soundTransform.leftToLeft = value;
	}
	
	public function get leftToRight():Number { return _leftToRight; }
	public function set leftToRight(value:Number):void 
	{
		_leftToRight = value;
		if (_soundTransform) _soundTransform.leftToRight = value;
	}
	
	public function get rightToLeft():Number { return _rightToLeft; }
	public function set rightToLeft(value:Number):void 
	{
		_rightToLeft = value;
		if (_soundTransform) _soundTransform.rightToLeft = value;
	}
	
	public function get rightToRight():Number { return _rightToRight; }
	public function set rightToRight(value:Number):void 
	{
		_rightToRight = value;
		if (_soundTransform) _soundTransform.rightToRight = value;
	}
}