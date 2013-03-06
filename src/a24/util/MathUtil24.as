package a24.util
{
	/**
	 *
	 * 計算に関する便利なやつです。
	 * @author Atsushi Kaga
	 *
	 */
	final public class MathUtil24
	{
		/**
		 * @private
		 */
		public function MathUtil24() { }
		
		/**
		 * 指定した範囲内のランダムな値を取得します。
		 * @param min 最小値
		 * @param max 最大値
		 * @param innerMin 内側の最小値
		 * @param innerMax 内側の最大値
		 * @param round 四捨五入して整数にするかどうか
		 * @return Number
		 */
		public function randomInRange(min:Number, max:Number, innerMin:Number = NaN, innerMax:Number = NaN, round:Boolean = false):Number
		{
			var result:Number;
			var useOutRange:Boolean = !(isNaN(innerMin) || isNaN(innerMax));
			do { result = Math.random() * (max - min) + min; }
			while (useOutRange && (innerMin < result && result < innerMax))
			return (round)? Math.round(result): result;
		}
	}
}