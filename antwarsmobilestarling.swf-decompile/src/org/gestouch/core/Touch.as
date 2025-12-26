package org.gestouch.core
{
   import flash.geom.Point;
   
   use namespace gestouch_internal;
   
   public class Touch
   {
      
      public var id:uint;
      
      public var target:Object;
      
      public var sizeX:Number;
      
      public var sizeY:Number;
      
      public var pressure:Number;
      
      protected var _location:Point;
      
      protected var _previousLocation:Point;
      
      protected var _beginLocation:Point;
      
      protected var _time:uint;
      
      protected var _beginTime:uint;
      
      public function Touch(param1:uint = 0)
      {
         super();
         this.id = param1;
      }
      
      public function get location() : Point
      {
         return _location.clone();
      }
      
      gestouch_internal function setLocation(param1:Number, param2:Number, param3:uint) : void
      {
         _location = new Point(param1,param2);
         _beginLocation = _location.clone();
         _previousLocation = _location.clone();
         _time = param3;
         _beginTime = param3;
      }
      
      gestouch_internal function updateLocation(param1:Number, param2:Number, param3:uint) : void
      {
         if(_location)
         {
            _previousLocation.x = _location.x;
            _previousLocation.y = _location.y;
            _location.x = param1;
            _location.y = param2;
            _time = param3;
         }
         else
         {
            gestouch_internal::setLocation(param1,param2,param3);
         }
      }
      
      public function get previousLocation() : Point
      {
         return _previousLocation.clone();
      }
      
      public function get beginLocation() : Point
      {
         return _beginLocation.clone();
      }
      
      public function get locationOffset() : Point
      {
         return _location.subtract(_beginLocation);
      }
      
      public function get time() : uint
      {
         return _time;
      }
      
      gestouch_internal function setTime(param1:uint) : void
      {
         _time = param1;
      }
      
      public function get beginTime() : uint
      {
         return _beginTime;
      }
      
      gestouch_internal function setBeginTime(param1:uint) : void
      {
         _beginTime = param1;
      }
      
      public function clone() : Touch
      {
         var _loc1_:Touch = new Touch(id);
         _loc1_._location = _location;
         _loc1_._beginLocation = _beginLocation;
         _loc1_.target = target;
         _loc1_.sizeX = sizeX;
         _loc1_.sizeY = sizeY;
         _loc1_.pressure = pressure;
         _loc1_._time = _time;
         _loc1_._beginTime = _beginTime;
         return _loc1_;
      }
      
      public function toString() : String
      {
         return "Touch [id: " + id + ", location: " + location + ", ...]";
      }
   }
}

