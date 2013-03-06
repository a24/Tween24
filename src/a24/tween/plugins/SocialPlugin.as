package a24.tween.plugins
{
	import a24.tween.core.plugins.PulginTween24;
	import a24.tween.Tween24;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.escapeMultiByte;
	
	/**
	 * 
	 * ソーシャルサービスに関する操作をするプラグインです。 
	 * @author Atsushi Kaga
	 * @since 2012.01.09
	 *
	 */
	public final class SocialPlugin extends PulginTween24
	{
		/**
		 * @private
		 */
		public function SocialPlugin() {}
		
		/**
		 * Twitter でメッセージをつぶやくツイートウィンドを開きます。
		 * @param message 入力欄に設定しておくメッセージ
		 * @return SocialPlugin
		 */
		static public function tweet(message:String):SocialPlugin
		{
			var plugin:SocialPlugin = new SocialPlugin();
			plugin._tween = Tween24.func(popup, "http://twitter.com/?status=" + escapeMultiByte(message));
			return plugin;
		}
		
		/**
		 * Twitter でシェアするツイートウィンドを開きます。
		 * @param url シェアするページのアドレス
		 * @param message 入力欄に設定しておくメッセージ
		 * @param via viaに設定するアカウント名
		 * @return SocialPlugin
		 */
		static public function tweetShare(url:String, message:String, via:String = null):SocialPlugin
		{
			var u:String = "https://twitter.com/intent/tweet";
			u += "?original_referer=" + escapeMultiByte(url);
			u += "&text=" + escapeMultiByte(message);
			u += "&url=" + escapeMultiByte(url);
			if (via) u += "&via=" + escapeMultiByte(via);
			
			var plugin:SocialPlugin = new SocialPlugin();
			plugin._tween = Tween24.func(popup, u);
			return plugin;
		}
		
		/**
		 * facebook でシェアするウィンドを開きます。
		 * @param url シェアするページのアドレス
		 * @return SocialPlugin
		 */
		static public function facebokShare(url:String):SocialPlugin
		{
			var plugin:SocialPlugin = new SocialPlugin();
			plugin._tween = Tween24.func(popup, "http://www.facebook.com/sharer.php?u=" + escapeMultiByte(url));
			return plugin;
		}
		
		/**
		 * mixi でチェックするウィンドを開きます。
		 * @param url チェックするページのアドレス
		 * @param checkKey mixi Plugin で取得したチェックキー
		 * @return SocialPlugin
		 */
		static public function mixiCheck(url:String, checkKey:String):SocialPlugin
		{
			var plugin:SocialPlugin = new SocialPlugin();
			plugin._tween = Tween24.func(popup, "http://mixi.jp/share.pl?u=" + escapeMultiByte(url) + "&k=" + escapeMultiByte(checkKey));
			return plugin;
		}
		
		/**
		 * ポップアップウィンドを開きます。
		 * @param url 開くページのアドレス
		 */
		static private function popup(url:String):void
		{
			try { ExternalInterface.call("window.open", url, "_blank", "width=640, height=360"); }
			catch (e:Error) { navigateToURL(new URLRequest(url), "_blank"); }
		}
		
		
		/*
		 * ===============================================================================================
		 * DELAY & EVENT
		 * -----------------------------------------------------------------------------------------------
		 */
		public function delay(time:Number):SocialPlugin { _tween.delay(time); return this; }
		public function onPlay    (func:Function, ...args):SocialPlugin { args.unshift(func); _tween.onPlay    .apply(_tween, args); return this; }
		public function onDelay   (func:Function, ...args):SocialPlugin { args.unshift(func); _tween.onDelay   .apply(_tween, args); return this; }
		public function onInit    (func:Function, ...args):SocialPlugin { args.unshift(func); _tween.onInit    .apply(_tween, args); return this; }
		public function onUpdate  (func:Function, ...args):SocialPlugin { args.unshift(func); _tween.onUpdate  .apply(_tween, args); return this; }
		public function onPause   (func:Function, ...args):SocialPlugin { args.unshift(func); _tween.onPause   .apply(_tween, args); return this; }
		public function onStop    (func:Function, ...args):SocialPlugin { args.unshift(func); _tween.onStop    .apply(_tween, args); return this; }
		public function onComplete(func:Function, ...args):SocialPlugin { args.unshift(func); _tween.onComplete.apply(_tween, args); return this; }
	}
}