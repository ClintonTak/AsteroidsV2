package states 
{
	import com.adobe.tvsdk.mediacore.events.NotificationEvent;
	import core.Entity;
	import core.Game;
	import core.State; 
	import core.Config; 
	import core.Utils;
	import core.Key;
	import events.AsteroidBreakEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import gameObjects.Bullet;
	import gameObjects.Ship;
	import events.PlayerShotEvent;
	import gameObjects.Asteroid;
	import flash.ui.Keyboard;
	import gameObjects.UFO;
	import gameObjects.gfx.GFX;
	import gameObjects.gfx.GFXPew;
	import gameObjects.gfx.GFXBoom;
	import gameObjects.gfx.GFXOuch;
	import gameObjects.gfx.GFXScreenShake;
	import Assets;
	import flash.display.SimpleButton;
	import ui.Label;
	import flash.events.MouseEvent;
	import SoundManager;
	public class PlayState extends State{
		private var _asteroidCount:Number = 0; 
		private var _playerScore:Number = 0; 
		private var _scoreBoard:Label = new Label("Score: 0", 56, Config.getColor("white", "color") , Config.getSetting("font", "settings") , true); 
		private var _level:Label = new Label("Level: 0", 48, Config.getColor("white", "color") , Config.getSetting("font", "settings") , true); 
		private var _currentLevel:Number = 0; 
		private var _fsm:Game; 
		private var _lives:Number = 3; 
		private var _healthShip1:SimpleButton = new SimpleButton(Assets.getImage("ship"), 
							Assets.getImage("ship"), Assets.getImage("ship"), Assets.getImage("ship"));
		private var _healthShip2:SimpleButton = new SimpleButton(Assets.getImage("ship"), 
							Assets.getImage("ship"), Assets.getImage("ship"), Assets.getImage("ship"));
		private var _healthShip3:SimpleButton = new SimpleButton(Assets.getImage("ship"), 
							Assets.getImage("ship"), Assets.getImage("ship"), Assets.getImage("ship"));
							
		private var _bullets:Vector.<Entity> = new Vector.<Entity>; 
		private var _asteroids:Vector.<Entity> = new Vector.<Entity>;
		private var _gfx:Vector.<Entity> = new Vector.<Entity>;
		private var _ufos:Vector.<Entity> = new Vector.<Entity>; 
		
		private var _ship:Ship = new Ship( Config.getNumber("width", "world") * .5, Config.getNumber("height", "world") * .5); 
		public var _collisions:Sprite = new Sprite(); 
									
		private var _paused:Boolean = false;
		private var _gamePaused:Label = new Label ("Game is paused.", 84, Config.getColor("white","color"), Config.getSetting("font", "settings"), true);
		private var _resumeButton:SimpleButton = new SimpleButton(Assets.getImage("resume"), 
							Assets.getImage("resumehover"), Assets.getImage("resumehover"), Assets.getImage("resume")); 
		
		private var _ufoAlive:Boolean = false;
		private var _ufo:UFO = new UFO(0, 0); 
		
		
		private var _fireSFX:SoundManager = new SoundManager("./assets/fire.mp3"); 
		private var _bangSmall:SoundManager = new SoundManager("./assets/bangSmall.mp3");
		private var _bangMedium:SoundManager = new SoundManager("./assets/bangMedium.mp3");
		private var _bangLarge:SoundManager = new SoundManager("./assets/bangLarge.mp3");
		private var _background:SoundManager = new SoundManager("./assets/backgroundmusic.mp3"); 
		public function PlayState(fsm:Game){
			super(fsm);
			_fsm = fsm; 
			_ship.addEventListener(PlayerShotEvent.PLAYER_SHOT, onPlayerShot, false, 0, true); 
			addChild(_collisions); 
			addEntity(_ship); 
			mouseEnabled = false;
			mouseChildren = false; 
			healthDisplay();
			addChild(_scoreBoard); 
			addChild(_level); 
			_background.playSound();
			
		}
		
		
		public function singleAsteroid():void{
			var noSpawnZone:Number = _ship.radius + 100; 
			var xpos:Number = (Math.random() < .5) 
									? Utils.randomInt(0, _ship.x - noSpawnZone)
									: Utils.randomInt(_ship.x + noSpawnZone, Config.getNumber("width", "world"));
			var ypos:Number = Utils.randomInt(0, Config.getNumber("height", "world"));
			
			var type:Number = Number(Utils.getRandomElementOf([1, .8, .4])); 
			addEntity(new Asteroid(xpos, ypos, type));
			_asteroidCount ++; 
			
		}

		private function getAllEntities(includePlayer:Boolean = false):Vector.<Entity>{
			var entities:Vector.<Entity> = _asteroids.concat(_bullets, _gfx);
			if (includePlayer){
				entities.push(_ship); 
			}
			return entities;
			
		}
		
		
		public function onPlayerShot(e:PlayerShotEvent):void{
			var b:Bullet = new Bullet(e._x, e._y, e._direction); 
			addEntity(new GFXPew(e._x, e._y)); 
			addEntity(b);
			_fireSFX.playSound();
			
		}
		
		public function addEntity(e:core.Entity):void{
			if (e is Bullet){
				_bullets.push(e);
			}else if (e is Asteroid){
				e.addEventListener(AsteroidBreakEvent.ASTEROID_BREAK, onAsteroidBreak, false, 0, true); 
				_asteroids.push(e); 
			}else if (e is GFX){
				_gfx.push(e); 
			}else if (e is UFO){
				_ufos.push(e);
			}
			addChild(e); 
		}
		
		public function onAsteroidBreak(e:AsteroidBreakEvent):void{
			var spawnCount:Number = 0; 
			var newType:Number = Asteroid.TYPE_MEDIUM;
			if (e._type == Asteroid.TYPE_BIG){
				spawnCount = 3; 
				_asteroidCount = _asteroidCount + 3;
				_bangLarge.playSound(); 
			} else if (e._type == Asteroid.TYPE_MEDIUM){
				spawnCount = 2; 
				newType = Asteroid.TYPE_SMALL
				_asteroidCount = _asteroidCount + 2; 
				_bangMedium.playSound(); 
			} else {
				_bangSmall.playSound(); 
			}
			while (spawnCount--){
				addEntity(new Asteroid(e._x, e._y, newType));
			}
			
		}

		override public function update():void{
			var entities:Vector.<Entity> = getAllEntities(true); 
			for each (var entity:Entity in entities){
				entity.update(); 
			}
			checkCollisions();
			removeAllDeadEntities(); 
			_scoreBoard.text = "Score: " + _playerScore; 
			_level.text = "Level: " + _currentLevel; 
			var minAstroidNumber:Number = 4; 
			if (_playerScore < 999){
				
				_scoreBoard.x = 1100 - (_scoreBoard.textWidth * .5);
				_level.x = 1200 - (_scoreBoard.textWidth * .5);
				_level.y = _scoreBoard.y + _level.height; 
			} 
			if (_playerScore > 1000){
				_scoreBoard.x = 1050 - (_scoreBoard.textWidth * .5);
				_level.y = _scoreBoard.y + _level.height; 
			}
			if (_playerScore == 1000){
				minAstroidNumber = 6;
				_currentLevel = 1; 
			} 
			if (_playerScore == 2000){
				minAstroidNumber == 8; 
				_currentLevel = 2; 
			}
			if (_playerScore == 3000){
				minAstroidNumber == 10; 
				_currentLevel = 3; 
			}
			if (_asteroidCount < minAstroidNumber){
				singleAsteroid(); 
			} 
			if (Key.isDown(Key.PAUSE)){
				pause(); 
			}
			
			
		}
		
		public function spawnUFO():void{
		
			_ufo = new UFO(0, 0); 
			addEntity(_ufo); 
			_ufoAlive = false; 
		}
		
		public function ufoShoot(ufo:UFO):void{
			var x:Number = ufo.centerX;
			var y:Number = ufo.centerY; 
			var dx:Number = x - _ship.centerX;
			var dy:Number = y - _ship.centerY;
			var radians:Number = Math.atan2(dy, dx); 
			var dr:Number = ufo.rotation - (radians * Config.TO_DEG);
			
			var b:Bullet = new Bullet(x, y, dr)
			addEntity(b); 
		}
		
	
		private function healthDisplay():void{
			for (var i:int = 0; i < _lives; i++){
				if (i == 0){
					addChild(_healthShip1);
					_healthShip1.x = 20; 
					_healthShip1.y = 20;
				} else if (i == 1){
					addChild(_healthShip2);
					_healthShip2.x = 60; 
					_healthShip2.y = 20;
				} else if (i == 2){
					addChild(_healthShip3);
					_healthShip3.x = 100; 
					_healthShip3.y = 20;
				}
			}
		}
		
		private function checkCollisions():void{
			for each(var a:Asteroid in _asteroids){
				for each(var b:Bullet in _bullets){
					if (b.isColliding(a)){
						b.onCollision(a);
						a.onCollision(b);
						addEntity(new GFXBoom(b.x, b.y)); 
						addEntity(new GFXScreenShake()); 
						_playerScore = _playerScore + 25; 
						_asteroidCount--; 
						break;
					}
				}
				if(_ship.isColliding(a)){
					_ship.onCollision(a);
					a.onCollision(_ship);
					addEntity(new GFXOuch(_ship.centerX, _ship.centerY)); 
					_lives--; 
					if (_lives == 2){
						removeChild(_healthShip3);
					}
					if (_lives == 1){
						removeChild(_healthShip2); 
					}
					if (_lives == 0){
						_fsm.changeState(Game.GAME_OVER_STATE);  
					}
					break;
				}
			}
		}
		
		public function removeDead(entities:Vector.<Entity>):void{
			var temp:Entity;
			for (var i:Number = entities.length-1; i >=0 ; i--){
				temp = entities[i] as Entity; 
				if (!temp._isAlive){
					removeChild(temp); 
					temp.destroy();
					entities.removeAt(i); 
				}
			}
		}
		
		public function removeAllDeadEntities():void{
			removeDead(_bullets);
			removeDead(_asteroids);
			removeDead(_gfx); 
			if (_ship != null){
				if (!_ship._isAlive){
					_ship.destroy();
					removeChild(_ship);
					//signal game over
				}
			}
		}
		
		private function pause():void{
			mouseEnabled = true;
			mouseChildren = true; 
			addChild(_gamePaused); 
			addChild(_gamePaused);
			
			_gamePaused.x = Config.getNumber("center_x", "world") - _gamePaused.textWidth * .5; 
			_gamePaused.y = Config.getNumber("center_y", "world") - _gamePaused.textHeight; 
			
			
			addChild(_resumeButton); 
			_resumeButton.x = Config.getNumber("center_x", "world") -_resumeButton.width * .5;
			_resumeButton.y = _gamePaused.y + _resumeButton.height; 
			_resumeButton.y =0; 
			_resumeButton.addEventListener(MouseEvent.CLICK, resume); 
			
			stage.frameRate = 0; 
		}
		private function resume(e:MouseEvent):void{
			stage.frameRate = 30; 
			
			removeChild(_resumeButton); 
			removeChild(_gamePaused); 
			mouseEnabled = false;
			mouseChildren = false; 
			
		}
		
		override public function destroy():void{
			var entities:Vector.<Entity> = getAllEntities(true);
			for (var i:Number = 0; i < entities.length; i++){
				Entity(entities[i])._isAlive = false; 
			}
			removeAllDeadEntities();
			_ship = null; 
			super.destroy(); 
			_background.stopSound();
			_fireSFX = null; 
			_bangSmall = null; 
			_bangMedium = null; 
			_bangLarge = null; 
			_background = null; 
		}

 
	}

}