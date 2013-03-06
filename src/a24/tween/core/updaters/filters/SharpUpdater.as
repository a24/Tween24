package a24.tween.core.updaters.filters
{
	import a24.tween.core.updaters.abstracts.AbstractBitmapFilterUpdater;
	import a24.tween.core.updaters.abstracts.AbstractUpdater;
	import flash.filters.BitmapFilter;
	import flash.filters.ConvolutionFilter;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2012.04.09
	 * @private
	 *
	 */
	public final class SharpUpdater extends AbstractBitmapFilterUpdater
	{
		private var _filter:ConvolutionFilter;
		private var _sharpness:Number;
		private var _matrix:Array;
		private var _startSharpness:Number;
		private var _progSharpness:Number;
		private var _deltaSharpness:Number;
		
		public function SharpUpdater() { }
		
		public function setProp(sharpness:Number):void
		{
			if (!isNaN(sharpness)) this.sharpness = sharpness;
		}
		
		override public function init(target:Object, filter:BitmapFilter):AbstractUpdater
		{
			super.init(target, filter);
			
			_target = target;
			_filter = filter as ConvolutionFilter;
			
			if (!_filter.matrix.length) {
				_filter.matrixX = _filter.matrixY = 3;
				_filter.matrix  = [0, 0, 0, 0, 1, 0, 0, 0, 0];
			}
			_matrix         = _filter.matrix;
			_startSharpness = (_filter.matrix[4] - 1) * 0.25;
			_progSharpness  = _startSharpness;
			_deltaSharpness = _sharpness - _startSharpness;
			return this;
		}
		
		override public function update(progress:Number):AbstractUpdater
		{
			if (_tweenFlag & (1 << 0)) {
				var s:Number = _progSharpness = _startSharpness + _deltaSharpness * progress;
				//_matrix = [
					 //0,        -s,  0, 
					//-s, 1 + s * 4, -s, 
					 //0,        -s,  0
				//];
				_matrix[4] = 1 + s * 4;
				_matrix[1] = _matrix[3] = _matrix[5] = _matrix[7] = -s;
				_filter.matrix = _matrix 
				
				setFilter(_filter, ConvolutionFilter);
			}
			return this;
		}
		
		override public function clone():AbstractBitmapFilterUpdater
		{
			var updater:SharpUpdater = new SharpUpdater();
			updater.setProp(_sharpness);
			updater._updateFlag = _updateFlag;
			return updater;
		}
		
		override public function toString():String
		{
			return formatToString('sharp', _sharpness);
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get sharpness():Number { return _sharpness; }
		public function set sharpness(value:Number):void { _sharpness = value; _updateFlag |= 1 << 0; }
	}
}