package a24.tween 
{
	import flash.geom.Point;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2010.10.31
	 *
	 */
	public class Ease24
	{
		/**
		 * Linear easing.
		 */
		static public const _Linear      :Function = linear;
		
		
		
		/**
		 * Sine easing-in.
		 */
		static public const _1_SineIn    :Function = sineIn;
		
		/**
		 * Sine easing-out.
		 */
		static public const _1_SineOut   :Function = sineOut;
		
		/**
		 * Sine easing-in-out.
		 */
		static public const _1_SineInOut :Function = sineInOut;
		
		/**
		 * Sine easing-out-in.
		 */
		static public const _1_SineOutIn :Function = sineOutIn;
		
		
		
		/**
		 * Quadratic easing-in.
		 */
		static public const _2_QuadIn    :Function = quadIn;
		
		/**
		 * Quadratic easing-out.
		 */
		static public const _2_QuadOut   :Function = quadOut;
		
		/**
		 * Quadratic easing-in-out.
		 */
		static public const _2_QuadInOut :Function = quadInOut;
		
		/**
		 * Quadratic easing-out-in.
		 */
		static public const _2_QuadOutIn :Function = quadOutIn;
		
		
		
		/**
		 * Cubic easing-in.
		 */
		static public const _3_CubicIn   :Function = cubicIn;
		
		/**
		 * Cubic easing-out.
		 */
		static public const _3_CubicOut  :Function = cubicOut;
		
		/**
		 * Cubic easing-in-out.
		 */
		static public const _3_CubicInOut:Function = cubicInOut;
		
		/**
		 * Cubic easing-out-in.
		 */
		static public const _3_CubicOutIn:Function = cubicOutIn;
		
		
		
		/**
		 * Quartic easing-in.
		 */
		static public const _4_QuartIn   :Function = quartIn;
		
		/**
		 * Quartic easing-out.
		 */
		static public const _4_QuartOut  :Function = quartOut;
		
		/**
		 * Quartic easing-in-out.
		 */
		static public const _4_QuartInOut:Function = quartInOut;
		
		/**
		 * Quartic easing-out-in.
		 */
		static public const _4_QuartOutIn:Function = quartOutIn;
		
		
		
		/**
		 * Quintic easing-in.
		 */
		static public const _5_QuintIn   :Function = quintIn;
		
		/**
		 * Quintic easing-out.
		 */
		static public const _5_QuintOut  :Function = quintOut;
		
		/**
		 * Quintic easing-in-out.
		 */
		static public const _5_QuintInOut:Function = quintInOut;
		
		/**
		 * Quintic easing-out-in.
		 */
		static public const _5_QuintOutIn:Function = quintOutIn;
		
		
		
		/**
		 * Exponential easing-in.
		 */
		static public const _6_ExpoIn    :Function = expoIn;
		
		/**
		 * Exponential easing-out.
		 */
		static public const _6_ExpoOut   :Function = expoOut;
		
		/**
		 * Exponential easing-in-out.
		 */
		static public const _6_ExpoInOut :Function = expoInOut;
		
		/**
		 * Exponential easing-out-in.
		 */
		static public const _6_ExpoOutIn :Function = expoOutIn;
		
		
		
		/**
		 * Circular easing-in.
		 */
		static public const _7_CircIn    :Function = circIn;
		
		/**
		 * Circular easing-out.
		 */
		static public const _7_CircOut   :Function = circOut;
		
		/**
		 * Circular easing-in-out.
		 */
		static public const _7_CircInOut :Function = circInOut;
		
		/**
		 * Circular easing-out-in.
		 */
		static public const _7_CircOutIn :Function = circOutIn;
		
		
		
		/**
		 * Back easing-in.
		 */
		static public const _BackIn      :Function = _BackInWith();
		
		/**
		 * Back easing-out.
		 */
		static public const _BackOut     :Function = _BackOutWith();
		
		/**
		 * Back easing-in-out.
		 */
		static public const _BackInOut   :Function = _BackInOutWith();
		
		/**
		 * Back easing-out-in.
		 */
		static public const _BackOutIn   :Function = _BackOutInWith();
		
		
		
		/**
		 * Bounce easing-in.
		 */
		static public const _BounceIn    :Function = bounceIn;
		
		/**
		 * Bounce easing-out.
		 */
		static public const _BounceOut   :Function = bounceOut;
		
		/**
		 * Bounce easing-in-out.
		 */
		static public const _BounceInOut :Function = bounceInOut;
		
		/**
		 * Bounce easing-out-in.
		 */
		static public const _BounceOutIn :Function = bounceOutIn;
		
		
		
		/**
		 * Elastic easing-in.
		 */
		static public const _ElasticIn   :Function = _ElasticInWith();
		
		/**
		 * Elastic easing-out.
		 */
		static public const _ElasticOut  :Function = _ElasticOutWith();
		
		/**
		 * Elastic easing-in-out.
		 */
		static public const _ElasticInOut:Function = _ElasticInOutWith();
		
		/**
		 * Elastic easing-out-in.
		 */
		static public const _ElasticOutIn:Function = _ElasticOutInWith();
		
		
		
		
		
		
		/**
		 * Linear easing.
		 */
		public function get Linear()      :Function { return linear;    }
		
		/**
		 * Sine easing-in.
		 */
		public function get SineIn()      :Function { return sineIn;    }
		
		/**
		 * Sine easing-out.
		 */
		public function get SineOut()     :Function { return sineOut;   }
		
		/**
		 * Sine easing-in-out.
		 */
		public function get SineInOut()   :Function { return sineInOut; }
		
		/**
		 * Sine easing-out-in.
		 */
		public function get SineOutIn()   :Function { return sineOutIn; }
		
		
		
		/**
		 * Quadratic easing-in.
		 */
		public function get QuadIn()      :Function { return quadIn;    }
		
		/**
		 * Quadratic easing-out.
		 */
		public function get QuadOut()     :Function { return quadOut;   }
		
		/**
		 * Quadratic easing-in-out.
		 */
		public function get QuadInOut()   :Function { return quadInOut; }
		
		/**
		 * Quadratic easing-out-in.
		 */
		public function get QuadOutIn()   :Function { return quadOutIn; }
		
		
		
		/**
		 * Cubic easing-in.
		 */
		public function get CubicIn()     :Function { return cubicIn;    }
		
		/**
		 * Cubic easing-out.
		 */
		public function get CubicOut()    :Function { return cubicOut;   }
		
		/**
		 * Cubic easing-in-out.
		 */
		public function get CubicInOut()  :Function { return cubicInOut; }
		
		/**
		 * Cubic easing-out-in.
		 */
		public function get CubicOutIn()  :Function { return cubicOutIn; }
		
		
		
		/**
		 * Quintic easing-in.
		 */
		public function get QuintIn()     :Function { return quintIn;    }
		
		/**
		 * Quintic easing-out.
		 */
		public function get QuintOut()    :Function { return quintOut;   }
		
		/**
		 * Quintic easing-in-out.
		 */
		public function get QuintInOut()  :Function { return quintInOut; }
		
		/**
		 * Quintic easing-out-in.
		 */
		public function get QuintOutIn()  :Function { return quintOutIn; }
		
		
		
		/**
		 * Quartic easing-in.
		 */
		public function get QuartIn()     :Function { return quartIn;    }
		
		/**
		 * Quartic easing-out.
		 */
		public function get QuartOut()    :Function { return quartOut;   }
		
		/**
		 * Quartic easing-in-out.
		 */
		public function get QuartInOut()  :Function { return quartInOut; }
		
		/**
		 * Quartic easing-out-in.
		 */
		public function get QuartOutIn()  :Function { return quartOutIn; }
		
		
		
		/**
		 * Exponential easing-in.
		 */
		public function get ExpoIn()      :Function { return expoIn;    }
		
		/**
		 * Exponential easing-out.
		 */
		public function get ExpoOut()     :Function { return expoOut;   }
		
		/**
		 * Exponential easing-in-out.
		 */
		public function get ExpoInOut()   :Function { return expoInOut; }
		
		/**
		 * Exponential easing-out-in.
		 */
		public function get ExpoOutIn()   :Function { return expoOutIn; }
		
		
		
		/**
		 * Circular easing-in.
		 */
		public function get CircIn()      :Function { return circIn;    }
		
		/**
		 * Circular easing-out.
		 */
		public function get CircOut()     :Function { return circOut;   }
		
		/**
		 * Circular easing-in-out.
		 */
		public function get CircInOut()   :Function { return circInOut; }
		
		/**
		 * Circular easing-out-in.
		 */
		public function get CircOutIn()   :Function { return circOutIn; }
		
		
		
		/**
		 * Back easing-in.
		 */
		public function get BackIn()      :Function { return _BackInWith();    }
		
		/**
		 * Back easing-out.
		 */
		public function get BackOut()     :Function { return _BackOutWith();   }
		
		/**
		 * Back easing-in-out.
		 */
		public function get BackInOut()   :Function { return _BackInOutWith(); }
		
		/**
		 * Back easing-out-in.
		 */
		public function get BackOutIn()   :Function { return _BackOutInWith(); }
		
		
		
		/**
		 * Bounce easing-in.
		 */
		public function get BounceIn()    :Function { return bounceIn;    }
		
		/**
		 * Bounce easing-out.
		 */
		public function get BounceOut()   :Function { return bounceOut;   }
		
		/**
		 * Bounce easing-in-out.
		 */
		public function get BounceInOut() :Function { return bounceInOut; }
		
		/**
		 * Bounce easing-out-in.
		 */
		public function get BounceOutIn() :Function { return bounceOutIn; }
		
		
		
		/**
		 * Elastic easing-in.
		 */
		public function get ElasticIn()   :Function { return _ElasticInWith();    }
		
		/**
		 * Elastic easing-out.
		 */
		public function get ElasticOut()  :Function { return _ElasticOutWith();   }
		
		/**
		 * Elastic easing-in-out.
		 */
		public function get ElasticInOut():Function { return _ElasticInOutWith(); }
		
		/**
		 * Elastic easing-out-in.
		 */
		public function get ElasticOutIn():Function { return _ElasticOutInWith(); }
		
		
		
		/**
		 * Back easing-in with parameter.
		 */
		public function BackInWith   (overshoot:Number = 1.70158):Function { return _BackInWith   (overshoot); }
		
		/**
		 * Back easing-out with parameter.
		 */
		public function BackOutWith  (overshoot:Number = 1.70158):Function { return _BackOutWith  (overshoot); }
		
		/**
		 * Back easing-in-out with parameter.
		 */
		public function BackInOutWith(overshoot:Number = 1.70158):Function { return _BackInOutWith(overshoot); }
		
		/**
		 * Back easing-out-in with parameter.
		 */
		public function BackOutInWith(overshoot:Number = 1.70158):Function { return _BackOutInWith(overshoot); }
		
		
		
		/**
		 * Elastic easing-in with parameter.
		 */
		public function ElasticInWith   (amplitude:Number = 0, period:Number = 0):Function { return _ElasticInWith   (amplitude, period); }
		
		/**
		 * Elastic easing-out with parameter.
		 */
		public function ElasticOutWith  (amplitude:Number = 0, period:Number = 0):Function { return _ElasticOutWith  (amplitude, period); }
		
		/**
		 * Elastic easing-in-out with parameter.
		 */
		public function ElasticInOutWith(amplitude:Number = 0, period:Number = 0):Function { return _ElasticInOutWith(amplitude, period); }
		
		/**
		 * Elastic easing-out-in with parameter.
		 */
		public function ElasticOutInWith(amplitude:Number = 0, period:Number = 0):Function { return _ElasticOutInWith(amplitude, period); }
		
		
		
		/**
		 * @private
		 */
		public function Ease24() { }
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * LINER EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		static private function linear(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * t / d + b;
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * SINE EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		static private function sineIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
		}
		
		static private function sineOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * Math.sin(t / d * (Math.PI / 2)) + b;
		}
		
		static private function sineInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
		}
		
		static private function sineOutIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < d / 2) return (c / 2) * Math.sin((t * 2) / d * (Math.PI / 2)) + b;
			return -(c / 2) * Math.cos((t * 2 - d) / d * (Math.PI / 2)) + (c / 2) + (b + c / 2);
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * QUAD EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		static private function quadIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t + b;
		}
		
		static private function quadOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * (t /= d) * (t - 2) + b;
		}
		
		static private function quadInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d / 2) < 1) return c / 2 * t * t + b;
			return -c / 2 * ((--t) * (t - 2) - 1) + b;
		}
		
		static private function quadOutIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < d / 2) return -(c / 2) * (t = (t * 2 / d)) * (t - 2) + b;
			return (c / 2) * (t = (t * 2 - d) / d) * t + (b + c / 2);
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * CUBIC EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		static private function cubicIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t * t + b;
		}
		
		static private function cubicOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * ((t = t / d - 1) * t * t + 1) + b;
		}
		
		static private function cubicInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return ((t /= d / 2) < 1) ? c / 2 * t * t * t + b: c / 2 * ((t -= 2) * t * t + 2) + b;
		}
		
		static private function cubicOutIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return (t < d / 2)? c / 2 * ((t = t * 2 / d - 1) * t * t + 1) + b: c / 2 * (t = (t * 2 - d) / d) * t * t + b + c / 2;
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * QUART EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		static private function quartIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t * t * t + b;
		}
		
		static private function quartOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * ((t = t / d - 1) * t * t * t - 1) + b;
		}
		
		static private function quartInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
			return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
		}
		
		static private function quartOutIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < d / 2) return -(c / 2) * ((t = (t * 2) / d - 1) * t * t * t - 1) + b;
			return (c / 2) * (t = (t * 2 - d) / d) * t * t * t + (b + c / 2);
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * QUINT EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		static private function quintIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t * t * t * t + b;
		}
		
		static private function quintOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
		}
		
		static private function quintInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
			return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
		}
		
		static private function quintOutIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < d / 2) return (c / 2) * ((t = (t * 2) / d - 1) * t * t * t * t + 1) + b;
			return (c / 2) * (t = (t * 2 - d) / d) * t * t * t * t + (b + c / 2);
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * EXPO EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		static private function expoIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return t == 0 ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;
		}
		
		static private function expoOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return t == d ? b + c : c * (1 - Math.pow(2, -10 * t / d)) + b;
		}
		
		static private function expoInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t == 0) return b;
			if (t == d) return b + c;
			if ((t /= d / 2.0) < 1.0) return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
			return c / 2 * (2 - Math.pow(2, -10 * --t)) + b;
		}
		
		static private function expoOutIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < d / 2.0) return t * 2.0 == d ? b + c / 2.0 : c / 2.0 * (1 - Math.pow(2, -10 * t * 2.0 / d)) + b;
			return ((t * 2.0 - d) == 0)? b + c / 2.0 : c / 2.0 * Math.pow(2, 10 * ((t * 2 - d) / d - 1)) + b + c / 2.0;
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * CIRC EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		static private function circIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
		}
		
		static private function circOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
		}
		
		static private function circInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d / 2) < 1) return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
			return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
		}
		
		static private function circOutIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < d / 2) return (c / 2) * Math.sqrt(1 - (t = (t * 2) / d - 1) * t) + b;
			return -(c / 2) * (Math.sqrt(1 - (t = (t * 2 - d) / d) * t) - 1) + (b + c / 2);
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * BACK EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * Back easing-in with parameter.
		 * @param overshoot	オーバー値
		 * @return Function
		 */
		static public function _BackInWith(overshoot:Number = 1.70158):Function
		{
			return function (t:Number, b:Number, c:Number, d:Number):Number {
				return c * (t /= d) * t * ((overshoot + 1) * t - overshoot) + b;
			}
		}
		
		/**
		 * Back easing-out with parameter.
		 * @param overshoot	オーバー値
		 * @return Function
		 */
		static public function _BackOutWith(overshoot:Number = 1.70158):Function
		{
			return function (t:Number, b:Number, c:Number, d:Number):Number {
				return c * ((t = t / d - 1) * t * ((overshoot + 1) * t + overshoot) + 1) + b;
			}
		}
		
		/**
		 * Back easing-in-out with parameter.
		 * @param overshoot	オーバー値
		 * @return Function
		 */
		static public function _BackInOutWith(overshoot:Number = 1.70158):Function
		{
			return function (t:Number, b:Number, c:Number, d:Number):Number {
				if ((t /= d / 2) < 1) return c / 2 * (t * t * (((overshoot * 1.525) + 1) * t - overshoot * 1.525)) + b;
				return c / 2 * ((t -= 2) * t * (((overshoot * 1.525) + 1) * t + overshoot * 1.525) + 2) + b;
			}
		}
		
		/**
		 * Back easing-out-in with parameter.
		 * @param overshoot オーバー値
		 * @return Function
		 */
		static public function _BackOutInWith(overshoot:Number = 1.70158):Function
		{
			return function (t:Number, b:Number, c:Number, d:Number):Number {
				if (t < d / 2) return (c / 2) * ((t = (t * 2) / d - 1) * t * ((overshoot + 1) * t + overshoot) + 1) + b;
				return (c / 2) * (t = (t * 2 - d) / d) * t * ((overshoot + 1) * t - overshoot) + (b + c / 2);
			}
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * BOUNCE EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		static private function bounceIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t = (d - t) / d) < (1 / 2.75)) return c - (c * (7.5625 * t * t)) + b;
			if (t < (2 / 2.75))                 return c - (c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) + b;
			if (t < (2.5 / 2.75))               return c - (c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) + b;
			                                    return c - (c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) + b;
		}
		
		static private function bounceOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d) < (1 / 2.75)) return c * (7.5625 * t * t) + b;
			if (t < (2 / 2.75))        return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b;
			if (t < (2.5 / 2.75))      return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b;
			                           return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b;
		}
		
		static private function bounceInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < d / 2)
			{
				if ((t = (d - t * 2) / d) < (1 / 2.75)) return (c - (c * (7.5625 * t * t))) * 0.5 + b;
				if (t < (2 / 2.75))                     return (c - (c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75))) * 0.5 + b;
				if (t < (2.5 / 2.75))                   return (c - (c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375))) * 0.5 + b;
				                                        return (c - (c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375))) * 0.5 + b;
			}
			else
			{
				if ((t = (t * 2 - d) / d) < (1 / 2.75)) return (c * (7.5625 * t * t)) * 0.5 + c * 0.5 + b;
				if (t < (2 / 2.75))                     return (c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) * 0.5 + c * 0.5 + b;
				if (t < (2.5 / 2.75))                   return (c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) * 0.5 + c * 0.5 + b;
				                                        return (c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) * 0.5 + c * 0.5 + b;
			}
		}
		
		static private function bounceOutIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < d / 2) {
				if ((t = (t * 2) / d) < (1 / 2.75)) return (c / 2) * (7.5625 * t * t) + b;
				if (t < (2 / 2.75))                 return (c / 2) * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b;
				if (t < (2.5 / 2.75))               return (c / 2) * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b;
				                                    return (c / 2) * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b;
			}
			else
			{
				if ((t = (d - (t * 2 - d)) / d) < (1 / 2.75)) return (c / 2) - ((c / 2) * (7.5625 * t * t)) + (b + c / 2);
				if (t < (2 / 2.75))                           return (c / 2) - ((c / 2) * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) + (b + c / 2);
				if (t < (2.5 / 2.75))                         return (c / 2) - ((c / 2) * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) + (b + c / 2);
				                                              return (c / 2) - ((c / 2) * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) + (b + c / 2);
			}
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * ELASTIC EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * Elastic easing-in with parameter.
		 * @param amplitude 振幅の大きさ
		 * @param period 振幅の周期
		 * @return Function
		 */
		static public function _ElasticInWith(amplitude:Number = 0, period:Number = 0):Function
		{
			return function (t:Number, b:Number, c:Number, d:Number):Number
			{
				t /= 1000;
				d /= 1000;
				
				if (t == 0) return b;
				if ((t /= d) == 1) return b + c;
				if (!period) period = d * 0.3;
				
				var s:Number;
				if (!amplitude || amplitude < Math.abs(c)) { amplitude = c; s = period / 4; }
				else s = period / (2 * Math.PI) * Math.asin(c / amplitude);
				return -(amplitude * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / period)) + b;
			}
		}
		
		/**
		 * Elastic easing-out with parameter.
		 * @param amplitude 振幅の大きさ
		 * @param period 振幅の周期
		 * @return Function
		 */
		static public function _ElasticOutWith(amplitude:Number = 0, period:Number = 0):Function
		{
			return function (t:Number, b:Number, c:Number, d:Number):Number
			{
				t /= 1000;
				d /= 1000;
				
				if (t == 0) return b;
				if ((t /= d) == 1) return b + c;
				if (!period) period = d * 0.3;
				
				var s:Number;
				if (!amplitude || amplitude < Math.abs(c)) { amplitude = c; s = period / 4; }
				else s = period / (2 * Math.PI) * Math.asin(c / amplitude);
				return amplitude * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / period) + c + b;			}
		}
		
		/**
		 * Elastic easing-in-out with parameter.
		 * @param amplitude 振幅の大きさ
		 * @param period 振幅の周期
		 * @return Function
		 */
		static public function _ElasticInOutWith(amplitude:Number = 0, period:Number = 0):Function
		{
			return function (t:Number, b:Number, c:Number, d:Number):Number
			{
				t /= 1000;
				d /= 1000;
				
				if (t == 0) return b;
				if ((t /= d / 2) == 2) return b + c;
				if (!period) period = d * (0.3 * 1.5);
				
				var s:Number;
				if (!amplitude || amplitude < Math.abs(c)) { amplitude = c; s = period / 4; }
				else s = period / (2 * Math.PI) * Math.asin(c / amplitude);
				if (t < 1) return -0.5 * (amplitude * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / period)) + b;
				return amplitude * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / period) * 0.5 + c + b;
			}
		}
		
		/**
		 * Elastic easing-out-in with parameter.
		 * @param amplitude 振幅の大きさ
		 * @param period 振幅の周期
		 * @return Function
		 */
		static public function _ElasticOutInWith(amplitude:Number = 0, period:Number = 0):Function
		{
			return function (t:Number, b:Number, c:Number, d:Number):Number
			{
				t /= 1000;
				d /= 1000;
				
				var s:Number;
				c /= 2;
				
				if (t < d / 2) {
					if ((t *= 2) == 0) return b;
					if ((t /= d) == 1) return b + c;
					if (!period) period = d * 0.3;
					if (!amplitude || amplitude < Math.abs(c)) { amplitude = c; s = period / 4; }
					else s = period / (2 * Math.PI) * Math.asin(c / amplitude);
					return amplitude * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / period) + c + b;
				}
				else
				{
					if ((t = t * 2 - d) == 0) return (b + c);
					if ((t /= d) == 1) return (b + c) + c;
					if (!period) period = d * 0.3;
					if (!amplitude || amplitude < Math.abs(c)) { amplitude = c; s = period / 4; }
					else s = period / (2 * Math.PI) * Math.asin(c / amplitude);
					return -(amplitude * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / period)) + (b + c);
				}
			}
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * CUSTOM EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * 配列から新しいイージングを生成します。
		 * @param points ポイント配列
		 * @return Function
		 */
		static public function custom(points:Array):Function
		{
			return function (t:Number, b:Number, c:Number, d:Number):Number {
				for (var i:int = 0; i < points.length - 1; i++) {
					if (t / d >= points[i].point[0] && t / d <= points[i + 1].point[0]) {
						return c * getYForX(t / d,
							new Point(points[i].point[0], points[i].point[1]),
							new Point(points[i].post[0], points[i].post[1]),
							new Point(points[i + 1].pre[0], points[i + 1].pre[1]),
							new Point(points[i + 1].point[0], points[i + 1].point[1])) + b;
					}
				}
				return NaN;
			};
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * BLEND EASING
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * 複数のイージングを組み合わせて、新しいイージングを生成します。
		 * @param easeA 元になるイージング
		 * @param easeB 混合されるイージング
		 * @param mixing 混合率を指定するイージング
		 * @param start 開始時の混合率
		 * @param end 終点時の混合率
		 * @return
		 */
		static public function blend(easeA:Function, easeB:Function, mixing:Function = null, start:Number = 0, end:Number = 1):Function
		{
			mixing ||= linear;
			
			return function (t:Number, b:Number, c:Number, d:Number):Number {
				
				var v1:Number   = easeA (t, b, c, d);
				var v2:Number   = easeB (t, b, c, d);
				var v3:Number   = mixing(t, b, c, d);
				var rate:Number = end - start;
				return v1 + (v2 - v1) * (v3 * rate + start);
			}
		}
		
		
		
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * Ported from fl.motion.BezierSegment.as
		 * Copyright © 2007. Adobe Systems Incorporated. All Rights Reserved.
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		
		static private function getYForX(x:Number, a:Point, b:Point, c:Point, d:Point):Number
		{
			if (a.x < d.x) { 
				if (x <= a.x + 0.0000000000000001) return a.y;
				if (x >= d.x - 0.0000000000000001) return d.y;
			}
			else {
				if (x >= a.x + 0.0000000000000001) return a.y;
				if (x <= d.x - 0.0000000000000001) return d.y;
			}
			
			var coefficients:Array = getCubicCoefficients(a.x, b.x, c.x, d.x);
			
			// x(t) = a*t^3 + b*t^2 + c*t + d
			var roots:Array = getCubicRoots(coefficients[0], coefficients[1], coefficients[2], coefficients[3] - x);
			var time:Number = NaN;
			if (roots.length == 0) time = 0;
			else if (roots.length == 1) time = roots[0];
			else {
				for each (var root:Number in roots) {
					if (0 <= root && root <= 1) {
						time = root;
						break;
					}
				}
			}
			
			if (isNaN(time)) return NaN;
			
			var y:Number = getSingleValue(time, a.y, b.y, c.y, d.y);
			return y;
		}
		
		/**
		 * @param a The first value of the Bezier equation.
		 * @param b The second value of the Bezier equation.
		 * @param c The third value of the Bezier equation.
		 * @param d The fourth value of the Bezier equation.
		 * @return An array containing four number values,
		 */
		static private function getCubicCoefficients(a:Number, b:Number, c:Number, d:Number):Array
		{
			return [ -a + 3 * b - 3 * c + d,
					3 * a - 6 * b + 3 * c,
					-3 * a + 3 * b,
					a];
		} 
		
		/**
		 * @param a The first coefficient of the cubic equation, which is multiplied by the cubed variable (t^3).
		 * @param b The second coefficient of the cubic equation, which is multiplied by the squared variable (t^2).
		 * @param c The third coefficient of the cubic equation, which is multiplied by the linear variable (t).
		 * @param d The fourth coefficient of the cubic equation, which is the constant.
		 * @return An array of number values, indicating the real roots of the equation. 
		 */
		static private function getCubicRoots(a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 0):Array
		{
			if (!a) return getQuadraticRoots(b, c, d);
			
			if (a != 1) {
				b /= a;
				c /= a;
				d /= a;
			}
			
			var q:Number = (b * b - 3 * c) / 9;
			var qCubed:Number = q * q * q;
			var r:Number = (2 * b * b * b - 9 * b * c + 27 * d) / 54;
			
			var diff:Number   = qCubed - r * r;
			if (diff >= 0) {
				if (!q) return [0];
				var theta:Number = Math.acos(r / Math.sqrt(qCubed));
				var qSqrt:Number = Math.sqrt(q);
				
				var root1:Number = -2 * qSqrt * Math.cos(theta / 3) - b / 3;
				var root2:Number = -2 * qSqrt * Math.cos((theta + 2 * Math.PI) / 3) - b / 3;
				var root3:Number = -2 * qSqrt * Math.cos((theta + 4 * Math.PI) / 3) - b / 3;
				
				return [root1, root2, root3];
			}
			else {
				var tmp:Number = Math.pow( Math.sqrt(-diff) + Math.abs(r), 1/3);
				var rSign:int = (r > 0) ?  1 : r < 0  ? -1 : 0;
				var root:Number = -rSign * (tmp + q / tmp) - b / 3;
				return [root];
			}
			return [];
		}
		
		/**
		 * @param a The first value of the Bezier equation.
		 * @param b The second value of the Bezier equation.
		 * @param c The third value of the Bezier equation.
		 * @param d The fourth value of the Bezier equation.
		 * @return The value of the Bezier equation at the specified time. 
		 */
		static private function getSingleValue(t:Number, a:Number=0, b:Number=0, c:Number=0, d:Number=0):Number
		{
			return (t * t * (d - a) + 3 * (1 - t) * (t * (c - a) + (1 - t) * (b - a))) * t + a;
		}
		
		/**
		 * @param a The first coefficient of the quadratic equation, which is multiplied by the squared variable (t^2).
		 * @param b The second coefficient of the quadratic equation, which is multiplied by the linear variable (t).
		 * @param c The third coefficient of the quadratic equation, which is the constant.
		 * @return An array of number values, indicating the real roots of the equation.
		 */
		static private function getQuadraticRoots(a:Number, b:Number, c:Number):Array
		{
			var roots:Array = [];
			if (!a) {
				if (!b) return [];
				roots[0] = -c / b;
				return roots;
			}
			
			var q:Number = b*b - 4*a*c;
			var signQ:int = (q > 0)?  1: q < 0  ? -1: 0;
			
			if (signQ < 0) return [];
			else if (!signQ) roots[0] = -b / (2 * a);
			else {
				roots[0] = roots[1] = -b / (2 * a);
				var tmp:Number = Math.sqrt(q) / (2 * a);
				roots[0] -= tmp;
				roots[1] += tmp;
			}
			return roots;
		}
	}
}