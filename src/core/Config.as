package core 
{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	
	public class Config 
	{
		
		public function Config(){}
		
		/*public static const BLACK:uint = 0x000000;
		public static const WHITE:uint = 0xFFFFFF;
		public static const RED:uint = 0xFF0000; 
		public static const GREEN:uint = 0x00FF00; 
		public static const BLUE:uint = 0x0000FF;
		public static const LINE_SIZE:int = 2; 
		
		public static const WORLD_WIDTH:Number = 1280;
		public static const WORLD_HEIGHT:Number = 720;
		public static const WORLD_CENTER_X:Number = WORLD_WIDTH * .5;
		public static const WORLD_CENTER_Y:Number = WORLD_HEIGHT * .5;*/
		
		public static const TO_RAD:Number = (Math.PI / 180); 
		public static const TO_DEG:Number = (180 / Math.PI); 
		//public static const DEFAULT_FONT:String = "ChunkFive"
	
		private static var _dispatcher:EventDispatcher = new EventDispatcher(); 
		private static var _data:XML;
		public static var _cache:Object = {}; 
		
		public static function loadConfig():void{
			var loader:URLLoader = new URLLoader(); 
			var url:URLRequest = new URLRequest("settings.xml");
			
			loader.addEventListener(Event.COMPLETE, Config.completeHandler, false, 0, true); 
			loader.addEventListener(Event.OPEN, Config.openHandler, false, 0, true);
			loader.addEventListener(ProgressEvent.PROGRESS, Config.progressHandler, false, 0, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, Config.securityErrorHandler, false, 0, true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, Config.httpStatusHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, Config.ioErrorHandler, false, 0, true);
			
			try{
				loader.load(url); 
			}catch (error:Error){
				trace("Error when loading: " + error);
			}
		}
		
		private static function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            var data:XML = XML(loader.data); 
            Config._data = data; 
			dispatchEvent(event); 
        }
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public static function dispatchEvent(event:Event):Boolean{
			return _dispatcher.dispatchEvent(event); 
		}
		
		public static function hasEventListener(type:String):Boolean{
			return _dispatcher.hasEventListener(type); 
		}
		
		public static function willTrigger(type:String):Boolean{
			return _dispatcher.willTrigger(type); 
		}

        private static function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private static function progressHandler(event:ProgressEvent):void {
            var loadProgress:Number = 0; 
			if (event.bytesTotal != 0){
				loadProgress = event.bytesLoaded / event.bytesTotal; 
			}
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal + " percentage: " + loadProgress);
        }

        private static function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }

        private static function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }

        private static function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }
		
		
		
		public static function getLevel(id:Number):Object{
			var data:Object = {}; 
			var values:XMLList = Config._data["level"].(@id == id.toString2);
			return data; 
		}
		
		
		public static function getSetting(key:String, node:String = ""):String{
			var nodeKey:String = node + key;
			if (_cache[nodeKey] !== undefined){
				return _cache[nodeKey];
			}
			
			var values:XMLList = Config._data[node].attribute(key); 
			if (values.length() != 1){
				trace("Warning: no attribute '" + key + "' for tag '" +node+"'."); 
				return ""; 
			}
			_cache[nodeKey] = values[0].toString(); 
			return _cache[nodeKey]; 
		}
		
		public static function getInt(attribute:String, node:String = ""):int{
			return parseInt(getSetting(attribute, node)); 
		}
		
		public static function getNumber(attribute:String, node:String = ""):Number{
			return parseFloat(getSetting(attribute, node)); 
		}
		
		public static function getBoolean(attribute:String, node:String = ""):Boolean{
			var s:String = getSetting(attribute, node);
			return (s == "1" || s == "true"); 
		}
		
		public static function getColor(attribute:String, node:String = ""):uint{
			return parseInt(getSetting(attribute, node), 16); 
		}
	}

}