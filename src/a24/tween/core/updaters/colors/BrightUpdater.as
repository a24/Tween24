package a24.tween.core.updaters.colors
{
	import a24.tween.core.updaters.abstracts.AbstractDisplayObjectUpdater;
	import a24.tween.core.updaters.abstracts.AbstractUpdater;
	
	import flash.display.DisplayObject;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2011.01.26
	 * @private
	 *
	 */
	public final class BrightUpdater extends AbstractDisplayObjectUpdater
	{
		private var _brightness:Number;
		private var _ctUpdater:ColorTransformUpdater;
		
		public function BrightUpdater() { }
		
		public function setProp(brightness:Number):void
		{
			this.brightness = brightness;
		}
		
		override public function init(target:DisplayObject):AbstractDisplayObjectUpdater 
		{
			super.init(target);
			
			var cb:Number = _brightness * 100;
			_ctUpdater ||= new ColorTransformUpdater();
			_ctUpdater.setProp(cb, cb, cb, 0, 1, 1, 1, NaN);
			
			_ctUpdater.init(_target.transform.colorTransform);
			
			return this;
		}
		
		override public function update(progress:Number):AbstractUpdater 
		{
			if (_tweenFlag & (1 << 0)) {
				_ctUpdater.update(_target, progress);
			}
			return this;
		}
		
		override public function clone():AbstractDisplayObjectUpdater 
		{
			var updater:BrightUpdater = new BrightUpdater();
			updater.setProp(_brightness);
			return updater;
		}
		
		override public function toString():String 
		{
			return ' bright:' + _brightness;
		}
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get brightness():Number { return _brightness; }
		public function set brightness(value:Number):void { _brightness = value; _updateFlag |= 1 << 0; }
	}
}