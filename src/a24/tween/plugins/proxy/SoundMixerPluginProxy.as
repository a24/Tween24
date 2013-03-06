package a24.tween.plugins.proxy
{
	import a24.tween.plugins.SoundMixerPlugin;

	public class SoundMixerPluginProxy
	{
		/**
		 * ミキサーの SoundTransform プロパティのトゥイーンを設定します。
		 * @param time 時間
		 * @param easing イージング
		 * @return SoundMixerPlugin
		 */
		public function tween(time:Number, easing:Function = null):SoundMixerPlugin { return SoundMixerPlugin.tween(time, easing); }
		
		/**
		 * ミキサーの SoundTransform プロパティを設定します。
		 * @return SoundMixerPlugin
		 */
		public function prop():SoundMixerPlugin { return SoundMixerPlugin.prop(); }
		
		/**
		 * 再生中のサウンドをすべて停止します。
		 * @return SoundMixerPlugin
		 */
		public function allStop():SoundMixerPlugin { return SoundMixerPlugin.allStop(); }
	}
}