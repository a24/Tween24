package a24.tween.core.updaters.filters
{
	import a24.tween.core.updaters.abstracts.AbstractBitmapFilterUpdater;
	import a24.tween.core.updaters.abstracts.AbstractUpdater;
	import a24.tween.core.updaters.colors.RGBUpdater;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2011.01.23
	 * @private
	 *
	 */
	public final class DropShadowFilterUpdater extends AbstractBitmapFilterUpdater 
	{
		private var _distance:Number;
		private var _angle:Number;
		private var _color:Number;
		private var _alpha:Number;
		private var _blurX:Number;
		private var _blurY:Number;
		private var _strength:Number;
		private var _quality:Number;
		private var _inner:Boolean;
		private var _knockout:Boolean;
		
		private var _startDistance:Number;
		private var _startAngle:Number;
		private var _startAlpha:Number;
		private var _startBlurX:Number;
		private var _startBlurY:Number;
		private var _startStrength:Number;
		private var _startQuality:Number;
		
		private var _deltaDistance:Number;
		private var _deltaAngle:Number;
		private var _deltaAlpha:Number;
		private var _deltaBlurX:Number;
		private var _deltaBlurY:Number;
		private var _deltaStrength:Number;
		private var _deltaQuality:Number;
		
		private var _filter:DropShadowFilter;
		private var _rgb:RGBUpdater;
		
		public function DropShadowFilterUpdater() { }
		
		public function setProp(distance:Number, angle:Number, color:Number, _alpha:Number, blurX:Number, blurY:Number, strength:Number, quality:Number):void
		{
			_rgb    ||= new RGBUpdater();
			if (!isNaN(distance)) this.distance = distance;
			if (!isNaN(angle))    this.angle    = angle;
			if (!isNaN(color))    this.color    = color;
			if (!isNaN(alpha))    this.alpha    = alpha;
			if (!isNaN(blurX))    this.blurX    = blurX;
			if (!isNaN(blurY))    this.blurY    = blurY;
			if (!isNaN(strength)) this.strength = strength
			if (!isNaN(quality))  this.quality  = quality;
		}
		
		
		override public function init(target:Object, filter:BitmapFilter):AbstractUpdater
		{
			super.init(target, filter);
			
			_target = target;
			_filter = filter as DropShadowFilter;
			
			if (_tweenFlag & (1 << 0)) { _startDistance   = _filter.distance; _deltaDistance = _distance - _startDistance; }
			if (_tweenFlag & (1 << 1)) { _startAngle      = _filter.angle;    _deltaAngle    = _angle    - _startAngle; }
			if (_tweenFlag & (1 << 2)) { _rgb.setProp(_filter.color, _color); }
			if (_tweenFlag & (1 << 3)) { _startAlpha      = _filter.alpha;    _deltaAlpha    = _alpha    - _startAlpha; }
			if (_tweenFlag & (1 << 4)) { _startBlurX      = _filter.blurX;    _deltaBlurX    = _blurX    - _startBlurX; }
			if (_tweenFlag & (1 << 5)) { _startBlurY      = _filter.blurY;    _deltaBlurY    = _blurY    - _startBlurY; }
			if (_tweenFlag & (1 << 6)) { _startStrength   = _filter.strength; _deltaStrength = _strength - _startStrength; }
			if (_tweenFlag & (1 << 7)) { _startQuality    = _filter.quality;  _deltaQuality  = _quality  - _startQuality; }
			if (_tweenFlag & (1 << 8)) { _filter.inner    = _inner; }
			if (_tweenFlag & (1 << 9)) { _filter.knockout = _knockout; }
			return this;
		}
		
		override public function update(progress:Number):AbstractUpdater
		{
			_filter = getFilter(DropShadowFilter) as DropShadowFilter || _filter;
			if (_tweenFlag & (1 << 0)) _filter.distance = _startDistance + _deltaDistance * progress;
			if (_tweenFlag & (1 << 1)) _filter.angle    = _startAngle    + _deltaAngle    * progress;
			if (_tweenFlag & (1 << 2)) _filter.color    = RGBUpdater(_rgb.update(progress)).getColor();
			if (_tweenFlag & (1 << 3)) _filter.alpha    = _startAlpha    + _deltaAlpha    * progress;
			if (_tweenFlag & (1 << 4)) _filter.blurX    = _startBlurX    + _deltaBlurX    * progress;
			if (_tweenFlag & (1 << 5)) _filter.blurY    = _startBlurY    + _deltaBlurY    * progress;
			if (_tweenFlag & (1 << 6)) _filter.strength = _startStrength + _deltaStrength * progress;
			if (_tweenFlag & (1 << 7)) _filter.quality  = _startQuality  + _deltaQuality  * progress;
			setFilter(_filter, DropShadowFilter);
			return this;
		}
		
		override public function clone():AbstractBitmapFilterUpdater
		{
			var updater:DropShadowFilterUpdater = new DropShadowFilterUpdater();
			updater.setProp(_distance, _angle, _color, _alpha, _blurX, _blurY, _strength, _quality);
			updater._inner      = _inner;
			updater._knockout   = _knockout;
			updater._updateFlag = _updateFlag;
			return updater;
		}
		
		override public function toString():String
		{
			return formatToString('dropShadow', _distance, _angle, RGBUpdater.getInt16(_color), _alpha, _blurX, _blurY, _strength, _quality);
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get distance():Number { return _distance; }
		public function set distance(value:Number):void { _distance = value; _updateFlag |= 1 << 0; }
		
		public function get angle():Number { return _angle; }
		public function set angle(value:Number):void { _angle = value; _updateFlag |= 1 << 1; }
		
		public function get color():Number { return _color; }
		public function set color(value:Number):void { _color = value; _updateFlag |= 1 << 2; }
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void { _alpha = value; _updateFlag |= 1 << 3; }
		
		public function get blurX():Number { return _blurX; }
		public function set blurX(value:Number):void { _blurX = value; _updateFlag |= 1 << 4; }
		
		public function get blurY():Number { return _blurY; }
		public function set blurY(value:Number):void { _blurY = value; _updateFlag |= 1 << 5; }
		
		public function get strength():Number { return _strength; }
		public function set strength(value:Number):void { _strength = value; _updateFlag |= 1 << 6; }
		
		public function get quality():Number { return _quality; }
		public function set quality(value:Number):void { _quality = value; _updateFlag |= 1 << 7; }
		
		public function get inner():Boolean { return _inner; }
		public function set inner(value:Boolean):void { _inner = value; _updateFlag |= 1 << 8; }
		
		public function get knockout():Boolean { return _knockout; }
		public function set knockout(value:Boolean):void { _knockout = value; _updateFlag |= 1 << 9; }
	}
}