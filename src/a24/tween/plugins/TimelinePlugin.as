package a24.tween.plugins
{
	import a24.tween.Ease24;
	import a24.tween.Tween24;
	import a24.tween.core.plugins.PulginTween24;
	import a24.util.Util24;
	
	import flash.display.MovieClip;
	
	/**
	 * 
	 * MovieClip のタイムラインを操作するプラグインです。 
	 * @author Atsushi Kaga
	 * @since 2012.01.09
	 *
	 */
	public final class TimelinePlugin extends PulginTween24
	{
		/**
		 * @private
		 */
		public function TimelinePlugin() {}
		
		/**
		 * タイムラインを、指定されたフレームレートでトゥイーンします。
		 * @param target 対象オブジェクト
		 * @param frameRate フレームレート
		 * @param startFrame 始点フレーム（指定しない場合は現在のフレームが設定されます）
		 * @param completeFrame 終点フレーム（指定しない場合は最後のフレームが設定されます）
		 * @param easing イージング
		 * @return Tween24
		 */
		static public function tweenFrame(target:MovieClip, frameRate:int, startFrame:int = 0, completeFrame:int = 0, easing:Function = null):TimelinePlugin
		{
			startFrame ||= target.currentFrame;
			completeFrame ||= target.totalFrames;
			easing ||= Ease24._Linear;
			
			var plugin:TimelinePlugin = new TimelinePlugin();
			plugin._tween = Tween24.serial(
				Tween24.plugin.timeline.gotoAndStop(startFrame, target),
				Tween24.tween(target, (completeFrame - startFrame) / frameRate, easing).frame(completeFrame)
			);
			return plugin;
		}
		
		/**
		 * タイムラインを再生します。
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function play(...target):TimelinePlugin
		{
			target.unshift(Util24.timeline.play);
			return new TimelinePlugin().setFunc.apply(null, target) as TimelinePlugin;
		}
		
		/**
		 * タイムラインを停止します。
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function stop(...target):TimelinePlugin
		{
			target.unshift(Util24.timeline.stop);
			return new TimelinePlugin().setFunc.apply(null, target) as TimelinePlugin;
		}
		
		/**
		 * 指定したフレームから、タイムラインを再生します。（複数ターゲット指定可）
		 * @param frame 移動フレーム
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function gotoAndPlay(frame:*, ...target):TimelinePlugin
		{
			target.unshift(Util24.timeline.gotoAndPlay, frame);
			return new TimelinePlugin().setFunc.apply(null, target) as TimelinePlugin;
		}
		
		/**
		 * 指定したフレームにタイムラインを移動し、停止します。（複数ターゲット指定可）
		 * @param frame 移動フレーム
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function gotoAndStop(frame:*, ...target):TimelinePlugin
		{
			target.unshift(Util24.timeline.gotoAndStop, frame);
			return new TimelinePlugin().setFunc.apply(null, target) as TimelinePlugin;
		}
		
		/**
		 * 一つ前のフレームへ移動します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function gotoPrevFrame(...target):TimelinePlugin
		{
			target.unshift(Util24.timeline.gotoPrevFrame);
			return new TimelinePlugin().setFunc.apply(null, target) as TimelinePlugin;
		}
		
		/**
		 * 一つ後ろのフレームへ移動します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function gotoNextFrame(...target):TimelinePlugin
		{
			target.unshift(Util24.timeline.gotoNextFrame);
			return new TimelinePlugin().setFunc.apply(null, target) as TimelinePlugin;
		}
		
		/**
		 * 最後のフレームへ移動します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function gotoLastFrame(...target):TimelinePlugin
		{
			target.unshift(Util24.timeline.gotoLastFrame);
			return new TimelinePlugin().setFunc.apply(null, target) as TimelinePlugin;
		}
		
		/**
		 * ランダムのフレームから、タイムラインを再生します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function gotoRandomAndPlay(...target):TimelinePlugin
		{
			target.unshift(Util24.timeline.gotoRandomAndPlay);
			return new TimelinePlugin().setFunc.apply(null, target) as TimelinePlugin;
		}
		
		/**
		 * ランダムのフレームへタイムラインを移動し、停止します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 * @return Tween24
		 */
		static public function gotoRandomAndStop(...target):TimelinePlugin
		{
			target.unshift(Util24.timeline.gotoRandomAndStop);
			return new TimelinePlugin().setFunc.apply(null, target) as TimelinePlugin;
		}
		
		
		/*
		 * ===============================================================================================
		 * DELAY & EVENT
		 * -----------------------------------------------------------------------------------------------
		 */
		public function delay     (time:Number):TimelinePlugin { add("delay", time); return this; }
		public function onPlay    (func:Function, ...args):TimelinePlugin { add("onPlay"    , func, args); return this; }
		public function onDelay   (func:Function, ...args):TimelinePlugin { add("onDelay"   , func, args); return this; }
		public function onInit    (func:Function, ...args):TimelinePlugin { add("onInit"    , func, args); return this; }
		public function onUpdate  (func:Function, ...args):TimelinePlugin { add("onUpdate"  , func, args); return this; }
		public function onPause   (func:Function, ...args):TimelinePlugin { add("onPause"   , func, args); return this; }
		public function onSkip    (func:Function, ...args):TimelinePlugin { add("onSkip"    , func, args); return this; }
		public function onStop    (func:Function, ...args):TimelinePlugin { add("onStop"    , func, args); return this; }
		public function onComplete(func:Function, ...args):TimelinePlugin { add("onComplete", func, args); return this; }
	}
}