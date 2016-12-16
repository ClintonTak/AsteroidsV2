package core {
	import core.Entity;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class Utils {
		
		public function Utils() 
		{
			
		}
		public static function randomInt(min:Number, max:Number):Number{
			return Math.floor(Math.random() * (max - min + 1)) + min; 
		}
		public static function random(min:Number, max:Number):Number{
			return Math.random() * (max - min + 1) + min; 
		}
		
		public static function lineCircleIntersection(lineStart:Point, lineEnd:Point, entity:Entity):Boolean{
			var angle:Number = Math.atan2((lineEnd.y - lineStart.y), (lineEnd.x - lineStart.y));
			var dx:Number = entity.centerX-((lineStart.x + lineEnd.x) * .5);
			var dy:Number = entity.centerY-((lineStart.y + lineEnd.y) * .5); 
			return (Math.abs(Math.cos(angle) * dy - Math.sin(angle) * dx) < entity.radius); 
		}
		//AABB intersection test
		public static function intersectsAABB(lhs:core.Entity, rhs:core.Entity):Boolean {
			return !(lhs.right < rhs.left
					|| rhs.right < lhs.left
					|| lhs.bottom < rhs.top
					|| rhs.bottom < lhs.top);
		}
		
		public static function distanceSq(lhs:Entity, rhs:Entity):Number{
			var dx:Number = lhs.centerX - rhs.centerX;
			var dy:Number = lhs.centerY - rhs.centerY; 
			return(dx * dx + dy * dy); 
		}
		
		public static function distance(lhs:Entity, rhs:Entity):Number{
			var dx:Number = lhs.centerX - rhs.centerX;
			var dy:Number = lhs.centerY - rhs.centerY; 
			return Math.sqrt(dx * dx + dy * dy); 
		}
		
		//SAT intersection test. http://www.metanetsoftware.com/technique/tutorialA.html
		//returns true on intersection, and sets the least intersecting axis in overlap
		public static function getOverlap(e1:core.Entity, e2:core.Entity, overlap:Point):Boolean {
			overlap.setTo(0, 0);
			var centerDeltaX:Number = e1.centerX - e2.centerX;
			var halfWidths:Number = (e1.width + e2.width) * 0.5;
		 
			if (Math.abs(centerDeltaX) > halfWidths) return false; //no overlap on x == no collision
		 
			var centerDeltaY:Number = e1.centerY - e2.centerY;
			var halfHeights:Number = (e1.height + e2.height) * 0.5;
		 
			if (Math.abs(centerDeltaY) > halfHeights) return false; //no overlap on y == no collision
		 
			var dx:Number = halfWidths - Math.abs(centerDeltaX); //overlap on x
			var dy:Number = halfHeights - Math.abs(centerDeltaY); //overlap on y
			if (dy < dx) {
				overlap.y = (centerDeltaY < 0) ? -dy : dy;
			} else if (dy > dx) {
				overlap.x = (centerDeltaX < 0) ? -dx : dx;
			} else {
				overlap.x = (centerDeltaX < 0) ? -dx : dx;
				overlap.y = (centerDeltaY < 0) ? -dy : dy;
			}
			return true;
		}
		
	}

}