package a24.tween.core.updaters.colors
{
	import a24.tween.core.updaters.abstracts.*;
	import flash.display.DisplayObject;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2012.01.4
	 * @private
	 *
	 */
	public final class ColorReversalUpdater extends AbstractDisplayObjectUpdater
	{
		private var _value:Number;
		private var _ctUpdater:ColorTransformUpdater;
		
		public function ColorReversalUpdater() { }
		
		public function setProp(value:Number):void
		{
			if (!isNaN(value)) this.value = value;
		}
		
		override public function init(target:DisplayObject):AbstractDisplayObjectUpdater 
		{
			super.init(target);
			
			var o:Number = _value * 255;
			var m:Number = _value * -2 + 1;
			_ctUpdater ||= new ColorTransformUpdater();
			_ctUpdater.setProp(o, o, o, 0, m, m, m, 1);
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
			var updater:ColorReversalUpdater = new ColorReversalUpdater();
			updater.setProp(_value);
			return updater;
		}
		
		override public function toString():String 
		{
			return ' colorReversal:[' + _value + ']';
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get value():Number { return _value; }
		public function set value(value:Number):void { _value = value; _updateFlag |= 1 << 0; }
	}
}