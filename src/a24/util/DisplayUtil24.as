package a24.util 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	
	/**
	 *
	 * 表示オブジェクトに関する便利なやつです。
	 * @author Atsushi Kaga
	 *
	 */
	final public class DisplayUtil24 
	{
		/**
		 * @private
		 */
		public function DisplayUtil24() {}
		
		// =============================================================================
		//
		// AddChild
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 子オブジェクトを追加します。（複数子オブジェクト指定可）
		 * @param container 親コンテナ
		 * @param child 追加する子オブジェクト
		 */
		public function addChild(container:DisplayObjectContainer, ...children):void
		{
			children = Util24.array.compressAndClean(children);
			if (container) {
				for each (var child:DisplayObject in children) {
					container.addChild(child);
				}
			}
		}
		
		/**
		 * 指定した深度に、子オブジェクトを追加します。
		 * @param containerr 親コンテナ
		 * @param child 追加する子オブジェクト
		 */
		public function addChildAt(container:DisplayObjectContainer, child:DisplayObject, index:int):void
		{
			if (container && child) {
				container.addChildAt(child, index);
			}
		}
		
		/**
		 * 指定したターゲットの前面に、子オブジェクトを追加します。
		 * @param container	親コンテナ
		 * @param child 追加する子オブジェクト
		 * @param target 基準になるオブジェクト
		 */
		public function addChildAtFront(child:DisplayObject, target:DisplayObject):void
		{
			var container:DisplayObjectContainer = target.parent;
			if (container && child && target) {
				container.addChildAt(child, container.getChildIndex(target) + 1);
			}
		}
		
		/**
		 * 指定したターゲットの背面に、子オブジェクトを追加します。
		 * @param container 親コンテナ
		 * @param child 追加する子オブジェクト
		 * @param target 基準になるオブジェクト
		 */
		public function addChildAtBack(child:DisplayObject, target:DisplayObject):void
		{
			var container:DisplayObjectContainer = target.parent;
			if (container && target && child) {
				container.addChildAt(child, container.getChildIndex(target));
			}
		}
		
		/**
		 * コンテナに子オブジェクトを追加し、座標をコピーし子オブジェクトとコンテナを入れ替えます。
		 * @param container 親コンテナ
		 * @param child 追加する子オブジェクト
		 * @return 親コンテナ
		 */
		public function addChildAndReplace(container:DisplayObjectContainer, child:DisplayObject):DisplayObjectContainer
		{
			container.x = child.x;
			container.y = child.y;
			child.x = 0;
			child.y = 0;
			if (child.parent) child.parent.addChild(container);
			container.addChild(child);
			return container;
		}
		
		
		// =============================================================================
		//
		// RemoveChild
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 子オブジェクトを削除します。（複数オブジェクト指定可）
		 * @param child 削除する子オブジェクト
		 */
		public function removeChild(...children):void
		{
			children = Util24.array.compressAndClean(children);
			var parent:DisplayObjectContainer;
			for each (var child:DisplayObject in children) {
				if ((parent = child.parent)) {
					parent.removeChild(child);
				}
			}
		}
		
		/**
		 * 指定した名前の子オブジェクトを削除します。（複数の名前指定可）
		 * @param container 親コンテナ
		 * @param ...names 削除する子オブジェクトの名前
		 */
		public function removeChildByName(container:DisplayObjectContainer, ...names):void
		{
			names = Util24.array.compressAndClean(names);
			var child:DisplayObject;
			for each (var n:String in names) {
				if ((child = container.getChildByName(n))) {
					container.removeChild(child);
				}
			}
		}
		
		/**
		 * 指定した深度にある子オブジェクトを削除します。（複数深度指定可）
		 * @param container 親コンテナ
		 * @param ...index 削除する子オブジェクトの深度
		 */
		public function removeChildAt(container:DisplayObjectContainer, ...index):void
		{
			index = Util24.array.compressAndClean(index);
			var child:DisplayObject;
			var children:Array = [];
			for each (var i:int in index) {
				try { child = container.getChildAt(i); children.push(child); }
				catch (e:Error) {}
			}
			for each (child in children) container.removeChild(child);
		}
		
		/**
		 * 子オブジェクトを全て削除します。
		 * @param container 親コンテナ
		 */
		public function removeAllChildren(...containers):void
		{
			containers = Util24.array.compressAndClean(containers);
			for each (var cont:DisplayObjectContainer in containers) {
				while (cont.numChildren) {
					var child:DisplayObject = cont.getChildAt(0);
					if (child) cont.removeChildAt(0);
					else break;
				}
			}
		}
		
		/**
		 * コンテナ以下にある全てのオブジェクトを全て削除します。
		 * @param ...containers 親コンテナ
		 */
		public function removeFullChildren(...containers):void
		{
			containers = Util24.array.compressAndClean(containers);
			for each (var cont:DisplayObjectContainer in containers) {
				if (!(cont is Loader)) {
					while (cont.numChildren) {
						var child:DisplayObject = cont.getChildAt(0);
						if (child) {
							cont.removeChildAt(0);
							if (child is DisplayObjectContainer) removeFullChildren(child);
						}
						else break;
					}
				}
			}
		}
		
		
		// =============================================================================
		//
		// GetChildren
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * 指定した深度にあるオブジェクトを配列で取得します。（複数深度指定可）
		 * @param container 親コンテナ
		 * @param ...index 取得する深度
		 * @return Array
		 */
		public function getChildrenAt(container:DisplayObjectContainer, ...index):Array
		{
			index = Util24.array.compressAndClean(index);
			var child:DisplayObject;
			var children:Array = [];
			for each (var n:int in index) {
				if ((child = container.getChildAt(n))) {
					children.push(child);
				}
			}
			return children;
		}
		
		/**
		 * 指定した名前のオブジェクトを配列で取得します。（複数の名前指定可）
		 * @param container 親コンテナ
		 * @param ...names 取得するオブジェクト名
		 * @return Array
		 */
		public function getChildrenByName(container:DisplayObjectContainer, ...names):Array
		{
			names = Util24.array.compressAndClean(names);
			var child:DisplayObject;
			var children:Array = [];
			for each (var n:String in names) {
				if ((child = container.getChildByName(n))) {
					children.push(child);
				}
			}
			return children;
		}
		
		/**
		 * 指定した文字列が名前に含まれているオブジェクトを配列で取得します。
		 * @param container 親コンテナ
		 * @param str 検索ワード
		 * @return Array
		 */
		public function getChildrenSearchName(container:DisplayObjectContainer, str:String):Array
		{
			var children:Array = [];
			var len:int = container.numChildren;
			for (var i:int = 0; i < len; i ++) {
				var child:DisplayObject = container.getChildAt(i);
				if (child.name.indexOf(str) > -1) children.push(child);
			}
			return children;
		}
		
		/**
		 * コンテナ内の子オブジェクトを全て取得します。（複数コンテナ指定可）
		 * @param ...containers 親コンテナ
		 * @return Array
		 */
		public function getAllChildren(...containers):Array
		{
			containers = Util24.array.compressAndClean(containers);
			var children:Array = [];
			for each (var container:DisplayObjectContainer in containers) {
				var len:int = container.numChildren;
				for (var i:int = 0; i < len; i ++) children.push(container.getChildAt(i));
			}
			return children;
		}
		
		
		// =============================================================================
		//
		// Other
		//
		// -----------------------------------------------------------------------------
		
		/**
		 * オブジェクトを最前面に配置します。
		 * @param target 対象オブジェクト
		 */
		public function setFrontChild(child:DisplayObject):void
		{
			var parent:DisplayObjectContainer = child.parent;
			if (parent && child) {
				parent.setChildIndex(child, parent.numChildren - 1);
			}
		}
		
		/**
		 * オブジェクトの深度を変更します。
		 * @param target 対象オブジェクト
		 * @param index 深度
		 */
		public function setChildIndex(child:DisplayObject, index:uint):void
		{
			var parent:DisplayObjectContainer = child.parent;
			if (parent && child) {
				parent.setChildIndex(child, index);
			}
		}
		
		/**
		 * オブジェクトの座標をコピーし、別のオブジェクトと入れ替えます。
		 * @param before 元になるオブジェクト
		 * @param after 置き換えるオブジェクト
		 * @return
		 */
		public function replaceChild(before:DisplayObject, after:DisplayObject):DisplayObject
		{
			var parent:DisplayObjectContainer = before.parent;
			if (parent) {
				after.x = before.x;
				after.y = before.y;
				parent.addChildAt(after, parent.getChildIndex(before));
				parent.removeChild(before);
			}
			return after;
		}
		
		/**
		 * マスクを設定します。マスクオブジェクトは自動的に対象と同じ階層の表示リストに追加されます。
		 * @param target マスクターゲット
		 * @param masker マスクオブジェクト
		 */
		public function addMask(target:DisplayObject, masker:DisplayObject):void
		{
			var parent:DisplayObjectContainer = target.parent;
			target.mask = masker;
			if (parent && parent != masker.parent) parent.addChild(masker);
		}
		
		/**
		 * マスクを解除します。マスクオブジェクトは自動的に表示リストから削除されます。
		 * @param target マスクターゲット
		 */
		public function removeMask(target:DisplayObject):void
		{
			var masker:DisplayObject = target.mask;
			var parent:DisplayObjectContainer = masker.parent;
			if (masker) {
				if (parent) parent.removeChild(masker);
				target.mask = null;
			}
		}
		
		/**
		 * オブジェクトに設定されているフィルタを全て解除します。（複数オブジェクト指定可）
		 * @param ...targets 対象オブジェクト
		 */
		public function removeFilters(...targets):void
		{
			targets = Util24.array.compressAndClean(targets);
			for each (var t:* in targets) {
				if (t.filters) t.filters = null;
			};
		}
		
		/**
		 * 矩形オブジェクトを生成し、ヒットエリアに設定します。
		 * @param target 対象オブジェクト
		 * @param container ヒットエリアオブジェクトを追加するコンテナ。指定しない場合は target が設定されます。
		 * @param model ヒットエリアの領域の基準になるオブジェクト。指定しない場合は target が設定されます。
		 * @param debug ヒットエリア領域にカラーを付加します
		 * @return
		 */
		public function addRectHitArea(target:Sprite, container:DisplayObjectContainer = null, model:Object = null, debug:Boolean = false):Sprite
		{
			var sp:Sprite = new Sprite();
			model ||= target;
			container ||= target;
			
			//sp.mouseEnabled = false;
			Util24.graphics.drawRectHitArea(sp, model, debug);
			target.mouseChildren = false;
			target.hitArea = sp;
			
			if (container != target && container.contains(target)) {
				sp.x = target.x;
				sp.y = target.y;
			}
			
			container.addChild(sp);
			return sp;
		}
		
		/**
		 * 円形オブジェクトを生成し、ヒットエリアに設定します。
		 * @param target 対象オブジェクト
		 * @param model ヒットエリアの領域の基準になるオブジェクト。指定しない場合は target が設定されます。
		 * @param debug ヒットエリア領域にカラーを付加します
		 * @return
		 */
		public function addCircleHitArea(target:Sprite, model:Object = null, debug:Boolean = false):Sprite
		{
			model ||= target;
			var sp:Sprite = new Sprite();
			//sp.mouseEnabled = false;
			Util24.graphics.drawCircleHitArea(sp, model, debug);
			target.mouseChildren = false;
			target.hitArea = sp;
			target.addChild(sp);
			return sp;
		}
		
		
		/**
		 * 縦横比を保持したままスケールを変更します。
		 * @param target 対象オブジェクト
		 * @param width 横幅
		 * @param height 高さ
		 */
		public function resizeRatio(target:DisplayObject, width:Number, height:Number):void
		{
			var ratioW:Number = width / (target.width / target.scaleX);
			var ratioH:Number = height / (target.height / target.scaleY);
			
			target.scaleX = target.scaleY = (ratioW < ratioH)? ratioW: ratioH;
		}
		
		/**
		 * グローバルX座標を、対象のオブジェクトを基準にしたローカル座標に変換し取得します。
		 * @param target 基準オブジェクト
		 * @param x グローバルX座標
		 * @return Number
		 */
		public function getLocalX(target:DisplayObject, x:Number):Number
		{
			var parent:DisplayObject = target.parent;
			var parents:Array = [];
			while (parent) {
				parents.push(parent);
				parent = parent.parent;
			}
			
			for (var i:int = parents.length - 1; i >= 0; i --) {
				parent = parents[i];
				x = (x - parent.x) / parent.scaleX;
			}
			return x;
		}
		
		/**
		 * グローバルY座標を、対象のオブジェクトを基準にしたローカル座標に変換し取得します。
		 * @param target 基準オブジェクト
		 * @param y グローバルX座標
		 * @return Number
		 */
		public function getLocalY(target:DisplayObject, y:Number):Number
		{
			var parent:DisplayObject = target.parent;
			var parents:Array = [];
			while (parent) {
				parents.push(parent);
				parent = parent.parent;
			}
			
			for (var i:int = parents.length - 1; i >= 0; i --) {
				parent = parents[i];
				y = (y - parent.y) / parent.scaleY;
			}
			return y;
		}
		
		/**
		 * ローカルX座標を、対象のオブジェクトを基準にグローバル座標に変換し取得します。
		 * @param target 基準オブジェクト
		 * @param x グローバルX座標
		 * @return Number
		 */
		public function getGlobalX(target:DisplayObject, x:Number):Number
		{
			var parent:DisplayObject = target.parent;
			while (parent) {
				x = x * parent.scaleX + parent.x;
				parent = parent.parent;
			}
			return x;
		}
		
		/**
		 * ローカルY座標を、対象のオブジェクトを基準にグローバル座標に変換し取得します。
		 * @param target 基準オブジェクト
		 * @param y グローバルX座標
		 * @return Number
		 */
		public function getGlobalY(target:DisplayObject, y:Number):Number
		{
			var parent:DisplayObject = target.parent;
			while (parent) {
				y = y * parent.scaleY + parent.y;
				parent = parent.parent;
			}
			return y;
		}
		
		/**
		 * ベジェ曲線上にある値を取得します。
		 * @param b	begin
		 * @param e	end
		 * @param t	time(0-1)
		 * @param p	bezier params
		 * @return	Number
		 */
		public function getBezier(b:Number, e:Number, t:Number, p:Array):Number
		{
			if (t == 1) return e;
			if (p.length == 1) return b + t * (2 * (1 - t) * (p[0] - b) + t * (e - b));
			else {
				var ip:uint = Math.floor(t * p.length);
				var it:Number = (t - (ip * (1 / p.length))) * p.length;
				var p1:Number;
				var p2:Number;
				
				if (ip == 0) {
					p1 = b;
					p2 = (p[0]+p[1])/2;
				}
				else if (ip == p.length - 1) {
					p1 = (p[ip - 1] + p[ip]) / 2;
					p2 = e;
				}
				else {
					p1 = (p[ip - 1] + p[ip]) / 2;
					p2 = (p[ip] + p[ip + 1]) / 2;
				}
				return p1 + it * (2 * (1 - it) * (p[ip] - p1) + it * (p2 - p1));
			}
		}
	}
}