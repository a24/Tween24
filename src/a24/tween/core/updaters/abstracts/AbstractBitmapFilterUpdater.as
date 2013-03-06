package a24.tween.core.updaters.abstracts
{
	import flash.filters.BitmapFilter;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2012.02.17
	 * @private
	 *
	 */
	public class AbstractBitmapFilterUpdater extends AbstractUpdater
	{
		protected var _target:Object;
		
		public function AbstractBitmapFilterUpdater() { }
		
		public function init(target:Object, filter:BitmapFilter):AbstractUpdater
		{
			initFlag();
			return this;
		}
		
		public function clone():AbstractBitmapFilterUpdater
		{
			return null;
		}
		
		protected function setFilter(filter:BitmapFilter, filterClass:Class):void
		{
			var filters:Array = _target.filters;
			var l:uint = filters.length;
			for (var i:uint = 0; i < l; ++i) {
				if (filters[i] is filterClass) {
					filters[i] = filter;
					_target.filters  = filters;
					return;
				}
			}
			filters.push(filter);
			_target.filters = filters;
 		}
		
		protected function getFilter(filterClass:Class):BitmapFilter
		{
			var filters:Array = _target.filters;
			for each (var f:BitmapFilter in filters) {
				if (f is filterClass) return f;
			}
			return null;
 		}
	}
}