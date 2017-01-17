package core  {
	import core.SimpleSound;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	
	public class SoundManager {
		
		private static var _instance:SoundManager = null;
		
		public var _backgroundMusic:core.SimpleSound; 
		public var _bangLarge:core.SimpleSound;
		public var _bangMedium:core.SimpleSound;
		public var _bangSmall:core.SimpleSound;
		public var _fire:core.SimpleSound;
		public var _startGame:core.SimpleSound;
		
		private var _sounds:Vector.<core.SimpleSound> = new Vector.<core.SimpleSound>;
		
		public function SoundManager() {}
		
		public static function sharedInstance():SoundManager {
            if (_instance == null) {
                _instance = new SoundManager();
            }
            return _instance;
        }
		
		public function init():void {
			_backgroundMusic = new core.SimpleSound("../bin/assets/backgroundmusic.mp3");
			_bangLarge = new core.SimpleSound("../bin/assets/bangLarge.mp3");
			_bangMedium = new core.SimpleSound("../bin/assets/bangMedium.mp3");
			_bangSmall = new core.SimpleSound("../bin/assets/bangSmall.mp3");
			_fire = new core.SimpleSound("../bin/assets/fire.mp3");
			_startGame = new core.SimpleSound("../bin/assets/startGame.mp3");
			
			_sounds.push(_backgroundMusic);
			_sounds.push(_bangLarge);
			_sounds.push(_bangMedium);
			_sounds.push(_bangSmall);
			_sounds.push(_fire);
			_sounds.push(_startGame);
		}
		
		public function resumeAll():void {
			for each (var sound:core.SimpleSound in _sounds) {
				sound.resume();
			}
		}
		
		public function pauseAll():void {
			for each (var sound:core.SimpleSound in _sounds) {
				sound.pause();
			}
		}

		
		public function stopAll():void {
			SoundMixer.stopAll();
		}
	}
}