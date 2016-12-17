package core {
	import flash.display.Sprite;
	import flash.events.Event; 
	import states.Play;
	import core.Config;
	
	[SWF(width = "1280", height = "720", backgroundColor = "0x000000", frameRate = "30")]
	public class Game extends Sprite {
		public static const ASSETS:Assets = new Assets; 
		public static const PLAY_STATE:Number = 1;
		private var _currentState:State;
		
		public function Game() 
		{
			Config.loadConfig(); 
			Config.addEventListener(Event.COMPLETE, init, false, 0, true); 
		}
		private function init(e:Event = null):void {
			if (!stage){
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, false); 
				return; 
			}
			removeEventListener(Event.ADDED_TO_STAGE, init); 
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true); 
			addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true); 
			core.Key.init(stage); 
			changeState(PLAY_STATE); 

			
		}
		private function onDeactivate(e:Event):void{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.ACTIVATE, onActivate, false, 0, true);
		}
		
		private function onActivate(e:Event):void{
			removeEventListener(Event.ACTIVATE, onActivate);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}
		public function changeState(nextState:Number):void{
			if (_currentState != null){
				_currentState.destroy(); 
				removeChild(Sprite(_currentState));
				_currentState = null; 
			}
			if (nextState == PLAY_STATE){
				_currentState = new Play(this);
			}
			addChild(Sprite(_currentState));
			
			
		}
		
		private function onEnterFrame(e:Event):void{
			_currentState.update(); 
		}
	}

}