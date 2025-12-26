package starling.filters
{
   import flash.display3D.Context3D;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.Program3D;
   import flash.display3D.VertexBuffer3D;
   import flash.errors.IllegalOperationError;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.utils.getQualifiedClassName;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import starling.core.starling_internal;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.QuadBatch;
   import starling.display.Stage;
   import starling.errors.AbstractClassError;
   import starling.errors.MissingContextError;
   import starling.textures.Texture;
   import starling.utils.MatrixUtil;
   import starling.utils.RectangleUtil;
   import starling.utils.SystemUtil;
   import starling.utils.VertexData;
   import starling.utils.getNextPowerOfTwo;
   
   use namespace starling_internal;
   
   public class FragmentFilter
   {
      
      private static var sStageBounds:Rectangle = new Rectangle();
      
      private static var sTransformationMatrix:Matrix = new Matrix();
      
      private const MIN_TEXTURE_SIZE:int = 64;
      
      protected const PMA:Boolean = true;
      
      protected const STD_VERTEX_SHADER:String = "m44 op, va0, vc0 \nmov v0, va1      \n";
      
      protected const STD_FRAGMENT_SHADER:String = "tex oc, v0, fs0 <2d, clamp, linear, mipnone>";
      
      private var mVertexPosAtID:int = 0;
      
      private var mTexCoordsAtID:int = 1;
      
      private var mBaseTextureID:int = 0;
      
      private var mMvpConstantID:int = 0;
      
      private var mNumPasses:int;
      
      private var mPassTextures:Vector.<Texture>;
      
      private var mMode:String;
      
      private var mResolution:Number;
      
      private var mMarginX:Number;
      
      private var mMarginY:Number;
      
      private var mOffsetX:Number;
      
      private var mOffsetY:Number;
      
      private var mVertexData:VertexData;
      
      private var mVertexBuffer:VertexBuffer3D;
      
      private var mIndexData:Vector.<uint>;
      
      private var mIndexBuffer:IndexBuffer3D;
      
      private var mCacheRequested:Boolean;
      
      private var mCache:QuadBatch;
      
      private var mHelperMatrix:Matrix = new Matrix();
      
      private var mHelperMatrix3D:Matrix3D = new Matrix3D();
      
      private var mHelperRect:Rectangle = new Rectangle();
      
      private var mHelperRect2:Rectangle = new Rectangle();
      
      public function FragmentFilter(param1:int = 1, param2:Number = 1)
      {
         super();
         if(Capabilities.isDebugger && getQualifiedClassName(this) == "starling.filters::FragmentFilter")
         {
            throw new AbstractClassError();
         }
         if(param1 < 1)
         {
            throw new ArgumentError("At least one pass is required.");
         }
         mNumPasses = param1;
         mMarginX = mMarginY = 0;
         mOffsetX = mOffsetY = 0;
         mResolution = param2;
         mPassTextures = new Vector.<Texture>(0);
         mMode = "replace";
         mVertexData = new VertexData(4);
         mVertexData.setTexCoords(0,0,0);
         mVertexData.setTexCoords(1,1,0);
         mVertexData.setTexCoords(2,0,1);
         mVertexData.setTexCoords(3,1,1);
         mIndexData = new <uint>[0,1,2,1,3,2];
         mIndexData.fixed = true;
         if(Starling.current.contextValid)
         {
            createPrograms();
         }
         Starling.current.stage3D.addEventListener("context3DCreate",onContextCreated,false,0,true);
      }
      
      public function dispose() : void
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
         disposePassTextures();
         disposeCache();
      }
      
      private function onContextCreated(param1:Object) : void
      {
         mVertexBuffer = null;
         mIndexBuffer = null;
         disposePassTextures();
         createPrograms();
         if(mCache)
         {
            cache();
         }
      }
      
      public function render(param1:DisplayObject, param2:RenderSupport, param3:Number) : void
      {
         if(mode == "above")
         {
            param1.render(param2,param3);
         }
         if(mCacheRequested)
         {
            mCacheRequested = false;
            mCache = renderPasses(param1,param2,1,true);
            disposePassTextures();
         }
         if(mCache)
         {
            mCache.render(param2,param3);
         }
         else
         {
            renderPasses(param1,param2,param3,false);
         }
         if(mode == "below")
         {
            param1.render(param2,param3);
         }
      }
      
      private function renderPasses(param1:DisplayObject, param2:RenderSupport, param3:Number, param4:Boolean = false) : QuadBatch
      {
         var _loc8_:Texture = null;
         var _loc11_:int = 0;
         var _loc6_:QuadBatch = null;
         var _loc7_:Image = null;
         var _loc13_:Texture = null;
         var _loc18_:Context3D = Starling.context;
         var _loc15_:DisplayObject = param1.stage;
         var _loc10_:Stage = Starling.current.stage;
         var _loc5_:Number = Starling.current.contentScaleFactor;
         var _loc17_:Matrix = mHelperMatrix;
         var _loc9_:Matrix3D = mHelperMatrix3D;
         var _loc12_:Rectangle = mHelperRect;
         var _loc14_:Rectangle = mHelperRect2;
         if(_loc18_ == null)
         {
            throw new MissingContextError();
         }
         calculateBounds(param1,_loc15_,mResolution * _loc5_,!param4,_loc12_,_loc14_);
         if(_loc12_.isEmpty())
         {
            disposePassTextures();
            return param4 ? new QuadBatch() : null;
         }
         updateBuffers(_loc18_,_loc14_);
         updatePassTextures(_loc14_.width,_loc14_.height,mResolution * _loc5_);
         param2.finishQuadBatch();
         param2.raiseDrawCount(mNumPasses);
         param2.pushMatrix();
         param2.pushMatrix3D();
         _loc17_.copyFrom(param2.projectionMatrix);
         _loc9_.copyFrom(param2.projectionMatrix3D);
         var _loc16_:Texture = param2.renderTarget;
         if(_loc16_ && !SystemUtil.supportsRelaxedTargetClearRequirement)
         {
            throw new IllegalOperationError("To nest filters, you need at least Flash Player / AIR version 15.");
         }
         if(param4)
         {
            _loc13_ = Texture.empty(_loc14_.width,_loc14_.height,true,false,true,mResolution * _loc5_);
         }
         param2.renderTarget = mPassTextures[0];
         param2.clear();
         param2.blendMode = "normal";
         param2.setProjectionMatrix(_loc12_.x,_loc12_.y,_loc14_.width,_loc14_.height,_loc10_.stageWidth,_loc10_.stageHeight,_loc10_.cameraPosition);
         param1.render(param2,param3);
         param2.finishQuadBatch();
         RenderSupport.setBlendFactors(true);
         param2.loadIdentity();
         param2.pushClipRect(_loc12_);
         _loc18_.setVertexBufferAt(mVertexPosAtID,mVertexBuffer,0,"float2");
         _loc18_.setVertexBufferAt(mTexCoordsAtID,mVertexBuffer,6,"float2");
         _loc11_ = 0;
         while(_loc11_ < mNumPasses)
         {
            if(_loc11_ < mNumPasses - 1)
            {
               param2.renderTarget = getPassTexture(_loc11_ + 1);
               param2.clear();
            }
            else if(param4)
            {
               param2.renderTarget = _loc13_;
               param2.clear();
            }
            else
            {
               param2.projectionMatrix = _loc17_;
               param2.projectionMatrix3D = _loc9_;
               param2.renderTarget = _loc16_;
               param2.translateMatrix(mOffsetX,mOffsetY);
               param2.blendMode = param1.blendMode;
               param2.applyBlendMode(true);
            }
            _loc8_ = getPassTexture(_loc11_);
            _loc18_.setProgramConstantsFromMatrix("vertex",mMvpConstantID,param2.mvpMatrix3D,true);
            _loc18_.setTextureAt(mBaseTextureID,_loc8_.base);
            activate(_loc11_,_loc18_,_loc8_);
            _loc18_.drawTriangles(mIndexBuffer,0,2);
            deactivate(_loc11_,_loc18_,_loc8_);
            _loc11_++;
         }
         _loc18_.setVertexBufferAt(mVertexPosAtID,null);
         _loc18_.setVertexBufferAt(mTexCoordsAtID,null);
         _loc18_.setTextureAt(mBaseTextureID,null);
         param2.popMatrix();
         param2.popMatrix3D();
         param2.popClipRect();
         if(param4)
         {
            param2.renderTarget = _loc16_;
            param2.projectionMatrix.copyFrom(_loc17_);
            param2.projectionMatrix3D.copyFrom(_loc9_);
            _loc6_ = new QuadBatch();
            _loc7_ = new Image(_loc13_);
            param1.getTransformationMatrix(_loc15_,sTransformationMatrix).invert();
            MatrixUtil.prependTranslation(sTransformationMatrix,_loc12_.x + mOffsetX,_loc12_.y + mOffsetY);
            _loc6_.addImage(_loc7_,1,sTransformationMatrix);
            return _loc6_;
         }
         return null;
      }
      
      private function updateBuffers(param1:Context3D, param2:Rectangle) : void
      {
         mVertexData.setPosition(0,param2.x,param2.y);
         mVertexData.setPosition(1,param2.right,param2.y);
         mVertexData.setPosition(2,param2.x,param2.bottom);
         mVertexData.setPosition(3,param2.right,param2.bottom);
         if(mVertexBuffer == null)
         {
            mVertexBuffer = param1.createVertexBuffer(4,8);
            mIndexBuffer = param1.createIndexBuffer(6);
            mIndexBuffer.uploadFromVector(mIndexData,0,6);
         }
         mVertexBuffer.uploadFromVector(mVertexData.rawData,0,4);
      }
      
      private function updatePassTextures(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc6_:int = 0;
         var _loc4_:int = mNumPasses > 1 ? 2 : 1;
         var _loc5_:Boolean = mPassTextures.length != _loc4_ || Math.abs(mPassTextures[0].nativeWidth - param1 * param3) > 0.1 || Math.abs(mPassTextures[0].nativeHeight - param2 * param3) > 0.1;
         if(_loc5_)
         {
            disposePassTextures();
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               mPassTextures[_loc6_] = Texture.empty(param1,param2,true,false,true,param3);
               _loc6_++;
            }
         }
      }
      
      private function getPassTexture(param1:int) : Texture
      {
         return mPassTextures[param1 % 2];
      }
      
      private function calculateBounds(param1:DisplayObject, param2:DisplayObject, param3:Number, param4:Boolean, param5:Rectangle, param6:Rectangle) : void
      {
         var _loc10_:Stage = null;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc12_:Number = mMarginX;
         var _loc11_:Number = mMarginY;
         if(param2 is Stage)
         {
            _loc10_ = param2 as Stage;
            if(param1 == _loc10_ || param1 == param1.root)
            {
               _loc12_ = _loc11_ = 0;
               param5.setTo(0,0,_loc10_.stageWidth,_loc10_.stageHeight);
            }
            else
            {
               param1.getBounds(_loc10_,param5);
            }
            if(param4)
            {
               sStageBounds.setTo(0,0,_loc10_.stageWidth,_loc10_.stageHeight);
               RectangleUtil.intersect(param5,sStageBounds,param5);
            }
         }
         else
         {
            param1.getBounds(param2,param5);
         }
         if(!param5.isEmpty())
         {
            param5.inflate(_loc12_,_loc11_);
            _loc8_ = 64 / param3;
            _loc9_ = Number(param5.width > _loc8_ ? param5.width : _loc8_);
            _loc7_ = Number(param5.height > _loc8_ ? param5.height : _loc8_);
            param6.setTo(param5.x,param5.y,getNextPowerOfTwo(_loc9_ * param3) / param3,getNextPowerOfTwo(_loc7_ * param3) / param3);
         }
      }
      
      private function disposePassTextures() : void
      {
         for each(var _loc1_ in mPassTextures)
         {
            _loc1_.dispose();
         }
         mPassTextures.length = 0;
      }
      
      private function disposeCache() : void
      {
         if(mCache)
         {
            if(mCache.texture)
            {
               mCache.texture.dispose();
            }
            mCache.dispose();
            mCache = null;
         }
      }
      
      protected function createPrograms() : void
      {
         throw new Error("Method has to be implemented in subclass!");
      }
      
      protected function activate(param1:int, param2:Context3D, param3:Texture) : void
      {
         throw new Error("Method has to be implemented in subclass!");
      }
      
      protected function deactivate(param1:int, param2:Context3D, param3:Texture) : void
      {
      }
      
      protected function assembleAgal(param1:String = null, param2:String = null) : Program3D
      {
         if(param1 == null)
         {
            param1 = "tex oc, v0, fs0 <2d, clamp, linear, mipnone>";
         }
         if(param2 == null)
         {
            param2 = "m44 op, va0, vc0 \nmov v0, va1      \n";
         }
         return RenderSupport.assembleAgal(param2,param1);
      }
      
      public function cache() : void
      {
         mCacheRequested = true;
         disposeCache();
      }
      
      public function clearCache() : void
      {
         mCacheRequested = false;
         disposeCache();
      }
      
      starling_internal function compile(param1:DisplayObject) : QuadBatch
      {
         var _loc2_:RenderSupport = null;
         var _loc4_:Stage = null;
         var _loc3_:QuadBatch = null;
         if(mCache)
         {
            return mCache;
         }
         _loc4_ = param1.stage;
         _loc2_ = new RenderSupport();
         param1.getTransformationMatrix(_loc4_,_loc2_.modelViewMatrix);
         _loc3_ = renderPasses(param1,_loc2_,1,true);
         _loc2_.dispose();
         return _loc3_;
      }
      
      public function get isCached() : Boolean
      {
         return mCache != null || mCacheRequested;
      }
      
      public function get resolution() : Number
      {
         return mResolution;
      }
      
      public function set resolution(param1:Number) : void
      {
         if(param1 <= 0)
         {
            throw new ArgumentError("Resolution must be > 0");
         }
         mResolution = param1;
      }
      
      public function get mode() : String
      {
         return mMode;
      }
      
      public function set mode(param1:String) : void
      {
         mMode = param1;
      }
      
      public function get offsetX() : Number
      {
         return mOffsetX;
      }
      
      public function set offsetX(param1:Number) : void
      {
         mOffsetX = param1;
      }
      
      public function get offsetY() : Number
      {
         return mOffsetY;
      }
      
      public function set offsetY(param1:Number) : void
      {
         mOffsetY = param1;
      }
      
      protected function get marginX() : Number
      {
         return mMarginX;
      }
      
      protected function set marginX(param1:Number) : void
      {
         mMarginX = param1;
      }
      
      protected function get marginY() : Number
      {
         return mMarginY;
      }
      
      protected function set marginY(param1:Number) : void
      {
         mMarginY = param1;
      }
      
      protected function set numPasses(param1:int) : void
      {
         mNumPasses = param1;
      }
      
      protected function get numPasses() : int
      {
         return mNumPasses;
      }
      
      final protected function get vertexPosAtID() : int
      {
         return mVertexPosAtID;
      }
      
      final protected function set vertexPosAtID(param1:int) : void
      {
         mVertexPosAtID = param1;
      }
      
      final protected function get texCoordsAtID() : int
      {
         return mTexCoordsAtID;
      }
      
      final protected function set texCoordsAtID(param1:int) : void
      {
         mTexCoordsAtID = param1;
      }
      
      final protected function get baseTextureID() : int
      {
         return mBaseTextureID;
      }
      
      final protected function set baseTextureID(param1:int) : void
      {
         mBaseTextureID = param1;
      }
      
      final protected function get mvpConstantID() : int
      {
         return mMvpConstantID;
      }
      
      final protected function set mvpConstantID(param1:int) : void
      {
         mMvpConstantID = param1;
      }
   }
}

