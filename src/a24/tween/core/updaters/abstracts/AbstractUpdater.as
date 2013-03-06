package a24.tween.core.updaters.abstracts
{
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2012.02.17
	 * @private
	 *
	 */
	public class AbstractUpdater
	{
		protected var _tweenFlag:uint;
		protected var _updateFlag:uint;
		protected var _$updateFlag:uint;
		protected var _$$updateFlag:uint;
		
		public function AbstractUpdater() { }
		
		public function initFlag():void
		{
			_tweenFlag = _updateFlag;
		}
		
		public function update(progress:Number):AbstractUpdater
		{
			return this;
		}
		
		public function complete():void
		{
			update(1);
		}
		
		public function overwrite(updater:AbstractUpdater):void
		{
			var a:uint = updater._tweenFlag;
			var b:uint = _tweenFlag;
			_tweenFlag = a ^ (a | b);
		}
		
		public function toString():String
		{
			return "";
		}
		
		protected function formatToString(label:String, ...values):String
		{
			if (values.length == 1) return ' ' + label + ':' + values;
			else                    return ' ' + label + ':[' + values.join(' ') + ']';
		}
	}
}