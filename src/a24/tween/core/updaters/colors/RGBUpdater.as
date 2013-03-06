package a24.tween.core.updaters.colors
{
	import a24.tween.core.updaters.abstracts.AbstractUpdater;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2011.01.23
	 * @private
	 *
	 */
	public final class RGBUpdater extends AbstractUpdater
	{
		private var _r:int;
		private var _g:int;
		private var _b:int;
		
		private var _startR:int;
		private var _startG:int;
		private var _startB:int;
		
		private var _deltaR:int;
		private var _deltaG:int;
		private var _deltaB:int;
		
		private var _compR:int;
		private var _compG:int;
		private var _compB:int;
		
		private var _complete:int;
		
		public function RGBUpdater() 
		{
			
		}
		
		public function setProp(start:Number, complete:uint):RGBUpdater
		{
			_complete = complete;
			
			_startR = start >> 16 & 0xFF;
			_startG = start >>  8 & 0xFF;
			_startB = start       & 0xFF;
			
			if (start < 0) {
				_startR *= -1;
				_startG *= -1;
				_startB *= -1;
			}
			
			_compR  = complete >> 16 & 0xFF;
			_compG  = complete >>  8 & 0xFF;
			_compB  = complete       & 0xFF;
			
			if (complete < 0) {
				_compR *= -1;
				_compG *= -1;
				_compB *= -1;
			}
			
			_deltaR = _compR - _startR;
			_deltaG = _compG - _startG;
			_deltaB = _compB - _startB;
			
			return this;
		}
		
		public function getColor():uint
		{
			return _r << 16 | _g << 8 | _b;
		}
		
		override public function update(progress:Number):AbstractUpdater
		{
			_r = _startR + _deltaR * progress;
			_g = _startG + _deltaG * progress;
			_b = _startB + _deltaB * progress;
			return this;
		}
		
		//public function complete():RGBUpdater
		//{
			//_r = _compR;
			//_g = _compG;
			//_b = _compB;
			//
			//return this;
		//}
		
		override public function toString():String 
		{
			return '0x' + _complete.toString(16);
		}
		
		static public function getInt16(n:int):String
		{
			return '0x' + String('000000' + n.toString(16)).substr(-6, 6);
		}
		
		
		
		/*
		 * ===============================================================================================
		 * 
		 * GETTER & SETTER
		 * 
		 * -----------------------------------------------------------------------------------------------
		 */
		public function get r():int { return _r; }
		public function get g():int { return _g; }
		public function get b():int { return _b; }
	}
}