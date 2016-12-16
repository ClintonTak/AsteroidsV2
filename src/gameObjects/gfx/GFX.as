package gameObjects.gfx {
	import core.Entity;
	import ui.Label; 
	import flash.text.TextFormat; 
	
	public class GFX extends Entity{
		protected var _label:Label; 
		
		public function GFX(x:Number = 0, y:Number = 0, text:String = "GFX", size:Number = 14, color:uint = 0xFFFFFF ) {
			super(x, y);
			_label = new Label(text, size, color, "ChunkFive", true);
			addChild(_label);
			_label.x = -(_label.width * .5); 
			_label.y = -(_label.height * .5); 
		}
		
		public function setFormat(format:TextFormat):void{
			_label.setTextFormat(format); 
			_label.refresh();
			_label.x = -(_label.width * .5); 
			_label.y = -(_label.height * .5); 
			
		}
		
		override public function isColliding(that:Entity):Boolean{
			return false; 
		}
		
		override public function destroy():void{
			removeChild(_label); 
			//_label.destroy(); 
			_label = null; 
		}
	}
}