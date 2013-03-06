package a24.tween.plugins 
{
	import a24.tween.core.plugins.PulginTween24;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * DisplayObject の Matrix を操作するプラグインです。 
	 * @author Atsushi Kaga
	 * @since 2012.01.09
	 *
	 */
	public class MatrixPlugin extends PulginTween24
	{
		static private var _properties:Dictionary;
		private var _property:MatrixTween24Property;
		
		/**
		 * @param property
		 * @private
		 */
		public function MatrixPlugin(property:MatrixTween24Property) 
		{
			_property = property;
		}
		
		
		/*
		 * ===============================================================================================
		 * PUBLIC
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * X軸方向の拡大縮小を設定します。
		 * @param a ピクセル位置
		 * @return MatrixPlugin
		 */
		public function a(a:Number):MatrixPlugin { addParam("a", a); return this; }
		
		/**
		 * Y軸方向の傾斜を設定します。
		 * @param b ピクセル位置
		 * @return MatrixPlugin
		 */
		public function b(b:Number):MatrixPlugin { addParam("b", b); return this; }
		
		/**
		 * X軸方向の傾斜を設定します。
		 * @param c ピクセル位置
		 * @return MatrixPlugin
		 */
		public function c(c:Number):MatrixPlugin { addParam("c", c); return this; }
		
		/**
		 * Y軸方向の拡大縮小を設定します。
		 * @param d ピクセル位置
		 * @return MatrixPlugin
		 */
		public function d(d:Number):MatrixPlugin { addParam("d", d); return this; }
		
		/**
		 * X軸方向に平行移動する距離を設定します。
		 * @param tx 移動距離
		 * @return MatrixPlugin
		 */
		public function tx(tx:Number):MatrixPlugin { addParam("tx", tx); return this; }
		
		/**
		 * Y軸方向に平行移動する距離を設定します。
		 * @param ty 移動距離
		 * @return MatrixPlugin
		 */
		public function ty(ty:Number):MatrixPlugin { addParam("ty", ty); return this; }
		
		/**
		 * X軸方向の傾斜を設定します。(プロパティcと動作は同じです)
		 * @param skewX ピクセル位置
		 * @return MatrixPlugin
		 */
		public function skewX(skewX:Number):MatrixPlugin { addParam("c", skewX); return this; }
		
		/**
		 * Y軸方向の傾斜を設定します。(プロパティbと動作は同じです)
		 * @param skewY ピクセル位置
		 * @return MatrixPlugin
		 */
		public function skewY(skewY:Number):MatrixPlugin { addParam("b", skewY); return this; }
		
		/**
		 * X軸方向の拡大縮小を設定します。(プロパティaと動作は同じです)
		 * @param scaleX ピクセル位置
		 * @return MatrixPlugin
		 */
		public function scaleX(scaleX:Number):MatrixPlugin { addParam("a", scaleX); return this; }
		
		/**
		 * Y軸方向の拡大縮小を設定します。(プロパティdと動作は同じです)
		 * @param scaleY ピクセル位置
		 * @return MatrixPlugin
		 */
		public function scaleY(scaleY:Number):MatrixPlugin { addParam("d", scaleY); return this; }
		
		
		
		/**
		 * X軸方向の拡大縮小を、現在の値を基準に設定します。
		 * @param a ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $a(a:Number):MatrixPlugin { addParam("$a", a); return this; }
		
		/**
		 * Y軸方向の傾斜を、現在の値を基準に設定します。
		 * @param b ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $b(b:Number):MatrixPlugin { addParam("$b", b); return this; }
		
		/**
		 * X軸方向の傾斜を、現在の値を基準に設定します。
		 * @param c ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $c(c:Number):MatrixPlugin { addParam("$c", c); return this; }
		
		/**
		 * Y軸方向の拡大縮小を、現在の値を基準に設定します。
		 * @param d ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $d(d:Number):MatrixPlugin { addParam("$d", d); return this; }
		
		/**
		 * X軸方向に平行移動する距離を、現在の値を基準に設定します。
		 * @param tx 移動距離
		 * @return MatrixPlugin
		 */
		public function $tx(tx:Number):MatrixPlugin { addParam("$tx", tx); return this; }
		
		/**
		 * Y軸方向に平行移動する距離を、現在の値を基準に設定します。
		 * @param ty 移動距離
		 * @return MatrixPlugin
		 */
		public function $ty(ty:Number):MatrixPlugin { addParam("$ty", ty); return this; }
		
		/**
		 * X軸方向の傾斜を、現在の値を基準に設定します。(プロパティ$cと動作は同じです)
		 * @param skewX ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $skewX(skewX:Number):MatrixPlugin { addParam("$c", skewX); return this; }
		
		/**
		 * Y軸方向の傾斜を、現在の値を基準に設定します。(プロパティ$bと動作は同じです)
		 * @param skewY ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $skewY(skewY:Number):MatrixPlugin { addParam("$b", skewY); return this; }
		
		/**
		 * X軸方向の拡大縮小を、現在の値を基準に設定します。(プロパティ$aと動作は同じです)
		 * @param scaleX ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $scaleX(scaleX:Number):MatrixPlugin { addParam("$a", scaleX); return this; }
		
		/**
		 * Y軸方向の拡大縮小を、現在の値を基準に設定します。(プロパティ$dと動作は同じです)
		 * @param scaleY ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $scaleY(scaleY:Number):MatrixPlugin { addParam("$d", scaleY); return this; }
		
		
		
		/**
		 * X軸方向の拡大縮小を、トゥイーン直前の値を基準に設定します。
		 * @param a ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $$a(a:Number):MatrixPlugin { addParam("$$a", a); return this; }
		
		/**
		 * Y軸方向の傾斜を、トゥイーン直前の値を基準に設定します。
		 * @param b ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $$b(b:Number):MatrixPlugin { addParam("$$b", b); return this; }
		
		/**
		 * X軸方向の傾斜を、トゥイーン直前の値を基準に設定します。
		 * @param c ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $$c(c:Number):MatrixPlugin { addParam("$$c", c); return this; }
		
		/**
		 * Y軸方向の拡大縮小を、トゥイーン直前の値を基準に設定します。
		 * @param d ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $$d(d:Number):MatrixPlugin { addParam("$$d", d); return this; }
		
		/**
		 * X軸方向に平行移動する距離を、トゥイーン直前の値を基準に設定します。
		 * @param tx 移動距離
		 * @return MatrixPlugin
		 */
		public function $$tx(tx:Number):MatrixPlugin { addParam("$$tx", tx); return this; }
		
		/**
		 * Y軸方向に平行移動する距離を、トゥイーン直前の値を基準に設定します。
		 * @param ty 移動距離
		 * @return MatrixPlugin
		 */
		public function $$ty(ty:Number):MatrixPlugin { addParam("$$ty", ty); return this; }
		
		/**
		 * X軸方向の傾斜を、トゥイーン直前の値を基準に設定します。(プロパティ$$cと動作は同じです)
		 * @param skewX ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $$skewX(skewX:Number):MatrixPlugin { addParam("$$c", skewX); return this; }
		
		/**
		 * Y軸方向の傾斜を、トゥイーン直前の値を基準に設定します。(プロパティ$$bと動作は同じです)
		 * @param skewY ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $$skewY(skewY:Number):MatrixPlugin { addParam("$$b", skewY); return this; }
		
		/**
		 * X軸方向の拡大縮小を、トゥイーン直前の値を基準に設定します。(プロパティ$$aと動作は同じです)
		 * @param scaleX ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $$scaleX(scaleX:Number):MatrixPlugin { addParam("$$a", scaleX); return this; }
		
		/**
		 * Y軸方向の拡大縮小を、トゥイーン直前の値を基準に設定します。(プロパティ$$dと動作は同じです)
		 * @param scaleY ピクセル位置
		 * @return MatrixPlugin
		 */
		public function $$scaleY(scaleY:Number):MatrixPlugin { addParam("$$d", scaleY); return this; }
		
		
		/*
		 * ===============================================================================================
		 * STATIC PUBLIC
		 * -----------------------------------------------------------------------------------------------
		 */
		
		/**
		 * DisplayObject のマトリックスのトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param time 時間
		 * @param easing イージング関数
		 * @return MatrixPlugin
		 */
		static public function tween(target:DisplayObject, time:Number, easing:Function = null):MatrixPlugin
		{
			_properties ||= new Dictionary();
			_properties[target] ||= new MatrixTween24Property(target);
			
			var plugin:MatrixPlugin = new MatrixPlugin(_properties[target]);
			plugin.setTween(plugin._property, time, easing);
			return plugin;
		}
		
		/**
		 * DisplayObject のマトリックスのプロパティを設定します。
		 * @param target 対象オブジェクト
		 * @return MatrixPlugin
		 */
		static public function prop(target:DisplayObject):MatrixPlugin
		{
			_properties ||= new Dictionary();
			_properties[target] ||= new MatrixTween24Property(target);
			
			var plugin:MatrixPlugin = new MatrixPlugin(_properties[target]);
			plugin.setProp(plugin._property);
			return plugin;
		}
		
		/*
		 * ===============================================================================================
		 * DELAY & EVENT
		 * -----------------------------------------------------------------------------------------------
		 */
		public function delay(time:Number):MatrixPlugin { _tween.delay(time); return this; }
		public function onPlay    (func:Function, ...args):MatrixPlugin { args.unshift(func); _tween.onPlay    .apply(_tween, args); return this; }
		public function onDelay   (func:Function, ...args):MatrixPlugin { args.unshift(func); _tween.onDelay   .apply(_tween, args); return this; }
		public function onInit    (func:Function, ...args):MatrixPlugin { args.unshift(func); _tween.onInit    .apply(_tween, args); return this; }
		public function onUpdate  (func:Function, ...args):MatrixPlugin { args.unshift(func); _tween.onUpdate  .apply(_tween, args); return this; }
		public function onPause   (func:Function, ...args):MatrixPlugin { args.unshift(func); _tween.onPause   .apply(_tween, args); return this; }
		public function onStop    (func:Function, ...args):MatrixPlugin { args.unshift(func); _tween.onStop    .apply(_tween, args); return this; }
		public function onComplete(func:Function, ...args):MatrixPlugin { args.unshift(func); _tween.onComplete.apply(_tween, args); return this; }
	}
}


import a24.tween.core.plugins.PluginTween24Property;
import flash.display.DisplayObject;
import flash.geom.Matrix;

internal class MatrixTween24Property extends PluginTween24Property
{
	private var _target:DisplayObject;
	private var _matrix:Matrix;
	private var _a:Number;
	private var _b:Number;
	private var _c:Number;
	private var _d:Number;
	private var _tx:Number;
	private var _ty:Number;
	
	public function MatrixTween24Property(target:DisplayObject) 
	{
		_target = target;
		_name = _target.name;
	}
	
	
	/*
	 * ===============================================================================================
	 * EVENT HANDLER
	 * -----------------------------------------------------------------------------------------------
	 */
	override public function atInit():void 
	{
		_matrix = _target.transform.matrix;
		_a  = _matrix.a;
		_b  = _matrix.b;
		_c  = _matrix.c;
		_d  = _matrix.d;
		_tx = _matrix.tx;
		_ty = _matrix.ty;
	}
	
	override public function atUpdate():void 
	{
		_target.transform.matrix = _matrix;
	}
	
	override public function atComplete():void 
	{
		atUpdate();
	}
	
	
	/*
	 * ===============================================================================================
	 * GETTER & SETTER
	 * -----------------------------------------------------------------------------------------------
	 */
	public function get a():Number { return _a; }
	public function set a(value:Number):void { _a = _matrix.a = value; }
	
	public function get b():Number { return _b; }
	public function set b(value:Number):void { _b = _matrix.b = value; }
	
	public function get c():Number { return _c; }
	public function set c(value:Number):void { _c = _matrix.c = value; }
	
	public function get d():Number { return _d; }
	public function set d(value:Number):void { _d = _matrix.d = value; }
	
	public function get tx():Number { return _tx; }
	public function set tx(value:Number):void { _tx = _matrix.tx = value; }
	
	public function get ty():Number { return _ty; }
	public function set ty(value:Number):void { _ty = _matrix.ty = value; }
}