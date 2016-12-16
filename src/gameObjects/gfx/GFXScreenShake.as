package gameObjects.gfx {
	
	public class GFXScreenShake extends GFX {
		private var _shakeSize:Number = 7; 
		
		public function GFXScreenShake(){
			super();
			//removeChild(_label); 
			//_label = null; 
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