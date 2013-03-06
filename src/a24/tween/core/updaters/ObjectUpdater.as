package a24.tween.core.updaters
{
	import a24.tween.core.updaters.abstracts.AbstractUpdater;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2011.03.04
	 * @private
	 *
	 */
	public final class ObjectUpdater extends AbstractUpdater
	{
		private var _target:*;
		private var _param:Object;
		private var _$param:Object;
		private var _$$param:Object;
		private var _startParam:Object;
		private var _deltaParam:Object;
		private var _key:Array;
		private var _tweenKey:Array;
		
		public function ObjectUpdater(target:*)
		{
			_target     = target;
			_param      = {};
			_startParam = {};
			_deltaParam = {};
			_key        = [];
		}
		
		public function setProp(param:Object):void
		{
			_param = param;
			
			for (var k:String in param) {
				if (k.slice(0, 2) == "$$") {
					k = k.substr(2, k.length);
					_$$param  ||= {};
					_$$param[k] = _param["$$" + k];
					delete _param["$$" + k];
				}
				else if (k.slice(0, 1) == "$") {
					k = k.substr(1, k.length);
					_$param  ||= {};
					_param[k]  = _target[k] + param["$" + k];
					_$param[k] = _param["$" + k];
					delete _param["$" + k];
				}
				else {
					_param[k] = param[k];
				}
				_key.push(k);
			}
		}
		
		public function addProp(paramName:String, value:*):void
		{
			var k:String = paramName;
			
			if (k.slice(0, 2) == "$$") {
				k = k.substr(2, k.length);
				_$$param  ||= {};
				_$$param[k] = value;
			}
			else if (k.slice(0, 1) == "$") {
				k = k.substr(1, k.length);
				_$param  ||= {};
				_param[k]  = _target[k] + value;
				_$param[k] = value;
			}
			else {
				_param[k] = value;
			}
			_key.push(k);
		}
		
		public function init():AbstractUpdater
		{
			_tweenKey = _key.concat();
			
			var k:String;
			if (_$$param) {
				for (k in _$$param) {
					_param[k] = _target[k] + _$$param[k];
				}
			}
			
			for each (k in _key) {
				_startParam[k] = _target[k];
				_deltaParam[k] = _param[k] - _target[k];
			}
			return this;
		}
		
		override public function update(progress:Number):AbstractUpdater 
		{
			for each (var k:String in _tweenKey) {
				_target[k] = _startParam[k] + _deltaParam[k] * progress;
			}
			return this;
		}
		
		override public function complete():void 
		{
			for each (var k:String in _tweenKey) {
				_target[k] = _param[k];
			}
		}
		
		override public function overwrite(updater:AbstractUpdater):void 
		{
			var u:ObjectUpdater = updater as ObjectUpdater;
			var f:Array = u._tweenKey;
			for each (var k:String in f) {
				var i:int = _tweenKey.indexOf(k);
				if (i > -1) _tweenKey.splice(i, 1);
			}
		}
		
		public function clone():ObjectUpdater
		{
			var updater:ObjectUpdater = new ObjectUpdater(_target);
			updater.setProp(_param);
			return updater;
		}
		
		override public function toString():String 
		{
			return ' param:' + _param;
		}
	}
}