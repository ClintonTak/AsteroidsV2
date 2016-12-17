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
	
	public class InstructionState extends State{
		private var _fsm:Game;
		
		private var _instrux0:Label = new Label("Dodge the asteroids to survive and shoot them to gain points.", 24, Config.getColor("white", "color"), Config.getSetting("font", "settings"), true);
		private var _instrux1:Label = new Label("Use W to move up, A to move left, S to move down, and D to move right. ", 24, Config.getColor("white", "color"), Config.getSetting("font", "settings"), true);
		private var _instrux2:Label = new Label("Use spacebar to shoot. ", 24, Config.getColor("white", "color"), Config.getSetting("font", "settings"), true); 
		private var _instrux3:Label = new Label("Collect powerups to help you survive. ", 24, Config.getColor("white", "color"), Config.getSetting("font", "settings"), true); 
		
		private var _backButton:SimpleButton = new SimpleButton(Assets.getImage("back"), 
							Assets.getImage("back"), Assets.getImage("back"), Assets.getImage("back")); 
		private var _wasd:SimpleButton = new SimpleButton(Assets.getImage("wasd"), Assets.getImage("wasd"), 
							Assets.getImage("wasd"), Assets.getImage("wasd") ); 
		public function InstructionState(fsm:Game){
			//stage.color = Config.getColor("grey", "color"); 
			super(fsm);
			_fsm = fsm; 
			var centerX:Number = Config.getNumber("center_x", "world"); 
			var centerY:Number = Config.getNumber("center_y", "world"); 
			addChild(_instrux0);
			_instrux0.x = centerX - _instrux0.textWidth * .5; 
			_instrux0.y = centerY + _instrux0.textHeight; 
			
			addChild(_instrux1);
			_instrux1.x = centerX - _instrux1.textWidth * .5; 
			_instrux1.y = _instrux0.y + _instrux1.textHeight; 
			
			addChild(_instrux2);
			_instrux2.x = centerX - _instrux2.textWidth * .5; 
			_instrux2.y = _instrux1.y + _instrux2.textHeight; 
			
			addChild(_instrux3); 
			_instrux3.x = centerX - _instrux3.textWidth * .5; 
			_instrux3.y = _instrux2.y + _instrux2.textHeight; 
			
			addChild(_backButton); 
			_backButton.x =0; 
			_backButton.y = 0; 
			_backButton.width = _backButton.width * .25; 
			_backButton.height = _backButton.height * .25; 
			_backButton.addEventListener(MouseEvent.CLICK, onClickBack); 
			
			addChild(_wasd);
			_wasd.x = centerX - _wasd.width * .5; 
			_wasd.y = centerY - 200; 
			
			
			
		}
		
		public function onClickBack(e:MouseEvent):void {
			_fsm.changeState(Game.MENU_STATE);
		}
		
		override public function update():void{}
		override public function destroy():void{
			
			_fsm = null;
			_backButton.removeEventListener(MouseEvent.CLICK, onClickBack);
			removeChild(_instrux0);
			_instrux0 = null; 
			removeChild(_instrux1);
			_instrux0 = null;
			removeChild(_instrux2);
			_instrux0 = null;
			removeChild(_instrux3);
			_instrux0 = null;
		} 
	}

}