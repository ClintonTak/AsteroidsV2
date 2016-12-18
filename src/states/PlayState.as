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
	import gameObjects.Bullet;
	import gameObjects.Ship;
	import events.PlayerShotEvent;
	import gameObjects.Asteroid;
	import flash.ui.Keyboard;
	import gameObjects.gfx.GFX;
	import gameObjects.gfx.GFXPew;
	import gameObjects.gfx.GFXBoom;
	import gameObjects.gfx.GFXOuch;
	import gameObjects.gfx.GFXScreenShake;
	import Assets;
	import flash.display.SimpleButton;
	import ui.Label;
	import flash.utils.Timer;

	public class PlayState extends State{
		private var _asteroidCount:Number = 0; 
		private var _playerScore:Number = 0; 
		private var _scoreBoard:Label = new Label("Score: 0", 56, Config.getColor("white", "color") , Config.getSetting("font", "settings") , true); 
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
		private var _ship:Ship = new Ship( Config.getNumber("width", "world") * .5, Config.getNumber("height", "world") * .5); 
		private const TO_SPAWN:Array = [Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_BIG,
										Asteroid.TYPE_SMALL, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_SMALL];
		public var _collisions:Sprite = new Sprite(); 
		private var _gameAlive:Boolean = true; 								
		public function PlayState(fsm:Game){
			super(fsm);
			_fsm = fsm; 
			_ship.addEventListener(PlayerShotEvent.PLAYER_SHOT, onPlayerShot, false, 0, true); 
			addChild(_collisions); 
			addEntity(_ship); 
			mouseEnabled = false;
			mouseChildren = false; 
			//spawnAsteroids();
			healthDisplay();
			addChild(_scoreBoard); 
			
			
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
			//_minuteTimer = new Timer(1000, 5); 
			//_minuteTimer.start(); 
		}

		private function getAllEntities(includePlayer:Boolean = false):Vector.<Entity>{
			var entities:Vector.<Entity> = _asteroids.concat(_bullets, _gfx);
			if (includePlayer){
				entities.push(_ship); 
			}
			return entities;
			
		}
		public function spawnAsteroids():void{
			var noSpawnZone:Number = _ship.radius + 100; 
			
			for each (var i:Number in TO_SPAWN){
				var xpos:Number = (Math.random() < .5) 
									? Utils.randomInt(0, _ship.x - noSpawnZone)
									: Utils.randomInt(_ship.x + noSpawnZone, Config.getNumber("width", "world"));
				var ypos:Number = Utils.randomInt(0, Config.getNumber("height", "world")); 
				addEntity(new Asteroid(xpos, ypos, i)); 
				//_asteroidCount++;
			}
			
			 
		}
		
		public function onPlayerShot(e:PlayerShotEvent):void{
			var b:Bullet = new Bullet(e._x, e._y, e._direction); 
			addEntity(new GFXPew(e._x, e._y)); 
			addEntity(b);
			
		}
		
		public function addEntity(e:core.Entity):void{
			if (e is Bullet){
				_bullets.push(e);
			}else if (e is Asteroid){
				e.addEventListener(AsteroidBreakEvent.ASTEROID_BREAK, onAsteroidBreak, false, 0, true); 
				_asteroids.push(e); 
			}else if (e is GFX){
				_gfx.push(e); 
			}
			addChild(e); 
		}
		
		public function onAsteroidBreak(e:AsteroidBreakEvent):void{
			var spawnCount:Number = 0; 
			var newType:Number = Asteroid.TYPE_MEDIUM;
			if (e._type == Asteroid.TYPE_BIG){
				spawnCount = 3; 
				_asteroidCount = _asteroidCount + 3; 
			} else if (e._type == Asteroid.TYPE_MEDIUM){
				spawnCount = 2; 
				newType = Asteroid.TYPE_SMALL
				_asteroidCount = _asteroidCount + 2; 
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
			if (_playerScore < 999){
				
				_scoreBoard.x = 1100 - (_scoreBoard.textWidth * .5);
			} 
			if (_playerScore > 1000){
				_scoreBoard.x = 1000 - (_scoreBoard.textWidth * .5);
			}
			
			if (_asteroidCount < 7){
				singleAsteroid(); 
			}
			trace(_asteroidCount); 
			
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
			//walk through each _bullet
				// walk through each _asteroid
				// if bullet [i] is colloding with astroid [j]
					//kill bullet
					//split asteroid 
				//else check if asteroid is colliding with the ship
					//take away health? 
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

		override public function destroy():void{
			var entities:Vector.<Entity> = getAllEntities(true);
			for (var i:Number = 0; i < entities.length; i++){
				Entity(entities[i])._isAlive = false; 
			}
			removeAllDeadEntities();
			_ship = null; 
			super.destroy(); 
		}

 
	}

}