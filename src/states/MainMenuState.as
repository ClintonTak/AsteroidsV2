package states{
	
	import core.SoundManager;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import core.Config;
	import ui.Label; 
	import core.Game;
	import core.State;
	import core.SimpleSound;
	import Assets;
	public class MainMenuState extends State{
		private var _fsm:Game;
		private var _label:Label = new Label ("Asteroids!", 124, Config.getColor("white", "color") , Config.getSetting("font", "settings"), true); 
		private var _playButton:SimpleButton = new SimpleButton(Assets.getImage("play"), 
							Assets.getImage("playhover"), Assets.getImage("playhover"), Assets.getImage("play")); 
		private var _instructionButton:SimpleButton = new SimpleButton(Assets.getImage("instructions"), 
							Assets.getImage("instructionshover"), Assets.getImage("instructionshover"), Assets.getImage("instructions")); 
		public function MainMenuState(fsm:Game){
			super(fsm);
			_fsm = fsm;
			
			addChild(_label); 
			_label.x = Config.getNumber("center_x", "world") - _label.textWidth * .5; 
			_label.y = Config.getNumber("center_y", "world") - 250;
			
			addChild(_playButton);
			_playButton.x = Config.getNumber("center_x", "world") - _playButton.width * .5; 
			_playButton.y = _label.y + _label.textHeight;
			_playButton.addEventListener(MouseEvent.CLICK, onClickPlay); 
			
			addChild(_instructionButton); 
			_instructionButton.x = Config.getNumber("center_x", "world") - _instructionButton.width * .5; 
			_instructionButton.y = _playButton.y + _playButton.height; 
			_instructionButton.width = _instructionButton.width ; 
			_instructionButton.addEventListener(MouseEvent.CLICK, onClickInstruction); 
		}
		
		public function onClickPlay(e:MouseEvent):void {
			SoundManager.sharedInstance()._startGame.playSound();
			_fsm.changeState(Game.PLAY_STATE); 
		}
		
		public function onClickInstruction(e:MouseEvent):void{
			_fsm.changeState(Game.INSTRUCTION_STATE); 
		}
		
		
		override public function update():void{}
		override public function destroy():void{
			_fsm = null;
			_playButton.removeEventListener(MouseEvent.CLICK, onClickPlay);
			removeChild(_label);
			_label = null; 
			removeChild(_playButton);
			_playButton = null;
			removeChild(_instructionButton);
			_instructionButton = null;
		
		} 
	}

}
