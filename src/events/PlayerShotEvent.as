package events {
	import flash.events.Event;
	
	public class PlayerShotEvent extends Event 
	{
		public static var PLAYER_SHOT:String = "playerShotEvent"; 
		public var _x:Number = 0; 
		public var _y:Number = 0; 
		public var _direction:Number = 0; 
		public var _parentVX:Number = 0; 
		public var _parentVY:Number = 0; 
		
		public function PlayerShotEvent(x:Number, y:Number, direction:Number, parentVX:Number = 0, parentVY:Number = 0 ) 
		{
			super(PLAYER_SHOT, false, false);
			_x = x;
			_y = y; 
			_direction = direction; 
			_parentVX = parentVX;
			_parentVY = parentVY; 
		}
		
		override public function clone():Event{
			return new PlayerShotEvent(_x, _y, _direction, _parentVX, _parentVY); 
		}
	}

}