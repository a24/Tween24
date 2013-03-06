package a24.util 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *
	 * 
	 * 基準点に関する便利なやつです。
	 * @author	Atsushi Kaga
	 * @since   2012.02.14
	 *
	 */
	final public class Align24 
	{
		/**
		 * 基準点を左上にするよう指定します。 
		 */		
		static public const TOP_LEFT:uint = 1;
		
		/**
		 * 基準点をセンター上にするよう指定します。 
		 */		
		static public const TOP_CENTER:uint = 2;
		
		/**
		 * 基準点を右上にするよう指定します。 
		 */		
		static public const TOP_RIGHT:uint = 3;
		
		/**
		 * 基準点を左中央にするよう指定します。 
		 */		
		static public const MIDDLE_LEFT:uint = 4;
		
		/**
		 * 基準点を中央にするよう指定します。 
		 */		
		static public const MIDDLE_CENTER:uint = 5;
		
		/**
		 * 基準点を右中央にするよう指定します。 
		 */		
		static public const MIDDLE_RIGHT:uint = 6;
		
		/**
		 * 基準点を左下にするよう指定します。 
		 */		
		static public const BOTTOM_LEFT:uint = 7;
		
		/**
		 * 基準点をセンター下にするよう指定します。 
		 */		
		static public const BOTTOM_CENTER:uint = 8;
		
		/**
		 * 基準点を右下にするよう指定します。 
		 */		
		static public const BOTTOM_RIGHT:uint = 9;
		
		/**
		 * 基準点をデフォルトにするよう指定します。 
		 */		
		static public const DEFAULT:uint = 0;
		
		/**
		 * 水平の基準点を左にするよう指定します。 
		 */		
		static public const LEFT:uint = 11;
		
		/**
		 * 水平の基準点をセンターにするよう指定します。 
		 */		
		static public const CENTER:uint = 12;
		
		/**
		 * 水平の基準点を右にするよう指定します。 
		 */		
		static public const RIGHT:uint = 13;
		
		/**
		 * 垂直の基準点を上にするよう指定します。 
		 */		
		static public const TOP:uint = 14;
		
		/**
		 * 垂直の基準点を中央にするよう指定します。 
		 */		
		static public const MIDDLE:uint = 15;
		
		/**
		 * 垂直の基準点を下にするよう指定します。 
		 */		
		static public const BOTTOM:uint = 16;
		
		/**
		 * 基準点を任意の点にするよう指定します。 
		 */		
		static public const SELECTED:uint = 100;
		
		
		
		/**
		 * 基準点を左上にするよう指定します。 
		 */		
		public var topLeft:uint = TOP_LEFT;
		
		/**
		 * 基準点をセンター上にするよう指定します。 
		 */		
		public var topCenter:uint = TOP_CENTER;
		
		/**
		 * 基準点を右上にするよう指定します。 
		 */		
		public var topRight:uint = TOP_RIGHT;
		
		/**
		 * 基準点を左中央にするよう指定します。 
		 */		
		public var middleLeft:uint = MIDDLE_LEFT;
		
		/**
		 * 基準点を中央にするよう指定します。 
		 */		
		public var middleCenter:uint = MIDDLE_CENTER;
		
		/**
		 * 基準点を右中央にするよう指定します。 
		 */		
		public var middleRight:uint = MIDDLE_RIGHT;
		
		/**
		 * 基準点を左下にするよう指定します。 
		 */		
		public var bottomLeft:uint = BOTTOM_LEFT;
		
		/**
		 * 基準点をセンター下にするよう指定します。 
		 */		
		public var bottomCenter:uint = BOTTOM_CENTER;
		
		/**
		 * 基準点を右下にするよう指定します。 
		 */		
		public var bottomRight:uint = BOTTOM_RIGHT;
		
		/**
		 * 基準点をデフォルトにするよう指定します。 
		 */		
		public var deautlt:uint = DEFAULT;
		
		/**
		 * 水平の基準点を左にするよう指定します。 
		 */	
		public var left:uint = LEFT;
		
		/**
		 * 水平の基準点をセンターにするよう指定します。 
		 */	
		public var center:uint = CENTER;
		
		/**
		 * 水平の基準点を右にするよう指定します。 
		 */	
		public var right:uint = RIGHT;
		
		/**
		 * 垂直の基準点を上にするよう指定します。 
		 */	
		public var top:uint = TOP;
		
		/**
		 * 垂直の基準点を中央にするよう指定します。 
		 */	
		public var middle:uint = MIDDLE;
		
		/**
		 * 垂直の基準点を下にするよう指定します。 
		 */	
		public var bottom:uint = BOTTOM;
		
		/**
		 * 基準点を任意の点にするよう指定します。 
		 */	
		public var selected:uint = SELECTED;
		
		/**
		 * @private
		 */
		public function Align24() {}
		
		/**
		 * 整列値を元に、オブジェクトに対する座標を取得します。
		 * @param target ターゲット
		 * @param align 整列値
		 * @return Point
		 */
		static public function getAlignPoint(target:DisplayObject, align:uint):Point
		{
			var pt:Point = new Point();
			var rect:Rectangle = target.getRect(target);
//			rect.x      *= target.scaleX;
//			rect.y      *= target.scaleY;
//			rect.width  *= target.scaleX;
//			rect.height *= target.scaleY;
			
			switch(align) {
				case 1: case 4: case 7: case 11: pt.x = rect.left;                    break; // Left
				case 2: case 5: case 8: case 12: pt.x = rect.left + (rect.width) / 2; break; // Center
				case 3: case 6: case 9: case 13: pt.x = rect.right;                   break; // Right
			}
			switch(align) {
				case 1: case 2: case 3: case 14: pt.y = rect.top;                   break; // Top
				case 4: case 5: case 6: case 15: pt.y = rect.top + rect.height / 2; break; // Middle
				case 7: case 8: case 9: case 16: pt.y = rect.bottom;                break; // Bottom
			}
			return pt;
		}
	}
}