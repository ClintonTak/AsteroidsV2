package gameObjects.gfx{
	import flash.display.DisplayObject; ;
	import core.Config;
	import core.Utils;
	public class GFXBoom extends GFX {
		private static const minSpeed:Number = -16; 
		private static const maxSpeed:Number = 16 ; 
		public function GFXBoom(x:Number=0, y:Number=0, text:String="GFX", size:Number=14, color:uint=0xFFFFFF) 
		{
			super(x, y, "BOOM!", 14, Config.WHITE);
			_vr = 16;
			
						
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