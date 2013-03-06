package a24.tween.core.plugins 
{
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since	2012.01.06
	 * @private
	 *
	 */
	public class PluginTween24Property 
	{
		public function PluginTween24Property() 
		{
			
		}
		
		protected var _name:String;
		public function get name():String { return _name; }
		
		protected var _type:String;
		public function get type():String { return _type; }
		
		public function atDelay   ():void {}
		public function atPlay    ():void {}
		public function atInit    ():void {}
		public function atUpdate  ():void {}
		public function atStop    ():void {}
		public function atPause   ():void {}
		public function atComplete():void {}
	}
}