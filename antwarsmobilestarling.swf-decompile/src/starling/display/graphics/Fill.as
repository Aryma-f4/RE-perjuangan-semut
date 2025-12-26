package starling.display.graphics
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class Fill extends Graphic
   {
      
      public static const VERTEX_STRIDE:int = 9;
      
      private static const EPSILON:Number = 1e-7;
      
      private var fillVertices:VertexList;
      
      private var _numVertices:int;
      
      public function Fill()
      {
         super();
         clear();
         _uvMatrix = new Matrix();
         _uvMatrix.scale(0.00390625,0.00390625);
      }
      
      private static function triangulate(param1:VertexList, param2:int, param3:Vector.<Number>, param4:Vector.<uint>) : void
      {
         var _loc7_:VertexList = null;
         var _loc20_:int = 0;
         var _loc14_:Boolean = false;
         var _loc19_:* = null;
         var _loc6_:VertexList = null;
         var _loc5_:* = null;
         var _loc8_:VertexList = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc10_:VertexList = null;
         var _loc9_:* = null;
         var _loc21_:Boolean = false;
         param1 = VertexList.clone(param1);
         var _loc13_:Vector.<VertexList> = convertToSimple(param1);
         flatten(_loc13_,param3);
         while(_loc13_.length > 0)
         {
            _loc7_ = _loc13_.pop();
            if(isClockWise(_loc7_) == false)
            {
               VertexList.reverse(_loc7_);
            }
            _loc20_ = 0;
            _loc14_ = false;
            _loc19_ = _loc7_.head;
            while(_loc20_ <= param2 * 3)
            {
               _loc20_++;
               _loc6_ = _loc19_.prev;
               _loc5_ = _loc19_;
               _loc8_ = _loc19_.next;
               if(_loc8_.next == _loc6_)
               {
                  param4.push(_loc6_.index,_loc5_.index,_loc8_.index);
                  VertexList.releaseNode(_loc6_);
                  VertexList.releaseNode(_loc5_);
                  VertexList.releaseNode(_loc8_);
                  break;
               }
               _loc11_ = _loc6_.vertex[0];
               _loc12_ = _loc6_.vertex[1];
               _loc18_ = _loc5_.vertex[0];
               _loc16_ = _loc5_.vertex[1];
               _loc15_ = _loc8_.vertex[0];
               _loc17_ = _loc8_.vertex[1];
               if(isReflex(_loc11_,_loc12_,_loc18_,_loc16_,_loc15_,_loc17_) == false)
               {
                  _loc19_ = _loc19_.next;
               }
               else
               {
                  _loc9_ = _loc10_ = _loc8_.next;
                  _loc21_ = false;
                  while(_loc9_ != _loc6_)
                  {
                     if(isPointInTriangle(_loc11_,_loc12_,_loc18_,_loc16_,_loc15_,_loc17_,_loc9_.vertex[0],_loc9_.vertex[1]))
                     {
                        _loc21_ = true;
                        break;
                     }
                     _loc9_ = _loc9_.next;
                  }
                  if(_loc21_)
                  {
                     _loc19_ = _loc19_.next;
                  }
                  else
                  {
                     param4.push(_loc6_.index,_loc5_.index,_loc8_.index);
                     if(_loc5_ == _loc5_.head)
                     {
                        _loc5_.vertex = _loc8_.vertex;
                        _loc5_.next = _loc8_.next;
                        _loc5_.index = _loc8_.index;
                        _loc5_.next.prev = _loc5_;
                        VertexList.releaseNode(_loc8_);
                     }
                     else
                     {
                        _loc6_.next = _loc8_;
                        _loc8_.prev = _loc6_;
                        VertexList.releaseNode(_loc5_);
                     }
                     _loc19_ = _loc6_;
                  }
               }
            }
            VertexList.dispose(_loc7_);
         }
      }
      
      private static function convertToSimple(param1:VertexList) : Vector.<VertexList>
      {
         var _loc2_:VertexList = null;
         var _loc11_:VertexList = null;
         var _loc7_:* = null;
         var _loc12_:Boolean = false;
         var _loc5_:VertexList = null;
         var _loc6_:* = undefined;
         var _loc9_:VertexList = null;
         var _loc14_:VertexList = null;
         var _loc8_:* = null;
         var _loc10_:VertexList = null;
         var _loc13_:Vector.<VertexList> = new Vector.<VertexList>();
         var _loc3_:int = 0;
         var _loc4_:Vector.<VertexList> = new Vector.<VertexList>();
         _loc4_.push(param1);
         while(_loc4_.length > 0)
         {
            _loc2_ = _loc4_.pop();
            _loc7_ = _loc11_ = _loc2_.head;
            _loc12_ = true;
            if(_loc7_.next == _loc7_ || _loc7_.next.next == _loc7_ || _loc7_.next.next.next == _loc7_)
            {
               _loc13_[_loc3_++] = _loc11_;
            }
            else
            {
               do
               {
                  _loc5_ = _loc7_.next.next;
                  do
                  {
                     _loc6_ = intersection(_loc7_,_loc7_.next,_loc5_,_loc5_.next);
                     if(_loc6_ != null)
                     {
                        _loc12_ = false;
                        _loc9_ = _loc7_.next;
                        _loc14_ = VertexList.getNode();
                        _loc14_.vertex = _loc6_;
                        _loc14_.prev = _loc7_;
                        _loc14_.next = _loc5_.next;
                        _loc14_.next.prev = _loc14_;
                        _loc14_.head = _loc11_;
                        _loc7_.next = _loc14_;
                        _loc8_ = _loc5_;
                        _loc10_ = VertexList.getNode();
                        _loc10_.vertex = _loc6_;
                        _loc10_.prev = _loc5_;
                        _loc10_.next = _loc9_;
                        _loc10_.next.prev = _loc10_;
                        _loc10_.head = _loc8_;
                        _loc5_.next = _loc10_;
                        do
                        {
                           _loc5_.head = _loc8_;
                        }
                        while(_loc5_ = _loc5_.next, _loc5_ != _loc8_);
                        
                        _loc4_.push(_loc11_,_loc8_);
                        break;
                     }
                  }
                  while(_loc5_ = _loc5_.next, _loc5_ != _loc7_.prev && _loc12_);
                  
               }
               while(_loc7_ = _loc7_.next, _loc7_ != _loc11_ && _loc12_);
               
               if(_loc12_)
               {
                  _loc13_[_loc3_++] = _loc11_;
               }
            }
         }
         return _loc13_;
      }
      
      private static function flatten(param1:Vector.<VertexList>, param2:Vector.<Number>) : void
      {
         var _loc7_:int = 0;
         var _loc6_:VertexList = null;
         var _loc3_:VertexList = null;
         var _loc5_:int = int(param1.length);
         var _loc4_:int = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_ = param1[_loc7_];
            _loc3_ = _loc6_.head;
            do
            {
               _loc3_.index = _loc4_++;
               param2.push(_loc3_.vertex[0],_loc3_.vertex[1],_loc3_.vertex[2],_loc3_.vertex[3],_loc3_.vertex[4],_loc3_.vertex[5],_loc3_.vertex[6],_loc3_.vertex[7],_loc3_.vertex[8]);
               _loc3_ = _loc3_.next;
            }
            while(_loc3_ != _loc3_.head);
            
            _loc7_++;
         }
      }
      
      private static function windingNumberAroundPoint(param1:VertexList, param2:Number, param3:Number) : int
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc10_:* = false;
         var _loc9_:int = 0;
         var _loc5_:VertexList = param1.head;
         do
         {
            _loc6_ = _loc5_.vertex[1];
            _loc7_ = _loc5_.next.vertex[1];
            if(param3 > _loc6_ && param3 < _loc7_ || param3 > _loc7_ && param3 < _loc6_)
            {
               _loc4_ = _loc5_.vertex[0];
               _loc8_ = _loc5_.next.vertex[0];
               _loc10_ = _loc7_ < param3;
               if(_loc10_)
               {
                  _loc9_ += (_loc8_ - _loc4_) * (param3 - _loc6_) - (_loc7_ - _loc6_) * (param2 - _loc4_) < 0 ? 1 : 0;
               }
               else
               {
                  _loc9_ += (_loc8_ - _loc4_) * (param3 - _loc6_) - (_loc7_ - _loc6_) * (param2 - _loc4_) < 0 ? 0 : -1;
               }
            }
         }
         while(_loc5_ = _loc5_.next, _loc5_ != param1.head);
         
         return _loc9_;
      }
      
      public static function isClockWise(param1:VertexList) : Boolean
      {
         var _loc3_:Number = 0;
         var _loc2_:VertexList = param1.head;
         do
         {
            _loc3_ += (_loc2_.next.vertex[0] - _loc2_.vertex[0]) * (_loc2_.next.vertex[1] + _loc2_.vertex[1]);
            _loc2_ = _loc2_.next;
         }
         while(_loc2_ != param1.head);
         
         return _loc3_ <= 0;
      }
      
      private static function windingNumber(param1:VertexList) : int
      {
         var _loc3_:int = 0;
         var _loc2_:VertexList = param1.head;
         do
         {
            _loc3_ += (_loc2_.next.vertex[0] - _loc2_.vertex[0]) * (_loc2_.next.next.vertex[1] - _loc2_.vertex[1]) - (_loc2_.next.next.vertex[0] - _loc2_.vertex[0]) * (_loc2_.next.vertex[1] - _loc2_.vertex[1]) < 0 ? -1 : 1;
            _loc2_ = _loc2_.next;
         }
         while(_loc2_ != param1.head);
         
         return _loc3_;
      }
      
      private static function isLeft(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Boolean
      {
         return (param3 - param1) * (param6 - param2) - (param4 - param2) * (param5 - param1) < 0;
      }
      
      private static function isPointInTriangle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         if((param3 - param1) * (param8 - param2) - (param7 - param1) * (param4 - param2) < 0)
         {
            return false;
         }
         if((param5 - param3) * (param8 - param4) - (param7 - param3) * (param6 - param4) < 0)
         {
            return false;
         }
         if((param1 - param5) * (param8 - param6) - (param7 - param5) * (param2 - param6) < 0)
         {
            return false;
         }
         return true;
      }
      
      private static function isReflex(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Boolean
      {
         if((param3 - param1) * (param6 - param2) - (param5 - param1) * (param4 - param2) < 0)
         {
            return false;
         }
         if((param5 - param3) * (param2 - param4) - (param1 - param3) * (param6 - param4) < 0)
         {
            return false;
         }
         return true;
      }
      
      private static function intersection(param1:VertexList, param2:VertexList, param3:VertexList, param4:VertexList) : Vector.<Number>
      {
         var _loc15_:Number = param2.vertex[0] - param1.vertex[0];
         var _loc12_:Number = param2.vertex[1] - param1.vertex[1];
         var _loc13_:Number = param4.vertex[0] - param3.vertex[0];
         var _loc10_:Number = param4.vertex[1] - param3.vertex[1];
         var _loc11_:Number = param1.vertex[0] - param3.vertex[0];
         var _loc9_:Number = param1.vertex[1] - param3.vertex[1];
         var _loc6_:Number = _loc15_ * _loc10_ - _loc12_ * _loc13_;
         if((_loc6_ < 0 ? -_loc6_ : _loc6_) < 1e-7)
         {
            return null;
         }
         var _loc14_:Number = (_loc13_ * _loc9_ - _loc10_ * _loc11_) / _loc6_;
         if(_loc14_ < 0 || _loc14_ > 1)
         {
            return null;
         }
         var _loc7_:Number = (_loc15_ * _loc9_ - _loc12_ * _loc11_) / _loc6_;
         if(_loc7_ < 0 || _loc7_ > 1)
         {
            return null;
         }
         var _loc5_:Vector.<Number> = param1.vertex;
         var _loc8_:Vector.<Number> = param2.vertex;
         return Vector.<Number>([_loc5_[0] + _loc14_ * (_loc8_[0] - _loc5_[0]),_loc5_[1] + _loc14_ * (_loc8_[1] - _loc5_[1]),0,_loc5_[3] + _loc14_ * (_loc8_[3] - _loc5_[3]),_loc5_[4] + _loc14_ * (_loc8_[4] - _loc5_[4]),_loc5_[5] + _loc14_ * (_loc8_[5] - _loc5_[5]),_loc5_[6] + _loc14_ * (_loc8_[6] - _loc5_[6]),_loc5_[7] + _loc14_ * (_loc8_[7] - _loc5_[7]),_loc5_[8] + _loc14_ * (_loc8_[8] - _loc5_[8])]);
      }
      
      public function get numVertices() : int
      {
         return _numVertices;
      }
      
      public function clear() : void
      {
         indices = new Vector.<uint>();
         vertices = new Vector.<Number>();
         minBounds.x = minBounds.y = Infinity;
         maxBounds.x = maxBounds.y = -Infinity;
         _numVertices = 0;
         VertexList.dispose(fillVertices);
         fillVertices = null;
         isInvalid = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         clear();
      }
      
      public function addVertex(param1:Number, param2:Number, param3:uint = 16777215, param4:Number = 1) : void
      {
         var _loc8_:Number = (param3 >> 16) / 255;
         var _loc5_:Number = ((param3 & 0xFF00) >> 8) / 255;
         var _loc7_:Number = (param3 & 0xFF) / 255;
         var _loc9_:Vector.<Number> = Vector.<Number>([param1,param2,0,_loc8_,_loc5_,_loc7_,param4,param1,param2]);
         var _loc6_:VertexList = VertexList.getNode();
         if(_numVertices == 0)
         {
            fillVertices = _loc6_;
            _loc6_.head = _loc6_;
            _loc6_.prev = _loc6_;
         }
         _loc6_.next = fillVertices.head;
         _loc6_.prev = fillVertices.head.prev;
         _loc6_.prev.next = _loc6_;
         _loc6_.next.prev = _loc6_;
         _loc6_.index = _numVertices;
         _loc6_.vertex = _loc9_;
         minBounds.x = param1 < minBounds.x ? param1 : minBounds.x;
         minBounds.y = param2 < minBounds.y ? param2 : minBounds.y;
         maxBounds.x = param1 > maxBounds.x ? param1 : maxBounds.x;
         maxBounds.y = param2 > maxBounds.y ? param2 : maxBounds.y;
         _numVertices = _numVertices + 1;
         isInvalid = true;
      }
      
      override protected function buildGeometry() : void
      {
         if(_numVertices < 3)
         {
            return;
         }
         vertices = new Vector.<Number>();
         indices = new Vector.<uint>();
         triangulate(fillVertices,_numVertices,vertices,indices);
      }
      
      override public function shapeHitTest(param1:Number, param2:Number) : Boolean
      {
         if(vertices == null)
         {
            return false;
         }
         if(numVertices < 3)
         {
            return false;
         }
         var _loc4_:Point = globalToLocal(new Point(param1,param2));
         var _loc3_:int = windingNumberAroundPoint(fillVertices,_loc4_.x,_loc4_.y);
         if(isClockWise(fillVertices))
         {
            return _loc3_ != 0;
         }
         return _loc3_ == 0;
      }
   }
}

