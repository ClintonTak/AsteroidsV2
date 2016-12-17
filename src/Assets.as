package{
	import flash.display.Bitmap;
	public class Assets{
		public function Assets() {}
		
		[Embed(source = "assets/Chunkfive.otf",fontName = "ChunkFive", mimeType = "application/x-font",
			unicodeRange = "U+0021-U+005a, U+005c-U+005f, U+0061-U+007d", advancedAntiAliasing = "true", embedAsCFF = "false")]
		public var ChunkFiveClass:Class; 

		
		[Embed(source = "assets/PlayButton.png")]
		private static const PlayButton:Class;
		[Embed(source = "assets/InstructionsButton.png")]
		private static const InstructionsButton:Class;
		[Embed(source = "assets/HighScoresButton.png")]
		private static const HighScoresButton:Class;
		
		[Embed(source = "assets/PlayButtonHover.png")]
		private static const PlayButtonHover:Class;
		[Embed(source = "assets/InstructionsButtonHover.png")]
		private static const InstructionsButtonHover:Class;
		[Embed(source = "assets/HighScoresButtonHover.png")]
		private static const HighScoresButtonHover:Class;
		
		[Embed(source = "assets/BackButton.png")]
		private static const BackButton:Class;
		
		[Embed(source = "assets/BackButton.png")]
		private static const ButtonNormal:Class;
		
		[Embed(source = "assets/WASD.png")]
		private static const WASD:Class
		
		[Embed(source = "assets/ship.png")]
		private static const Ship:Class
		
		public static function getImage(n:String):Bitmap{
			var imgClass:Class = ButtonNormal; 
			if (n == "play"){
				imgClass = PlayButton;
			} else if (n == "instructions"){
				imgClass = InstructionsButton; 
			} else if ( n == "highscores"){
				imgClass = HighScoresButton; 
			} else if (n == "back"){
				imgClass = BackButton; 
			} else if (n == "playhover"){
				imgClass = PlayButtonHover; 
			} else if (n == "instructionshover"){
				imgClass = InstructionsButtonHover
			} else if (n == "highscoreshover"){
				imgClass = HighScoresButtonHover
			} else if (n == "wasd"){
				imgClass = WASD; 
			} else if (n == "ship"){
				imgClass = Ship; 
			}
			return new imgClass() as Bitmap;
		}
		
	}

}