package states {
	import core.State;
	import core.Game;
	import core.Config;
	import flash.display.SimpleButton; 
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;
	import flash.xml.XMLDocument;
	import ui.Label;
	import flash.text.*; 
	import flash.events.TextEvent;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject; 
	
	public class GameOverState extends State{
		private var _fsm:Game;
		
		private var _instrux0:Label = new Label("Game Over.", 48, Config.getColor("white", "color"), Config.getSetting("font", "settings"), true);
		private var _highScore:Label = new Label("Test", 40, Config.getColor("white", "color"), Config.getSetting("font", "settings"), true);
		private var _backButton:SimpleButton = new SimpleButton(Assets.getImage("back"), 
							Assets.getImage("back"), Assets.getImage("back"), Assets.getImage("back")); 
		private var _newHighScore:Label = new Label("New HighScore! Enter yor name here.", 34, Config.getColor("white", "color"), Config.getSetting("font", "settings"), true);
		private var _textBox:TextField = new TextField(); 
		private var _outputBox:TextField = new TextField(); 
		private var _infoText:String = "Enter your name here"; 
		
		private var _shared:SharedObject; 
		private var _tempArray:Array = []; 
		
		private var _highScoreHeader:Label = new Label("Current High Scores", 24,  Config.getColor("white", "color"), Config.getSetting("font", "settings"), true);
		private var _highScore1:Label = new Label("Highscore 1: 0", 24,  Config.getColor("white", "color"), Config.getSetting("font", "settings"), true);
		private var _highScore2:Label = new Label("Highscore 2: 0", 24,  Config.getColor("white", "color"), Config.getSetting("font", "settings"), true);
		private var _highScore3:Label = new Label("Highscore 3: 0", 24,  Config.getColor("white", "color"), Config.getSetting("font", "settings"), true);
		
		private var _savedSN:Object; 
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
			_instrux0.y = centerY + _instrux0.textHeight - 200;
			
			addChild(_highScore);
			_highScore.text = "Your score was: " + PlayState._playerScore; 
			_highScore.x = centerX - _highScore.textWidth * .5; 
			_highScore.y = _instrux0.y + _highScore.textHeight;
			_shared = SharedObject.getLocal("highScores"); 

			_savedSN = _shared.data.nameScore; 
			if (_savedSN == null){
				trace("New game save created"); 
				_savedSN = {name1: "-", name2: "-", name3: "-",
							score1:"0", score2:"0", score3:"0"};
				_shared.data.nameScore = _savedSN;
				_shared.flush(); 
			}
			else{
				if (PlayState._playerScore > _savedSN.score1 || PlayState._playerScore > _savedSN.score2 || PlayState._playerScore > _savedSN.score3){
					captureText(); 
				}
			}
			displayScores();
		}
		
		private function displayScores():void{
			addChild(_highScoreHeader);
			_highScoreHeader.x = Config.getNumber("center_x", "world") - _highScoreHeader.textWidth * .5;
			_highScoreHeader.y = Config.getNumber("center_y", "world") + _highScoreHeader.textHeight + 50;
			
			addChild(_highScore1);
			_highScore1.text = _savedSN.name1 + " : " + _savedSN.score1;  
			_highScore1.x = Config.getNumber("center_x", "world") - _highScore1.textWidth * .5;
			_highScore1.y = _highScoreHeader.y + _highScore1.textHeight;
			
			addChild(_highScore2);
			_highScore2.text = _savedSN.name2 + " : " + _savedSN.score2;  
			_highScore2.x = Config.getNumber("center_x", "world") - _highScore2.textWidth * .5;
			_highScore2.y = _highScore1.y + _highScore2.textHeight;
			
			addChild(_highScore3);
			_highScore3.text = _savedSN.name3 + " : " + _savedSN.score3;  
			_highScore3.x = Config.getNumber("center_x", "world") - _highScore3.textWidth * .5;
			_highScore3.y = _highScore2.y + _highScore3.textHeight;
		}
		
		public function captureText():void{
			addChild(_newHighScore); 
			_newHighScore.x = Config.getNumber("center_x", "world") - _newHighScore.textWidth * .5; 
			_newHighScore.y = _highScore.y + _newHighScore.textHeight + 20;
			
			_textBox.type = TextFieldType.INPUT;
			_textBox.background = true; 
			_textBox.backgroundColor = Config.getColor("grey", "color");
			_textBox.width = 100; 
			_textBox.x = Config.getNumber("center_x", "world") - _textBox.width *.5;
			_textBox.y = + Config.getNumber("center_y", "world");
			_textBox.height = 30; 
			addChild(_textBox); 
			_textBox.addEventListener(KeyboardEvent.KEY_DOWN, textInputCapture); 
		}
		
		public function textInputCapture(event:KeyboardEvent):void{
			var playerScore:Number = PlayState._playerScore; 
			if (event.charCode == 13){
				if (playerScore > _savedSN.score1 || _savedSN.score1 == "0"){
					_savedSN = {
						name1: _textBox.text, name2: _savedSN.name1, name3:_savedSN.name2,
					score1:playerScore, score:_savedSN.score1, score3:_savedSN.score2};
					_shared.data.nameScore = _savedSN;
					_shared.flush();
					_fsm.changeState(Game.MENU_STATE);
				} else if (playerScore > _savedSN.score2 || _savedSN.score == "0"){
					_savedSN = {
						name1: _savedSN.name1 , name2: _textBox.text, name3:_savedSN.name2,
					score1: _savedSN.score1, score2: playerScore, score3:_savedSN.score2};
					_shared.data.nameScore = _savedSN;
					_shared.flush();
					_fsm.changeState(Game.MENU_STATE);
				} else if (playerScore > _savedSN.score3 || _savedSN.score == "0"){
					_savedSN = {
						name1: _savedSN.name1 , name2:_savedSN.name2, name3: _textBox.text,
					score1: _savedSN.score1, score: _savedSN.score2, score3: playerScore};
					_shared.data.nameScore = _savedSN;
					_shared.flush();
					_fsm.changeState(Game.MENU_STATE);
				}
			}
        } 
             
        public function createOutputBox(str:String):void{ 
            _outputBox.background = true; 
            _outputBox.x = 200; 
            addChild(_outputBox); 
            _outputBox.text = str; 
        } 
		
		public function onClickBack(e:MouseEvent):void {
			_fsm.changeState(Game.MENU_STATE);
		}
		
		override public function update():void{}
		override public function destroy():void{
			_fsm = null;
			_backButton.removeEventListener(MouseEvent.CLICK, onClickBack);
			removeChild(_instrux0);
			_instrux0 = null
			removeChild(_highScore);
			_highScore = null; 
			_backButton = null; 
			_newHighScore = null; 
			_textBox = null; 
			_outputBox = null; 
			_infoText = null;
			_shared = null; 
			_tempArray = null; 
			removeChild(_highScoreHeader);
			_highScoreHeader= null;
			removeChild(_highScore1);
			_highScore1 = null;
			removeChild(_highScore2);
			_highScore2 = null; 
			removeChild(_highScore3);
			_highScore3 = null; 
		} 
	}
}