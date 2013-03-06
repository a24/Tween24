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
	public final class ColorUpdater extends AbstractDisplayObjectUpdater
	{
		private var _color:Number;
		private var _alpha:Number;
		private var _ctUpdater:ColorTransformUpdater;
		
		public function ColorUpdater() { }
		
		
		public function setProp(color:Number, alpha:Number, clear:Boolean = false):void
		{
			if (!isNaN(color)) this.color = color;
			var targetAlpha:Number = clear? 0: alpha? alpha: 15 / 255;
			this.alpha = (alpha >= 0.99)? 1: targetAlpha;
		}
		
		override public function init(target:DisplayObject):AbstractDisplayObjectUpdater 
		{
			super.init(target);
			var ct:ColorTransform = _target.transform.colorTransform;
			var al:Number =  1.0 - _alpha;
			var r:Number = isNaN(_color)? ct.redOffset   / (1.0 - ct.redMultiplier)   * _alpha: (_color >> 16 & 0xFF) * _alpha;
			var g:Number = isNaN(_color)? ct.greenOffset / (1.0 - ct.greenMultiplier) * _alpha: (_color >>  8 & 0xFF) * _alpha;
			var b:Number = isNaN(_color)? ct.blueOffset  / (1.0 - ct.blueMultiplier)  * _alpha: (_color       & 0xFF) * _alpha;
			
			_ctUpdater ||= new ColorTransformUpdater();
			_ctUpdater.setProp(r, g, b, 0, al, al, al, _target.alpha);
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
		override public function complete():void 
		{
			super.complete();
		}
		
		override public function clone():AbstractDisplayObjectUpdater 
		{
			var updater:ColorUpdater = new ColorUpdater();
			updater.setProp(_color, _alpha);
			return updater;
		}
		
		override public function toString():String 
		{
			return ' color:[' + RGBUpdater.getInt16(_color) + ' ' + _alpha + ']';
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get color():int { return _color; }
		public function set color(value:int):void { _color = value; _updateFlag |= 1 << 0; }
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void { _alpha = value; _updateFlag |= 1 << 0; }
	}
}