package core   {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class SimpleSound extends Sound {
		private var _position:Number = 0;
		private var _channel:SoundChannel;
		private var _transform:SoundTransform;
		private var _loop:Number = 0;
		
		public function SimpleSound(url:String) {
			addEventListener(IOErrorEvent.IO_ERROR, error);
			addEventListener(Event.COMPLETE, onLoaded);
			
			super(new URLRequest(url));
		}
		
		private function error(e:IOErrorEvent):void {
			trace("SOUND ERROR");
		}
		
		private function onLoaded(e:Event):void {
			//trace("SOUND LOADED");
		}
		
		public function playSound(position:Number = 0, loop:Number = 0):void {
			_loop = loop;
			_channel = play(position);
			_channel.addEventListener(Event.SOUND_COMPLETE, soundComplete)
		}
		
		public function stop():void {
			_channel.stop();
		}
		
		public function pause():void {
			if (_channel != null) {
				_position = _channel.position;
				stop();
			}
		}
		
		public function resume():void {
			if (_channel != null && _position != 0) {
				playSound(_position, _loop);
				//_channel.soundTransform = _transform;
			}
		}
		
		public function soundComplete(e:Event):void {
			dispatchEvent(e);
			if (_loop > 0) {
				_loop--;
				playSound(0, _loop);
			}
		}
	}
	
}