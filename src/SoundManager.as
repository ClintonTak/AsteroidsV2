package {
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import core.Config;

	public class SoundManager{
		private var _sound:Sound;
		private var _channel:SoundChannel; 
		
		
		
		
		public function SoundManager(){
			super();
			_sound = new Sound(new URLRequest("fire.mp3"));
		}
		
		public function playSound ():void{
			_channel =  _sound.play(); 
			var transform:SoundTransform = new SoundTransform(1, 0); 
			var leftSize:Number = Config.getNumber("width", "world");  
			var rightSize:Number = Config.getNumber("width", "world");  
			_channel.soundTransform = transform;
		}
		
		public function stopSound():void{
			_channel.stop();
		}
		
		public function update():void{
		}

		public function destroy():void{
			_sound = null; 
			_channel = null; 
		}
	
 
	}

}