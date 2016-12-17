package gameObjects.gfx{
	import flash.display.DisplayObject; ;
	import core.Config;
	import core.Utils;
	public class GFXBoom extends GFX {
		 
		public function GFXBoom(x:Number=0, y:Number=0) 
		{
			super(x, y, Config.getSetting("text", "gfxboom"), Config.getNumber("size", "gfxboom"), Config.getColor("color", "gfxboom"));
			_vr = Config.getNumber("rotation", "gfxboom");
			
						
		}
		
		override public function update():void{
			super.update(); 
			alpha *= .92; 
			DisplayObject(parent).x; 
			if (alpha < 0.02){
				_isAlive = false; 
				visible = false; 
			}
		}
	}

}