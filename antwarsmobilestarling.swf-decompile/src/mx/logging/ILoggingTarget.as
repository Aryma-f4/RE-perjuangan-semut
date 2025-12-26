package mx.logging
{
   public interface ILoggingTarget
   {
      
      function addLogger(param1:ILogger) : void;
      
      function removeLogger(param1:ILogger) : void;
      
      function get level() : int;
      
      function set filters(param1:Array) : void;
      
      function set level(param1:int) : void;
      
      function get filters() : Array;
   }
}

