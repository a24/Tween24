package a24.util
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 *
	 * Graphics に関する便利なやつです。
	 * @author Atsushi Kaga
	 *
	 */
	final public class GraphicsUtil24
	{
		/**
		 * @private
		 */
		public function GraphicsUtil24() {}
		
		/**
		 * 対象オブジェクトの graphics に、オブジェクトのサイズに合わせて矩形を描画します。
		 * @param drawTarget graphics を持ったオブジェクト
		 * @param model 描画領域の基準になるオブジェクト。指定しない場合は drawTarget が設定されます。
		 * @param debug ヒットエリア領域にカラーを付加します
		 */
		public function drawRectHitArea(drawTarget:Object, model:Object = null, debug:Boolean = false):void
		{
			model ||= drawTarget;
			drawTarget.graphics.clear();
			var rect:Rectangle = model.getRect(model);
			drawTarget.graphics.beginFill(0x00FFFF, debug? 0.5: 0);
			drawTarget.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		}
		
		/**
		 * 対象オブジェクトの graphics に、オブジェクトのサイズに合わせて円形を描画します。
		 * @param drawTarget graphics を持ったオブジェクト
		 * @param model 描画領域の基準になるオブジェクト。指定しない場合は drawTarget が設定されます。
		 * @param debug ヒットエリア領域にカラーを付加します
		 */
		public function drawCircleHitArea(drawTarget:Object, model:Object = null, debug:Boolean = false):void
		{
			model ||= drawTarget;
			drawTarget.graphics.clear();
			var rect:Rectangle = model.getRect(model);
			drawTarget.graphics.beginFill(0x00FFFF, debug? 0.5: 0);
			drawTarget.graphics.drawCircle(rect.x + rect.width / 2, rect.y + rect.height / 2, rect.width / 2);
		}
	}
}