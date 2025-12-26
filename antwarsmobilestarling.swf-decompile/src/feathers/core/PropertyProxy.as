package feathers.core
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public final dynamic class PropertyProxy extends Proxy
   {
      
      private var _subProxyName:String;
      
      private var _onChangeCallbacks:Vector.<Function> = new Vector.<Function>(0);
      
      private var _names:Array = [];
      
      private var _storage:Object = {};
      
      public function PropertyProxy(param1:Function = null)
      {
         super();
         if(param1 != null)
         {
            this._onChangeCallbacks[this._onChangeCallbacks.length] = param1;
         }
      }
      
      public static function fromObject(param1:Object, param2:Function = null) : PropertyProxy
      {
         var _loc4_:PropertyProxy = new PropertyProxy(param2);
         for(var _loc3_ in param1)
         {
            _loc4_[_loc3_] = param1[_loc3_];
         }
         return _loc4_;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return this._storage.hasOwnProperty(param1);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var _loc2_:String = null;
         var _loc3_:PropertyProxy = null;
         if(this.flash_proxy::isAttribute(param1))
         {
            _loc2_ = param1 is QName ? QName(param1).localName : param1.toString();
            if(!this._storage.hasOwnProperty(_loc2_))
            {
               _loc3_ = new PropertyProxy(subProxy_onChange);
               _loc3_._subProxyName = _loc2_;
               this._storage[_loc2_] = _loc3_;
               this._names[this._names.length] = _loc2_;
               this.fireOnChangeCallback(_loc2_);
            }
            return this._storage[_loc2_];
         }
         return this._storage[param1];
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         var _loc3_:String = param1 is QName ? QName(param1).localName : param1.toString();
         this._storage[_loc3_] = param2;
         if(this._names.indexOf(_loc3_) < 0)
         {
            this._names[this._names.length] = _loc3_;
         }
         this.fireOnChangeCallback(_loc3_);
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:String = param1 is QName ? QName(param1).localName : param1.toString();
         var _loc5_:int = int(this._names.indexOf(_loc3_));
         if(_loc5_ == 0)
         {
            this._names.shift();
         }
         else
         {
            _loc2_ = this._names.length - 1;
            if(_loc5_ == _loc2_)
            {
               this._names.pop();
            }
            else
            {
               this._names.splice(_loc5_,1);
            }
         }
         var _loc4_:* = delete this._storage[_loc3_];
         if(_loc4_)
         {
            this.fireOnChangeCallback(_loc3_);
         }
         return _loc4_;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         if(param1 < this._names.length)
         {
            return param1 + 1;
         }
         return 0;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return this._names[param1 - 1];
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         var _loc2_:* = this._names[param1 - 1];
         return this._storage[_loc2_];
      }
      
      public function addOnChangeCallback(param1:Function) : void
      {
         this._onChangeCallbacks[this._onChangeCallbacks.length] = param1;
      }
      
      public function removeOnChangeCallback(param1:Function) : void
      {
         var _loc3_:int = int(this._onChangeCallbacks.indexOf(param1));
         if(_loc3_ < 0)
         {
            return;
         }
         if(_loc3_ == 0)
         {
            this._onChangeCallbacks.shift();
            return;
         }
         var _loc2_:int = this._onChangeCallbacks.length - 1;
         if(_loc3_ == _loc2_)
         {
            this._onChangeCallbacks.pop();
            return;
         }
         this._onChangeCallbacks.splice(_loc3_,1);
      }
      
      public function toString() : String
      {
         var _loc2_:String = "[object PropertyProxy";
         for(var _loc1_ in this)
         {
            _loc2_ += " " + _loc1_;
         }
         return _loc2_ + "]";
      }
      
      private function fireOnChangeCallback(param1:String) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Function = null;
         var _loc2_:int = int(this._onChangeCallbacks.length);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this._onChangeCallbacks[_loc4_] as Function;
            _loc3_(this,param1);
            _loc4_++;
         }
      }
      
      private function subProxy_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.fireOnChangeCallback(param1._subProxyName);
      }
   }
}

