package com.boyaa.antwars.view.screen.mail
{
   import flash.events.EventDispatcher;
   
   public class MailEventManager extends EventDispatcher
   {
      
      private static var _instance:MailEventManager = null;
      
      public function MailEventManager(param1:Single)
      {
         super();
      }
      
      public static function get instance() : MailEventManager
      {
         if(_instance == null)
         {
            _instance = new MailEventManager(new Single());
         }
         return _instance;
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
