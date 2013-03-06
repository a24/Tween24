package a24.tween.core.updaters.filters
{
	import a24.tween.core.updaters.abstracts.AbstractBitmapFilterUpdater;
	import a24.tween.core.updaters.abstracts.AbstractUpdater;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2011.01.23
	 * @private
	 *
	 */
	public final class BlurFilterUpdater extends AbstractBitmapFilterUpdater
	{
		private var _blurX:Number;
		private var _blurY:Number;
		private var _quality:Number;
		
		private var _startBlurX:Number;
		private var _startBlurY:Number;
		private var _startQuality:Number;
		
		private var _deltaBlurX:Number;
		private var _deltaBlurY:Number;
		private var _deltaQuality:Number;
		
		private var _filter:BlurFilter;
		
		public function BlurFilterUpdater() { }
		
		public function setProp(blurX:Number = NaN, blurY:Number = NaN, quality:Number = NaN):void
		{
			if (!isNaN(blurX))   this.blurX   = blurX;
			if (!isNaN(blurY))   this.blurY   = blurY;
			if (!isNaN(quality)) this.quality = quality;
		}
		
		override public function init(target:Object, filter:BitmapFilter):AbstractUpdater
		{
			super.init(target, filter);
			
			_target       = target;
			_filter       = filter as BlurFilter;
			
			if (_tweenFlag & (1 << 0)) { _startBlurX   = _filter.blurX; _deltaBlurX   = _blurX   - _startBlurX; }
			if (_tweenFlag & (1 << 1)) { _startBlurY   = _filter.blurY; _deltaBlurY   = _blurY   - _startBlurY; }
			if (_tweenFlag & (1 << 2)) { _startQuality = _filter.quality; _deltaQuality = _quality - _startQuality; }
			
			return this;
		}
		
		override public function update(progress:Number):AbstractUpdater 
		{
			_filter = getFilter(BlurFilter) as BlurFilter || _filter;
			if (_tweenFlag & (1 << 0)) _filter.blurX   = _startBlurX   + _deltaBlurX   * progress;
			if (_tweenFlag & (1 << 1)) _filter.blurY   = _startBlurY   + _deltaBlurY   * progress;
			if (_tweenFlag & (1 << 2)) _filter.quality = _startQuality + _deltaQuality * progress;
			setFilter(_filter, BlurFilter);
			return this;
		}
		
		override public function clone():AbstractBitmapFilterUpdater
		{
			var updater:BlurFilterUpdater = new BlurFilterUpdater();
			updater.setProp(_blurX, _blurY, _quality);
			updater._updateFlag = _updateFlag;
			return updater;
		}
		
		override public function toString():String
		{
			return formatToString('blur', _blurX, _blurY, _quality);
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get blurX():Number { return _blurX; }
		public function set blurX(value:Number):void { _blurX = value; _updateFlag |= 1 << 0; }
		
		public function get blurY():Number { return _blurY; }
		public function set blurY(value:Number):void { _blurY = value; _updateFlag |= 1 << 1; }
		
		public function get quality():Number { return _quality; }
		public function set quality(value:Number):void { _quality = value; _updateFlag |= 1 << 2; }
	}
}