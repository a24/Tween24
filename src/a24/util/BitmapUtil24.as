package a24.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 *
	 * ビットマップに関する便利なやつです。
	 * @author Atsushi Kaga
	 *
	 */
	final public class BitmapUtil24
	{
		/**
		 * @private
		 */
		public function BitmapUtil24() {}
		
		/**
		 * 表示オブジェクトのキャプチャデータを取得します。
		 * @param target 対象オブジェクト
		 * @param transparent 透明度をサポートするかどうか
		 * @param fillColor 領域を塗りつぶす ARGB カラー値
		 * @param smoothing スムージングするかどうか
		 * @return BitmapData
		 */
		public function getCaptureData(target:DisplayObject, transparent:Boolean = true, fillColor:uint = 0xFFFFFF, smoothing:Boolean = false):BitmapData
		{
			var bmpData:BitmapData = new BitmapData(target.width / target.scaleX, target.height / target.scaleY, transparent, fillColor);
			var rect:Rectangle = target.getBounds(target);
			var mtx:Matrix = new Matrix();
			mtx.tx = -rect.left;
			mtx.ty = -rect.top;
			bmpData.draw(target, mtx, null, null, null, smoothing);
			return bmpData;
		}
		
		/**
		 * 表示オブジェクトのキャプチャ画像を取得します。
		 * @param target 対象オブジェクト
		 * @param smoothing スムージングするかどうか
		 * @return Bitmap
		 */
		public function getCapture(target:DisplayObject, smoothing:Boolean = false):Bitmap
		{
			var bmp:Bitmap = new Bitmap(getCaptureData(target, true, 0, smoothing));
			if (smoothing) {
				bmp.smoothing = true;
				bmp.pixelSnapping = PixelSnapping.NEVER;
			}
			return bmp;
		}
		
		/**
		 * 表示オブジェクトのキャプチャ画像を取得し、対象オブジェクトと同じ座標に設定します。
		 * @param target 対象オブジェクト
		 * @param smoothing スムージングするかどうか
		 * @return Bitmap
		 */
		public function getCaptureAndSyncPoint(target:DisplayObject, smoothing:Boolean = false):Bitmap
		{
			var bmp:Bitmap = getCapture(target, smoothing);
			var rect:Rectangle = target.getRect(target);
			if (target is TextField) rect.offset(2, 2);
			bmp.x = target.x + rect.x;
			bmp.y = target.y + rect.y;
			return bmp;
		}
		
		/**
		 * 指定したサイズに合わせてリサイズし、範囲内をクリッピングした画像を取得します。
		 * @param target 対象オブジェクト
		 * @param width クリッピング幅
		 * @param height クリッピング高さ
		 * @return Bitmap
		 */
		public function getResizeAndCenterClipping(target:DisplayObject, width:int, height:int, transparent:Boolean = true, bgColor:uint = 0xFFFFFF):Bitmap
		{
			var sw:Number = width  / target.width;
			var sh:Number = height / target.height;
			var s:Number  = (sw > sh)? sw: sh;
			var w:Number  = target.width  * s;
			var h:Number  = target.height * s;
			
			var bmpData:BitmapData = new BitmapData(width, height, transparent, bgColor);
			var rect:Rectangle = target.getBounds(target);
			var mtx:Matrix = new Matrix();
			mtx.tx = -rect.left - (target.width - width / s) / 2 >> 0;
			mtx.ty = -rect.top  - (target.height - height / s) / 2 >> 0;
			mtx.scale(s, s);
			bmpData.draw(target, mtx, null, null);
			return new Bitmap(bmpData);
		}
	}
}