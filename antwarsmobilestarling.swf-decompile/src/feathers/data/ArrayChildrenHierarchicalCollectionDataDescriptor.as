package feathers.data
{
   public class ArrayChildrenHierarchicalCollectionDataDescriptor implements IHierarchicalCollectionDataDescriptor
   {
      
      public var childrenField:String = "children";
      
      public function ArrayChildrenHierarchicalCollectionDataDescriptor()
      {
         super();
      }
      
      public function getLength(param1:Object, ... rest) : int
      {
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:Array = param1 as Array;
         var _loc4_:int = int(rest.length);
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc3_ = rest[_loc6_] as int;
            _loc5_ = _loc5_[_loc3_][childrenField] as Array;
            _loc6_++;
         }
         return _loc5_.length;
      }
      
      public function getItemAt(param1:Object, param2:int, ... rest) : Object
      {
         var _loc7_:int = 0;
         rest.unshift(param2);
         var _loc6_:Array = param1 as Array;
         var _loc5_:int = rest.length - 1;
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            param2 = rest[_loc7_] as int;
            _loc6_ = _loc6_[param2][childrenField] as Array;
            _loc7_++;
         }
         var _loc4_:int = rest[_loc5_] as int;
         return _loc6_[_loc4_];
      }
      
      public function setItemAt(param1:Object, param2:Object, param3:int, ... rest) : void
      {
         var _loc8_:int = 0;
         rest.unshift(param3);
         var _loc7_:Array = param1 as Array;
         var _loc6_:int = rest.length - 1;
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            param3 = rest[_loc8_] as int;
            _loc7_ = _loc7_[param3][childrenField] as Array;
            _loc8_++;
         }
         var _loc5_:int = int(rest[_loc6_]);
         _loc7_[_loc5_] = param2;
      }
      
      public function addItemAt(param1:Object, param2:Object, param3:int, ... rest) : void
      {
         var _loc8_:int = 0;
         rest.unshift(param3);
         var _loc7_:Array = param1 as Array;
         var _loc6_:int = rest.length - 1;
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            param3 = rest[_loc8_] as int;
            _loc7_ = _loc7_[param3][childrenField] as Array;
            _loc8_++;
         }
         var _loc5_:int = int(rest[_loc6_]);
         _loc7_.splice(_loc5_,0,param2);
      }
      
      public function removeItemAt(param1:Object, param2:int, ... rest) : Object
      {
         var _loc8_:int = 0;
         rest.unshift(param2);
         var _loc7_:Array = param1 as Array;
         var _loc5_:int = rest.length - 1;
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            param2 = rest[_loc8_] as int;
            _loc7_ = _loc7_[param2][childrenField] as Array;
            _loc8_++;
         }
         var _loc4_:int = int(rest[_loc5_]);
         var _loc6_:Object = _loc7_[_loc4_];
         _loc7_.splice(_loc4_,1);
         return _loc6_;
      }
      
      public function getItemLocation(param1:Object, param2:Object, param3:Vector.<int> = null, ... rest) : Vector.<int>
      {
         var _loc9_:int = 0;
         var _loc6_:int = 0;
         if(!param3)
         {
            param3 = new Vector.<int>(0);
         }
         else
         {
            param3.length = 0;
         }
         var _loc8_:Array = param1 as Array;
         var _loc7_:int = int(rest.length);
         _loc9_ = 0;
         while(_loc9_ < _loc7_)
         {
            _loc6_ = rest[_loc9_] as int;
            param3[_loc9_] = _loc6_;
            _loc8_ = _loc8_[_loc6_][childrenField] as Array;
            _loc9_++;
         }
         var _loc5_:Boolean = this.findItemInBranch(_loc8_,param2,param3);
         if(!_loc5_)
         {
            param3.length = 0;
         }
         return param3;
      }
      
      public function isBranch(param1:Object) : Boolean
      {
         return param1.hasOwnProperty(this.childrenField) && param1[this.childrenField] is Array;
      }
      
      protected function findItemInBranch(param1:Array, param2:Object, param3:Vector.<int>) : Boolean
      {
         var _loc8_:int = 0;
         var _loc6_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = int(param1.indexOf(param2));
         if(_loc5_ >= 0)
         {
            param3.push(_loc5_);
            return true;
         }
         var _loc7_:int = int(param1.length);
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_ = param1[_loc8_];
            if(this.isBranch(_loc6_))
            {
               param3.push(_loc8_);
               _loc4_ = this.findItemInBranch(_loc6_[childrenField] as Array,param2,param3);
               if(_loc4_)
               {
                  return true;
               }
               param3.pop();
            }
            _loc8_++;
         }
         return false;
      }
   }
}

