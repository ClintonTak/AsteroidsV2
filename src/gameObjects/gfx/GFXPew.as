package gameObjects.gfx{
	import core.Config;
	import core.Utils;
	public class GFXPew extends GFX {
		private static const minSpeed:Number = -8; 
		private static const maxSpeed:Number = 8 ; 
		public function GFXPew(x:Number=0, y:Number=0, text:String="GFX", size:Number=14, color:uint=0xFFFFFF) 
		{
			super(x, y, "Pew!", 14, Config.WHITE);
			_vx = Utils.randomInt(minSpeed, maxSpeed);
			_vy = Utils.randomInt(minSpeed, maxSpeed); 
						
		}
		
		override public function update():void{
			super.update(); 
			this.alpha *= .85; 
			if (alpha < 0.02){
				_isAlive = false; 
				visible = false; 
			}
		}
	}

}