package a24.util
{
	/**
	 *
	 * 配列に関する便利なやつです。
	 * @author Atsushi Kaga
	 *
	 */
	final public class ArrayUtil24
	{
		/**
		 * @private
		 */
		public function ArrayUtil24() {}
		
		/**
		 * null や空白文字を削除します。
		 * @param array 対象の配列
		 * @return Array
		 */		
		public function clean(array:Array):Array
		{
			var result:Array = [];
			for each (var item:* in array) {
				if (item !== "" && item !== null && item !== undefined && ((item is Number)? !isNaN(item): true)) {
					result.push(item);
				}
			}
			return result;
		}
		
		/**
		 * 2次配列を展開し、1次配列を返します。
		 * @param array 対象の配列
		 * @return Array
		 */		
		public function compress(array:Array):Array
		{
			var result:Array = [];
			for each (var a:* in array) {
				if (a is Array) result = result.concat(a);
				else            result.push(a);
			}
			return result;
		}
		
		/**
		 * 2次配列を展開し、null や空白文字を削除した配列を返します。
		 * @param array 対象の配列
		 * @return 
		 */		
		public function compressAndClean(array:Array):Array
		{
			return clean(compress(array));
		}
		
		/**
		 * シャッフルされた配列を返します。
		 * @param array 対象の配列
		 * @return Array
		 */		
		public function shuffle(array:Array):Array
		{
			var l:int = array.length;
			var result:Array = array.concat();
			while(l) {
				var m:int = Math.floor(Math.random() * l);
				var n:Object = result[--l];
				result[l] = result[m];
				result[m] = n;
			}
			return result;
		}
		
		/**
		 * 配列から特定の要素を削除します。このメソッドは配列をコピーせず、元の配列を変更します。
		 * @param array 対象の配列
		 * @param item 削除する要素
		 * @return Array
		 */		
		public function removeAt(array:Array, index:uint):Array
		{
			return array.splice(index, 1);
		}
		
		/**
		 * 配列から特定の要素を削除します。このメソッドは配列をコピーせず、元の配列を変更します。
		 * @param array 対象の配列
		 * @param item 削除する要素
		 * @return Array
		 */		
		public function removeItem(array:Array, deleteValue:*):Array
		{
			var index:int = array.indexOf(deleteValue);
			if (index > -1) array.splice(index, 1);
			return array;
		}
		
		/**
		 * 連番が入った配列を返します。
		 * @param min 最小値
		 * @param max 最大値
		 * @return Array
		 */		
		public function getOrderNumberArray(min:int, max:int):Array
		{
			var ary:Array = [];
			var n:int = max - min;
			for (var i:int = 0; i <= n; i ++) ary.push(i + min);
			return ary;
		}
	}
}