package a24.tween.plugins.proxy
{
	import a24.tween.plugins.SoundPlugin;
	import flash.media.SoundTransform;
	import flash.media.Sound;

	public class SoundPulginProxy
	{
		public function SoundPulginProxy() {}
		
		/**
		 * サウンドを登録します。
		 * @param id サウンドのID
		 * @param sound サウンドインスタンス
		 * @param defaultVolume デフォルトのボリューム（ここで設定したボリュームを1としてトゥイーンします）
		 */
		public function addSound(id:String, sound:Sound, defaultVolume:Number = 1):void { return SoundPlugin.addSound(id, sound, defaultVolume); }
		
		/**
		 * 登録したサウンドを解除します。
		 * @param id サウンドのID
		 */
		public function removeSound(id:String):void { return SoundPlugin.removeSound(id); }
		
		/**
		 * SoundTransform のプロパティのトゥイーンを設定します。
		 * @param id addSound メソッドで登録したサウンドID
		 * @param time 時間
		 * @param easing イージング
		 * @return SoundPlugin
		 */
		public function tween(id:String, time:Number, easing:Function = null):SoundPlugin { return SoundPlugin.tween(id, time, easing); }
		
		/**
		 * SoundTransform のプロパティを設定します。
		 * @param id addSound メソッドで登録したサウンドID
		 * @return SoundPlugin
		 */
		public function prop(id:String):SoundPlugin
		{
			return SoundPlugin.prop(id);
		}
		
		/**
		 * サウンドを再生します。
		 * @param id addSound メソッドで登録したサウンドID
		 * @param startTime 再生を開始する初期位置 (ミリ秒単位) 
		 * @param loops 繰り返す回数
		 * @param sndTransform サウンドチャンネルに割り当てられた初期 SoundTransform オブジェクト
		 * @return SoundPlugin
		 */
		public function playSound(id:String, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundPlugin { return SoundPlugin.playSound(id, startTime, loops, sndTransform); }
		
		/**
		 * サウンドを停止します。
		 * @param id addSound メソッドで登録したサウンドID
		 * @return SoundPlugin
		 */
		public function stopSound(id:String):SoundPlugin { return SoundPlugin.stopSound(id); }
	}
}