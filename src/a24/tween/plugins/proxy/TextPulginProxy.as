package a24.tween.plugins.proxy
{
	import a24.tween.plugins.TextPlugin;
	
	import flash.text.TextField;
	
	public class TextPulginProxy
	{
		public function TextPulginProxy() {}
		
		/**
		 * テキストフィールドに1文字づつ文字を追加するトゥイーンを設定します。
		 * @param textField テキストフィールド
		 * @param text 表示するテキスト
		 * @param delay 1文字の表示間隔
		 * @param reset テキストフィールドにすでに表示されているテキストを削除するかどうか
		 * @return TextPlugin
		 */
		public function typingTween(textField:TextField, text:String, time:Number, reset:Boolean = false):TextPlugin { return TextPlugin.typingTween(textField, text, time, reset); }
	}
}