package gameObjects {
	import core.Entity;
	import core.Utils;
	import core.Config;
	import events.AsteroidBreakEvent;
	/**
	 * ...
	 * @author Clinton Tak
	 */
	public class Asteroid extends Entity{
		public static const ASTEROID_BREAK:String = "asteroidBreak"; 
		public static const TYPE_BIG:Number = 1; 
		public static const TYPE_MEDIUM:Number = .8; 
		public static const TYPE_SMALL:Number = .4; 
		public static const DEFAULT_RADIUS:Number = 65;
		public static const DEFAULT_SPEED:Number = 4; 
		private var _radius:Number = 0; 
		private var _type:Number = TYPE_BIG; 
		override public function get radius():Number {return _radius; }
		
		public function Asteroid(x:Number=0, y:Number=0, type:Number = 0) {
			super(x, y);
			_type = type; 
			_radius = type * DEFAULT_RADIUS;
			var maxSpeed:Number = DEFAULT_SPEED / type;
			_vx = Utils.random( -maxSpeed, maxSpeed);
			_vy = Utils.random( -maxSpeed, maxSpeed); 
			_vr = 0; 
			draw(); 
			cacheAsBitmap = true; 
		}
		
		override public function onCollision(that:Entity):void{
			super.onCollision(that);  
			dispatchEvent(new AsteroidBreakEvent(centerX, centerY, _type));
		}
		public function draw():void{
			graphics.clear();
			graphics.lineStyle(Config.getNumber("line_size", "settings"), _color);
			graphics.drawCircle(_radius, _radius, _radius); 
		}
		
	}

}