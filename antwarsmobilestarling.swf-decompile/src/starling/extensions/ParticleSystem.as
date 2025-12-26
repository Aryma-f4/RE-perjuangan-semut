package starling.extensions
{
   import com.adobe.utils.AGALMiniAssembler;
   import flash.display3D.Context3D;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.Program3D;
   import flash.display3D.VertexBuffer3D;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.animation.IAnimatable;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.errors.MissingContextError;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.utils.MatrixUtil;
   import starling.utils.VertexData;
   
   public class ParticleSystem extends DisplayObject implements IAnimatable
   {
      
      private static var sHelperMatrix:Matrix = new Matrix();
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sRenderAlpha:Vector.<Number> = new <Number>[1,1,1,1];
      
      private var mTexture:Texture;
      
      private var mParticles:Vector.<Particle>;
      
      private var mFrameTime:Number;
      
      private var mProgram:Program3D;
      
      private var mVertexData:VertexData;
      
      private var mVertexBuffer:VertexBuffer3D;
      
      private var mIndices:Vector.<uint>;
      
      private var mIndexBuffer:IndexBuffer3D;
      
      private var mNumParticles:int;
      
      private var mMaxCapacity:int;
      
      private var mEmissionRate:Number;
      
      private var mEmissionTime:Number;
      
      protected var mEmitterX:Number;
      
      protected var mEmitterY:Number;
      
      protected var mPremultipliedAlpha:Boolean;
      
      protected var mBlendFactorSource:String;
      
      protected var mBlendFactorDestination:String;
      
      public function ParticleSystem(param1:Texture, param2:Number, param3:int = 128, param4:int = 8192, param5:String = null, param6:String = null)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("texture must not be null");
         }
         mTexture = param1;
         mPremultipliedAlpha = param1.premultipliedAlpha;
         mParticles = new Vector.<Particle>(0,false);
         mVertexData = new VertexData(0);
         mIndices = new Vector.<uint>(0);
         mEmissionRate = param2;
         mEmissionTime = 0;
         mFrameTime = 0;
         mEmitterX = mEmitterY = 0;
         mMaxCapacity = Math.min(8192,param4);
         mBlendFactorDestination = param6 || "oneMinusSourceAlpha";
         mBlendFactorSource = param5 || (mPremultipliedAlpha ? "one" : "sourceAlpha");
         createProgram();
         raiseCapacity(param3);
         Starling.current.stage3D.addEventListener("context3DCreate",onContextCreated,false,0,true);
      }
      
      override public function dispose() : void
      {
         Starling.current.stage3D.removeEventListener("context3DCreate",onContextCreated);
         if(mVertexBuffer)
         {
            mVertexBuffer.dispose();
         }
         if(mIndexBuffer)
         {
            mIndexBuffer.dispose();
         }
         if(mProgram)
         {
            mProgram.dispose();
         }
         super.dispose();
      }
      
      private function onContextCreated(param1:Object) : void
      {
         createProgram();
         raiseCapacity(0);
      }
      
      protected function createParticle() : Particle
      {
         return new Particle();
      }
      
      protected function initParticle(param1:Particle) : void
      {
         param1.x = mEmitterX;
         param1.y = mEmitterY;
         param1.currentTime = 0;
         param1.totalTime = 1;
         param1.color = Math.random() * 16777215;
      }
      
      protected function advanceParticle(param1:Particle, param2:Number) : void
      {
         param1.y += param2 * 250;
         param1.alpha = 1 - param1.currentTime / param1.totalTime;
         param1.scale = 1 - param1.alpha;
         param1.currentTime += param2;
      }
      
      private function raiseCapacity(param1:int) : void
      {
         var _loc8_:* = 0;
         var _loc7_:int = 0;
         var _loc2_:int = 0;
         var _loc5_:int = capacity;
         var _loc4_:int = Math.min(mMaxCapacity,capacity + param1);
         var _loc6_:Context3D = Starling.context;
         if(_loc6_ == null)
         {
            throw new MissingContextError();
         }
         var _loc3_:VertexData = new VertexData(4);
         _loc3_.setTexCoords(0,0,0);
         _loc3_.setTexCoords(1,1,0);
         _loc3_.setTexCoords(2,0,1);
         _loc3_.setTexCoords(3,1,1);
         mTexture.adjustVertexData(_loc3_,0,4);
         mParticles.fixed = false;
         mIndices.fixed = false;
         _loc8_ = _loc5_;
         while(_loc8_ < _loc4_)
         {
            _loc7_ = _loc8_ * 4;
            _loc2_ = _loc8_ * 6;
            mParticles[_loc8_] = createParticle();
            mVertexData.append(_loc3_);
            mIndices[_loc2_] = _loc7_;
            mIndices[_loc2_ + 1] = _loc7_ + 1;
            mIndices[_loc2_ + 2] = _loc7_ + 2;
            mIndices[_loc2_ + 3] = _loc7_ + 1;
            mIndices[_loc2_ + 4] = _loc7_ + 3;
            mIndices[_loc2_ + 5] = _loc7_ + 2;
            _loc8_++;
         }
         mParticles.fixed = true;
         mIndices.fixed = true;
         if(mVertexBuffer)
         {
            mVertexBuffer.dispose();
         }
         if(mIndexBuffer)
         {
            mIndexBuffer.dispose();
         }
         mVertexBuffer = _loc6_.createVertexBuffer(_loc4_ * 4,8);
         mVertexBuffer.uploadFromVector(mVertexData.rawData,0,_loc4_ * 4);
         mIndexBuffer = _loc6_.createIndexBuffer(_loc4_ * 6);
         mIndexBuffer.uploadFromVector(mIndices,0,_loc4_ * 6);
      }
      
      public function start(param1:Number = 1.7976931348623157e+308) : void
      {
         if(mEmissionRate != 0)
         {
            mEmissionTime = param1;
         }
      }
      
      public function stop() : void
      {
         mEmissionTime = 0;
         mNumParticles = 0;
      }
      
      public function pause() : void
      {
         mEmissionTime = 0;
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         if(param2 == null)
         {
            param2 = new Rectangle();
         }
         getTransformationMatrix(param1,sHelperMatrix);
         MatrixUtil.transformCoords(sHelperMatrix,0,0,sHelperPoint);
         param2.x = sHelperPoint.x;
         param2.y = sHelperPoint.y;
         param2.width = param2.height = 0;
         return param2;
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc7_:Particle = null;
         var _loc22_:Particle = null;
         var _loc19_:Number = NaN;
         var _loc10_:* = 0;
         var _loc16_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc20_:int = 0;
         while(_loc20_ < mNumParticles)
         {
            _loc7_ = mParticles[_loc20_] as Particle;
            if(_loc7_.currentTime < _loc7_.totalTime)
            {
               advanceParticle(_loc7_,param1);
               _loc20_++;
            }
            else
            {
               if(_loc20_ != mNumParticles - 1)
               {
                  _loc22_ = mParticles[mNumParticles - 1] as Particle;
                  mParticles[mNumParticles - 1] = _loc7_;
                  mParticles[_loc20_] = _loc22_;
               }
               mNumParticles = mNumParticles - 1;
               if(mNumParticles == 0)
               {
                  dispatchEvent(new Event("complete"));
               }
            }
         }
         if(mEmissionTime > 0)
         {
            _loc19_ = 1 / mEmissionRate;
            mFrameTime += param1;
            while(mFrameTime > 0)
            {
               if(mNumParticles < mMaxCapacity)
               {
                  if(mNumParticles == capacity)
                  {
                     raiseCapacity(capacity);
                  }
                  _loc7_ = mParticles[mNumParticles++] as Particle;
                  initParticle(_loc7_);
                  advanceParticle(_loc7_,mFrameTime);
               }
               mFrameTime -= _loc19_;
            }
            if(mEmissionTime != 1.7976931348623157e+308)
            {
               mEmissionTime = Math.max(0,mEmissionTime - param1);
            }
         }
         var _loc4_:* = 0;
         var _loc13_:Number = mTexture.width;
         var _loc15_:Number = mTexture.height;
         _loc6_ = 0;
         while(_loc6_ < mNumParticles)
         {
            _loc4_ = _loc6_ << 2;
            _loc7_ = mParticles[_loc6_] as Particle;
            _loc10_ = _loc7_.color;
            _loc16_ = _loc7_.alpha;
            _loc14_ = _loc7_.rotation;
            _loc23_ = _loc7_.x;
            _loc21_ = _loc7_.y;
            _loc8_ = _loc13_ * _loc7_.scale >> 1;
            _loc2_ = _loc15_ * _loc7_.scale >> 1;
            _loc5_ = 0;
            while(_loc5_ < 4)
            {
               mVertexData.setColor(_loc4_ + _loc5_,_loc10_);
               mVertexData.setAlpha(_loc4_ + _loc5_,_loc16_);
               _loc5_++;
            }
            if(_loc14_)
            {
               _loc3_ = Math.cos(_loc14_);
               _loc12_ = Math.sin(_loc14_);
               _loc11_ = _loc3_ * _loc8_;
               _loc9_ = _loc3_ * _loc2_;
               _loc17_ = _loc12_ * _loc8_;
               _loc18_ = _loc12_ * _loc2_;
               mVertexData.setPosition(_loc4_,_loc23_ - _loc11_ + _loc18_,_loc21_ - _loc17_ - _loc9_);
               mVertexData.setPosition(_loc4_ + 1,_loc23_ + _loc11_ + _loc18_,_loc21_ + _loc17_ - _loc9_);
               mVertexData.setPosition(_loc4_ + 2,_loc23_ - _loc11_ - _loc18_,_loc21_ - _loc17_ + _loc9_);
               mVertexData.setPosition(_loc4_ + 3,_loc23_ + _loc11_ - _loc18_,_loc21_ + _loc17_ + _loc9_);
            }
            else
            {
               mVertexData.setPosition(_loc4_,_loc23_ - _loc8_,_loc21_ - _loc2_);
               mVertexData.setPosition(_loc4_ + 1,_loc23_ + _loc8_,_loc21_ - _loc2_);
               mVertexData.setPosition(_loc4_ + 2,_loc23_ - _loc8_,_loc21_ + _loc2_);
               mVertexData.setPosition(_loc4_ + 3,_loc23_ + _loc8_,_loc21_ + _loc2_);
            }
            _loc6_++;
         }
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         if(mNumParticles == 0)
         {
            return;
         }
         param1.finishQuadBatch();
         if(param1.hasOwnProperty("raiseDrawCount"))
         {
            param1.raiseDrawCount();
         }
         param2 *= this.alpha;
         var _loc3_:Context3D = Starling.context;
         var _loc4_:Boolean = texture.premultipliedAlpha;
         sRenderAlpha[0] = sRenderAlpha[1] = sRenderAlpha[2] = _loc4_ ? param2 : 1;
         sRenderAlpha[3] = param2;
         if(_loc3_ == null)
         {
            throw new MissingContextError();
         }
         mVertexBuffer.uploadFromVector(mVertexData.rawData,0,mNumParticles * 4);
         mIndexBuffer.uploadFromVector(mIndices,0,mNumParticles * 6);
         _loc3_.setBlendFactors(mBlendFactorSource,mBlendFactorDestination);
         _loc3_.setTextureAt(0,mTexture.base);
         _loc3_.setProgram(mProgram);
         _loc3_.setProgramConstantsFromMatrix("vertex",0,param1.mvpMatrix3D,true);
         _loc3_.setProgramConstantsFromVector("vertex",4,sRenderAlpha,1);
         _loc3_.setVertexBufferAt(0,mVertexBuffer,0,"float2");
         _loc3_.setVertexBufferAt(1,mVertexBuffer,2,"float4");
         _loc3_.setVertexBufferAt(2,mVertexBuffer,6,"float2");
         _loc3_.drawTriangles(mIndexBuffer,0,mNumParticles * 2);
         _loc3_.setTextureAt(0,null);
         _loc3_.setVertexBufferAt(0,null);
         _loc3_.setVertexBufferAt(1,null);
         _loc3_.setVertexBufferAt(2,null);
      }
      
      private function createProgram() : void
      {
         var _loc8_:Boolean = mTexture.mipMapping;
         var _loc7_:String = mTexture.format;
         var _loc5_:Context3D = Starling.context;
         if(_loc5_ == null)
         {
            throw new MissingContextError();
         }
         if(mProgram)
         {
            mProgram.dispose();
         }
         var _loc4_:String = "2d, clamp, linear, " + (_loc8_ ? "mipnearest" : "mipnone");
         if(_loc7_ == "compressed")
         {
            _loc4_ += ", dxt1";
         }
         else if(_loc7_ == "compressedAlpha")
         {
            _loc4_ += ", dxt5";
         }
         var _loc2_:String = "m44 op, va0, vc0 \nmul v0, va1, vc4 \nmov v1, va2      \n";
         var _loc6_:String = "tex ft1, v1, fs0 <" + _loc4_ + "> \n" + "mul oc, ft1, v0";
         var _loc1_:AGALMiniAssembler = new AGALMiniAssembler();
         _loc1_.assemble("vertex",_loc2_);
         var _loc3_:AGALMiniAssembler = new AGALMiniAssembler();
         _loc3_.assemble("fragment",_loc6_);
         mProgram = _loc5_.createProgram();
         mProgram.upload(_loc1_.agalcode,_loc3_.agalcode);
      }
      
      public function get capacity() : int
      {
         return mVertexData.numVertices / 4;
      }
      
      public function get numParticles() : int
      {
         return mNumParticles;
      }
      
      public function get maxCapacity() : int
      {
         return mMaxCapacity;
      }
      
      public function set maxCapacity(param1:int) : void
      {
         mMaxCapacity = Math.min(8192,param1);
      }
      
      public function get emissionRate() : Number
      {
         return mEmissionRate;
      }
      
      public function set emissionRate(param1:Number) : void
      {
         mEmissionRate = param1;
      }
      
      public function get emitterX() : Number
      {
         return mEmitterX;
      }
      
      public function set emitterX(param1:Number) : void
      {
         mEmitterX = param1;
      }
      
      public function get emitterY() : Number
      {
         return mEmitterY;
      }
      
      public function set emitterY(param1:Number) : void
      {
         mEmitterY = param1;
      }
      
      public function get blendFactorSource() : String
      {
         return mBlendFactorSource;
      }
      
      public function set blendFactorSource(param1:String) : void
      {
         mBlendFactorSource = param1;
      }
      
      public function get blendFactorDestination() : String
      {
         return mBlendFactorDestination;
      }
      
      public function set blendFactorDestination(param1:String) : void
      {
         mBlendFactorDestination = param1;
      }
      
      public function get texture() : Texture
      {
         return mTexture;
      }
      
      public function set texture(param1:Texture) : void
      {
         mTexture = param1;
         createProgram();
      }
   }
}

