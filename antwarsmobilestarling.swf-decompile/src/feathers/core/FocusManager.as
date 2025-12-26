package feathers.core
{
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   
   public class FocusManager
   {
      
      protected static const FOCUS_MANAGER_NOT_ENABLED_ERROR:String = "The specified action is not permitted when the focus manager is not enabled.";
      
      protected static const FOCUS_MANAGER_ROOT_MUST_BE_ON_STAGE_ERROR:String = "A focus manager may not be added or removed for a display object that is not on stage.";
      
      protected static const STAGE_TO_STACK:Dictionary = new Dictionary(true);
      
      public static var focusManagerFactory:Function = defaultFocusManagerFactory;
      
      public function FocusManager()
      {
         super();
      }
      
      public static function getFocusManagerForStage(param1:Stage) : IFocusManager
      {
         var _loc2_:Vector.<IFocusManager> = STAGE_TO_STACK[param1] as Vector.<IFocusManager>;
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_[_loc2_.length - 1];
      }
      
      public static function defaultFocusManagerFactory(param1:DisplayObjectContainer) : IFocusManager
      {
         return new DefaultFocusManager(param1);
      }
      
      public static function isEnabledForStage(param1:Stage) : Boolean
      {
         var _loc2_:Vector.<IFocusManager> = STAGE_TO_STACK[param1];
         return _loc2_ != null;
      }
      
      public static function setEnabledForStage(param1:Stage, param2:Boolean) : void
      {
         var _loc3_:IFocusManager = null;
         var _loc4_:Vector.<IFocusManager> = STAGE_TO_STACK[param1];
         if(param2 && _loc4_ || !param2 && !_loc4_)
         {
            return;
         }
         if(param2)
         {
            STAGE_TO_STACK[param1] = new Vector.<IFocusManager>(0);
            pushFocusManager(param1);
         }
         else
         {
            while(_loc4_.length > 0)
            {
               _loc3_ = _loc4_.pop();
               _loc3_.isEnabled = false;
            }
            delete STAGE_TO_STACK[param1];
         }
      }
      
      public static function get focus() : IFocusDisplayObject
      {
         var _loc1_:IFocusManager = getFocusManagerForStage(Starling.current.stage);
         if(_loc1_)
         {
            return _loc1_.focus;
         }
         return null;
      }
      
      public static function set focus(param1:IFocusDisplayObject) : void
      {
         var _loc2_:IFocusManager = getFocusManagerForStage(Starling.current.stage);
         if(!_loc2_)
         {
            throw new Error("The specified action is not permitted when the focus manager is not enabled.");
         }
         _loc2_.focus = param1;
      }
      
      public static function pushFocusManager(param1:DisplayObjectContainer) : IFocusManager
      {
         var _loc3_:IFocusManager = null;
         var _loc5_:Stage = param1.stage;
         if(!_loc5_)
         {
            throw new ArgumentError("A focus manager may not be added or removed for a display object that is not on stage.");
         }
         var _loc4_:Vector.<IFocusManager> = STAGE_TO_STACK[_loc5_] as Vector.<IFocusManager>;
         if(!_loc4_)
         {
            throw new Error("The specified action is not permitted when the focus manager is not enabled.");
         }
         var _loc2_:IFocusManager = FocusManager.focusManagerFactory(param1);
         _loc2_.isEnabled = true;
         if(_loc4_.length > 0)
         {
            _loc3_ = _loc4_[_loc4_.length - 1];
            _loc3_.isEnabled = false;
         }
         _loc4_.push(_loc2_);
         return _loc2_;
      }
      
      public static function removeFocusManager(param1:IFocusManager) : void
      {
         var _loc4_:Stage = param1.root.stage;
         var _loc3_:Vector.<IFocusManager> = STAGE_TO_STACK[_loc4_] as Vector.<IFocusManager>;
         if(!_loc3_)
         {
            throw new Error("The specified action is not permitted when the focus manager is not enabled.");
         }
         var _loc2_:int = int(_loc3_.indexOf(param1));
         if(_loc2_ < 0)
         {
            return;
         }
         param1.isEnabled = false;
         _loc3_.splice(_loc2_,1);
         if(_loc2_ > 0 && _loc2_ == _loc3_.length)
         {
            param1 = _loc3_[_loc3_.length - 1];
            param1.isEnabled = true;
         }
      }
      
      public function disableAll() : void
      {
         var _loc3_:Stage = null;
         var _loc2_:* = undefined;
         var _loc1_:IFocusManager = null;
         for(var _loc4_ in STAGE_TO_STACK)
         {
            _loc3_ = Stage(_loc4_);
            _loc2_ = STAGE_TO_STACK[_loc3_];
            while(_loc2_.length > 0)
            {
               _loc1_ = _loc2_.pop();
               _loc1_.isEnabled = false;
            }
            delete STAGE_TO_STACK[_loc3_];
         }
      }
   }
}

