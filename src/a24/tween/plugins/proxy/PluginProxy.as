package a24.tween.plugins.proxy
{
	/**
	 *
	 * プラグインを使いやすくするプロキシクラスです。
	 * @author Atsushi Kaga
	 * @since 2012.06.27
	 *
	 */
	public class PluginProxy
	{
		public function PluginProxy()
		{
			_matrix     = new MatrixPluginProxy();
			_social     = new SocialPulginProxy();
			_soundMixer = new SoundMixerPluginProxy();
			_sound      = new SoundPulginProxy();
			_timeline   = new TimelinePluginProxy();
			_text       = new TextPulginProxy();
		}
		
		/**
		 * DisplayObject の Matrix を操作するプラグインです。 
		 */
		public function get matrix():MatrixPluginProxy { return _matrix; }
		private var _matrix:MatrixPluginProxy;
		
		/**
		 * ソーシャルサービスに関する操作をするプラグインです。 
		 */
		public function get social():SocialPulginProxy { return _social; }
		private var _social:SocialPulginProxy;
		
		/**
		 * SoundMixer を操作するプラグインです。
		 */
		public function get soundMixer():SoundMixerPluginProxy { return _soundMixer; }
		private var _soundMixer:SoundMixerPluginProxy;
		
		/**
		 * Sound や SoundTransform を操作するプラグインです。 
		 */
		public function get sound():SoundPulginProxy { return _sound; }
		private var _sound:SoundPulginProxy;
		
		/**
		 * TextField を操作するプラグインです。 
		 */
		public function get text():TextPulginProxy { return _text; }
		private var _text:TextPulginProxy;
		
		/**
		 * MovieClip のタイムラインを操作するプラグインです。 
		 */
		public function get timeline():TimelinePluginProxy { return _timeline; }
		private var _timeline:TimelinePluginProxy;
	}
}
