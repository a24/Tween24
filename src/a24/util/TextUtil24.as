package a24.util
{
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.system.IMEConversionMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;

	/**
	 *
	 * TextField に関する便利なやつです。
	 * @author Atsushi Kaga
	 *
	 */
	final public class TextUtil24
	{
		/**
		 * @private
		 */
		public function TextUtil24() {}
		
		/**
		 * テキストサイズを設定します。
		 * @param tf 対象のテキストフィールド
		 * @param size テキストサイズ
		 * @return TextField
		 */
		public function setTextSize(tf:TextField, size:Number):TextField
		{
			var format:TextFormat = tf.defaultTextFormat;
			format.size = size;
			tf.defaultTextFormat = format;
			return tf;
		}
		
		/**
		 * 行送りを設定します。
		 * @param tf 対象のテキストフィールド
		 * @param leading 行間の垂直の行送り
		 * @return TextField
		 */
		public function setLeading(tf:TextField, leading:Number = 0):TextField
		{
			var format:TextFormat = tf.defaultTextFormat;
			format.leading = leading;
			tf.defaultTextFormat = format;
			return tf;
		}
		
		/**
		 * 文字間のスペースを設定します。
		 * @param tf 対象のテキストフィールド
		 * @param letterSpacing 文字の間のスペースの量
		 * @return TextField
		 */
		public function setLetterSpacing(tf:TextField, letterSpacing:Number = 0):TextField
		{
			var format:TextFormat = tf.defaultTextFormat;
			format.letterSpacing = letterSpacing;
			tf.defaultTextFormat = format;
			return tf;
		}
		
		/**
		 * 下線の設定をします。
		 * @param tf 対象のテキストフィールド
		 * @param underline アンダーラインを表示するかどうか
		 * @return TextField
		 */
		public function setUnderline(tf:TextField, underline:Boolean = true):TextField
		{
			var format:TextFormat = tf.defaultTextFormat;
			format.underline = underline;
			tf.defaultTextFormat = format;
			return tf;
		}
		
		/**
		 * 数値のみ入力できる制限をかけます。
		 * @param tf 対象のテキストフィールド
		 * @return TextField
		 */
		public function restrictPostcode(tf:TextField):TextField
		{
			tf.restrict = "0-9\-";
			return tf;
		}
		
		/**
		 * 英字のみ入力できる制限をかけます。
		 * @param tf 対象のテキストフィールド
		 * @return TextField
		 */
		public function restrictEnglish(tf:TextField):TextField
		{
			tf.restrict = "a-z\A-Z";
			return tf;
		}
		
		/**
		 * 英数字のみ入力できる制限をかけます。
		 * @param tf 対象のテキストフィールド
		 * @return TextField
		 */
		public function restrictEnglishNum(tf:TextField):TextField
		{
			tf.restrict = "a-z\A-Z\0-9";
			return tf;
		}
		
		/**
		 * メールアドレスに使用する文字のみ入力できる制限をかけます。
		 * @param tf 対象のテキストフィールド
		 * @return TextField
		 */
		public function restrictMailAddress(tf:TextField):TextField
		{
			tf.restrict = "a-z\A-Z\0-9\-_.@";
			return tf;
		}
		
		/**
		 * 日本語のみ入力できる制限をかけます。
		 * @param tf 対象のテキストフィールド
		 * @return TextField
		 */
		public function restrictJapanese(tf:TextField):TextField
		{
			tf.restrict = "ぁ-ん/ァ-ン/一-龥/ 　";
			return tf;
		}
		
		/**
		 * テキストフィールドにフォーカスした時に、半角英数字入力モードに設定します。
		 * @param tf 対象のテキストフィールド
		 * @return TextField
		 */
		public function inputModeEnglish(tf:TextField):TextField
		{
			tf.addEventListener(FocusEvent.FOCUS_IN, function():void
			{
				if (Capabilities.hasIME) { 
					try { IME.enabled = false; }
					catch(err:Error) {}
				}
			});
			return tf;
		}
		
		/**
		 * テキストフィールドにフォーカスした時に、日本語入力モードに設定します。
		 * @param tf 対象のテキストフィールド
		 * @return TextField
		 */
		public function inputModeJapanese(tf:TextField):TextField
		{
			tf.addEventListener(FocusEvent.FOCUS_IN, function():void
			{
				if(Capabilities.hasIME){ 
					try { IME.conversionMode = IMEConversionMode.JAPANESE_HIRAGANA; }
					catch(err:Error) {}
				}
			});
			return tf;
		}
		
		/**
		 * テキストフィールドが空の場合に表示するデフォルトテキストを設定します。
		 * @param tf 対象のテキストフィールド
		 * @param text デフォルトで表示されるテキスト
		 * @param textColor デフォルトで表示されるテキストの色
		 * @return TextField
		 */
		public function defaultInputText(tf:TextField, text:String, textColor:uint = 0x999999):TextField
		{
			var c:uint = tf.textColor;
			tf.textColor = textColor;
			tf.text = text;
			
			tf.addEventListener(FocusEvent.FOCUS_IN, function():void
			{
				if (tf.text == text) {
					tf.textColor = c;
					tf.text = "";
				}
			});
			
			tf.addEventListener(FocusEvent.FOCUS_OUT, function():void
			{
				if (!tf.text.length) {
					tf.textColor = textColor;
					tf.text = text;
				}
			});
			return tf;
		}
		
		/**
		 * エンターキーで他のテキストフィールドにフォーカスします。
		 * @param tf 対象のテキストフィールド
		 * @param next 次にフォーカスするテキストフィールド
		 * @return TextField
		 */
		public function enterAndFocus(tf:TextField, next:TextField):TextField
		{
			tf.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode == Keyboard.ENTER) tf.stage.focus = next;
			});
			return tf;
		}
		
		/**
		 * エンターキーで指定した関数を実行します。
		 * @param tf 対象のテキストフィールド
		 * @param func 実行する関数
		 * @return TextField
		 */
		public function enterAndFunc(tf:TextField, func:Function):TextField
		{
			tf.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode == Keyboard.ENTER) func();
			});
			return tf;
		}
		
		/**
		 * 文字列がメールアドレスかどうか判定します。
		 * @param address 判定する文字列
		 * @return TextField
		 */
		public function isMailAddress(address:String):Boolean
		{
			return (address.match(/^([a-z0-9_]|\-|\.|\+)+@(([a-z0-9_]|\-)+\.)+[a-z]{2,6}$/i) != null);
		}
	}
}