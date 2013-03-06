package a24.tween.events
{
	import a24.tween.Tween24;
	import flash.events.Event;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @version	2.0
	 * @since	2011.05.05
	 *
	 */
	public class Tween24Event extends Event
	{
		/**
		 * play イベントオブジェクトの type プロパティ値を定義します。
		 */
		static public const PLAY:String = "play";
		
		/**
		 * delay イベントオブジェクトの type プロパティ値を定義します。
		 */
		static public const DELAY:String = "delay";
		
		/**
		 * init イベントオブジェクトの type プロパティ値を定義します。
		 */
		static public const INIT:String = "init";
		
		/**
		 * pause イベントオブジェクトの type プロパティ値を定義します。
		 */
		static public const PAUSE:String = "pause";
		
		/**
		 * skip イベントオブジェクトの type プロパティ値を定義します。
		 */
		static public const SKIP:String = "skip";
		
		/**
		 * stop イベントオブジェクトの type プロパティ値を定義します。
		 */
		static public const STOP:String = "stop";
		
		/**
		 * update イベントオブジェクトの type プロパティ値を定義します。
		 */
		static public const UPDATE:String = "update";
		
		/**
		 * complete イベントオブジェクトの type プロパティ値を定義します。
		 */
		static public const COMPLETE:String = "complete";
		
		private var _tween:Tween24;
		
		/**
		 * イベントリスナーにパラメーターとして渡す Tween24Event オブジェクトを作成します。
		 * @param	tween		関連付けされるトゥイーンインスタンス
		 * @param	type		イベントのタイプです
		 * @param	bubbles		イベントがバブリングイベントか
		 * @param	cancelable	イベントに関連付けられた動作を回避できるか
		 */
		public function Tween24Event(tween:Tween24, type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_tween = tween;
		}
		
		/**
		 * ストリング表現を返します。
		 * @return	String
		 */
		override public function toString():String 
		{
			return String('[Tween24Event type="' + type + '" bubbles=' + bubbles + ' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']');
		}
		
		/**
		 * 関連付けされているトゥイーンインスタンスです。
		 */
		public function get tween():Tween24 { return _tween; }
	}
}