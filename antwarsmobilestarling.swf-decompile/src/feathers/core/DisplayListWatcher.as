package feathers.core
{
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   public class DisplayListWatcher extends EventDispatcher
   {
      
      public var requiredBaseClass:Class = IFeathersControl;
      
      public var processRecursively:Boolean = true;
      
      protected var initializedObjects:Dictionary = new Dictionary(true);
      
      protected var _initializeOnce:Boolean = true;
      
      protected var root:DisplayObjectContainer;
      
      protected var _initializerNoNameTypeMap:Dictionary = new Dictionary(true);
      
      protected var _initializerNameTypeMap:Dictionary = new Dictionary(true);
      
      protected var _initializerSuperTypeMap:Dictionary = new Dictionary(true);
      
      protected var _initializerSuperTypes:Vector.<Class> = new Vector.<Class>(0);
      
      protected var _excludedObjects:Vector.<DisplayObject>;
      
      public function DisplayListWatcher(param1:DisplayObjectContainer)
      {
         super();
         this.root = param1;
         this.root.addEventListener("added",addedHandler);
      }
      
      public function get initializeOnce() : Boolean
      {
         return this._initializeOnce;
      }
      
      public function set initializeOnce(param1:Boolean) : void
      {
         if(this._initializeOnce == param1)
         {
            return;
         }
         this._initializeOnce = param1;
         if(param1)
         {
            this.initializedObjects = new Dictionary(true);
         }
         else
         {
            this.initializedObjects = null;
         }
      }
      
      public function dispose() : void
      {
         if(this.root)
         {
            this.root.removeEventListener("added",addedHandler);
            this.root = null;
         }
         if(this._excludedObjects)
         {
            this._excludedObjects.length = 0;
            this._excludedObjects = null;
         }
         for(var _loc1_ in this.initializedObjects)
         {
            delete this.initializedObjects[_loc1_];
         }
         for(_loc1_ in this._initializerNameTypeMap)
         {
            delete this._initializerNameTypeMap[_loc1_];
         }
         for(_loc1_ in this._initializerNoNameTypeMap)
         {
            delete this._initializerNoNameTypeMap[_loc1_];
         }
         for(_loc1_ in this._initializerSuperTypeMap)
         {
            delete this._initializerSuperTypeMap[_loc1_];
         }
         this._initializerSuperTypes.length = 0;
      }
      
      public function exclude(param1:DisplayObject) : void
      {
         if(!this._excludedObjects)
         {
            this._excludedObjects = new Vector.<DisplayObject>(0);
         }
         this._excludedObjects.push(param1);
      }
      
      public function isExcluded(param1:DisplayObject) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:DisplayObject = null;
         if(!this._excludedObjects)
         {
            return false;
         }
         var _loc3_:int = int(this._excludedObjects.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this._excludedObjects[_loc4_];
            if(_loc2_ is DisplayObjectContainer)
            {
               if(DisplayObjectContainer(_loc2_).contains(param1))
               {
                  return true;
               }
            }
            else if(_loc2_ == param1)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function setInitializerForClass(param1:Class, param2:Function, param3:String = null) : void
      {
         if(!param3)
         {
            this._initializerNoNameTypeMap[param1] = param2;
            return;
         }
         var _loc4_:Object = this._initializerNameTypeMap[param1];
         if(!_loc4_)
         {
            this._initializerNameTypeMap[param1] = _loc4_ = {};
         }
         _loc4_[param3] = param2;
      }
      
      public function setInitializerForClassAndSubclasses(param1:Class, param2:Function) : void
      {
         var _loc3_:int = int(this._initializerSuperTypes.indexOf(param1));
         if(_loc3_ < 0)
         {
            this._initializerSuperTypes.push(param1);
         }
         this._initializerSuperTypeMap[param1] = param2;
      }
      
      public function getInitializerForClass(param1:Class, param2:String = null) : Function
      {
         if(!param2)
         {
            return this._initializerNoNameTypeMap[param1] as Function;
         }
         var _loc3_:Object = this._initializerNameTypeMap[param1];
         if(!_loc3_)
         {
            return null;
         }
         return _loc3_[param2] as Function;
      }
      
      public function getInitializerForClassAndSubclasses(param1:Class) : Function
      {
         return this._initializerSuperTypeMap[param1];
      }
      
      public function clearInitializerForClass(param1:Class, param2:String = null) : void
      {
         if(!param2)
         {
            delete this._initializerNoNameTypeMap[param1];
            return;
         }
         var _loc3_:Object = this._initializerNameTypeMap[param1];
         if(!_loc3_)
         {
            return;
         }
         delete _loc3_[param2];
      }
      
      public function clearInitializerForClassAndSubclasses(param1:Class) : void
      {
         delete this._initializerSuperTypeMap[param1];
         var _loc2_:int = int(this._initializerSuperTypes.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this._initializerSuperTypes.splice(_loc2_,1);
         }
      }
      
      public function initializeObject(param1:DisplayObject) : void
      {
         var _loc6_:Boolean = false;
         var _loc4_:DisplayObjectContainer = null;
         var _loc3_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:DisplayObject = null;
         var _loc5_:DisplayObject = DisplayObject(param1 as requiredBaseClass);
         if(_loc5_)
         {
            _loc6_ = this._initializeOnce && this.initializedObjects[_loc5_];
            if(!_loc6_)
            {
               if(this.isExcluded(param1))
               {
                  return;
               }
               if(this._initializeOnce)
               {
                  this.initializedObjects[_loc5_] = true;
               }
               this.processAllInitializers(param1);
            }
         }
         if(this.processRecursively)
         {
            _loc4_ = param1 as DisplayObjectContainer;
            if(_loc4_)
            {
               _loc3_ = _loc4_.numChildren;
               _loc7_ = 0;
               while(_loc7_ < _loc3_)
               {
                  _loc2_ = _loc4_.getChildAt(_loc7_);
                  this.initializeObject(_loc2_);
                  _loc7_++;
               }
            }
         }
      }
      
      protected function processAllInitializers(param1:DisplayObject) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Class = null;
         var _loc2_:int = int(this._initializerSuperTypes.length);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this._initializerSuperTypes[_loc4_];
            if(param1 is _loc3_)
            {
               this.applyAllStylesForTypeFromMaps(param1,_loc3_,this._initializerSuperTypeMap);
            }
            _loc4_++;
         }
         _loc3_ = Class(Object(param1).constructor);
         this.applyAllStylesForTypeFromMaps(param1,_loc3_,this._initializerNoNameTypeMap,this._initializerNameTypeMap);
      }
      
      protected function applyAllStylesForTypeFromMaps(param1:DisplayObject, param2:Class, param3:Dictionary, param4:Dictionary = null) : void
      {
         var _loc12_:Function = null;
         var _loc9_:Object = null;
         var _loc5_:IFeathersControl = null;
         var _loc6_:TokenList = null;
         var _loc8_:int = 0;
         var _loc10_:int = 0;
         var _loc7_:String = null;
         var _loc11_:Boolean = false;
         if(param1 is IFeathersControl && param4)
         {
            _loc9_ = param4[param2];
            if(_loc9_)
            {
               _loc5_ = IFeathersControl(param1);
               _loc6_ = _loc5_.styleNameList;
               _loc8_ = _loc6_.length;
               _loc10_ = 0;
               while(_loc10_ < _loc8_)
               {
                  _loc7_ = _loc6_.item(_loc10_);
                  _loc12_ = _loc9_[_loc7_] as Function;
                  if(_loc12_ != null)
                  {
                     _loc11_ = true;
                     _loc12_(param1);
                  }
                  _loc10_++;
               }
            }
         }
         if(_loc11_)
         {
            return;
         }
         _loc12_ = param3[param2] as Function;
         if(_loc12_ != null)
         {
            _loc12_(param1);
         }
      }
      
      protected function addedHandler(param1:Event) : void
      {
         this.initializeObject(param1.target as DisplayObject);
      }
   }
}

