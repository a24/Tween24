package a24.tween.plugins 
{
	import a24.tween.core.plugins.PulginTween24;
	import a24.tween.Tween24;
	import flash.media.SoundMixer;
	
	/**
	 * 
	 * SoundMixer を操作するプラグインです。
	 * @author Atsushi Kaga
	 * @since 2012.01.09
	 *
	 */
	public class SoundMixerPlugin extends PulginTween24
	{
		static private var _property:SoundMixerTween24Property;
		
		/**
		 * @private
		 */
		public function SoundMixerPlugin() 
		{
			_property ||= new SoundMixerTween24Property();
		}
		
		
		/*
		 * ===============================================================================================
		 * PUBLIC
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * ボリュームを設定します。(0 - 1)
		 * @param volume ボリューム
		 * @return SoundMixerPlugin
		 */
		public function volume(volume:Number):SoundMixerPlugin
		{
			addParam("volume", volume);
			return this;
		}
		
		/**
		 * サウンドの左から右へのパンを設定します。(-1 - 1)
		 * @param pan パン
		 * @return SoundMixerPlugin
		 */
		public function pan(pan:Number):SoundMixerPlugin
		{
			addParam("pan", pan);
			return this;
		}
		
		/**
		 * 左スピーカーで再生する左入力データの量を設定します。（0 - 1）
		 * @param leftToLeft データの量
		 * @return SoundMixerPlugin
		 */
		public function leftToLeft(leftToLeft:Number):SoundMixerPlugin
		{
			addParam("leftToLeft", leftToLeft);
			return this;
		}
		
		/**
		 * 右スピーカーで再生する左入力データの量を設定します。（0 - 1）
		 * @param leftToRight データの量
		 * @return SoundMixerPlugin
		 */
		public function leftToRight(leftToRight:Number):SoundMixerPlugin
		{
			addParam("leftToRight", leftToRight);
			return this;
		}
		
		/**
		 * 左スピーカーで再生する右入力データの量を設定します。（0 - 1）
		 * @param rightToLeft データの量
		 * @return SoundMixerPlugin
		 */
		public function rightToLeft(rightToLeft:Number):SoundMixerPlugin
		{
			addParam("rightToLeft", rightToLeft);
			return this;
		}
		
		/**
		 * 右スピーカーで再生する右入力データの量を設定します。（0 - 1）
		 * @param rightToRight データの量
		 * @return SoundMixerPlugin
		 */
		public function rightToRight(rightToRight:Number):SoundMixerPlugin
		{
			addParam("rightToRight", rightToRight);
			return this;
		}
		
		
		
		/*
		 * ===============================================================================================
		 * STATIC PUBLIC
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * ミキサーの SoundTransform プロパティのトゥイーンを設定します。
		 * @param time 時間
		 * @param easing イージング
		 * @return SoundMixerPlugin
		 */
		static public function tween(time:Number, easing:Function = null):SoundMixerPlugin
		{
			var plugin:SoundMixerPlugin = new SoundMixerPlugin();
			plugin.setTween(_property, time, easing);
			return plugin;
		}
		
		/**
		 * ミキサーの SoundTransform プロパティを設定します。
		 * @return SoundMixerPlugin
		 */
		static public function prop():SoundMixerPlugin
		{
			var plugin:SoundMixerPlugin = new SoundMixerPlugin();
			plugin.setProp(_property);
			return plugin;
		}
		
		/**
		 * 再生中のサウンドをすべて停止します。
		 * @return SoundMixerPlugin
		 */
		static public function allStop():SoundMixerPlugin
		{
			var plugin:SoundMixerPlugin = new SoundMixerPlugin();
			plugin.setFunc(SoundMixer.stopAll);
			return plugin;
		}
		
		
		/*
		 * ===============================================================================================
		 * DELAY & EVENT
		 * -----------------------------------------------------------------------------------------------
		 */
		public function delay(time:Number):SoundMixerPlugin { _tween.delay(time); return this; }
		public function onPlay    (func:Function, ...args):SoundMixerPlugin { args.unshift(func); _tween.onPlay    .apply(_tween, args); return this; }
		public function onDelay   (func:Function, ...args):SoundMixerPlugin { args.unshift(func); _tween.onDelay   .apply(_tween, args); return this; }
		public function onInit    (func:Function, ...args):SoundMixerPlugin { args.unshift(func); _tween.onInit    .apply(_tween, args); return this; }
		public function onUpdate  (func:Function, ...args):SoundMixerPlugin { args.unshift(func); _tween.onUpdate  .apply(_tween, args); return this; }
		public function onPause   (func:Function, ...args):SoundMixerPlugin { args.unshift(func); _tween.onPause   .apply(_tween, args); return this; }
		public function onStop    (func:Function, ...args):SoundMixerPlugin { args.unshift(func); _tween.onStop    .apply(_tween, args); return this; }
		public function onComplete(func:Function, ...args):SoundMixerPlugin { args.unshift(func); _tween.onComplete.apply(_tween, args); return this; }
	}
}


import a24.tween.core.plugins.PluginTween24Property;
import flash.media.SoundMixer;
import flash.media.SoundTransform;

internal class SoundMixerTween24Property extends PluginTween24Property
{
	private var _soundTransform:SoundTransform;
	private var _volume:Number;
	private var _pan:Number;
	private var _leftToLeft:Number;
	private var _leftToRight:Number;
	private var _rightToLeft:Number;
	private var _rightToRight:Number;
	
	public function SoundMixerTween24Property() 
	{
		_soundTransform = SoundMixer.soundTransform;
		_volume         = _soundTransform.volume;
		_pan            = _soundTransform.pan;
		_leftToLeft     = _soundTransform.leftToLeft;
		_leftToRight    = _soundTransform.leftToRight;
		_rightToLeft    = _soundTransform.rightToLeft;
		_rightToRight   = _soundTransform.rightToRight;
	}
	
	
	/*
	 * ===============================================================================================
	 * EVENT HANDLER
	 * -----------------------------------------------------------------------------------------------
	 */
	override public function atUpdate():void 
	{
		SoundMixer.soundTransform = _soundTransform;
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
		_soundTransform.volume = _volume;
	}
	
	public function get pan():Number { return _pan; }
	public function set pan(value:Number):void 
	{
		_pan = value;
		_soundTransform.pan = pan;
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