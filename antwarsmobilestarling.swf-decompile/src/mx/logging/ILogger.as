package mx.logging
{
   import flash.events.IEventDispatcher;
   
   public interface ILogger extends IEventDispatcher
   {
      
      function debug(param1:String, ... rest) : void;
      
      function fatal(param1:String, ... rest) : void;
      
      function get category() : String;
      
      function warn(param1:String, ... rest) : void;
      
      function error(param1:String, ... rest) : void;
      
      function log(param1:int, param2:String, ... rest) : void;
      
      function info(param1:String, ... rest) : void;
   }
}

