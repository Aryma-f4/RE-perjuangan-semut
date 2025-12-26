package com.boyaa.antwars.view
{
   import starling.core.Starling;
   import starling.display.Quad;
   
   public class DisableAll extends Quad
   {
      
      private static var _instance:DisableAll = null;
      
      private var _enabled:Boolean = false;
      
      public function DisableAll(param1:Single)
      {
         super(1365,768,0);
         alpha = 0;
      }
      
      public static function get instance() : DisableAll
      {
         if(_instance == null)
         {
            _instance = new DisableAll(new Single());
         }
         return _instance;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(param1 != _enabled)
         {
            _enabled = param1;
            if(_enabled)
            {
               Starling.current.stage.addChild(this);
            }
            else
            {
               Starling.current.stage.removeChild(this);
            }
         }
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
