package a24.tween.core.plugins
{
	import a24.tween.Tween24;
	import a24.util.Util24;
	
	/**
	 * 
	 * @author	Atsushi Kaga
	 * @since	2011.05.01
	 * @private
	 * 
	 */
	public class PulginTween24
	{
		protected var _tween:Tween24;
		private var _target:Object;
		private var _time:Number;
		private var _easing:Function;
		
		public function PulginTween24()
		{
			_tween = new Tween24();
		}
		
		/*
		 * ===============================================================================================
		 *
		 * PROTECTED
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		protected function setTween(target:Object, time:Number, easing:Function = null):PulginTween24
		{
			_tween = Tween24.tween(target, time, easing);
			return this;
		}
		
		protected function setProp(target:Object):PulginTween24
		{
			_tween = Tween24.prop(target);
			return this;
		}
		
		protected function setFunc(func:Function, ... args):PulginTween24
		{
			args.unshift(func);
			_tween = Tween24.func.apply(_tween, args);
			return this;
		}
		
		protected function add(funcName:String, ... args):PulginTween24
		{
			args = Util24.array.compress(args);
			_tween[funcName].apply(_tween, args);
			return this;
		}
		
		protected function addParam(name:String, value:*):void
		{
			_tween.addParam(name, value);
		}
		
		/*
		 * ===============================================================================================
		 *
		 * PUBLIC
		 *
		 * -----------------------------------------------------------------------------------------------
		 */
		public function getTween24():Tween24
		{
			return _tween;
		}
		
		public function play():void
		{
			_tween.play();
		}
		
		public function pause():void
		{
			_tween.pause();
		}
		
		public function skip():void
		{
			_tween.skip();
		}
		
		public function stop():void
		{
			_tween.stop();
		}
		
		public function setTimeScale(timeScale:Number):void
		{
			_tween.setTimeScale(timeScale);
		}
	}
}