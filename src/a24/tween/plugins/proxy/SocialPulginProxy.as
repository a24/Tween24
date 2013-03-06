package a24.tween.plugins.proxy
{
	import a24.tween.plugins.SocialPlugin;
	
	public class SocialPulginProxy
	{
		public function SocialPulginProxy() {}
		
		/**
		 * Twitter でメッセージをつぶやくツイートウィンドを開きます。
		 * @param message 入力欄に設定しておくメッセージ
		 * @return SocialPlugin
		 */
		public function tweet(message:String):SocialPlugin { return SocialPlugin.tweet(message); }
		
		/**
		 * Twitter でシェアするツイートウィンドを開きます。
		 * @param url シェアするページのアドレス
		 * @param message 入力欄に設定しておくメッセージ
		 * @param via viaに設定するアカウント名
		 * @return SocialPlugin
		 */
		public function tweetShare(url:String, message:String, via:String = null):SocialPlugin { return SocialPlugin.tweetShare(url, message, via); }
		
		/**
		 * facebook でシェアするウィンドを開きます。
		 * @param url シェアするページのアドレス
		 * @return SocialPlugin
		 */
		public function facebokShare(url:String):SocialPlugin { return SocialPlugin.facebokShare(url); }
		
		/**
		 * mixi でチェックするウィンドを開きます。
		 * @param url チェックするページのアドレス
		 * @param checkKey mixi Plugin で取得したチェックキー
		 * @return SocialPlugin
		 */
		public function mixiCheck(url:String, checkKey:String):SocialPlugin { return SocialPlugin.mixiCheck(url, checkKey); }
	}
}