package mx.logging
{
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   public class LogLogger extends EventDispatcher implements ILogger
   {
      
      mx_internal static const VERSION:String = "3.4.1.10084";
      
      private var _category:String;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function LogLogger(param1:String)
      {
         super();
         _category = param1;
      }
      
      public function log(param1:int, param2:String, ... rest) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(param1 < LogEventLevel.DEBUG)
         {
            _loc4_ = resourceManager.getString("logging","levelLimit");
            throw new ArgumentError(_loc4_);
         }
         if(hasEventListener(LogEvent.LOG))
         {
            _loc5_ = 0;
            while(_loc5_ < rest.length)
            {
               param2 = param2.replace(new RegExp("\\{" + _loc5_ + "\\}","g"),rest[_loc5_]);
               _loc5_++;
            }
            dispatchEvent(new LogEvent(param2,param1));
         }
      }
      
      public function error(param1:String, ... rest) : void
      {
         var _loc3_:int = 0;
         if(hasEventListener(LogEvent.LOG))
         {
            _loc3_ = 0;
            while(_loc3_ < rest.length)
            {
               param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),rest[_loc3_]);
               _loc3_++;
            }
            dispatchEvent(new LogEvent(param1,LogEventLevel.ERROR));
         }
      }
      
      public function warn(param1:String, ... rest) : void
      {
         var _loc3_:int = 0;
         if(hasEventListener(LogEvent.LOG))
         {
            _loc3_ = 0;
            while(_loc3_ < rest.length)
            {
               param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),rest[_loc3_]);
               _loc3_++;
            }
            dispatchEvent(new LogEvent(param1,LogEventLevel.WARN));
         }
      }
      
      public function get category() : String
      {
         return _category;
      }
      
      public function info(param1:String, ... rest) : void
      {
         var _loc3_:int = 0;
         if(hasEventListener(LogEvent.LOG))
         {
            _loc3_ = 0;
            while(_loc3_ < rest.length)
            {
               param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),rest[_loc3_]);
               _loc3_++;
            }
            dispatchEvent(new LogEvent(param1,LogEventLevel.INFO));
         }
      }
      
      public function debug(param1:String, ... rest) : void
      {
         var _loc3_:int = 0;
         if(hasEventListener(LogEvent.LOG))
         {
            _loc3_ = 0;
            while(_loc3_ < rest.length)
            {
               param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),rest[_loc3_]);
               _loc3_++;
            }
            dispatchEvent(new LogEvent(param1,LogEventLevel.DEBUG));
         }
      }
      
      public function fatal(param1:String, ... rest) : void
      {
         var _loc3_:int = 0;
         if(hasEventListener(LogEvent.LOG))
         {
            _loc3_ = 0;
            while(_loc3_ < rest.length)
            {
               param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),rest[_loc3_]);
               _loc3_++;
            }
            dispatchEvent(new LogEvent(param1,LogEventLevel.FATAL));
         }
      }
   }
}

