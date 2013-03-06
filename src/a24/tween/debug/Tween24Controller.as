package a24.tween.debug 
{
	import a24.tween.EventTween24;
	import a24.tween.Tween24;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 *
	 * @author	Atsushi Kaga
	 * @since   2011.12.12
	 *
	 */
	public class Tween24Controller extends Sprite 
	{
		private var _buttons:Array;
		private var _ctrlKey:Boolean;
		private var _altKey:Boolean;
		private var _shiftKey:Boolean;
		private var _listKyeParam:Array;
		
		/**
		 * Tween24 のグローバルタイムスケールを制御するコントローラーインスタンスを生成します。
		 * プリセットに設定されているものは自動的にキーボートの数値キーにも割り当てられるので、キーボードでの操作も可能になります。
		 * キーボードでの操作は、キーを押している間のみタイムスケールが変更され、離すと元のスケールに戻ります。
		 * また、addKey()を使用することで任意のキーに割り当てることも可能です。
		 * @param x 配置するX座標
		 * @param y 配置するY座標
		 * @param preset コントローラーに配置する倍速値（デフォルト-[0.5, 1, 1.5, 2, 5, 10, 24] ）
		 */
		public function Tween24Controller(x:Number = 0, y:Number = 0, preset:Array = null) 
		{
			this.x = x;
			this.y = y;
			
			alpha        = 0.85;
			blendMode    = BlendMode.LAYER;
			_buttons     = [];
			_listKyeParam = [];
			
			_ctrlKey = true;
			_altKey = false;
			_shiftKey = false;
			
			preset ||= [0.5, 1, 1.5, 2, 5, 10, 24];
			var w:int = 23 * preset.length + 5;
			
			// Label
			var labelContainer:Sprite = new Sprite();
			createLabel(labelContainer, 0, "Tween24 [version " + Tween24.VERSION + "]", w);
			
			// Draw background
			graphics.beginFill(0xFFFFFF, 0.5);
			graphics.drawRect(0, 0, w, 28 + 23);
			
			graphics.beginFill(0x222222);
			graphics.drawRect(1, 1, w - 2, 26 + 23);
			
			graphics.beginFill(0x444444);
			graphics.drawRect(2, 2, w - 4, 24 + 23);
			
			graphics.beginFill(0x000000);
			graphics.drawRect(3, 3, w - 6, 22 + 23);
			
			graphics.beginFill(0x444444);
			graphics.drawRect(2, 25, w - 4, 1);
			
			
			// Line and label, button
			var i:int;
			var tx:int;
			graphics.beginFill(0x444444);
			for (i = 0; i < preset.length; i++) {
				tx = 2 + 23 * i;
				graphics.drawRect(tx, 3 + 23, 1, 22);
				var label:TextField = createLabel(labelContainer, tx + 1, "" + preset[i], 22, 2, "Arial");
				createButton(tx + 1, preset[i]);
				
				// Keyboard
				if (i < 9) {
					var code:uint = Keyboard.NUMPAD_1 + i;
					_listKyeParam[code] = new KeyParam(preset[i], code).setNum(i + 1);
					_listKyeParam[49 + i] = new KeyParam(preset[i], code).setNum(i + 1);
				}
				else if (i == 9) {
					_listKyeParam[Keyboard.NUMPAD_0] = new KeyParam(preset[i], code).setNum(i + 1);
					_listKyeParam[48] = new KeyParam(preset[i], code).setNum(i + 1);
				}
			}
			graphics.endFill();
			
			
			// Erase label 
			var eraseLabel:Shape = new Shape();
			drawCapture(eraseLabel.graphics, labelContainer);
			eraseLabel.blendMode = BlendMode.ERASE;
			addChild(eraseLabel);
			
			// Caputure and remove
			Tween24.visible(false, _buttons).play();
			drawCapture(graphics, this);
			removeChild(eraseLabel);
			blendMode = BlendMode.NORMAL;
			Tween24.visible(true, _buttons).play();
			
			// Screen label
			var screenLabel:Shape = new Shape();
			drawCapture(screenLabel.graphics, labelContainer);
			screenLabel.blendMode = BlendMode.SCREEN;
			addChild(screenLabel);
			
			
			// Drag
			addEventListener(MouseEvent.MOUSE_DOWN, function():void {
				startDrag();
			});
			
			addEventListener(MouseEvent.MOUSE_UP, function():void {
				stopDrag();
			});
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * キーボードにグローバルタイムスケール変更を割り当てます。
		 * @param speed 倍速値
		 * @param keyCode 割り当てるキーボード値
		 * @param ctrlKey Ctrキーの同時押しを有効にするか
		 * @param altKey Altキーの同時押しを有効にするか
		 * @param shiftKey Shiftキーの同時押しを有効にするか
		 * @return Tween24Controller
		 * 
		 */		
		public function addKey(speed:Number, keyCode:uint, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false):Tween24Controller
		{
			_listKyeParam[keyCode] = new KeyParam(speed, keyCode, ctrlKey, altKey, shiftKey);
			return this;
		}

		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (stage && stage.focus && stage.focus is TextField  && TextField(stage.focus).type == TextFieldType.INPUT) return;
			
			var param:KeyParam = _listKyeParam[event.keyCode];
			if (param && param.check(event)) {
				if (param.num) btnActivate(_buttons[param.num - 1]);
				Tween24.globalTimeScale = 1 / param.keySpeed;
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			btnDeactivate();
			Tween24.globalTimeScale = 1;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function btnActivate(btn:Sprite):void
		{
			if (!btn) return;
			
			btnDeactivate();
			Tween24.prop(btn).alpha(1).play();
			EventTween24.enabled(false, btn);
		}
		
		private function btnDeactivate():void
		{
			Tween24.prop(_buttons).alpha(0).play();
			EventTween24.enabled(true, _buttons);
		}
		
		/**
		 * Draw caputure.
		 * @param canvas
		 * @param target
		 */
		private function drawCapture(canvas:Graphics, target:DisplayObject):void
		{
			var bmd:BitmapData = new BitmapData(target.width + 3, target.height + 2, true, 0);
			bmd.draw(target);
			
			canvas.clear();
			canvas.beginBitmapFill(bmd, null, false);
			canvas.drawRect(0, 0, bmd.width + 3, bmd.height);
		}
		
		/**
		 * Create button.
		 * @param _x
		 * @param timeScale
		 */
		private function createButton(_x:int, timeScale:Number):void
		{
			var btn:Sprite = new Sprite();
			btn.x = _x;
			btn.y = 3 + 23;
			btn.alpha = 0;
			btn.graphics.beginFill(0xFFFFFF, 0.25);
			btn.graphics.drawRect(0, 0, 22, 22);
			addChild(btn);
			_buttons.push(btn);
			
			EventTween24.onRollOver(btn,
				Tween24.tween(btn, 0).fadeIn()
			);
			EventTween24.onRollOut(btn,
				Tween24.prop(btn).fadeIn(),
				Tween24.tween(btn, 0.1).alpha(0)
			);
			EventTween24.onClick(btn,
				Tween24.func(function():void {
					Tween24.globalTimeScale = 1 / timeScale;
					btnActivate(btn);
				})
			);
		}
		
		/**
		 * Create button's label.
		 * @param _x
		 * @param label
		 * @param _width
		 */
		private function createLabel(container:Sprite, _x:int, label:String, _width:int, line:int = 1, fontName:String = "Georgia"):TextField
		{
			var tf:TextField = new TextField();
			tf.x                 = _x;
			tf.y                 = 5 + 23 * (line - 1);
			tf.width             = _width;
			tf.mouseEnabled      = false;
			tf.selectable        = false;
			tf.autoSize          = TextFieldAutoSize.CENTER;
			tf.defaultTextFormat = new TextFormat(fontName, 10, 0x999999);
			tf.text              = label;
			container.addChild(tf);
			return tf;
		}
	}
}


import flash.events.KeyboardEvent;

class KeyParam 
{
	private var _keySpeed:Number;
	private var _keyCode:uint;
	private var _ctrlKey:Boolean;
	private var _altKey:Boolean;
	private var _shiftKey:Boolean;
	private var _num:uint;
	
	public function KeyParam(speed:Number, keyCode:uint, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false)
	{
		_keySpeed = speed;
		_keyCode = keyCode;
		_ctrlKey = ctrlKey;
		_altKey = altKey;
		_shiftKey = shiftKey;
	}
	
	public function setNum(n:uint):KeyParam
	{
		_num = n;
		return this;
	}
	
	public function check(event:KeyboardEvent):Boolean
	{
		return (event.ctrlKey == _ctrlKey && event.altKey == _altKey && event.shiftKey == _shiftKey);
	}

	public function get keySpeed():Number { return _keySpeed; }
	public function get num():uint { return _num; }
}

