package a24.tween.plugins.proxy
{
	import a24.tween.plugins.TimelinePlugin;
	
	import flash.display.MovieClip;

	public class TimelinePluginProxy
	{
		public function TimelinePluginProxy() {}
		
		/**
		 * タイムラインを、指定されたフレームレートでトゥイーンします。
		 * @param target 対象オブジェクト
		 * @param frameRate フレームレート
		 * @param startFrame 始点フレーム（指定しない場合は現在のフレームが設定されます）
		 * @param completeFrame 終点フレーム（指定しない場合は最後のフレームが設定されます）
		 * @param easing イージング
		 * @return Tween24
		 */
		public function tweenFrame(target:MovieClip, frameRate:int, startFrame:int = 0, completeFrame:int = 0, easing:Function = null):TimelinePlugin { return TimelinePlugin.tweenFrame(target, frameRate, startFrame, completeFrame, easing); }
		
		/**
		 * タイムラインを再生します。
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		public function play(...target):TimelinePlugin { return TimelinePlugin.play.apply(this, target); }
		
		/**
		 * タイムラインを停止します。
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		public function stop(...target):TimelinePlugin { return TimelinePlugin.stop.apply(this, target); }
		
		/**
		 * 指定したフレームから、タイムラインを再生します。（複数ターゲット指定可）
		 * @param frame 移動フレーム
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		public function gotoAndPlay(frame:*, ...target):TimelinePlugin { target.unshift(frame); return TimelinePlugin.gotoAndPlay.apply(this, target); }
		
		/**
		 * 指定したフレームにタイムラインを移動し、停止します。（複数ターゲット指定可）
		 * @param frame 移動フレーム
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		public function gotoAndStop(frame:*, ...target):TimelinePlugin { target.unshift(frame); return TimelinePlugin.gotoAndStop.apply(this, target); }
		
		/**
		 * 一つ前のフレームへ移動します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		public function gotoPrevFrame(...target):TimelinePlugin { return TimelinePlugin.gotoPrevFrame.apply(this, target); }
		
		/**
		 * 一つ後ろのフレームへ移動します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		public function gotoNextFrame(...target):TimelinePlugin { return TimelinePlugin.gotoNextFrame.apply(this, target); }
		
		/**
		 * 最後のフレームへ移動します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		public function gotoLastFrame(...target):TimelinePlugin { return TimelinePlugin.gotoLastFrame.apply(this, target); }
		
		/**
		 * ランダムのフレームから、タイムラインを再生します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		public function gotoRandomAndPlay(...target):TimelinePlugin { return TimelinePlugin.gotoRandomAndPlay.apply(this, target); }
		
		/**
		 * ランダムのフレームへタイムラインを移動し、停止します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		public function gotoRandomAndStop(...target):TimelinePlugin { return TimelinePlugin.gotoRandomAndStop.apply(this, target); }
	}
}