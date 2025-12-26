package feathers.controls
{
   import flash.errors.IllegalOperationError;
   import starling.display.DisplayObject;
   
   public class ScreenNavigatorItem
   {
      
      public var screen:Object;
      
      public var events:Object;
      
      public var properties:Object;
      
      public function ScreenNavigatorItem(param1:Object = null, param2:Object = null, param3:Object = null)
      {
         super();
         this.screen = param1;
         this.events = param2 ? param2 : {};
         this.properties = param3 ? param3 : {};
      }
      
      internal function getScreen() : DisplayObject
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:Class = null;
         if(this.screen is Class)
         {
            _loc1_ = Class(this.screen);
            _loc3_ = new _loc1_();
         }
         else if(this.screen is Function)
         {
            _loc3_ = DisplayObject((this.screen as Function)());
         }
         else
         {
            if(!(this.screen is DisplayObject))
            {
               throw new IllegalOperationError("ScreenNavigatorItem \"screen\" must be a Class, a Function, or a Starling display object.");
            }
            _loc3_ = DisplayObject(this.screen);
         }
         if(this.properties)
         {
            for(var _loc2_ in this.properties)
            {
               _loc3_[_loc2_] = this.properties[_loc2_];
            }
         }
         return _loc3_;
      }
   }
}

