package ui{
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Label extends TextField{
		
		private var _format:TextFormat; 
		public function Label(text:String, size:Number = 14, color:uint = 0xFFFFFF, fontName:String = "Verdana", embedFonts:Boolean = false){
			super();
			_format = new TextFormat(); 
			_format.font = fontName; 
			_format.color = color; 
			_format.size = size; 
			_format.align = TextFormatAlign.LEFT;
			this.defaultTextFormat = _format; 
			this.embedFonts = embedFonts;
			this.antiAliasType = AntiAliasType.ADVANCED; 
			this.autoSize = TextFieldAutoSize.LEFT;
			this.multiline = false; 
			this.cacheAsBitmap = true; 
			this.selectable = false; 
			this.text = text; 
			
		}
		
		public function set format(format:TextFormat):void{
			_format = format; 
			refresh(); 
		}
		
		public function get format():TextFormat{
			return _format; 
		}
		
		public function refresh():void{
			this.setTextFormat(_format); 
		}
	}

}