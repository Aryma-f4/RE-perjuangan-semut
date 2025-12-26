package com.boyaa.tool
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class ContainerClear
   {
      
      public function ContainerClear()
      {
         super();
      }
      
      public static function removeAllChild(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         var _loc3_:DisplayObject = null;
         while(param1.numChildren)
         {
            if(param2 == true)
            {
               _loc3_ = param1.getChildAt(0);
               if(_loc3_ is DisplayObjectContainer)
               {
                  removeAllChild(_loc3_ as DisplayObjectContainer);
               }
            }
            param1.removeChildAt(0);
         }
      }
   }
}

