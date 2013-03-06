package a24.tween.core.updaters.filters
{
	import a24.tween.core.updaters.abstracts.AbstractBitmapFilterUpdater;
	import a24.tween.core.updaters.abstracts.AbstractUpdater;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2011.01.23
	 * @private
	 *
	 */
	public final class SaturationUpdater extends AbstractBitmapFilterUpdater
	{
		private var _filter:ColorMatrixFilter;
		private var _saturation:Number;
		private var _startSaturate:Number;
		private var _progSaturate:Number;
		private var _deltaSaturate:Number;
		
		public function SaturationUpdater() { }
		
		public function setProp(saturation:Number):void
		{
			if (!isNaN(saturation)) this.saturation = saturation;
		}
		
		override public function init(target:Object, filter:BitmapFilter):AbstractUpdater
		{
			super.init(target, filter);
			
			_target        = target;
			_filter        = filter as ColorMatrixFilter;
			_startSaturate = (_filter.matrix[0] - (1 / 3)) / (2 / 3);
			_progSaturate  = _startSaturate;
			_deltaSaturate = _saturation - _startSaturate;
			return this;
		}
		
		override public function update(progress:Number):AbstractUpdater
		{
			if (_tweenFlag & (1 << 0)) {
				_progSaturate = _startSaturate + _deltaSaturate * progress;
				
				var rl:Number = 1 / 3;
				var gl:Number = 1 / 3;
				var bl:Number = 1 / 3;
				
				var sf:Number = _progSaturate;
				var nf:Number = 1 - sf;
				var nr:Number = rl * nf;
				var ng:Number = gl * nf;
				var nb:Number = bl * nf;
				
				_filter.matrix = [
					nr + sf, ng     , nb     , 0, 0,
					nr     , ng + sf, nb     , 0, 0,
					nr     , ng     , nb + sf, 0, 0,
					0      , 0      , 0      , 1, 0
				];
				setFilter(_filter, ColorMatrixFilter);
			}
			return this;
		}
		
		override public function clone():AbstractBitmapFilterUpdater
		{
			var updater:SaturationUpdater = new SaturationUpdater();
			updater.setProp(_saturation);
			updater._updateFlag = _updateFlag;
			return updater;
		}
		
		override public function toString():String
		{
			return formatToString('saturation', _saturation);
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get saturation():Number { return _saturation; }
		public function set saturation(value:Number):void { _saturation = value; _updateFlag |= 1 << 0; }
	}
}