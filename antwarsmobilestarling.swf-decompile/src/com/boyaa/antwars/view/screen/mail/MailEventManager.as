package com.boyaa.antwars.view.screen.mail
{
   import starling.events.EventDispatcher;
   
   public class MailEventManager extends EventDispatcher
   {
      private static var _instance:MailEventManager;
      
      public function MailEventManager()
      {
         super();
      }
      
      public static function get instance() : MailEventManager
      {
         if(!_instance)
         {
            _instance = new MailEventManager();
         }
         return _instance;
      }
   }
}
