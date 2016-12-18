package gameObjects {
	import core.Entity;
	import core.Utils;
	import core.Config;
	import events.AsteroidBreakEvent;

	public class UFO extends Entity{
		public static const ASTEROID_BREAK:String = "asteroidBreak"; 
		public static const TYPE_BIG:Number = 1; 
		public static const TYPE_MEDIUM:Number = .8; 
		public static const TYPE_SMALL:Number = .4; 
		public static const DEFAULT_RADIUS:Number = 65;
		public static const DEFAULT_SPEED:Number = 4; 
		private var _radius:Number = 0; 
		private var _type:Number = TYPE_BIG; 
		override public function get radius():Number {return _radius; }
		
		public function UFO(x:Number=0, y:Number=0) {
			super(x, y);
			_vx = 5;
			_vy = -5; 
			_vr = 0; 
			draw(); 
			cacheAsBitmap = true; 
		}
		
		override public function onCollision(that:Entity):void{
			super.onCollision(that);  
		}
		
		private function shoot():void{
			//var nose:Point = localToGlobal(_nose); 
			//dispatchEvent(new PlayerShotEvent(nose.x, nose.y, rotation)); 
			//_nextShot = getTimer() + Config.getNumber("time_between_shots", "ship"); 
		}
		
		public function draw():void{
			graphics.clear();
			graphics.lineStyle(Config.getNumber("line_size", "settings"), _color);
			graphics.drawCircle(0, 0, 40); 
			graphics.drawCircle(0, 0, 20); 
		}
		
	}

}