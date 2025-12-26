package starling.display.graphics
{
   import starling.textures.Texture;
   
   public class Stroke extends Graphic
   {
      
      private static const EPSILON:Number = 1e-7;
      
      private var strokeVertices:Vector.<StrokeVertex>;
      
      private var _numVertices:int;
      
      private var _closed:Boolean = false;
      
      public function Stroke()
      {
         super();
         clear();
      }
      
      private static function createPolyLine(param1:Vector.<StrokeVertex>, param2:Boolean, param3:Vector.<Number>, param4:Vector.<uint>) : void
      {
         var _loc22_:int = 0;
         var _loc5_:StrokeVertex = null;
         var _loc6_:StrokeVertex = null;
         var _loc8_:StrokeVertex = null;
         var _loc15_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:* = NaN;
         var _loc7_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc30_:* = NaN;
         var _loc18_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc23_:Array = null;
         var _loc24_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc31_:Array = null;
         var _loc29_:Number = NaN;
         var _loc21_:int = int(param1.length);
         _loc22_ = 0;
         while(_loc22_ < _loc21_)
         {
            _loc5_ = param1[_loc22_];
            _loc6_ = _loc22_ > 0 ? param1[_loc22_ - 1] : StrokeVertex(_loc5_.clone());
            _loc8_ = _loc22_ < _loc21_ - 1 ? param1[_loc22_ + 1] : StrokeVertex(_loc5_.clone());
            _loc15_ = _loc5_.x - _loc6_.x;
            _loc14_ = _loc5_.y - _loc6_.y;
            _loc25_ = _loc8_.x - _loc5_.x;
            _loc27_ = _loc8_.y - _loc5_.y;
            if(_loc22_ == _loc21_ - 1)
            {
               _loc8_.x += _loc15_;
               _loc8_.y += _loc14_;
               _loc25_ = _loc8_.x - _loc5_.x;
               _loc27_ = _loc8_.y - _loc5_.y;
            }
            if(_loc22_ == 0)
            {
               _loc6_.x -= _loc25_;
               _loc6_.y -= _loc27_;
               _loc15_ = _loc5_.x - _loc6_.x;
               _loc14_ = _loc5_.y - _loc6_.y;
            }
            _loc11_ = -_loc14_;
            _loc12_ = _loc15_;
            _loc7_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_);
            _loc11_ /= _loc7_;
            _loc12_ /= _loc7_;
            _loc28_ = -_loc27_;
            _loc30_ = _loc25_;
            _loc18_ = Math.sqrt(_loc28_ * _loc28_ + _loc30_ * _loc30_);
            _loc28_ /= _loc18_;
            _loc30_ /= _loc18_;
            _loc13_ = _loc5_.thickness * 0.5;
            _loc17_ = _loc5_.x + _loc11_ * _loc13_;
            _loc16_ = _loc5_.y + _loc12_ * _loc13_;
            _loc10_ = _loc5_.x + _loc28_ * _loc13_;
            _loc9_ = _loc5_.y + _loc30_ * _loc13_;
            _loc23_ = intersection(_loc17_,_loc16_,_loc17_ + _loc15_,_loc16_ + _loc14_,_loc10_,_loc9_,_loc10_ + _loc25_,_loc9_ + _loc27_);
            _loc24_ = _loc5_.x - _loc11_ * _loc13_;
            _loc26_ = _loc5_.y - _loc12_ * _loc13_;
            _loc19_ = _loc5_.x - _loc28_ * _loc13_;
            _loc20_ = _loc5_.y - _loc30_ * _loc13_;
            _loc31_ = intersection(_loc24_,_loc26_,_loc24_ + _loc15_,_loc26_ + _loc14_,_loc19_,_loc20_,_loc19_ + _loc25_,_loc20_ + _loc27_);
            param3.push(_loc23_[0],_loc23_[1],_loc5_.z,_loc5_.r2,_loc5_.g2,_loc5_.b2,_loc5_.a2,_loc5_.u,1);
            param3.push(_loc31_[0],_loc31_[1],_loc5_.z,_loc5_.r,_loc5_.g,_loc5_.b,_loc5_.a,_loc5_.u,0);
            if(_loc22_ < _loc21_ - 1)
            {
               _loc29_ = _loc22_ * 2;
               param4.push(_loc29_,_loc29_ + 2,_loc29_ + 1,_loc29_ + 1,_loc29_ + 2,_loc29_ + 3);
            }
            _loc22_++;
         }
      }
      
      public static function intersection(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Array
      {
         var _loc16_:Number = param3 - param1;
         var _loc14_:Number = param4 - param2;
         var _loc15_:Number = param7 - param5;
         var _loc12_:Number = param8 - param6;
         var _loc11_:Number = param1 - param5;
         var _loc10_:Number = param2 - param6;
         var _loc9_:Number = _loc16_ * _loc12_ - _loc14_ * _loc15_;
         if((_loc9_ < 0 ? -_loc9_ : _loc9_) < 1e-7)
         {
            return [param1,param2];
         }
         var _loc13_:Number = (_loc15_ * _loc10_ - _loc12_ * _loc11_) / _loc9_;
         return [param1 + _loc13_ * (param3 - param1),param2 + _loc13_ * (param4 - param2)];
      }
      
      public function get numVertices() : int
      {
         return _numVertices;
      }
      
      public function clear() : void
      {
         minBounds.x = minBounds.y = Infinity;
         maxBounds.x = maxBounds.y = -Infinity;
         strokeVertices = new Vector.<StrokeVertex>();
         _numVertices = 0;
         isInvalid = true;
      }
      
      public function addVertex(param1:Number, param2:Number, param3:Number = 1, param4:uint = 16777215, param5:Number = 1, param6:uint = 16777215, param7:Number = 1) : void
      {
         var _loc19_:StrokeVertex = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc12_:Number = 0;
         var _loc11_:Vector.<Texture> = _material.textures;
         if(strokeVertices.length > 0 && _loc11_.length > 0)
         {
            _loc19_ = strokeVertices[strokeVertices.length - 1];
            _loc9_ = param1 - _loc19_.x;
            _loc10_ = param2 - _loc19_.y;
            _loc8_ = Math.sqrt(_loc9_ * _loc9_ + _loc10_ * _loc10_);
            _loc12_ = _loc19_.u + _loc8_ / _loc11_[0].width;
         }
         var _loc17_:Number = (param4 >> 16) / 255;
         var _loc16_:Number = ((param4 & 0xFF00) >> 8) / 255;
         var _loc13_:Number = (param4 & 0xFF) / 255;
         var _loc18_:Number = (param6 >> 16) / 255;
         var _loc15_:Number = ((param6 & 0xFF00) >> 8) / 255;
         var _loc14_:Number = (param6 & 0xFF) / 255;
         strokeVertices.push(new StrokeVertex(param1,param2,0,_loc17_,_loc16_,_loc13_,param5,_loc18_,_loc15_,_loc14_,param7,_loc12_,0,param3));
         _numVertices = _numVertices + 1;
         minBounds.x = param1 < minBounds.x ? param1 : minBounds.x;
         minBounds.y = param2 < minBounds.y ? param2 : minBounds.y;
         maxBounds.x = param1 > maxBounds.x ? param1 : maxBounds.x;
         maxBounds.y = param2 > maxBounds.y ? param2 : maxBounds.y;
         isInvalid = true;
      }
      
      public function get closed() : Boolean
      {
         return _closed;
      }
      
      public function set closed(param1:Boolean) : void
      {
         _closed = param1;
      }
      
      override protected function buildGeometry() : void
      {
         vertices = new Vector.<Number>();
         indices = new Vector.<uint>();
         createPolyLine(strokeVertices,_closed,vertices,indices);
      }
   }
}

class StrokeVertex
{
   
   public var x:Number;
   
   public var y:Number;
   
   public var z:Number;
   
   public var r:Number;
   
   public var g:Number;
   
   public var b:Number;
   
   public var a:Number;
   
   public var u:Number;
   
   public var v:Number;
   
   public var thickness:Number;
   
   public var r2:Number;
   
   public var g2:Number;
   
   public var b2:Number;
   
   public var a2:Number;
   
   public function StrokeVertex(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 1, param5:Number = 1, param6:Number = 1, param7:Number = 1, param8:Number = 1, param9:Number = 1, param10:Number = 1, param11:Number = 1, param12:Number = 0, param13:Number = 0, param14:Number = 1)
   {
      super();
      this.x = param1;
      this.y = param2;
      this.z = param3;
      this.u = param12;
      this.v = param13;
      this.r = param4;
      this.g = param5;
      this.b = param6;
      this.a = param7;
      this.r2 = param8;
      this.g2 = param9;
      this.b2 = param10;
      this.a2 = param11;
      this.thickness = param14;
   }
   
   public function clone() : StrokeVertex
   {
      return new StrokeVertex(x,y,z,r,g,b,a,r2,g2,b2,a2,u,v);
   }
}
