package gameObjects.gfx{
	import core.Config;
	import core.Utils;
	public class GFXPew extends GFX {
		public function GFXPew(x:Number=0, y:Number=0) 
		{
			super(x, y, Config.getSetting("text","gfxpew"), Config.getNumber("size", "gfxpew"), Config.getColor("color", "gfxpew"));
			_vx = Utils.randomInt(Config.getNumber("minSpeed", "gfxpew"), Config.getNumber("maxSpeed", "gfxpew"));
			_vy = Utils.randomInt(Config.getNumber("minSpeed", "gfxpew"), Config.getNumber("maxSpeed", "gfxpew")); 
			
						
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