package com.boyaa.debug.Logging
{
   import com.boyaa.AntwarsMobileId.AntwarsMobileIdTool;
   import com.boyaa.debug.Debug;
   import com.freshplanet.ane.AirAlert.AirAlert;
   import flash.events.EventDispatcher;
   
   public class LevelLogger extends EventDispatcher implements ILogger
   {
      
      public static var outputEnabled:Boolean = true;
      
      private static var _antTool:AntwarsMobileIdTool = null;
      
      private var _category:String;
      
      public function LevelLogger(param1:String)
      {
         super();
         _category = param1;
      }
      
      public static function getLogger(param1:String) : LevelLogger
      {
         return new LevelLogger(param1);
      }
      
      public function get category() : String
      {
         return _category;
      }
      
      public function log(param1:int, param2:String, ... rest) : void
      {
         throw new Error("Please use debug,error,fatal,info, or warn");
      }
      
      public function debug(param1:String, ... rest) : void
      {
         printMessage("DEBUG",param1,rest);
      }
      
      public function error(param1:String, ... rest) : void
      {
         printMessage("ERROR",param1,rest);
      }
      
      public function fatal(param1:String, ... rest) : void
      {
         printMessage("FATAL",param1,rest);
      }
      
      public function info(param1:String, ... rest) : void
      {
         printMessage("INFO",param1,rest);
      }
      
      public function warn(param1:String, ... rest) : void
      {
         printMessage("WARNNING",param1,rest);
      }
      
      private function printMessage(param1:String, param2:String, param3:Array) : void
      {
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param3.length)
         {
            param2 = param2.replace(new RegExp("\\{" + _loc4_ + "\\}","g"),param3[_loc4_]);
            _loc4_++;
         }
         if(outputEnabled)
         {
            Debug.debug("[" + param1 + "][" + category + "]: " + param2);
            printMsgInPhone("[" + param1 + "][" + category + "]: " + param2);
         }
      }
      
      private function printMsgInPhone(param1:String) : void
      {
         if(!AirAlert.isSupported)
         {
            return;
         }
         if(Constants.lanVersion != 3)
         {
            return;
         }
         if(!_antTool)
         {
            _antTool = new AntwarsMobileIdTool();
            _antTool.init();
         }
         _antTool.test(param1);
      }
   }
}

