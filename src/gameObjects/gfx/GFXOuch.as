package gameObjects.gfx{
	import core.Config;
	import core.Utils;
	public class GFXOuch extends GFX { 
		public function GFXOuch(x:Number=0, y:Number=0, text:String="GFX", size:Number=14, color:uint=0xFFFFFF) 
		{
			super(x, y, "Ouch!", 14, Config.WHITE);
			_vr = 16;
			
						
		}
		
		override public function update():void{
			super.update(); 
			scaleX *= 1.05; 
			scaleY *= 1.05; 
			alpha *= .92; 
			if (alpha < 0.02){
				_isAlive = false; 
				visible = false; 
			}
		}
	}

}