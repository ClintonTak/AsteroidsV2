package{
	
	public class Assets{
		[Embed(source = "assets/Chunkfive.otf",fontName = "ChunkFive", mimeType = "application/x-font",
			unicodeRange = "U+0021-U+005a, U+005c-U+005f, U+0061-U+007d", advancedAntiAliasing = "true", embedAsCFF = "false")]
		public var ChunkFiveClass:Class; 

		public function Assets() {
			
		}
		
	}

}