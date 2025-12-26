package starling.display
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import starling.display.graphics.Fill;
   import starling.display.graphics.NGon;
   import starling.display.graphics.Plane;
   import starling.display.graphics.RoundedRectangle;
   import starling.display.graphics.Stroke;
   import starling.display.materials.IMaterial;
   import starling.display.shaders.fragment.TextureFragmentShader;
   import starling.display.util.CurveUtil;
   import starling.textures.Texture;
   
   public class Graphics
   {
      
      public static const BEZIER_ERROR:Number = 0.75;
      
      private static const DEG_TO_RAD:Number = 0.017453292519943295;
      
      private static var textureFragmentShader:TextureFragmentShader = new TextureFragmentShader();
      
      private var _currentX:Number;
      
      private var _currentY:Number;
      
      private var _currentStroke:Stroke;
      
      private var _currentFill:Fill;
      
      private var _fillColor:uint;
      
      private var _fillAlpha:Number;
      
      private var _strokeThickness:Number;
      
      private var _strokeColor:uint;
      
      private var _strokeAlpha:Number;
      
      private var _strokeTexture:Texture;
      
      private var _strokeMaterial:IMaterial;
      
      private var _container:DisplayObjectContainer;
      
      public function Graphics(param1:DisplayObjectContainer)
      {
         super();
         _container = param1;
      }
      
      public function clear() : void
      {
         var _loc1_:DisplayObject = null;
         while(_container.numChildren > 0)
         {
            _loc1_ = _container.getChildAt(0);
            _loc1_.dispose();
            _container.removeChildAt(0);
         }
         _currentX = NaN;
         _currentY = NaN;
      }
      
      public function beginFill(param1:uint, param2:Number = 1) : void
      {
         _fillColor = param1;
         _fillAlpha = param2;
         _currentFill = new Fill();
         _currentFill.alpha = _fillAlpha;
         _currentFill.material.color = param1;
         _container.addChild(_currentFill);
      }
      
      public function beginBitmapFill(param1:BitmapData, param2:Matrix = null) : void
      {
         _fillColor = 16777215;
         _fillAlpha = 1;
         _currentFill = new Fill();
         _currentFill.material.fragmentShader = textureFragmentShader;
         var _loc3_:Texture = Texture.fromBitmapData(param1,false);
         _currentFill.material.textures[0] = _loc3_;
         var _loc4_:Matrix = new Matrix();
         _loc4_.scale(1 / _loc3_.width,1 / _loc3_.height);
         if(param2)
         {
            _loc4_.concat(param2);
         }
         _currentFill.uvMatrix = _loc4_;
         _container.addChild(_currentFill);
      }
      
      public function beginTextureFill(param1:Texture, param2:Matrix = null) : void
      {
         _fillColor = 16777215;
         _fillAlpha = 1;
         _currentFill = new Fill();
         _currentFill.material.fragmentShader = textureFragmentShader;
         _currentFill.material.textures[0] = param1;
         var _loc3_:Matrix = new Matrix();
         _loc3_.scale(1 / param1.width,1 / param1.height);
         if(param2)
         {
            _loc3_.concat(param2);
         }
         _currentFill.uvMatrix = _loc3_;
         _container.addChild(_currentFill);
      }
      
      public function beginMaterialFill(param1:IMaterial, param2:Matrix = null) : void
      {
         var _loc3_:Matrix = null;
         _fillColor = 16777215;
         _fillAlpha = 1;
         _currentFill = new Fill();
         _currentFill.material = param1;
         if(param2)
         {
            _loc3_ = param2.clone();
            _loc3_.invert();
         }
         else
         {
            _loc3_ = new Matrix();
         }
         if(param1.textures.length > 0)
         {
            _loc3_.scale(1 / param1.textures[0].width,1 / param1.textures[0].height);
         }
         _currentFill.uvMatrix = _loc3_;
         _container.addChild(_currentFill);
      }
      
      public function endFill() : void
      {
         if(_currentFill && _currentFill.numVertices < 3)
         {
            _container.removeChild(_currentFill);
         }
         _fillColor = NaN;
         _fillAlpha = NaN;
         _currentFill = null;
      }
      
      public function drawCircle(param1:Number, param2:Number, param3:Number) : void
      {
         drawEllipse(param1,param2,param3 * 2,param3 * 2);
      }
      
      public function drawEllipse(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc19_:NGon = null;
         var _loc10_:Matrix = null;
         var _loc18_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc14_:* = NaN;
         var _loc8_:* = NaN;
         var _loc11_:int = 0;
         var _loc20_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc13_:int = 3.141592653589793 * (param3 * 0.5 + param4 * 0.5) * 0.25;
         _loc13_ = int(_loc13_ < 6 ? 6 : _loc13_);
         var _loc12_:Fill = _currentFill;
         if(_currentFill)
         {
            _loc19_ = new NGon(param3 * 0.5,_loc13_);
            _loc19_.x = param1;
            _loc19_.y = param2;
            _loc19_.scaleY = param4 / param3;
            _loc19_.material = _currentFill.material;
            _loc19_.material.color = _fillColor;
            _loc19_.alpha = _fillAlpha;
            _loc10_ = new Matrix();
            _loc10_.scale(param3,param4);
            if(_loc12_.uvMatrix)
            {
               _loc10_.concat(_loc12_.uvMatrix);
            }
            _loc19_.uvMatrix = _loc10_;
            _container.addChild(_loc19_);
            _currentFill = null;
         }
         if(isNaN(_strokeThickness) == false)
         {
            _loc18_ = param3 * 0.5;
            _loc16_ = param4 * 0.5;
            _loc6_ = 3.141592653589793 * 2 / _loc13_;
            _loc9_ = Math.cos(_loc6_);
            _loc7_ = Math.sin(_loc6_);
            _loc14_ = 0;
            _loc8_ = 1;
            _loc11_ = 0;
            while(_loc11_ <= _loc13_)
            {
               _loc20_ = _loc14_ * _loc18_ + param1;
               _loc17_ = -_loc8_ * _loc16_ + param2;
               if(_loc11_ == 0)
               {
                  moveTo(_loc20_,_loc17_);
               }
               else
               {
                  lineTo(_loc20_,_loc17_);
               }
               _loc5_ = _loc7_ * _loc8_ + _loc9_ * _loc14_;
               _loc8_ = _loc15_ = _loc9_ * _loc8_ - _loc7_ * _loc14_;
               _loc14_ = _loc5_;
               _loc11_++;
            }
         }
         _currentFill = _loc12_;
      }
      
      public function drawRect(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc7_:Fill = null;
         var _loc5_:Plane = null;
         var _loc6_:Matrix = null;
         if(_currentFill)
         {
            _loc7_ = _currentFill;
            _currentFill = null;
            _loc5_ = new Plane(param3,param4);
            _loc5_.material = _loc7_.material;
            _loc6_ = new Matrix();
            _loc6_.scale(param3,param4);
            if(_loc7_.uvMatrix)
            {
               _loc6_.concat(_loc7_.uvMatrix);
            }
            _loc5_.uvMatrix = _loc6_;
            _loc5_.x = param1;
            _loc5_.y = param2;
            _container.addChild(_loc5_);
         }
         moveTo(param1,param2);
         lineTo(param1 + param3,param2);
         lineTo(param1 + param3,param2 + param4);
         lineTo(param1,param2 + param4);
         lineTo(param1,param2);
         _currentFill = _loc7_;
      }
      
      public function drawRoundRect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         drawRoundRectComplex(param1,param2,param3,param4,param5,param5,param5,param5);
      }
      
      public function drawRoundRectComplex(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         var _loc12_:Fill = null;
         var _loc10_:Matrix = null;
         var _loc9_:* = undefined;
         var _loc11_:int = 0;
         if(!_currentFill && _strokeThickness <= 0)
         {
            return;
         }
         var _loc13_:RoundedRectangle = new RoundedRectangle(param3,param4,param5,param6,param7,param8);
         if(_currentFill)
         {
            _loc12_ = _currentFill;
            _currentFill = null;
            _loc13_.material = _loc12_.material;
            _loc10_ = new Matrix();
            _loc10_.scale(param3,param4);
            if(_loc12_.uvMatrix)
            {
               _loc10_.concat(_loc12_.uvMatrix);
            }
            _loc13_.uvMatrix = _loc10_;
            _loc13_.x = param1;
            _loc13_.y = param2;
            _container.addChild(_loc13_);
         }
         _currentFill = _loc12_;
         if(_strokeTexture)
         {
            beginTextureStroke();
         }
         else if(_strokeMaterial)
         {
            beginMaterialStroke();
         }
         else if(_strokeThickness > 0)
         {
            beginStroke();
         }
         if(_currentStroke)
         {
            _loc9_ = _loc13_.getStrokePoints();
            _loc11_ = 0;
            while(_loc11_ < _loc9_.length)
            {
               _currentStroke.addVertex(param1 + _loc9_[_loc11_],param2 + _loc9_[_loc11_ + 1],_strokeThickness,_strokeColor,_strokeAlpha,_strokeColor,_strokeAlpha);
               _loc11_ += 2;
            }
         }
      }
      
      public function lineStyle(param1:Number = NaN, param2:uint = 0, param3:Number = 1) : void
      {
         _strokeThickness = param1;
         _strokeColor = param2;
         _strokeAlpha = param3;
         _strokeTexture = null;
         _strokeMaterial = null;
      }
      
      public function lineTexture(param1:Number = NaN, param2:Texture = null) : void
      {
         _strokeThickness = param1;
         _strokeColor = 16777215;
         _strokeAlpha = 1;
         _strokeTexture = param2;
         _strokeMaterial = null;
      }
      
      public function lineMaterial(param1:Number = NaN, param2:IMaterial = null) : void
      {
         _strokeThickness = param1;
         _strokeColor = 16777215;
         _strokeAlpha = 1;
         _strokeTexture = null;
         _strokeMaterial = param2;
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         if(_strokeTexture)
         {
            beginTextureStroke();
         }
         else if(_strokeMaterial)
         {
            beginMaterialStroke();
         }
         else if(_strokeThickness > 0)
         {
            beginStroke();
         }
         if(_currentStroke && _strokeThickness > 0)
         {
            _currentStroke.addVertex(param1,param2,_strokeThickness);
         }
         if(_currentFill)
         {
            _currentFill.addVertex(param1,param2);
         }
         _currentX = param1;
         _currentY = param2;
      }
      
      public function lineTo(param1:Number, param2:Number) : void
      {
         if(!_currentStroke && _strokeThickness > 0)
         {
            if(_strokeTexture)
            {
               beginTextureStroke();
            }
            else if(_strokeMaterial)
            {
               beginMaterialStroke();
            }
            else
            {
               beginStroke();
            }
         }
         if(isNaN(_currentX))
         {
            moveTo(0,0);
         }
         if(_currentStroke && _strokeThickness > 0)
         {
            _currentStroke.addVertex(param1,param2,_strokeThickness);
         }
         if(_currentFill)
         {
            _currentFill.addVertex(param1,param2);
         }
         _currentX = param1;
         _currentY = param2;
      }
      
      public function curveTo(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 0.75) : void
      {
         var _loc12_:int = 0;
         var _loc11_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc6_:Number = _currentX;
         var _loc7_:Number = _currentY;
         if(isNaN(_loc6_))
         {
            _loc6_ = 0;
            _loc7_ = 0;
         }
         var _loc9_:Vector.<Number> = CurveUtil.quadraticCurve(_loc6_,_loc7_,param1,param2,param3,param4,param5);
         var _loc8_:int = int(_loc9_.length);
         _loc12_ = 0;
         while(_loc12_ < _loc8_)
         {
            _loc11_ = _loc9_[_loc12_];
            _loc10_ = _loc9_[_loc12_ + 1];
            if(_loc12_ == 0 && isNaN(_currentX))
            {
               moveTo(_loc11_,_loc10_);
            }
            else
            {
               lineTo(_loc11_,_loc10_);
            }
            _loc12_ += 2;
         }
         _currentX = param3;
         _currentY = param4;
      }
      
      public function cubicCurveTo(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number = 0.75) : void
      {
         var _loc9_:int = 0;
         var _loc14_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc10_:Number = _currentX;
         var _loc11_:Number = _currentY;
         if(isNaN(_loc10_))
         {
            _loc10_ = 0;
            _loc11_ = 0;
         }
         var _loc12_:Vector.<Number> = CurveUtil.cubicCurve(_loc10_,_loc11_,param1,param2,param3,param4,param5,param6,param7);
         var _loc8_:int = int(_loc12_.length);
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc14_ = _loc12_[_loc9_];
            _loc13_ = _loc12_[_loc9_ + 1];
            if(_loc9_ == 0 && isNaN(_currentX))
            {
               moveTo(_loc14_,_loc13_);
            }
            else
            {
               lineTo(_loc14_,_loc13_);
            }
            _loc9_ += 2;
         }
         _currentX = param5;
         _currentY = param6;
      }
      
      private function beginStroke() : void
      {
         if(_currentStroke && _currentStroke.numVertices < 2)
         {
            _container.removeChild(_currentStroke);
         }
         _currentStroke = new Stroke();
         _currentStroke.material.color = _strokeColor;
         _currentStroke.material.alpha = _strokeAlpha;
         _container.addChild(_currentStroke);
      }
      
      private function beginTextureStroke() : void
      {
         if(_currentStroke && _currentStroke.numVertices < 2)
         {
            _container.removeChild(_currentStroke);
         }
         _currentStroke = new Stroke();
         _currentStroke.material.fragmentShader = textureFragmentShader;
         _currentStroke.material.textures[0] = _strokeTexture;
         _currentStroke.material.color = _strokeColor;
         _currentStroke.material.alpha = _strokeAlpha;
         _container.addChild(_currentStroke);
      }
      
      private function beginMaterialStroke() : void
      {
         if(_currentStroke && _currentStroke.numVertices < 2)
         {
            _container.removeChild(_currentStroke);
         }
         _currentStroke = new Stroke();
         _currentStroke.material = _strokeMaterial;
         _container.addChild(_currentStroke);
      }
      
      private function deg2rad(param1:Number) : Number
      {
         return param1 * 3.141592653589793 / 180;
      }
   }
}

