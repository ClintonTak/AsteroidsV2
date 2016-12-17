package states {
	import core.State;
	import core.Game;
	import core.Config;
	import flash.display.SimpleButton; 
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.xml.XMLDocument;
	import ui.Label;
	
	public class GameOverState extends State{
		private var _fsm:Game;
		
		private var _instrux0:Label = new Label("Game Over.", 24, Config.getColor("white", "color"), Config.getSetting("font", "settings"), true);
		
		private var _backButton:SimpleButton = new SimpleButton(Assets.getImage("back"), 
							Assets.getImage("back"), Assets.getImage("back"), Assets.getImage("back"));  
		public function GameOverState(fsm:Game){
			var centerX:Number = Config.getNumber("center_x", "world"); 
			var centerY:Number = Config.getNumber("center_y", "world");
			super(fsm);
			_fsm = fsm; 
			
			
			addChild(_backButton); 
			_backButton.x =0; 
			_backButton.y = 0; 
			_backButton.width = _backButton.width * .25; 
			_backButton.height = _backButton.height * .25; 
			_backButton.addEventListener(MouseEvent.CLICK, onClickBack); 
			
			addChild(_instrux0);
			_instrux0.x = centerX - _instrux0.textWidth * .5; 
			_instrux0.y = centerY + _instrux0.textHeight;
			
			
		}
		
		public function onClickBack(e:MouseEvent):void {
			_fsm.changeState(Game.MENU_STATE);
		}
		
		override public function update():void{}
		override public function destroy():void{
			
			_fsm = null;
			_backButton.removeEventListener(MouseEvent.CLICK, onClickBack);
			
		} 
	}

}