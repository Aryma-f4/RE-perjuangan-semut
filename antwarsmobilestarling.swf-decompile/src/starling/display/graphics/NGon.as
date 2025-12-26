package starling.display.graphics
{
   public class NGon extends Graphic
   {
      
      private const DEGREES_TO_RADIANS:Number = 0.017453292519943295;
      
      private var _radius:Number;
      
      private var _innerRadius:Number;
      
      private var _startAngle:Number;
      
      private var _endAngle:Number;
      
      private var _numSides:int;
      
      public function NGon(param1:Number = 100, param2:int = 10, param3:Number = 0, param4:Number = 0, param5:Number = 360)
      {
         super();
         this.radius = param1;
         this.numSides = param2;
         this.innerRadius = param3;
         this.startAngle = param4;
         this.endAngle = param5;
      }
      
      private static function buildSimpleNGon(param1:Number, param2:int, param3:Vector.<Number>, param4:Vector.<uint>) : void
      {
         var _loc9_:int = 0;
         var _loc15_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc8_:int = 0;
         param3.push(0,0,0,1,1,1,1,0.5,0.5);
         _loc8_++;
         var _loc6_:Number = 3.141592653589793 * 2 / param2;
         var _loc14_:Number = Math.cos(_loc6_);
         var _loc12_:Number = Math.sin(_loc6_);
         var _loc10_:* = 0;
         var _loc7_:* = 1;
         _loc9_ = 0;
         while(_loc9_ < param2)
         {
            _loc15_ = _loc10_ * param1;
            _loc13_ = -_loc7_ * param1;
            param3.push(_loc15_,_loc13_,0,1,1,1,1,_loc15_ / (param1 * 2) + 0.5,_loc13_ / (param1 * 2) + 0.5);
            _loc8_++;
            param4.push(0,_loc8_ - 1,_loc9_ == param2 - 1 ? 1 : _loc8_);
            _loc5_ = _loc12_ * _loc7_ + _loc14_ * _loc10_;
            _loc7_ = _loc11_ = _loc14_ * _loc7_ - _loc12_ * _loc10_;
            _loc10_ = _loc5_;
            _loc9_++;
         }
      }
      
      private static function buildHoop(param1:Number, param2:Number, param3:int, param4:Vector.<Number>, param5:Vector.<uint>) : void
      {
         var _loc10_:int = 0;
         var _loc15_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc9_:int = 0;
         var _loc7_:Number = 3.141592653589793 * 2 / param3;
         var _loc16_:Number = Math.cos(_loc7_);
         var _loc13_:Number = Math.sin(_loc7_);
         var _loc11_:* = 0;
         var _loc8_:* = 1;
         _loc10_ = 0;
         while(_loc10_ < param3)
         {
            _loc15_ = _loc11_ * param2;
            _loc14_ = -_loc8_ * param2;
            param4.push(_loc15_,_loc14_,0,1,1,1,1,_loc15_ / (param2 * 2) + 0.5,_loc14_ / (param2 * 2) + 0.5);
            _loc9_++;
            _loc15_ = _loc11_ * param1;
            _loc14_ = -_loc8_ * param1;
            param4.push(_loc15_,_loc14_,0,1,1,1,1,_loc15_ / (param2 * 2) + 0.5,_loc14_ / (param2 * 2) + 0.5);
            _loc9_++;
            if(_loc10_ == param3 - 1)
            {
               param5.push(_loc9_ - 2,_loc9_ - 1,0,0,_loc9_ - 1,1);
            }
            else
            {
               param5.push(_loc9_ - 2,_loc9_ - 1,_loc9_,_loc9_,_loc9_ - 1,_loc9_ + 1);
            }
            _loc6_ = _loc13_ * _loc8_ + _loc16_ * _loc11_;
            _loc8_ = _loc12_ = _loc16_ * _loc8_ - _loc13_ * _loc11_;
            _loc11_ = _loc6_;
            _loc10_++;
         }
      }
      
      private static function buildFan(param1:Number, param2:Number, param3:Number, param4:int, param5:Vector.<Number>, param6:Vector.<uint>) : void
      {
         var _loc12_:int = 0;
         var _loc7_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         param5.push(0,0,0,1,1,1,1,0.5,0.5);
         _loc11_++;
         var _loc13_:Number = 3.141592653589793 * 2 / param4;
         var _loc9_:Number = param2 / _loc13_;
         _loc9_ = Number(_loc9_ < 0 ? -Math.ceil(-_loc9_) : int(_loc9_));
         _loc9_ = _loc9_ * _loc13_;
         _loc12_ = 0;
         while(_loc12_ <= param4 + 1)
         {
            _loc7_ = _loc9_ + _loc12_ * _loc13_;
            _loc16_ = _loc7_ + _loc13_;
            if(_loc16_ >= param2)
            {
               _loc20_ = Math.sin(_loc7_) * param1;
               _loc18_ = -Math.cos(_loc7_) * param1;
               _loc15_ = _loc7_ - _loc13_;
               if(_loc7_ < param2 && _loc16_ > param2)
               {
                  _loc17_ = Math.sin(_loc16_) * param1;
                  _loc19_ = -Math.cos(_loc16_) * param1;
                  _loc14_ = (param2 - _loc7_) / _loc13_;
                  _loc20_ += _loc14_ * (_loc17_ - _loc20_);
                  _loc18_ += _loc14_ * (_loc19_ - _loc18_);
               }
               else if(_loc7_ > param3 && _loc15_ < param3)
               {
                  _loc8_ = Math.sin(_loc15_) * param1;
                  _loc10_ = -Math.cos(_loc15_) * param1;
                  _loc14_ = (param3 - _loc15_) / _loc13_;
                  _loc20_ = _loc8_ + _loc14_ * (_loc20_ - _loc8_);
                  _loc18_ = _loc10_ + _loc14_ * (_loc18_ - _loc10_);
               }
               param5.push(_loc20_,_loc18_,0,1,1,1,1,_loc20_ / (param1 * 2) + 0.5,_loc18_ / (param1 * 2) + 0.5);
               _loc11_++;
               if(param5.length > 18)
               {
                  param6.push(0,_loc11_ - 2,_loc11_ - 1);
               }
               if(_loc7_ >= param3)
               {
                  break;
               }
            }
            _loc12_++;
         }
      }
      
      private static function buildArc(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<Number>, param7:Vector.<uint>) : void
      {
         var _loc23_:int = 0;
         var _loc22_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc13_:int = 0;
         var _loc24_:Number = 3.141592653589793 * 2 / param5;
         var _loc20_:Number = param3 / _loc24_;
         _loc20_ = Number(_loc20_ < 0 ? -Math.ceil(-_loc20_) : int(_loc20_));
         _loc20_ = _loc20_ * _loc24_;
         _loc23_ = 0;
         while(_loc23_ <= param5 + 1)
         {
            _loc22_ = _loc20_ + _loc23_ * _loc24_;
            _loc19_ = _loc22_ + _loc24_;
            if(_loc19_ >= param3)
            {
               _loc26_ = Math.sin(_loc22_);
               _loc9_ = Math.cos(_loc22_);
               _loc29_ = _loc26_ * param2;
               _loc28_ = -_loc9_ * param2;
               _loc12_ = _loc26_ * param1;
               _loc21_ = -_loc9_ * param1;
               _loc14_ = _loc22_ - _loc24_;
               if(_loc22_ < param3 && _loc19_ > param3)
               {
                  _loc26_ = Math.sin(_loc19_);
                  _loc9_ = Math.cos(_loc19_);
                  _loc15_ = _loc26_ * param2;
                  _loc17_ = -_loc9_ * param2;
                  _loc8_ = _loc26_ * param1;
                  _loc18_ = -_loc9_ * param1;
                  _loc25_ = (param3 - _loc22_) / _loc24_;
                  _loc29_ += _loc25_ * (_loc15_ - _loc29_);
                  _loc28_ += _loc25_ * (_loc17_ - _loc28_);
                  _loc12_ += _loc25_ * (_loc8_ - _loc12_);
                  _loc21_ += _loc25_ * (_loc18_ - _loc21_);
               }
               else if(_loc22_ > param4 && _loc14_ < param4)
               {
                  _loc26_ = Math.sin(_loc14_);
                  _loc9_ = Math.cos(_loc14_);
                  _loc10_ = _loc26_ * param2;
                  _loc11_ = -_loc9_ * param2;
                  _loc27_ = _loc26_ * param1;
                  _loc16_ = -_loc9_ * param1;
                  _loc25_ = (param4 - _loc14_) / _loc24_;
                  _loc29_ = _loc10_ + _loc25_ * (_loc29_ - _loc10_);
                  _loc28_ = _loc11_ + _loc25_ * (_loc28_ - _loc11_);
                  _loc12_ = _loc27_ + _loc25_ * (_loc12_ - _loc27_);
                  _loc21_ = _loc16_ + _loc25_ * (_loc21_ - _loc16_);
               }
               param6.push(_loc29_,_loc28_,0,1,1,1,1,_loc29_ / (param2 * 2) + 0.5,_loc28_ / (param2 * 2) + 0.5);
               _loc13_++;
               param6.push(_loc12_,_loc21_,0,1,1,1,1,_loc12_ / (param2 * 2) + 0.5,_loc21_ / (param2 * 2) + 0.5);
               _loc13_++;
               if(param6.length > 27)
               {
                  param7.push(_loc13_ - 1,_loc13_ - 2,_loc13_ - 3,_loc13_ - 3,_loc13_ - 2,_loc13_ - 4);
               }
               if(_loc22_ >= param4)
               {
                  break;
               }
            }
            _loc23_++;
         }
      }
      
      public function get endAngle() : Number
      {
         return _endAngle;
      }
      
      public function set endAngle(param1:Number) : void
      {
         _endAngle = param1;
         isInvalid = true;
      }
      
      public function get startAngle() : Number
      {
         return _startAngle;
      }
      
      public function set startAngle(param1:Number) : void
      {
         _startAngle = param1;
         isInvalid = true;
      }
      
      public function get radius() : Number
      {
         return _radius;
      }
      
      public function set radius(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : param1;
         _radius = param1;
         var _loc2_:Number = Math.max(_radius,_innerRadius);
         minBounds.x = minBounds.y = -_loc2_;
         maxBounds.x = minBounds.y = _loc2_;
         isInvalid = true;
      }
      
      public function get innerRadius() : Number
      {
         return _innerRadius;
      }
      
      public function set innerRadius(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : param1;
         _innerRadius = param1;
         var _loc2_:Number = Math.max(_radius,_innerRadius);
         minBounds.x = minBounds.y = -_loc2_;
         maxBounds.x = minBounds.y = _loc2_;
         isInvalid = true;
      }
      
      public function get numSides() : int
      {
         return _numSides;
      }
      
      public function set numSides(param1:int) : void
      {
         param1 = int(param1 < 3 ? 3 : param1);
         _numSides = param1;
         isInvalid = true;
      }
      
      override protected function buildGeometry() : void
      {
         vertices = new Vector.<Number>();
         indices = new Vector.<uint>();
         var _loc3_:Number = _startAngle;
         var _loc6_:Number = _endAngle;
         var _loc4_:int = _loc3_ < 0 ? -1 : 1;
         var _loc2_:int = _loc6_ < 0 ? -1 : 1;
         _loc3_ *= _loc4_;
         _loc6_ *= _loc2_;
         _loc6_ = _loc6_ % 360;
         _loc6_ = _loc6_ * _loc2_;
         _loc3_ %= 360;
         if(_loc6_ < _loc3_)
         {
            _loc6_ += 360;
         }
         _loc3_ *= _loc4_ * 0.017453292519943295;
         _loc6_ *= 0.017453292519943295;
         if(_loc6_ - _loc3_ > 3.141592653589793 * 2)
         {
            _loc6_ -= 3.141592653589793 * 2;
         }
         var _loc1_:Number = _innerRadius < _radius ? _innerRadius : _radius;
         var _loc5_:Number = _radius > _innerRadius ? _radius : _innerRadius;
         var _loc7_:Boolean = _loc3_ != 0 || _loc6_ != 0;
         if(_loc1_ == 0 && !_loc7_)
         {
            buildSimpleNGon(_loc5_,_numSides,vertices,indices);
         }
         else if(_loc1_ != 0 && !_loc7_)
         {
            buildHoop(_loc1_,_loc5_,_numSides,vertices,indices);
         }
         else if(_loc1_ == 0)
         {
            buildFan(_loc5_,_loc3_,_loc6_,_numSides,vertices,indices);
         }
         else
         {
            buildArc(_loc1_,_loc5_,_loc3_,_loc6_,_numSides,vertices,indices);
         }
      }
   }
}

