package a24.util 
{
	import flash.display.MovieClip;
	
	/**
	 *
	 * MovieClip のタイムラインに関する便利なやつです。
	 * @author Atsushi Kaga
	 *
	 */
	final public class TimelineUtil24 
	{
		/**
		 * @private
		 */
		public function TimelineUtil24() {}
		
		/**
		 * タイムラインを再生します。
		 * @param ...target 対象オブジェクト
		 */
		public function play(...target):void
		{
			target = Util24.array.compressAndClean(target);
			for each (var t:MovieClip in target) t.play();
		}
		
		/**
		 * タイムラインを停止します。
		 * @param ...target 対象オブジェクト
		 */
		public function stop(...target):void
		{
			target = Util24.array.compressAndClean(target);
			for each (var t:MovieClip in target) t.stop();
		}
		
		/**
		 * 指定したフレームから、タイムラインを再生します。（複数ターゲット指定可）
		 * @param frame 移動フレーム
		 * @param ...target 対象オブジェクト
		 */
		public function gotoAndPlay(frame:*, ...target):void
		{
			target = Util24.array.compressAndClean(target);
			for each (var t:MovieClip in target) t.gotoAndPlay(frame);
		}
		
		/**
		 * 指定したフレームにタイムラインを移動し、停止します。（複数ターゲット指定可）
		 * @param frame 移動フレーム
		 * @param ...target 対象オブジェクト
		 */
		public function gotoAndStop(frame:*, ...target):void
		{
			target = Util24.array.compressAndClean(target);
			for each (var t:MovieClip in target) t.gotoAndStop(frame);
		}
		
		/**
		 * 一つ前のフレームに移動します。
		 * @param ...target 対象オブジェクト
		 */
		public function gotoPrevFrame(...target):void
		{
			target = Util24.array.compressAndClean(target);
			for each (var t:MovieClip in target) t.gotoAndStop(t.currentFrame - 1);
		}
		
		/**
		 * 一つ次のフレームに移動します。
		 * @param ...target 対象オブジェクト
		 */
		public function gotoNextFrame(...target):void
		{
			target = Util24.array.compressAndClean(target);
			for each (var t:MovieClip in target) t.gotoAndStop(t.currentFrame + 1);
		}
		
		/**
		 * 最後のフレームに移動します。
		 * @param ...target 対象オブジェクト
		 */
		public function gotoLastFrame(...target):void
		{
			target = Util24.array.compressAndClean(target);
			for each (var t:MovieClip in target) t.gotoAndStop(t.totalFrames);
		}
		
		/**
		 * ランダムのフレームから、タイムラインを再生します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 */
		public function gotoRandomAndPlay(...target):void
		{
			target = Util24.array.compressAndClean(target);
			for each (var t:MovieClip in target) t.gotoAndPlay(int(t.totalFrames * Math.random() + 1));
		}
		
		/**
		 * ランダムのフレームへタイムラインを移動し停止します。（複数ターゲット指定可）
		 * @param ...target 対象オブジェクト
		 */
		public function gotoRandomAndStop(...target):void
		{
			target = Util24.array.compressAndClean(target);
			for each (var t:MovieClip in target) t.gotoAndStop(int(t.totalFrames * Math.random() + 1));
		}
	}
}