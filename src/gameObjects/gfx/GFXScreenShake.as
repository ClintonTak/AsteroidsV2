package gameObjects.gfx {
	import core.Config;
	public class GFXScreenShake extends GFX {
		private var _shakeSize:Number = Config.getNumber("shakeSize", "gfxscreenshake"); 
		
		public function GFXScreenShake(){
			super();
		
		}
		
		override public function update():void{
			if (_shakeSize < 0){
				_isAlive = false;
				return; 
			}
			var odd:int = _shakeSize % 2; 
			var moveTo:Number = (odd) ? _shakeSize : -_shakeSize; 
			parent.x = moveTo; 
			parent.y = moveTo; 
			_shakeSize--;
		}
	}
}