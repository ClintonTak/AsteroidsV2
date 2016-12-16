package core 
{
	/**
	 * ...
	 * @author Clinton Tak
	 */
	public class Config 
	{
		
		public function Config(){}
		
		public static const BLACK:uint = 0x000000;
		public static const WHITE:uint = 0xFFFFFF;
		public static const RED:uint = 0xFF0000; 
		public static const GREEN:uint = 0x00FF00; 
		public static const BLUE:uint = 0x0000FF;
		public static const LINE_SIZE:int = 2; 
		
		public static const WORLD_WIDTH:Number = 1280;
		public static const WORLD_HEIGHT:Number = 720;
		public static const WORLD_CENTER_X:Number = WORLD_WIDTH * .5;
		public static const WORLD_CENTER_Y:Number = WORLD_HEIGHT * .5;
		
		public static const SHIP_HEIGHT:Number = 15; 
		public static const SHIP_WIDTH:Number = 25; 
		public static const SHIP_THRUST:Number = 1.25; // increae of acceleration per frame
		public static const SHIP_ROTATIONAL_THRUST:Number = 8;//in degrees
		public static const BULLET_IMPULSE:Number = 10; //pixels per frmae 
		public static const TIME_BETWEEN_SHOTS:Number = 80; 
		public static const BULLET_TIME_TO_LIVE:Number = 90; //frames
		
		public static const TO_RAD:Number = (Math.PI / 180); 
		public static const TO_DEG:Number = (180 / Math.PI); 
		//public static const DEFAULT_FONT:String = "ChunkFive"
	
		public static var config:XML = 
			<settings ship_width = "25" ship_height = "15" ship_thrus = "1.25" >
			< ship color = "0xFFFFFF" width = "25" height = "25" thrust = "1.25" rotational_thrust = "8" />
			< GFXBoom color = "0xD200D2" />
			</settings>; 
			
		public static function getSetting(propertyName:String, node:String = ""):String{
			var values:XMLList = null; 
			if (node != ""){
				values = Config.config[node]. attribute(propertyName);
			}else {
				values = Config.config.attribute(propertyName);
			}
			trace(values); 
			return values.toString(); 
			
		}
	}

}