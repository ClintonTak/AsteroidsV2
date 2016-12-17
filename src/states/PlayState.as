package states 
{
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
	
	
	/*
	 * Ship
	 * 	add the engine flame
	 * bullets
	 * 	custom event dispatch
	 * 	make key an event dispatcher
	 * 	projecting positions
	 * asteroids
	 * 	break into smaller parts
	 * collisions 
	 * 	circle circle
	 * 	line circle
	 * fgx
	 * dynamic config 
	 * 	getsetting()/ getvar()
	 * loadsettingsfrom cml
	 *
	 * */

	public class PlayState extends State{
		private var _bullets:Vector.<Entity> = new Vector.<Entity>; 
		private var _asteroids:Vector.<Entity> = new Vector.<Entity>;
		private var _gfx:Vector.<Entity> = new Vector.<Entity>;
		private var _ship:Ship = new Ship( Config.getNumber("width", "world") * .5, Config.getNumber("height", "world") * .5); 
		private const TO_SPAWN:Array = [Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_BIG,
										Asteroid.TYPE_SMALL, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_SMALL];
		public var _collisions:Sprite = new Sprite(); 
										
		public function PlayState(fsm:Game){
			super(fsm);
			 _ship.addEventListener(PlayerShotEvent.PLAYER_SHOT, onPlayerShot, false, 0, true); 
			Key.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addChild(_collisions); 
			addEntity(_ship); 
			mouseEnabled = false;
			mouseChildren = false; 
			spawnAsteroids();
		}
		public function onKeyDown(e:KeyboardEvent):void{
			if (e.keyCode == Keyboard.R){
				spawnAsteroids(); 
			}
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
			} else if (e._type == Asteroid.TYPE_MEDIUM){
				spawnCount = 2; 
				newType = Asteroid.TYPE_SMALL
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
		}
		
		private function checkCollisions():void{
			for each(var a:Asteroid in _asteroids){
				for each(var b:Bullet in _bullets){
					if (b.isColliding(a)){
						b.onCollision(a);
						a.onCollision(b);
						addEntity(new GFXBoom(b.x, b.y)); 
						addEntity(new GFXScreenShake()); 
						break;
					}
				}
				if(_ship.isColliding(a)){
					_ship.onCollision(a);
					a.onCollision(_ship);
					addEntity(new GFXOuch(_ship.centerX, _ship.centerY)); 
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
			if (!_ship._isAlive){
				_ship.destroy();
				removeChild(_ship);
				//signal game over
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