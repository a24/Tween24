package a24.util 
{
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	
	/**
	 *
	 * クラスに関する便利なやつです。
	 * @author Atsushi Kaga
	 *
	 */
	final public class ClassUtil24 
	{
		/**
		 * @private
		 */
		public function ClassUtil24() {}
		
		/**
		 * クラス名からインスタンスを生成します。
		 * @param className 生成するクラスの名前
		 * @return 生成されたインスタンス
		 */
		public function getInstanceByName(className:String):*
		{
			var cls:Class = getDefinitionByName(className) as Class;
			return new cls();
		}
		
		/**
		 * クラス名からリンゲージされたBitmapDataを生成します。
		 * @param className 生成する BitmapData のクラスの名前
		 * @return BitmapData
		 */
		public function getLinkageBitmapDataByName(className:String):BitmapData
		{
			var cls:Class = getDefinitionByName(className) as Class;
			return new cls(0, 0);
		}
	}
}