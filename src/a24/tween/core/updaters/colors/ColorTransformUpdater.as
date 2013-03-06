package a24.tween.core.updaters.colors
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2011.12.28
	 * @private
	 *
	 */
	public class ColorTransformUpdater 
	{
		private var _redOffset           :Number;
		private var _greenOffset         :Number;
		private var _blueOffset          :Number;
		private var _alphaOffset         :Number;
		private var _redMultiplier       :Number;
		private var _greenMultiplier     :Number;
		private var _blueMultiplier      :Number;
		private var _alphaMultiplier     :Number;
		
		private var _startRedOffset      :Number;
		private var _startGreenOffset    :Number;
		private var _startBlueOffset     :Number;
		private var _startAlphaOffset    :Number;
		private var _startRedMultiplier  :Number;
		private var _startGreenMultiplier:Number;
		private var _startBlueMultiplier :Number;
		private var _startAlphaMultiplier:Number;
		
		private var _deltaRedOffset      :Number;
		private var _deltaGreenOffset    :Number;
		private var _deltaBlueOffset     :Number;
		private var _deltaAlphaOffset    :Number;
		private var _deltaRedMultiplier  :Number;
		private var _deltaGreenMultiplier:Number;
		private var _deltaBlueMultiplier :Number;
		private var _deltaAlphaMultiplier:Number;
		
		private var _compRedOffset       :Number;
		private var _compGreenOffset     :Number;
		private var _compBlueOffset      :Number;
		private var _compAlphaOffset     :Number;
		private var _compRedMultiplier   :Number;
		private var _compGreenMultiplier :Number;
		private var _compBlueMultiplier  :Number;
		private var _compAlphaMultiplier :Number;
		
		public function ColorTransformUpdater() 
		{
			
		}
		
		public function setProp(redOffset:Number, greenOffset:Number, blueOffset:Number, alphaOffset:Number, redMultiplier:Number, greenMultiplier:Number, blueMultiplier:Number, alphaMultiplier:Number):void
		{
			_compRedOffset       = redOffset;
			_compGreenOffset     = greenOffset;
			_compBlueOffset      = blueOffset;
			_compAlphaOffset     = alphaOffset;
			_compRedMultiplier   = redMultiplier;
			_compGreenMultiplier = greenMultiplier;
			_compBlueMultiplier  = blueMultiplier;
			_compAlphaMultiplier = alphaMultiplier;
		}
		
		public function init(colorTransform:ColorTransform):void
		{
			_startRedOffset       = colorTransform.redOffset;
			_startGreenOffset     = colorTransform.greenOffset;
			_startBlueOffset      = colorTransform.blueOffset;
			_startAlphaOffset     = colorTransform.alphaOffset;
			_startRedMultiplier   = colorTransform.redMultiplier;
			_startGreenMultiplier = colorTransform.greenMultiplier;
			_startBlueMultiplier  = colorTransform.blueMultiplier;
			_startAlphaMultiplier = colorTransform.alphaMultiplier;
			
			if (!isNaN(_compRedOffset))       _deltaRedOffset       = _compRedOffset       - _startRedOffset;
			if (!isNaN(_compGreenOffset))     _deltaGreenOffset     = _compGreenOffset     - _startGreenOffset;
			if (!isNaN(_compBlueOffset))      _deltaBlueOffset      = _compBlueOffset      - _startBlueOffset;
			if (!isNaN(_compAlphaOffset))     _deltaAlphaOffset     = _compAlphaOffset     - _startAlphaOffset;
			if (!isNaN(_compRedMultiplier))   _deltaRedMultiplier   = _compRedMultiplier   - _startRedMultiplier;
			if (!isNaN(_compGreenMultiplier)) _deltaGreenMultiplier = _compGreenMultiplier - _startGreenMultiplier;
			if (!isNaN(_compBlueMultiplier))  _deltaBlueMultiplier  = _compBlueMultiplier  - _startBlueMultiplier;
			if (!isNaN(_compAlphaMultiplier)) _deltaAlphaMultiplier = _compAlphaMultiplier - _startAlphaMultiplier;
		}
		
		public function update(target:DisplayObject, progress:Number):void
		{
			var ct:ColorTransform = target.transform.colorTransform;
			if (!isNaN(_compRedOffset))       ct.redOffset       = _redOffset       = _startRedOffset       + _deltaRedOffset       * progress;
			if (!isNaN(_compGreenOffset))     ct.greenOffset     = _greenOffset     = _startGreenOffset     + _deltaGreenOffset     * progress;
			if (!isNaN(_compBlueOffset))      ct.blueOffset      = _blueOffset      = _startBlueOffset      + _deltaBlueOffset      * progress;
			if (!isNaN(_compAlphaOffset))     ct.alphaOffset     = _alphaOffset     = _startAlphaOffset     + _deltaAlphaOffset     * progress;
			if (!isNaN(_compRedMultiplier))   ct.redMultiplier   = _redMultiplier   = _startRedMultiplier   + _deltaRedMultiplier   * progress;
			if (!isNaN(_compGreenMultiplier)) ct.greenMultiplier = _greenMultiplier = _startGreenMultiplier + _deltaGreenMultiplier * progress;
			if (!isNaN(_compBlueMultiplier))  ct.blueMultiplier  = _blueMultiplier  = _startBlueMultiplier  + _deltaBlueMultiplier  * progress;
			if (!isNaN(_compAlphaMultiplier)) ct.alphaMultiplier = _alphaMultiplier = _startAlphaMultiplier + _deltaAlphaMultiplier * progress;
			target.transform.colorTransform = ct;
		}
		
		public function complete():void
		{
			if (!isNaN(_compRedOffset))       _redOffset       = _compRedOffset;
			if (!isNaN(_compGreenOffset))     _greenOffset     = _compGreenOffset;
			if (!isNaN(_compBlueOffset))      _blueOffset      = _compBlueOffset;
			if (!isNaN(_compAlphaOffset))     _alphaOffset     = _compAlphaOffset;
			if (!isNaN(_compRedMultiplier))   _redMultiplier   = _compRedMultiplier;
			if (!isNaN(_compGreenMultiplier)) _greenMultiplier = _compGreenMultiplier;
			if (!isNaN(_compBlueMultiplier))  _blueMultiplier  = _compBlueMultiplier;
			if (!isNaN(_compAlphaMultiplier)) _alphaMultiplier = _compAlphaMultiplier;
		}
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get redOffset():Number { return _redOffset; }
		
		public function get greenOffset():Number { return _greenOffset;}
		
		public function get blueOffset():Number { return _blueOffset;}
		
		public function get alphaOffset():Number { return _alphaOffset; }
		
		public function get redMultiplier():Number { return _redMultiplier; }
		
		public function get greenMultiplier():Number { return _greenMultiplier; }
		
		public function get blueMultiplier():Number { return _blueMultiplier; }
		
		public function get alphaMultiplier():Number { return _alphaMultiplier; }
	}
}