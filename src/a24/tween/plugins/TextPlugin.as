package a24.tween.plugins 
{
	import a24.tween.core.plugins.PulginTween24;
	import a24.tween.Tween24;
	import flash.text.TextField;
	
	
	/**
	 *
	 * TextField を操作するプラグインです。 
	 * @author Atsushi Kaga
	 * @since 2012.08.28
	 *
	 */
	public class TextPlugin extends PulginTween24
	{
		/**
		 * @private
		 */
		public function TextPlugin() {}
		
		
		/*
		 * ===============================================================================================
		 * STATIC PUBLIC
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * テキストフィールドに1文字づつ文字を追加するトゥイーンを設定します。
		 * @param textField テキストフィールド
		 * @param text 表示するテキスト
		 * @param delay 1文字の表示間隔
		 * @param reset テキストフィールドにすでに表示されているテキストを削除するかどうか
		 * @return TextPlugin
		 */
		static public function typingTween(textField:TextField, text:String, delay:Number, reset:Boolean = false):TextPlugin
		{
			var i:int;
			var plugin:TextPlugin = new TextPlugin();
			plugin._tween = Tween24.serial(
				Tween24.ifCase(reset,
					Tween24.prop(textField, {text:""})
				),
				Tween24.loop(text.length,
					Tween24.wait(delay),
					Tween24.func(function():void {
						textField.appendText(text.charAt(i));
						i++;
					})
				)
			);
			return plugin;
		}
		
		
		/*
		 * ===============================================================================================
		 * DELAY & EVENT
		 * -----------------------------------------------------------------------------------------------
		 */
		public function delay(time:Number):TextPlugin { _tween.delay(time); return this; }
		public function onPlay    (func:Function, ...args):TextPlugin { args.unshift(func); _tween.onPlay    .apply(_tween, args); return this; }
		public function onDelay   (func:Function, ...args):TextPlugin { args.unshift(func); _tween.onDelay   .apply(_tween, args); return this; }
		public function onInit    (func:Function, ...args):TextPlugin { args.unshift(func); _tween.onInit    .apply(_tween, args); return this; }
		public function onUpdate  (func:Function, ...args):TextPlugin { args.unshift(func); _tween.onUpdate  .apply(_tween, args); return this; }
		public function onPause   (func:Function, ...args):TextPlugin { args.unshift(func); _tween.onPause   .apply(_tween, args); return this; }
		public function onStop    (func:Function, ...args):TextPlugin { args.unshift(func); _tween.onStop    .apply(_tween, args); return this; }
		public function onComplete(func:Function, ...args):TextPlugin { args.unshift(func); _tween.onComplete.apply(_tween, args); return this; }
	}
}