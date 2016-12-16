package gameObjects {
	import core.Entity;
	import core.Config;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	
	public class Bullet extends Entity {
		private var _ttl:Number = Config.BULLET_TIME_TO_LIVE;
		
		public function Bullet(x:Number, y:Number, direction:Number) {
			super(x, y); 
			var radians:Number = direction * Config.TO_RAD; 
			_vx = Math.cos(radians) * Config.BULLET_IMPULSE;
			_vy = Math.sin(radians) * Config.BULLET_IMPULSE; 
			draw(); 
		}
		
		public function draw():void{
			graphics.clear(); 
			graphics.lineStyle(4, _color, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
			graphics.lineTo(.5, 0);
			cacheAsBitmap = true;
		}
		
		override public function update():void{
			if ( _ttl-- < 0){
				_isAlive = false; 
			} 
			super.update(); 
		}
	}

}