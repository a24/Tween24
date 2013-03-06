package a24.util 
{
	/**
	 * メソッドチェーンで扱える便利クラスです。
	 */
	public final class Util24 
	{
		/**
		 * @private
		 */
		public function Util24() {}
		
		/**
		 * 配列に関する便利なやつです。
		 */
		static public function get array():ArrayUtil24 { return _array; }
		static private var _array:ArrayUtil24 = new ArrayUtil24();
		
		/**
		 * ビットマップに関する便利なやつです。
		 */
		static public function get bitmap():BitmapUtil24 { return _bitmap; }
		static private var _bitmap:BitmapUtil24 = new BitmapUtil24();
		
		/**
		* クラスに関する便利なやつです。
		 */
		static public function get clazz():ClassUtil24 { return _class; }
		static private var _class:ClassUtil24 = new ClassUtil24();
		
		/**
		* 表示オブジェクトに関する便利なやつです。
		 */
		static public function get display() :DisplayUtil24 { return _display; }
		static private var _display:DisplayUtil24 = new DisplayUtil24();
		
		/**
		* Graphics に関する便利なやつです。
		 */
		static public function get graphics():GraphicsUtil24 { return _graphics; }
		static private var _graphics:GraphicsUtil24 = new GraphicsUtil24();
		
		/**
		* 計算に関する便利なやつです。
		 */
		static public function get math():MathUtil24 { return _math; }
		static private var _math:MathUtil24 = new MathUtil24();
		
		/**
		* TextField に関する便利なやつです。
		 */
		static public function get text():TextUtil24 { return _text; }
		static private var _text:TextUtil24 = new TextUtil24();
		
		/**
		* MovieClip のタイムラインに関する便利なやつです。
		 */
		static public function get timeline():TimelineUtil24 { return _timeline; }
		static private var _timeline:TimelineUtil24 = new TimelineUtil24();
	}
}