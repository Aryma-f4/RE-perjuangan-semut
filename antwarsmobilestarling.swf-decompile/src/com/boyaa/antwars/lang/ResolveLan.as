package com.boyaa.antwars.lang
{
   public class ResolveLan
   {
      
      private var _lan:XML = null;
      
      private var _obj:Object = {};
      
      public function ResolveLan(param1:XML)
      {
         super();
         _lan = param1;
      }
      
      public function resolveXML() : void
      {
         for each(var _loc1_ in _lan.config)
         {
            if("@value" in _loc1_)
            {
               _obj[_loc1_.@id.toString()] = _loc1_.@value.toString();
            }
            else
            {
               _obj[_loc1_.@id.toString()] = _loc1_.text();
            }
         }
      }
      
      public function get obj() : Object
      {
         return _obj;
      }
   }
}

