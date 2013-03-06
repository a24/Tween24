package a24.tween.core.updaters.abstracts
{
	import flash.display.DisplayObject;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2012.02.17
	 * @private
	 *
	 */
	public class AbstractDisplayObjectUpdater extends AbstractUpdater
	{
		protected var _target:DisplayObject;
		
		public function AbstractDisplayObjectUpdater() { }
		
		public function init(target:DisplayObject):AbstractDisplayObjectUpdater
		{
			initFlag();
			_target = target;
			return this;
		}
		
		public function clone():AbstractDisplayObjectUpdater
		{
			return null;
		}
	}
}