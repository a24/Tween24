package a24.tween.core.updaters.display
{
	import a24.tween.core.updaters.abstracts.AbstractUpdater;
	import a24.util.Align24;
	import a24.util.Util24;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2012.01.12
	 * @private
	 *
	 */
	public final class DisplayObjectUpdater extends AbstractUpdater
	{
		private var _target:Object;
		private var _targetDisplayObject:DisplayObject;
		
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		private var _alpha:Number;
		private var _width:Number;
		private var _height:Number;
		private var _scaleX:Number;
		private var _scaleY:Number;
		private var _scaleZ:Number;
		private var _rotation:Number;
		private var _rotationX:Number;
		private var _rotationY:Number;
		private var _rotationZ:Number;
		
		private var _startX:Number;
		private var _startY:Number;
		private var _startZ:Number;
		private var _startAlpha:Number;
		private var _startWidth:Number;
		private var _startHeight:Number;
		private var _startScaleX:Number;
		private var _startScaleY:Number;
		private var _startScaleZ:Number;
		private var _startRotation:Number;
		private var _startRotationX:Number;
		private var _startRotationY:Number;
		private var _startRotationZ:Number;
		
		private var _deltaX:Number;
		private var _deltaY:Number;
		private var _deltaZ:Number;
		private var _deltaAlpha:Number;
		private var _deltaWidth:Number;
		private var _deltaHeight:Number;
		private var _deltaScaleX:Number;
		private var _deltaScaleY:Number;
		private var _deltaScaleZ:Number;
		private var _deltaRotation:Number;
		private var _deltaRotationX:Number;
		private var _deltaRotationY:Number;
		private var _deltaRotationZ:Number;
		
		private var _$x:Number;
		private var _$y:Number;
		private var _$z:Number;
		private var _$alpha:Number;
		private var _$width:Number;
		private var _$height:Number;
		private var _$scaleX:Number;
		private var _$scaleY:Number;
		private var _$scaleZ:Number;
		private var _$rotation:Number;
		private var _$rotationX:Number;
		private var _$rotationY:Number;
		private var _$rotationZ:Number;
		
		private var _$$x:Number;
		private var _$$y:Number;
		private var _$$z:Number;
		private var _$$alpha:Number;
		private var _$$width:Number;
		private var _$$height:Number;
		private var _$$scaleX:Number;
		private var _$$scaleY:Number;
		private var _$$scaleZ:Number;
		private var _$$rotation:Number;
		private var _$$rotationX:Number;
		private var _$$rotationY:Number;
		private var _$$rotationZ:Number;
		
		// Global & Local　& Bezier
		private var _globalX:Number;
		private var _globalY:Number;
		private var _bezierX:Array;
		private var _bezierY:Array;
		private var _$$bezierX:Array;
		private var _$$bezierY:Array;
		private var _localX:Number;
		private var _localY:Number;
		private var _localXTarget:DisplayObject;
		private var _localYTarget:DisplayObject;
		
		// Align
		private var _align:uint;
		private var _alignX:Number;
		private var _alignY:Number;
		private var _alignScaleX:Number;
		private var _alignScaleY:Number;
		private var _alignOffsetByScaleX :Number;
		private var _alignOffsetByScaleY:Number;
		private var _startRect:Rectangle;
		private var _rotX:Number;
		private var _rotY:Number;
		
		// Flag
		private var _fadeIn:Boolean;
		private var _fadeOut:Boolean;
		private var _useLayerBlend:Boolean;
		private var _mouseEnabled:Boolean;
		private var _mouseChildren:Boolean;
		
		// BlendMode
		private var _beforeBlend:String;
		private var _blendMode:String;
		
		// Random
		private var _randomMinX:Number;
		private var _randomMaxX:Number;
		private var _randomMinY:Number;
		private var _randomMaxY:Number;
		private var _randomMinZ:Number;
		private var _randomMaxZ:Number;
		private var _randomRound:Boolean;
		
		private var _useSize:Boolean;
		private var _useScale:Boolean;
		private var _useRotation:Boolean;
		private var _useRandom:Boolean;
		private var _useGlobalLocal:Boolean;
		
		public function DisplayObjectUpdater(target:Object) 
		{
			_target = target;
			if (target is DisplayObject) _targetDisplayObject = target as DisplayObject;
		}
		
		public function bezier(x:Number, y:Number):void
		{
			_bezierX ||= [];
			_bezierY ||= [];
			_bezierX.push(x);
			_bezierY.push(y);
		}
		
		public function $$bezier(x:Number, y:Number):void
		{
			_$$bezierX ||= [];
			_$$bezierY ||= [];
			_$$bezierX.push(x);
			_$$bezierY.push(y);
		}
		
		public function set$x($x:Number):void
		{
			this.$x = $x;
			initAlign();
			init$XY(true, false);
		}
		
		public function set$y($y:Number):void
		{
			this.$y = $y;
			initAlign();
			init$XY(false, true);
		}
		
		public function update$xy():void
		{
			initAlign();
			if (!isNaN($x)) init$XY(true, false);
			if (!isNaN($y)) init$XY(false, true);
		}
		
		private function initAlign():void
		{
			if (_align && _targetDisplayObject) {
				if (_align == Align24.SELECTED) {
					var rect:Rectangle = _target.getBounds(_targetDisplayObject);
					if (!isNaN(_alignScaleX)) _alignX = (rect.left + rect.width)  * _alignScaleX;
					if (!isNaN(_alignScaleY)) _alignY = (rect.top  + rect.height) * _alignScaleY;
				}
				else {
					var a:Point = Align24.getAlignPoint(_targetDisplayObject as DisplayObject, _align);
					_alignX = a.x;
					_alignY = a.y;
				}
			}
			else {
				_alignX = _alignY = 0;
				_alignOffsetByScaleX = _alignOffsetByScaleY = 0;
			}
		}
		
		private function init$XY(setX:Boolean, setY:Boolean):void
		{
			if (_align && _targetDisplayObject) {
				var pt1:Point = _targetDisplayObject.localToGlobal(new Point(0, 0));
				var pt2:Point = _targetDisplayObject.localToGlobal(new Point(_alignX, _alignY));
				if (setX) x = _targetDisplayObject.x + $x + (pt2.x - pt1.x);
				if (setY) y = _targetDisplayObject.y + $y + (pt2.y - pt1.y);
			}
			else {
				if (setX) x = _target.x + $x;
				if (setY) y = _target.y + $y;
			}
		}
		
		
		public function setProp(x:Number, y:Number, z:Number, alpha:Number, width:Number, height:Number, scaleX:Number, scaleY:Number, scaleZ:Number, rotation:Number, rotationX:Number, rotationY:Number, rotationZ:Number):void
		{
			_x         = x;
			_y         = y;
			_z         = z;
			_alpha     = alpha;
			_width     = width;
			_height    = height;
			_scaleX    = scaleX;
			_scaleY    = scaleY;
			_scaleZ    = scaleZ;
			_rotation  = rotation;
			_rotationX = rotationX;
			_rotationY = rotationY;
			_rotationZ = rotationZ;
		}
		
		public function init():void
		{
			var i:int, l:int;
			_tweenFlag = _updateFlag | _$$updateFlag;
			
			// Random
			var rx:Number = 0, ry:Number = 0, rz:Number = 0;
			if (_useRandom) {
				if (!isNaN(_randomMinX)) {
					if (isNaN(_x)) _x = _target.x;
					rx = Util24.math.randomInRange(_randomMinX, _randomMaxX, NaN, NaN, _randomRound);
				}
				if (!isNaN(_randomMinY)) {
					if (isNaN(_y)) _y = _target.y;
					ry = Util24.math.randomInRange(_randomMinY, _randomMaxY, NaN, NaN, _randomRound);
				}
				if (!isNaN(_randomMinZ)) {
					if (isNaN(_z)) _z = _target.z;
					rz = Util24.math.randomInRange(_randomMinZ, _randomMaxZ, NaN, NaN, _randomRound);
				}
			}
			
			// Case: DisplayObject
			if (_targetDisplayObject) {
				// Align
				var pt:Point;
				if (_align) pt = _targetDisplayObject.localToGlobal(new Point(_alignX, _alignY));
				else        pt = new Point(_targetDisplayObject.x, _targetDisplayObject.y);
				
				
				if (_useGlobalLocal) {
					// Global
					if (!isNaN(_globalX)) _x = Util24.display.getLocalX(_targetDisplayObject, _globalX);
					if (!isNaN(_globalY)) _y = Util24.display.getLocalY(_targetDisplayObject, _globalY);
					
					// Local
					if (!isNaN(_localX)) {
						var tx1:Number = Util24.display.getGlobalX(_targetDisplayObject, _targetDisplayObject.x);
						var tx2:Number = Util24.display.getGlobalX(_localXTarget, _localXTarget.x + _localX);
						_x = _targetDisplayObject.x + (tx2 - tx1);
					}
					if (!isNaN(_localY)) {
						var ty1:Number = Util24.display.getGlobalY(_targetDisplayObject, _targetDisplayObject.y);
						var ty2:Number = Util24.display.getGlobalY(_localYTarget, _localYTarget.y + _localY);
						_y = _targetDisplayObject.y + (ty2 - ty1);
					}
				}
				
				if (_$$updateFlag) {
					if (_$$updateFlag & (1 <<  0)) _x         = pt.x + _$$x;
					if (_$$updateFlag & (1 <<  1)) _y         = pt.y + _$$y;
					if (_$$updateFlag & (1 <<  2)) _z         = _target.z + _$$z;
					if (_$$updateFlag & (1 <<  3)) _alpha     = _targetDisplayObject.alpha    + _$$alpha;
					if (_$$updateFlag & (1 <<  4)) _width     = _targetDisplayObject.width    + _$$width;
					if (_$$updateFlag & (1 <<  5)) _height    = _targetDisplayObject.height   + _$$height;
					if (_$$updateFlag & (1 <<  6)) _scaleX    = _targetDisplayObject.scaleX   + _$$scaleX;
					if (_$$updateFlag & (1 <<  7)) _scaleY    = _targetDisplayObject.scaleY   + _$$scaleY;
					if (_$$updateFlag & (1 <<  8)) _scaleZ    = _target.scaleZ                + _$$scaleZ;
					if (_$$updateFlag & (1 <<  9)) _rotation  = _targetDisplayObject.rotation + _$$rotation;
					if (_$$updateFlag & (1 << 10)) _rotationX = _target.rotationX             + _$$rotationX;
					if (_$$updateFlag & (1 << 11)) _rotationY = _target.rotationY             + _$$rotationY;
					if (_$$updateFlag & (1 << 12)) _rotationZ = _target.rotationZ             + _$$rotationZ;
				}
				
				if (_align) {
					initByAlign();
					if (_tweenFlag & (1 << 0)) _deltaX = _x + ((_align)? _alignOffsetByScaleX - pt.x: -_startX) + rx;
					if (_tweenFlag & (1 << 1)) _deltaY = _y + ((_align)? _alignOffsetByScaleY - pt.y: -_startY) + ry;
				}
				else {
					if (_tweenFlag & (1 <<  0)) { _startX = _targetDisplayObject.x; _deltaX = _x - _startX + rx }
					if (_tweenFlag & (1 <<  1)) { _startY = _targetDisplayObject.y; _deltaY = _y - _startY + ry }
				}
				if (_tweenFlag & (1 <<  2))     { _startZ         = _target.z;                     _deltaZ         = _z         - _startZ + rz;    }
				if (_tweenFlag & (1 <<  3))     { _startAlpha     = _targetDisplayObject.alpha;    _deltaAlpha     = _alpha     - _startAlpha;     }
				if (_useSize) {
					if (_tweenFlag & (1 <<  4)) { _startWidth     = _targetDisplayObject.width;    _deltaWidth     = _width     - _startWidth;     }
					if (_tweenFlag & (1 <<  5)) { _startHeight    = _targetDisplayObject.height;   _deltaHeight    = _height    - _startHeight;    }
				}
				if (_useScale) {
					if (_tweenFlag & (1 <<  6)) { _startScaleX    = _targetDisplayObject.scaleX;   _deltaScaleX    = _scaleX    - _startScaleX;    }
					if (_tweenFlag & (1 <<  7)) { _startScaleY    = _targetDisplayObject.scaleY;   _deltaScaleY    = _scaleY    - _startScaleY;    }
					if (_tweenFlag & (1 <<  8)) { _startScaleZ    = _target.scaleZ;                _deltaScaleZ    = _scaleZ    - _startScaleZ;    }
				}
				if (_useRotation) {
					if (_tweenFlag & (1 <<  9)) { _startRotation  = _targetDisplayObject.rotation; _deltaRotation  = _rotation  - _startRotation;  }
					if (_tweenFlag & (1 << 10)) { _startRotationX = _target.rotationX;             _deltaRotationX = _rotationX - _startRotationX; }
					if (_tweenFlag & (1 << 11)) { _startRotationY = _target.rotationY;             _deltaRotationY = _rotationY - _startRotationY; }
					if (_tweenFlag & (1 << 12)) { _startRotationZ = _target.rotationZ;             _deltaRotationZ = _rotationZ - _startRotationZ; }
				}
				
				// Bezier
				if (_$$bezierX) {
					_bezierX = [], _bezierY = [];
					l = _$$bezierX.length;
					for (i = 0; i < l; i++) {
						_bezierX[i] = pt.x + _$$bezierX[i];
						_bezierY[i] = pt.y + _$$bezierY[i];
					}
				}
				if (_bezierX || _bezierY) {
					if (isNaN(_x)) { _x = _startX = pt.x; _deltaX = 0 + rx; }
					if (isNaN(_y)) { _y = _startY = pt.y; _deltaY = 0 + ry; }
				}
			}
			// Case: Other Object
			else {
				if (_$$updateFlag) {
					if (_$$updateFlag & (1 <<  0)) _x         = _target.x         + _$$x;
					if (_$$updateFlag & (1 <<  1)) _y         = _target.y         + _$$y;
					if (_$$updateFlag & (1 <<  2)) _z         = _target.z         + _$$z;
					if (_$$updateFlag & (1 <<  3)) _alpha     = _target.alpha     + _$$alpha;
					if (_$$updateFlag & (1 <<  4)) _width     = _target.width     + _$$width;
					if (_$$updateFlag & (1 <<  5)) _height    = _target.height    + _$$height;
					if (_$$updateFlag & (1 <<  6)) _scaleX    = _target.scaleX    + _$$scaleX;
					if (_$$updateFlag & (1 <<  7)) _scaleY    = _target.scaleY    + _$$scaleY;
					if (_$$updateFlag & (1 <<  8)) _scaleZ    = _target.scaleZ    + _$$scaleZ;
					if (_$$updateFlag & (1 <<  9)) _rotation  = _target.rotation  + _$$rotation;
					if (_$$updateFlag & (1 << 10)) _rotationX = _target.rotationX + _$$rotationX;
					if (_$$updateFlag & (1 << 11)) _rotationY = _target.rotationY + _$$rotationY;
					if (_$$updateFlag & (1 << 12)) _rotationZ = _target.rotationZ + _$$rotationZ;
				}
				
				if (_tweenFlag & (1 <<  0)) { _startX         = _target.x;         _deltaX         = _x         - _startX + rx;    }
				if (_tweenFlag & (1 <<  1)) { _startY         = _target.y;         _deltaY         = _y         - _startY + ry;    }
				if (_tweenFlag & (1 <<  2)) { _startZ         = _target.z;         _deltaZ         = _z         - _startZ + rz;    }
				if (_tweenFlag & (1 <<  3)) { _startAlpha     = _target.alpha;     _deltaAlpha     = _alpha     - _startAlpha;     }
				if (_useSize) {
					if (_tweenFlag & (1 <<  4)) { _startWidth     = _target.width;     _deltaWidth     = _width     - _startWidth;     }
					if (_tweenFlag & (1 <<  5)) { _startHeight    = _target.height;    _deltaHeight    = _height    - _startHeight;    }
				}
				if (_useScale) {
					if (_tweenFlag & (1 <<  6)) { _startScaleX    = _target.scaleX;    _deltaScaleX    = _scaleX    - _startScaleX;    }
					if (_tweenFlag & (1 <<  7)) { _startScaleY    = _target.scaleY;    _deltaScaleY    = _scaleY    - _startScaleY;    }
					if (_tweenFlag & (1 <<  8)) { _startScaleZ    = _target.scaleZ;    _deltaScaleZ    = _scaleZ    - _startScaleZ;    }
				}
				if (_useRotation) {
					if (_tweenFlag & (1 <<  9)) { _startRotation  = _target.rotation;  _deltaRotation  = _rotation  - _startRotation;  }
					if (_tweenFlag & (1 << 10)) { _startRotationX = _target.rotationX; _deltaRotationX = _rotationX - _startRotationX; }
					if (_tweenFlag & (1 << 11)) { _startRotationY = _target.rotationY; _deltaRotationY = _rotationY - _startRotationY; }
					if (_tweenFlag & (1 << 12)) { _startRotationZ = _target.rotationZ; _deltaRotationZ = _rotationZ - _startRotationZ; }
				}
				
				// Bezier
				if (_$$bezierX) {
					_bezierX = [], _bezierY = [];
					l = _$$bezierX.length;
					for (i = 0; i < l; i++) {
						_bezierX[i] = _target.x + _$$bezierX[i];
						_bezierY[i] = _target.y + _$$bezierY[i];
					}
				}
				if (_bezierX || _bezierY) {
					if (isNaN(_x)) { _x = _startX = _target.x; _deltaX = 0 + rx; }
					if (isNaN(_y)) { _y = _startY = _target.y; _deltaY = 0 + ry; }
				}
			}
			
			// Visible
			if (_tweenFlag & (1 << 13) && _fadeIn) _target.visible = true;
			
			// Blend mode
			if (_blendMode) _target.blendMode = _blendMode;
			if (_useLayerBlend) {
				_beforeBlend = _target.blendMode;
				_target.blendMode = "layer";
			}
			
			// MouseEnabled, Children
			if (_tweenFlag & (1 << 14) && !_mouseEnabled ) _target.mouseEnabled  = _mouseEnabled;
			if (_tweenFlag & (1 << 15) && !_mouseChildren) _target.mouseChildren = _mouseChildren;
		}
		
		public function initByAlign():void
		{
			initAlign(); // Kari
			
			// Point
			_startX = _targetDisplayObject.x;
			_startY = _targetDisplayObject.y;
			_deltaX = 0;
			_deltaY = 0;
			
			// Size
			if (_tweenFlag & (1 << 4) || _tweenFlag & (1 << 5)) {
				_scaleX = _scaleY = 1;
				var rect:Rectangle  = _targetDisplayObject.getRect(_targetDisplayObject);
				if (_tweenFlag & (1 << 4)) _scaleX = _width  / rect.width;
				if (_tweenFlag & (1 << 5)) _scaleY = _height / rect.height;
			}
			
			// Scale
			if (_tweenFlag & (1 << 6) || _tweenFlag & (1 << 7) || _tweenFlag & (1 << 4) || _tweenFlag & (1 << 5)) {
				_startScaleX = _targetDisplayObject.scaleX;
				_startScaleY = _targetDisplayObject.scaleY;
				_deltaScaleX = _deltaScaleY = 0;
				
				// Murasaki imo
				var rad:Number  = _targetDisplayObject.rotation * Math.PI / 180;
				var difx:Number = _alignX * (_startScaleX - _scaleX);
				var dify:Number = _alignY * (_startScaleY - _scaleY);
				var sin:Number  = Math.sin(rad);
				var cos:Number  = Math.cos(rad);
				_alignOffsetByScaleX = difx * cos - dify * sin;
				_alignOffsetByScaleY = difx * sin + dify * cos;
			}
		}
		
		
		/*
		 * ===============================================================================================
		 * 
		 * UPDATE
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		override public function update(progress:Number):AbstractUpdater
		{
			if (_targetDisplayObject) {
				var offsetX:Number = 0, offsetY:Number = 0;
				
				// Align
				if (_align != 0) {
					// if Scale
					if (_tweenFlag & (1 << 6) || _tweenFlag & (1 << 7) || _tweenFlag & (1 << 4) || _tweenFlag & (1 << 5)) {
						if (!(_tweenFlag & (1 << 0))) offsetX += _alignOffsetByScaleX * progress;
						if (!(_tweenFlag & (1 << 1))) offsetY += _alignOffsetByScaleY * progress;
					}
					
					// if rotation
					if (_tweenFlag & (1 << 9)) {
						var algX:Number = _alignX * _targetDisplayObject.scaleX;
						var algY:Number = _alignY * _targetDisplayObject.scaleY;
						var rad1:Number = (_startRotation / 180) * Math.PI;
						var rad2:Number = ((_startRotation + _deltaRotation * progress) / 180) * Math.PI;
						var x1:Number   = algX * Math.cos(rad1) - algY * Math.sin(rad1);
						var y1:Number   = algX * Math.sin(rad1) + algY * Math.cos(rad1);
						var x2:Number   = algX * Math.cos(rad2) - algY * Math.sin(rad2);
						var y2:Number   = algX * Math.sin(rad2) + algY * Math.cos(rad2);
						
						offsetX += (x1 - x2);
						offsetY += (y1 - y2);
					}
				}
				
				// Bezier
				if (_bezierX != null) {
					_targetDisplayObject.x = Util24.display.getBezier(_startX, _startX + _deltaX, progress, _bezierX) + offsetX;
					_targetDisplayObject.y = Util24.display.getBezier(_startY, _startY + _deltaY, progress, _bezierY) + offsetY;
				}
				// Normal
				else {
					if (_tweenFlag & (1 <<  0) || _align) _targetDisplayObject.x = _startX + _deltaX * progress + offsetX;
					if (_tweenFlag & (1 <<  1) || _align) _targetDisplayObject.y = _startY + _deltaY * progress + offsetY;
				}
				if (_tweenFlag & (1 <<  2)) _target.z                      = _startZ         + _deltaZ         * progress;
				if (_tweenFlag & (1 <<  3)) _targetDisplayObject.alpha     = _startAlpha     + _deltaAlpha     * progress;
				if (_useSize) {
					if (_tweenFlag & (1 <<  4)) _targetDisplayObject.width     = _startWidth     + _deltaWidth     * progress;
					if (_tweenFlag & (1 <<  5)) _targetDisplayObject.height    = _startHeight    + _deltaHeight    * progress;
				}
				if (_useScale) {
					if (_tweenFlag & (1 <<  6)) _targetDisplayObject.scaleX    = _startScaleX    + _deltaScaleX    * progress;
					if (_tweenFlag & (1 <<  7)) _targetDisplayObject.scaleY    = _startScaleY    + _deltaScaleY    * progress;
					if (_tweenFlag & (1 <<  8)) _target.scaleZ                 = _startScaleZ    + _deltaScaleZ    * progress;
				}
				if (_useRotation) {
					if (_tweenFlag & (1 <<  9)) _targetDisplayObject.rotation  = _startRotation  + _deltaRotation  * progress;
					if (_tweenFlag & (1 << 10)) _target.rotationX              = _startRotationX + _deltaRotationX * progress;
					if (_tweenFlag & (1 << 11)) _target.rotationY              = _startRotationY + _deltaRotationY * progress;
					if (_tweenFlag & (1 << 12)) _target.rotationZ              = _startRotationZ + _deltaRotationZ * progress;
				}
			}
			else {
				// Bezier
				if (_bezierX) {
					_target.x = Util24.display.getBezier(_startX, _startX + _deltaX, progress, _bezierX);
					_target.y = Util24.display.getBezier(_startY, _startY + _deltaY, progress, _bezierY);
				}
				else {
					if (_tweenFlag & (1 <<  0)) _target.x = _startX + _deltaX * progress;
					if (_tweenFlag & (1 <<  1)) _target.y = _startY + _deltaY * progress;
				}
				if (_tweenFlag & (1 <<  2)) _target.z         = _startZ         + _deltaZ         * progress;
				if (_tweenFlag & (1 <<  3)) _target.alpha     = _startAlpha     + _deltaAlpha     * progress;
				if (_useSize) {
					if (_tweenFlag & (1 <<  4)) _target.width     = _startWidth     + _deltaWidth     * progress;
					if (_tweenFlag & (1 <<  5)) _target.height    = _startHeight    + _deltaHeight    * progress;
				}
				if (_useScale) {
					if (_tweenFlag & (1 <<  6)) _target.scaleX    = _startScaleX    + _deltaScaleX    * progress;
					if (_tweenFlag & (1 <<  7)) _target.scaleY    = _startScaleY    + _deltaScaleY    * progress;
					if (_tweenFlag & (1 <<  8)) _target.scaleZ    = _startScaleZ    + _deltaScaleZ    * progress;
				}
				if (_useRotation) {
					if (_tweenFlag & (1 <<  9)) _target.rotation  = _startRotation  + _deltaRotation  * progress;
					if (_tweenFlag & (1 << 10)) _target.rotationX = _startRotationX + _deltaRotationX * progress;
					if (_tweenFlag & (1 << 11)) _target.rotationY = _startRotationY + _deltaRotationY * progress;
					if (_tweenFlag & (1 << 12)) _target.rotationZ = _startRotationZ + _deltaRotationZ * progress;
				}
			}
			return this;
		}
		
		override public function complete():void 
		{
			super.complete();
			
			// Visible
			if (_tweenFlag & (1 << 13) && _fadeOut) _target.visible = false;
			
			// Blend mode
			if (_useLayerBlend) _target.blendMode = _beforeBlend;
			
			// MouseEnabled, Children
			if (_tweenFlag & (1 << 14) && _mouseEnabled ) _target.mouseEnabled  = _mouseEnabled;
			if (_tweenFlag & (1 << 15) && _mouseChildren) _target.mouseChildren = _mouseChildren;
		}
		
		public function clone():DisplayObjectUpdater
		{
			var updater:DisplayObjectUpdater = new DisplayObjectUpdater(_target);
			updater.setProp(_x, _y, z, _alpha, _width, _height, _scaleX, _scaleY, _scaleZ, _rotation, _rotationX, _rotationY, _rotationZ);
			
			updater._$x         = _$x;
			updater._$y         = _$y;
			updater._$z         = _$z;
			updater._$alpha     = _$alpha;
			updater._$width     = _$width;
			updater._$height    = _$height;
			updater._$scaleX    = _$scaleX;
			updater._$scaleY    = _$scaleY;
			updater._$scaleZ    = _$scaleZ;
			updater._$rotation  = _$rotation;
			updater._$rotationX = _$rotationX;
			updater._$rotationY = _$rotationY;
			updater._$rotationZ = _$rotationZ;
			
			updater._$$x         = _$$x;
			updater._$$y         = _$$y;
			updater._$$z         = _$$z;
			updater._$$alpha     = _$$alpha;
			updater._$$width     = _$$width;
			updater._$$height    = _$$height;
			updater._$$scaleX    = _$$scaleX;
			updater._$$scaleY    = _$$scaleY;
			updater._$$scaleZ    = _$$scaleZ;
			updater._$$rotation  = _$$rotation;
			updater._$$rotationX = _$$rotationX;
			updater._$$rotationY = _$$rotationY;
			updater._$$rotationZ = _$$rotationZ;
			
			updater._updateFlag    = _updateFlag;
			updater._$updateFlag   = _$updateFlag;
			updater._$$updateFlag  = _$$updateFlag;
			updater._globalX       = _globalX;
			updater._globalY       = _globalY;
			updater._bezierX       = _bezierX;
			updater._bezierY       = _bezierY;
			updater._$$bezierX     = _$$bezierX;
			updater._$$bezierY     = _$$bezierY;
			updater._fadeIn        = _fadeIn;
			updater._fadeOut       = _fadeOut;
			updater._useLayerBlend = _useLayerBlend;
			
			updater._useGlobalLocal = _useGlobalLocal;
			updater._useLayerBlend  = _useLayerBlend;
			updater._useRandom      = _useRandom;
			updater._useRotation    = _useRotation;
			updater._useScale       = _useScale;
			updater._useSize        = _useSize;
			return updater;
		}
		
		override public function toString():String
		{
			var str:String = "";
			var flag:uint = _updateFlag | _$$updateFlag;
			if (flag & (1 <<  0)) str = 'x:'         + _x         + ', ';
			if (flag & (1 <<  1)) str = 'y:'         + _y         + ', ';
			if (flag & (1 <<  2)) str = 'z:'         + _z         + ', ';
			if (flag & (1 <<  3)) str = 'alpha:'     + _alpha     + ', ';
			if (flag & (1 <<  4)) str = 'width:'     + _width     + ', ';
			if (flag & (1 <<  5)) str = 'height:'    + _height    + ', ';
			if (flag & (1 <<  6)) str = 'scaleX:'    + _scaleX    + ', ';
			if (flag & (1 <<  7)) str = 'scaleY:'    + _scaleY    + ', ';
			if (flag & (1 <<  8)) str = 'scaleZ:'    + _scaleZ    + ', ';
			if (flag & (1 <<  9)) str = 'rotation:'  + _rotation  + ', ';
			if (flag & (1 << 10)) str = 'rotationX:' + _rotationX + ', ';
			if (flag & (1 << 11)) str = 'rotationY:' + _rotationY + ', ';
			if (flag & (1 << 12)) str = 'rotationZ:' + _rotationZ + ', ';
			if (flag & (1 << 14)) str = 'mouseEnabled:'  + _mouseEnabled  + ', ';
			if (flag & (1 << 15)) str = 'mouseChildren:' + _mouseChildren + ', ';
			return str.slice(0, -2);
		}
		
		public function getDistance():Number
		{
			var dx:Number = isNaN(_deltaX)? 0: _deltaX;
			var dy:Number = isNaN(_deltaY)? 0: _deltaY;
			var dz:Number = isNaN(_deltaZ)? 0: _deltaZ;
			return Math.sqrt(dx * dx + dy * dy + dz * dz);
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get target():Object { return _target; }
		public function set target(value:Object):void { _target = value; }
		
		public function get align():uint { return _align; }
		public function set align(value:uint):void { _align = value; }
		
		public function get alignX():Number { return _alignX; }
		public function set alignX(value:Number):void { _alignX = value; _align = Align24.SELECTED; }
		
		public function get alignY():Number { return _alignY; }
		public function set alignY(value:Number):void { _alignY = value; _align = Align24.SELECTED; }
		
		public function get alignScaleX():Number { return _alignScaleX; }
		public function set alignScaleX(value:Number):void { _alignScaleX = value; _align = Align24.SELECTED; }
		
		public function get alignScaleY():Number { return _alignScaleY; }
		public function set alignScaleY(value:Number):void { _alignScaleY = value; _align = Align24.SELECTED; }
		
		public function get useLayerBlend():Boolean { return _useLayerBlend; }
		public function set useLayerBlend(value:Boolean):void { _useLayerBlend = value; }
		
		public function get blendMode():String { return _blendMode; }
		public function set blendMode(value:String):void { _blendMode = value; }
		
		
		
		public function get globalX():Number { return _globalX; }
		public function set globalX(value:Number):void { _globalX = value; _updateFlag |= 1 << 0; _useGlobalLocal = true; }
		
		public function get globalY():Number { return _globalY; }
		public function set globalY(value:Number):void { _globalY = value; _updateFlag |= 1 << 1; _useGlobalLocal = true; }
		
		public function get localX():Number { return _localX; }
		public function set localX(value:Number):void { _localX = value; _updateFlag |= 1 << 0; _useGlobalLocal = true; }
		
		public function get localY():Number { return _localY; }
		public function set localY(value:Number):void { _localY = value; _updateFlag |= 1 << 1; _useGlobalLocal = true; }
		
		public function get localXTarget():DisplayObject { return _localXTarget; }
		public function set localXTarget(value:DisplayObject):void { _localXTarget = value; }
		
		public function get localYTarget():DisplayObject { return _localYTarget; }
		public function set localYTarget(value:DisplayObject):void { _localYTarget = value; }
		
		public function get randomMinX():Number { return _randomMinX; }
		public function set randomMinX(value:Number):void { _randomMinX = value; _updateFlag |= 1 << 0; _useRandom = true; }
		
		public function get randomMaxX():Number { return _randomMaxX; }
		public function set randomMaxX(value:Number):void { _randomMaxX = value; _useRandom = true; }
		
		public function get randomMinY():Number { return _randomMinY; }
		public function set randomMinY(value:Number):void { _randomMinY = value; _updateFlag |= 1 << 1; _useRandom = true; }
		
		public function get randomMaxY():Number { return _randomMaxY; }
		public function set randomMaxY(value:Number):void { _randomMaxY = value; _useRandom = true; }
		
		public function get randomMinZ():Number { return _randomMinZ; }
		public function set randomMinZ(value:Number):void { _randomMinZ = value; _updateFlag |= 1 << 2; _useRandom = true; }
		
		public function get randomMaxZ():Number { return _randomMaxZ; }
		public function set randomMaxZ(value:Number):void { _randomMaxZ = value;  _useRandom = true;}
		
		public function get randomRound():Boolean { return _randomRound; }
		public function set randomRound(value:Boolean):void { _randomRound = value; _useRandom = true; }
		
		
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void { _x = value; _updateFlag |= 1 << 0; }
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void { _y = value; _updateFlag |= 1 << 1; }
		
		public function get z():Number { return _z; }
		public function set z(value:Number):void { _z = value; _updateFlag |= 1 << 2; }
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void { _alpha = value; _updateFlag |= 1 << 3; }
		
		public function get width():Number { return _width; }
		public function set width(value:Number):void { _width = value; _updateFlag |= 1 << 4; _useSize = true; }
		
		public function get height():Number { return _height; }
		public function set height(value:Number):void { _height = value; _updateFlag |= 1 << 5; _useSize = true; }
		
		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void { _scaleX = value; _updateFlag |= 1 << 6; _useScale = true; }
		
		public function get scaleY():Number { return _scaleY; }
		public function set scaleY(value:Number):void { _scaleY = value; _updateFlag |= 1 << 7; _useScale = true; }
		
		public function get scaleZ():Number { return _scaleZ; }
		public function set scaleZ(value:Number):void { _scaleZ = value; _updateFlag |= 1 << 8; _useScale = true; }
		
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void { _rotation = value; _updateFlag |= 1 << 9; _useRotation = true; }
		
		public function get rotationX():Number { return _rotationX; }
		public function set rotationX(value:Number):void { _rotationX = value; _updateFlag |= 1 << 10; _useRotation = true; }
		
		public function get rotationY():Number { return _rotationY; }
		public function set rotationY(value:Number):void { _rotationY = value; _updateFlag |= 1 << 11; _useRotation = true; }
		
		public function get rotationZ():Number { return _rotationZ; }
		public function set rotationZ(value:Number):void { _rotationZ = value; _updateFlag |= 1 << 12; _useRotation = true; }
		
		public function get fadeIn():Boolean { return _fadeIn; }
		public function set fadeIn(value:Boolean):void { _fadeIn = value; _updateFlag |= 1 << 13; }
		
		public function get fadeOut():Boolean { return _fadeOut; }
		public function set fadeOut(value:Boolean):void { _fadeOut = value; _updateFlag |= 1 << 13; }
		
		public function get mouseEnabled():Boolean { return _mouseEnabled; }
		public function set mouseEnabled(value:Boolean):void { _mouseEnabled = value; _updateFlag |= 1 << 14; }
		
		public function get mouseChildren():Boolean { return _mouseChildren; }
		public function set mouseChildren(value:Boolean):void { _mouseChildren = value; _updateFlag |= 1 << 15; }
		
		
		
		public function get $x():Number { return _$x; }
		public function set $x(value:Number):void { _$x = value; _$updateFlag |= 1 << 0; }
		
		public function get $y():Number { return _$y; }
		public function set $y(value:Number):void { _$y = value; _$updateFlag |= 1 << 1; }
		
		public function get $z():Number { return _$z; }
		public function set $z(value:Number):void { _$z = value; _$updateFlag |= 1 << 2; }
		
		public function get $alpha():Number { return _$alpha; }
		public function set $alpha(value:Number):void { _$alpha = value; _$updateFlag |= 1 << 3; }
		
		public function get $width():Number { return _$width; }
		public function set $width(value:Number):void { _$width = value; _$updateFlag |= 1 << 4; _useSize = true; }
		
		public function get $height():Number { return _$height; }
		public function set $height(value:Number):void { _$height = value; _$updateFlag |= 1 << 5; _useSize = true; }
		
		public function get $scaleX():Number { return _$scaleX; }
		public function set $scaleX(value:Number):void { _$scaleX = value; _$updateFlag |= 1 << 6; _useScale = true; }
		
		public function get $scaleY():Number { return _$scaleY; }
		public function set $scaleY(value:Number):void { _$scaleY = value; _$updateFlag |= 1 << 7; _useScale = true; }
		
		public function get $scaleZ():Number { return _$scaleZ; }
		public function set $scaleZ(value:Number):void { _$scaleZ = value; _$updateFlag |= 1 << 8; _useScale = true; }
		
		public function get $rotation():Number { return _$rotation; }
		public function set $rotation(value:Number):void { _$rotation = value; _$updateFlag |= 1 << 9; _useRotation = true; }
		
		public function get $rotationX():Number { return _$rotationX; }
		public function set $rotationX(value:Number):void { _$rotationX = value; _$updateFlag |= 1 << 10; _useRotation = true; }
		
		public function get $rotationY():Number { return _$rotationY; }
		public function set $rotationY(value:Number):void { _$rotationY = value; _$updateFlag |= 1 << 11; _useRotation = true; }
		
		public function get $rotationZ():Number { return _$rotationZ; }
		public function set $rotationZ(value:Number):void { _$rotationZ = value; _$updateFlag |= 1 << 12; _useRotation = true; }
		
		
		
		public function get $$x():Number { return _$$x; }
		public function set $$x(value:Number):void { _$$x = value; _$$updateFlag |= 1 << 0; }
		
		public function get $$y():Number { return _$$y; }
		public function set $$y(value:Number):void { _$$y = value; _$$updateFlag |= 1 << 1; }
		
		public function get $$z():Number { return _$$z; }
		public function set $$z(value:Number):void { _$$z = value; _$$updateFlag |= 1 << 2; }
		
		public function get $$alpha():Number { return _$$alpha; }
		public function set $$alpha(value:Number):void { _$$alpha = value; _$$updateFlag |= 1 << 3; }
		
		public function get $$width():Number { return _$$width; }
		public function set $$width(value:Number):void { _$$width = value; _$$updateFlag |= 1 << 4; _useSize = true; }
		
		public function get $$height():Number { return _$$height; }
		public function set $$height(value:Number):void { _$$height = value; _$$updateFlag |= 1 << 5; _useSize = true; }
		
		public function get $$scaleX():Number { return _$$scaleX; }
		public function set $$scaleX(value:Number):void { _$$scaleX = value; _$$updateFlag |= 1 << 6; _useScale = true; }
		
		public function get $$scaleY():Number { return _$$scaleY; }
		public function set $$scaleY(value:Number):void { _$$scaleY = value; _$$updateFlag |= 1 << 7; _useScale = true; }
		
		public function get $$scaleZ():Number { return _$$scaleZ; }
		public function set $$scaleZ(value:Number):void { _$$scaleZ = value; _$$updateFlag |= 1 << 8; _useScale = true; }
		
		public function get $$rotation():Number { return _$$rotation; }
		public function set $$rotation(value:Number):void { _$$rotation = value; _$$updateFlag |= 1 << 9; _useRotation = true; }
		
		public function get $$rotationX():Number { return _$$rotationX; }
		public function set $$rotationX(value:Number):void { _$$rotationX = value; _$$updateFlag |= 1 << 10; _useRotation = true; }
		
		public function get $$rotationY():Number { return _$$rotationY; }
		public function set $$rotationY(value:Number):void { _$$rotationY = value; _$$updateFlag |= 1 << 11; _useRotation = true; }
		
		public function get $$rotationZ():Number { return _$$rotationZ; }
		public function set $$rotationZ(value:Number):void { _$$rotationZ = value; _$$updateFlag |= 1 << 12; _useRotation = true; }
	}
}