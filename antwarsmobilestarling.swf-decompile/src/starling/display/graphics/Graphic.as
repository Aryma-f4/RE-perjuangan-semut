package starling.display.graphics
{
   import flash.display3D.Context3D;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.VertexBuffer3D;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.materials.IMaterial;
   import starling.display.materials.StandardMaterial;
   import starling.display.shaders.fragment.VertexColorFragmentShader;
   import starling.display.shaders.vertex.StandardVertexShader;
   import starling.errors.AbstractMethodError;
   import starling.errors.MissingContextError;
   
   public class Graphic extends DisplayObject
   {
      
      protected static const VERTEX_STRIDE:int = 9;
      
      protected static var defaultVertexShader:StandardVertexShader;
      
      protected static var defaultFragmentShader:VertexColorFragmentShader;
      
      protected static var sHelperMatrix:Matrix = new Matrix();
      
      protected var _material:IMaterial;
      
      private var vertexBuffer:VertexBuffer3D;
      
      private var indexBuffer:IndexBuffer3D;
      
      protected var vertices:Vector.<Number>;
      
      protected var indices:Vector.<uint>;
      
      protected var _uvMatrix:Matrix;
      
      protected var isInvalid:Boolean = false;
      
      protected var uvsInvalid:Boolean = false;
      
      protected var minBounds:Point;
      
      protected var maxBounds:Point;
      
      public function Graphic()
      {
         super();
         indices = new Vector.<uint>();
         vertices = new Vector.<Number>();
         if(defaultVertexShader == null)
         {
            defaultVertexShader = new StandardVertexShader();
            defaultFragmentShader = new VertexColorFragmentShader();
         }
         _material = new StandardMaterial(defaultVertexShader,defaultFragmentShader);
         minBounds = new Point();
         maxBounds = new Point();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(vertexBuffer)
         {
            vertexBuffer.dispose();
            vertexBuffer = null;
         }
         if(indexBuffer)
         {
            indexBuffer.dispose();
            indexBuffer = null;
         }
         if(material)
         {
            material.dispose();
            material = null;
         }
      }
      
      public function set material(param1:IMaterial) : void
      {
         _material = param1;
      }
      
      public function get material() : IMaterial
      {
         return _material;
      }
      
      public function get uvMatrix() : Matrix
      {
         return _uvMatrix;
      }
      
      public function set uvMatrix(param1:Matrix) : void
      {
         _uvMatrix = param1;
         uvsInvalid = true;
      }
      
      public function shapeHitTest(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Point = globalToLocal(new Point(param1,param2));
         return _loc3_.x >= minBounds.x && _loc3_.x <= maxBounds.x && _loc3_.y >= minBounds.y && _loc3_.y <= maxBounds.y;
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         if(param2 == null)
         {
            param2 = new Rectangle();
         }
         if(param1 == this)
         {
            param2.x = minBounds.x;
            param2.y = minBounds.y;
            param2.right = maxBounds.x;
            param2.bottom = maxBounds.y;
            return param2;
         }
         getTransformationMatrix(param1,sHelperMatrix);
         var _loc4_:Point = sHelperMatrix.transformPoint(minBounds.clone());
         var _loc3_:Point = sHelperMatrix.transformPoint(maxBounds.clone());
         param2.x = _loc4_.x;
         param2.y = _loc4_.y;
         param2.right = _loc3_.x;
         param2.bottom = _loc3_.y;
         return param2;
      }
      
      protected function buildGeometry() : void
      {
         throw new AbstractMethodError();
      }
      
      protected function applyUVMatrix() : void
      {
         var _loc2_:int = 0;
         if(!vertices)
         {
            return;
         }
         if(!_uvMatrix)
         {
            return;
         }
         var _loc1_:Point = new Point();
         _loc2_ = 0;
         while(_loc2_ < vertices.length)
         {
            _loc1_.x = vertices[_loc2_ + 7];
            _loc1_.y = vertices[_loc2_ + 8];
            _loc1_ = _uvMatrix.transformPoint(_loc1_);
            vertices[_loc2_ + 7] = _loc1_.x;
            vertices[_loc2_ + 8] = _loc1_.y;
            _loc2_ += 9;
         }
      }
      
      protected function validateNow() : void
      {
         if(vertexBuffer && (isInvalid || uvsInvalid))
         {
            vertexBuffer.dispose();
            indexBuffer.dispose();
         }
         if(isInvalid)
         {
            buildGeometry();
            applyUVMatrix();
         }
         else if(uvsInvalid)
         {
            applyUVMatrix();
         }
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         var _loc4_:int = 0;
         validateNow();
         if(indices.length < 3)
         {
            return;
         }
         if(isInvalid || uvsInvalid)
         {
            _loc4_ = vertices.length / 9;
            vertexBuffer = Starling.context.createVertexBuffer(_loc4_,9);
            vertexBuffer.uploadFromVector(vertices,0,_loc4_);
            indexBuffer = Starling.context.createIndexBuffer(indices.length);
            indexBuffer.uploadFromVector(indices,0,indices.length);
            isInvalid = uvsInvalid = false;
         }
         param1.finishQuadBatch();
         var _loc3_:Context3D = Starling.context;
         if(_loc3_ == null)
         {
            throw new MissingContextError();
         }
         RenderSupport.setBlendFactors(false,this.blendMode == "auto" ? param1.blendMode : this.blendMode);
         _material.drawTriangles(Starling.context,param1.mvpMatrix3D,vertexBuffer,indexBuffer,param2 * this.alpha);
         _loc3_.setTextureAt(0,null);
         _loc3_.setTextureAt(1,null);
         _loc3_.setVertexBufferAt(0,null);
         _loc3_.setVertexBufferAt(1,null);
         _loc3_.setVertexBufferAt(2,null);
      }
   }
}

