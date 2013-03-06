package a24.tween.plugins.proxy 
{
	import a24.tween.plugins.MatrixPlugin;
	
	import flash.display.DisplayObject;
	
	/**
	 * 
	 * @author Atsushi Kaga
	 * @since 2012.06.27
	 * @private
	 *
	 */
	public class MatrixPluginProxy
	{
		public function MatrixPluginProxy() {}
		
		/**
		 * DisplayObject のマトリックスのトゥイーンを設定します。
		 * @param target 対象オブジェクト
		 * @param time 時間
		 * @param easing イージング関数
		 * @return MatrixPlugin
		 * @see a24.tween.plugins.MatrixPlugin#tween()
		 */
		public function tween(target:DisplayObject, time:Number, easing:Function = null):MatrixPlugin { return MatrixPlugin.tween(target, time, easing); }
		
		/**
		 * DisplayObject のマトリックスのプロパティを設定します。
		 * @param target 対象オブジェクト
		 * @return MatrixPlugin
		 * @see a24.tween.plugins.MatrixPlugin#prop()
		 */
		public function prop(target:DisplayObject):MatrixPlugin { return MatrixPlugin.prop(target); }
	}
}