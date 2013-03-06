package a24.tween.core.updaters.display
{
	import a24.tween.core.updaters.abstracts.AbstractUpdater;
	import flash.display.MovieClip;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2011.01.26
	 * @private
	 *
	 */
	public final class TimelineUpdater extends AbstractUpdater
	{
		private var _target:MovieClip
		private var _frame:int;
		private var _startFrame:int;
		private var _deltaFrame:int;
		
		public function TimelineUpdater() { }
		
		public function setProp(frame:int):void
		{
			if (!isNaN(frame)) this.frame = frame;
		}
		
		public function init(target:MovieClip):AbstractUpdater
		{
			initFlag();
			_target     = target;
			_startFrame = _target.currentFrame;
			_deltaFrame = _frame - _startFrame;
			return this;
		}
		
		override public function update(progress:Number):AbstractUpdater 
		{
			if (_tweenFlag & (1 << 0)) {
				_target.gotoAndStop(int(_startFrame + _deltaFrame * progress));
			}
			return this;
		}
		
		public function clone():TimelineUpdater
		{
			var updater:TimelineUpdater = new TimelineUpdater();
			updater.setProp(_frame);
			return updater;
		}
		
		override public function toString():String 
		{
			return ' frame:' + _frame;
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get frame():int { return _frame; }
		public function set frame(value:int):void { _frame = value; _updateFlag |= 1 << 0; }
	}
}