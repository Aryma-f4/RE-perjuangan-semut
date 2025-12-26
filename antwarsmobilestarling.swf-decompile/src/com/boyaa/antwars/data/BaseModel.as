package com.boyaa.antwars.data
{
   import starling.events.EventDispatcher;
   
   public class BaseModel extends EventDispatcher
   {
      
      public static var REFRESH:String = "Model::Refresh";
      
      public function BaseModel()
      {
         super();
      }
   }
}

