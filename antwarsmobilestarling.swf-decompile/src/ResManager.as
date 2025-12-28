package
{
   import com.boyaa.tool.ForceUpdateGame;
   // import com.coltware.airxzip.ZipEntry;
   // import com.coltware.airxzip.ZipFileReader;
   import com.freshplanet.ane.AirAlert.AirAlert;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   // import flash.filesystem.File; // REMOVED FOR WEB
   // import flash.filesystem.FileStream; // REMOVED FOR WEB
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   
   public class ResManager
   {
      
      public static const CHANGERLOG:String = "ChangerLog.xml";
      
      private var serverXML:XML;
      
      private var localXML:XML;
      
      private var packageXML:XML;
      
      private var needUpdateFile:Vector.<String>;
      
      private var needDeleteFile:Vector.<String>;
      
      private var onProgress:Function;
      
      private var serverXMLBytes:ByteArray;
      
      private var completeCount:int = 0;
      
      private var needComplete:int = 0;
      
      public var localVersion:int = 0;
      
      public var serverVersion:int = 0;
      
      public var packageVersion:int = 0;
      
      private var _forceUpdate:String = "";
      
      private var numElements:Number = 0;
      
      private var currentRatio:Number = 0;
      
      private var display:TextField;
      
      public function ResManager()
      {
         super();
      }
      
      public function update(param1:Function) : void
      {
         // SIMPLIFIED UPDATE LOGIC FOR WEB
         // Just fetch the changelog via HTTP and proceed

         needComplete = 0;
         completeCount = 0;
         localXML = null;
         serverXML = null;
         packageXML = null;
         this.onProgress = param1;

         var _loc4_:URLLoader = new URLLoader();
         _loc4_.dataFormat = "binary";
         _loc4_.addEventListener("ioError",getXMLIoError);
         _loc4_.addEventListener("complete",onUrlLoaderComplete);
         _loc4_.load(new URLRequest(Constants.ResUrl + "/" + "ChangerLog.xml"));

         // No local file checking
      }
      
      private function getXMLIoError(param1:IOErrorEvent) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         _loc2_.removeEventListener("ioError",getXMLIoError);
         Application.instance.log("IO error: ",param1.text);
         log("xml reader error: " + param1.text);
         // Auto complete to bypass blocking
         onProgress(1);
      }
      
      private function onUrlLoaderComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         serverXMLBytes = _loc2_.data as ByteArray;
         _loc2_.removeEventListener("complete",onUrlLoaderComplete);
         serverXML = new XML(serverXMLBytes);
         complete();
      }
      
      private function onFileLoaderComplete(param1:Event) : void
      {
         // REMOVED
      }
      
      private function onFileLoaderComplete2(param1:Event) : void
      {
         // REMOVED
      }
      
      private function complete() : void
      {
         // WEB MODE: Skip all file checking/saving logic
         // Just assume we have the assets on the web server or load them on demand via Starling's AssetManager

         if(onProgress != null)
         {
            onProgress(1);
         }
      }
      
      private function loadRaw(param1:String, param2:Function, param3:Function) : void
      {
         // REMOVED
      }
      
      private function resume() : void
      {
         // REMOVED
      }
      
      private function progress(param1:Number) : void
      {
         // REMOVED
      }
      
      private function saveFile(param1:String, param2:ByteArray) : void
      {
         // REMOVED: Cannot save files in Web/Ruffle
      }
      
      public function getAllResByDir(param1:Array) : Array
      {
         // Stubbed to return empty or manage via XML listing
         // Since we can't list directories on Web without an index,
         // we might need to rely on what Starling AssetManager does.
         // For now, return empty array to prevent crash.
         return [];
      }
      
      public function getResFile(param1:String) : *
      {
         // Always return URL for Web
         return Constants.ResUrl + "/" + param1;
      }
      
      private function log(param1:String) : void
      {
         var _loc2_:TextFormat = null;
         if(!display)
         {
            display = new TextField();
            display.textColor = 16777215;
            display.autoSize = "center";
            _loc2_ = new TextFormat();
            _loc2_.size = 22;
            display.defaultTextFormat = _loc2_;
            display.y = (Application.instance.viewPort.height >> 1) + 10;
            Application.instance.currentMain.stage.addChild(display);
         }
         display.text = param1;
         display.x = Application.instance.viewPort.width - 460 >> 1;
      }
   }
}
