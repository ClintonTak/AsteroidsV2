package core {
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import states.PlayState;
	public class Entity extends Sprite {
		public function get halfHeight():Number { return height * 0.5;  }
		public function get halfWidth():Number { return width * 0.5;  }
		public function get centerY():Number {return y + (height * 0.5); }
		public function get centerX():Number {return x + (width * 0.5); }
		public function get bottom():Number{return y + height; }
		public function get right():Number{return x + width; }
		public function get left():Number{return x; }
		public function get top():Number{return y; }
		public function get radius():Number {return (width + height) * 0.25;  }

		public function set centerY(y:Number):void {this.y = y - (height * 0.5); }		
		public function set centerX(x:Number):void {this.x = x - (width * 0.5); }
		public function set bottom(n:Number):void{ y = n - height; }
		public function set right(n:Number):void{ x = n - width; }
		public function set left(n:Number):void{ x = n; }
		public function set top(n:Number):void{ y = n; }
		
		protected var _vx:Number = 0; 
		protected var _vy:Number = 0; 
		protected var _vr:Number = 0; 
		protected var _color:uint = Config.getColor("white", "color"); 
		public var _isAlive:Boolean = true; 
		
		public function Entity(x:Number = 0, y:Number = 0){
			super();
			this.x = x;
			this.y = y; 
		}
		public function reset():void{
			_vx = 0;
			_vy = 0;
			_vr = 0; 
		}
		public function update():void{
			x += _vx;
			y += _vy; 
			rotate(_vr); 
		
			worldWrap(); 
		}
		
		
		public function destroy():void{
			//Clean up any refernce we're holding
			//remove event listeners
			graphics.clear(); 
			
		}
		public function worldWrap():void{
			if (right < 0){
				left = Config.getNumber("width", "world");
			}else if (left > Config.getNumber("width", "world")){
				right = 0; 
			}
			
			if (bottom < 0){
				top = Config.getNumber("height", "world"); 
			}else if (top > Config.getNumber("height", "world")){
				bottom = 0; 
			}
		}
		
		
		public function isColliding(that:Entity):Boolean{
			return (Utils.distanceSq(this, that) < (this.radius * this.radius + that.radius * that.radius)); 
		}
		
		public function onCollision(e:Entity):void{
			_isAlive = false; 
			drawCollisionHull(); //debug new 
		}
		
		protected function drawCollisionHull():void{
			PlayState(parent)._collisions.graphics.lineStyle(1 , 0xFFFF00, .7);
			PlayState(parent)._collisions.graphics.moveTo(centerX, centerY); 
			PlayState(parent)._collisions.graphics.drawCircle(centerX, centerY, this.radius); 
		}
		
		public function rotate(degrees:Number):void{
			var bounds:Rectangle = this.getBounds(this.parent);
			var center:Point = new Point(bounds.x + bounds.width * .5, bounds.y +bounds.height * .5);
			this.rotation += degrees;
			bounds = this.getBounds(this.parent); 
			var newCenter:Point = new Point(bounds.x + bounds.width * .5, bounds.y +bounds.height * .5);
			this.x += center.x - newCenter.x; 
			this.y += center.y - newCenter.y; 
		}
		
		
	}

}