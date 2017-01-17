package core {
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Key{
		private static var _itialized:Boolean = false; 
		private static var _keys:Object = {}; 
		private static var _dispatcher:EventDispatcher;
		public static const SHOOT:uint = Keyboard.SPACE;
		public static const ACCELERATE:uint = Keyboard.W;
		public static const BREAK:uint = Keyboard.S;
		public static const LEFT:uint = Keyboard.A;
		public static const RIGHT:uint = Keyboard.D;
		public static const TELEPORT:uint = Keyboard.Q; 
		public static const PAUSE:uint = Keyboard.ESCAPE;
		public static const SHIELD:uint = Keyboard.E;
		
		
		public function Key(){} //never call this because we will never create an instance of this class
		
		public static function init(stage:Stage):void{
			if (!_itialized){
				_dispatcher = new EventDispatcher(); 
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
				stage.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);
				_itialized = true; 
			}
		}
		
		public static function isDown(keyCode:uint):Boolean{
			
			return Boolean(keyCode in _keys); 
		}
		
		public static function onKeyDown(e:KeyboardEvent):void{
			//store key press
			
			_keys[e.keyCode] = true;
			_dispatcher.dispatchEvent(e); 
		}
		
		public static function onKeyUp(e:KeyboardEvent):void{
			//delete /remove stored keypress
			
			delete _keys[e.keyCode]
			_dispatcher.dispatchEvent(e); 
		}
		
		public static function onDeactivate(e:Event):void{
			//clear all keypresses
			_keys = {}; 
		}
		
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public static function dispatchEvent(event:Event):Boolean{
			return _dispatcher.dispatchEvent(event); 
		}
		
		public static function hasEventListener(type:String):Boolean{
			return _dispatcher.hasEventListener(type); 
		}
		
		public static function willTrigger(type:String):Boolean{
			return _dispatcher.willTrigger(type); 
		}
		

		
	}

}