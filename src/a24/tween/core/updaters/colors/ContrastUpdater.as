package a24.tween.core.updaters.colors
{
	import a24.tween.core.updaters.abstracts.AbstractDisplayObjectUpdater;
	import a24.tween.core.updaters.abstracts.AbstractUpdater;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2011.01.26
	 * @private
	 *
	 */
	public final class ContrastUpdater extends AbstractDisplayObjectUpdater
	{
		private var _contrast:Number;
		private var _startContrast:Number;
		private var _deltaContrast:Number;
		private var _progContrast:Number;
		
		public function ContrastUpdater() { }
		
		public function setProp(contrast:Number):void
		{
			if (!isNaN(contrast)) this.contrast = contrast;
		}
		
		override public function init(target:DisplayObject):AbstractDisplayObjectUpdater 
		{
			super.init(target);
			
			var ct:ColorTransform = _target.transform.colorTransform;
			_startContrast = ct.redMultiplier - 1;
			_deltaContrast = _contrast - _startContrast;
			return this;
		}
		
		override public function update(progress:Number):AbstractUpdater 
		{
			if (_tweenFlag & (1 << 0)) {
				_progContrast = _startContrast + _deltaContrast * progress;
				
				var mc:Number = _progContrast + 1;
				var co:Number = Math.round(_progContrast * -128);
				var ct:ColorTransform = _target.transform.colorTransform;
				ct.redMultiplier      = mc;
				ct.greenMultiplier    = mc;
				ct.blueMultiplier     = mc;
				//ct.alphaMultiplier    = mc;
				ct.redOffset          = co;
				ct.greenOffset        = co;
				ct.blueOffset         = co;
				ct.alphaOffset        = 0;
				_target.transform.colorTransform = ct;
			}
			return this;
		}
		
		override public function clone():AbstractDisplayObjectUpdater 
		{
			var updater:ContrastUpdater = new ContrastUpdater();
			updater.setProp(_contrast);
			return updater;
		}
		
		override public function toString():String 
		{
			return ' contrast:' + _contrast;
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get contrast():int { return _contrast; }
		public function set contrast(value:int):void { _contrast = value; _updateFlag |= 1 << 0; }
	}
}