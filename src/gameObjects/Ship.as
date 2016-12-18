package gameObjects {
	import core.Entity;
	import core.Config;
	import core.Key;
	import core.Utils;
	import events.PlayerShotEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.*;
	public class Ship extends Entity {
		private var _thrust:Number = 0; 
		private var _friction:Number = 0.97;
		
		private var _rearRight:Point = new Point(0, 0); 
		private var _nose:Point = new Point(Config.getNumber("width", "ship"), Config.getNumber("height", "ship") * .5 ); 
		private var _rearLeft:Point = new Point(0,  Config.getNumber("height", "ship")); 
		private var _engineHole:Point = new Point(Config.getNumber("width", "ship")*.125, Config.getNumber("height", "ship") * .5); 
		private var _nextShot:Number = getTimer() + Config.getNumber("time_between_shots", "ship"); 
		
		private var _playerLives:Number = 3; 
		//private var _isAlive = true; 
		
		public function Ship(x:Number = 0, y:Number = 0) {
			super(x, y);
		}
		
		override public function update():void{
			checkInput(); 
			var radians:Number = rotation * Config.TO_RAD; 
			var ax:Number = Math.cos(radians) *  _thrust; 
			var ay:Number = Math.sin(radians) * _thrust; 
			if (_thrust){
				_vx += ax; 
				_vy += ay; 
			}
			_vx *= _friction;
			_vy *= _friction;
			_vr *= _friction;
			draw(); 
			if (_thrust){
				drawFlame(); 
			}
			super.update(); 
		}
		
		private function checkInput():void{
			if (Key.isDown(Key.SHOOT) && getTimer()> _nextShot){
				shoot(); 
			}
			if (Key.isDown(Key.LEFT)){
				_vr = -10; 
			} else if (Key.isDown(Key.RIGHT)){
				_vr = 10; 
			} else{
				_vr = 0; 
			}
			if (Key.isDown(Key.ACCELERATE)){
				_thrust = 1; 
			}else {
				_thrust = 0; 
			}
		}
		
		override public function isColliding(that:Entity):Boolean{
			if (!super.isColliding(that)){
				return false; 
				
			}
			var nose:Point = localToGlobal(_nose); 
			var rr:Point = localToGlobal(_rearRight); 
			var rl:Point = localToGlobal(_rearLeft);
				
			if (Utils.lineCircleIntersection(nose, rr, that)){
				return true; 
			}else if (Utils.lineCircleIntersection(nose, rl, that)){
				return true; 
			}
			return false; 
		}
		
		override public function onCollision(e:Entity):void{
			//_isAlive = false; 
			//drawCollisionHull(); //debug new 
		}
		
		override protected function drawCollisionHull():void{
			super.drawCollisionHull();
			
		}
		
		private function shoot():void{
			var nose:Point = localToGlobal(_nose); 
			dispatchEvent(new PlayerShotEvent(nose.x, nose.y, rotation)); 
			_nextShot = getTimer() + Config.getNumber("time_between_shots", "ship"); 
		}
		
		public function draw():void{
			graphics.clear();
			graphics.lineStyle(Config.getNumber("line_size", "settings"), _color); 
			graphics.moveTo( _rearRight.x, _rearRight.y);
			graphics.lineTo( _nose.x, _nose.y); 
			graphics.lineTo( _rearLeft.x, _rearLeft.y); 
			graphics.lineTo( _engineHole.x, _engineHole.y);
			graphics.lineTo( _rearRight.x, _rearRight.y);
		}
		
		public function drawFlame():void{
			graphics.lineStyle(Config.getNumber("line_size", "settings"), _color);
			var h:Number = Config.getNumber("height", "ship"); 
			var l:Number = Utils.randomInt(4, 15); 
			graphics.moveTo(2, 1); 
			graphics.lineTo( -l, h * .5); 
			graphics.lineTo( 2, h - 1); 
		}
		
		override public function destroy():void{
			
			graphics.clear();
		}
		
	}

}