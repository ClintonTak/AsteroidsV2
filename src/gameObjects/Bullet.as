package gameObjects {
	import core.Entity;
	import core.Config;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	
	public class Bullet extends Entity {
		private var _ttl:Number = Config.getNumber("time_to_live", "bullet");
		
		public function Bullet(x:Number, y:Number, direction:Number) {
			super(x, y); 
			var radians:Number = direction * Config.TO_RAD; 
			_vx = Math.cos(radians) * Config.getNumber("impulse", "bullet");
			_vy = Math.sin(radians) * Config.getNumber("impulse", "bullet"); 
			draw(); 
		}
		
		public function draw():void{
			graphics.clear(); 
			graphics.lineStyle(Config.getNumber("thickness", "bullet"), Config.getColor("color", "bullet"), 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
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