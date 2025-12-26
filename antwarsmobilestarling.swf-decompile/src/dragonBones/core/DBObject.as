package dragonBones.core
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.objects.DBTransform;
   import flash.geom.Matrix;
   
   use namespace dragonBones_internal;
   
   public class DBObject
   {
      
      public var name:String;
      
      public var userData:Object;
      
      public var fixedRotation:Boolean;
      
      dragonBones_internal var _globalTransformMatrix:Matrix;
      
      protected var _scaleType:int;
      
      dragonBones_internal var _isColorChanged:Boolean;
      
      dragonBones_internal var _global:DBTransform;
      
      protected var _origin:DBTransform;
      
      protected var _offset:DBTransform;
      
      dragonBones_internal var _tween:DBTransform;
      
      protected var _visible:Boolean;
      
      protected var _parent:Bone;
      
      protected var _armature:Armature;
      
      public function DBObject()
      {
         super();
         dragonBones_internal::_global = new DBTransform();
         _origin = new DBTransform();
         _offset = new DBTransform();
         dragonBones_internal::_tween = new DBTransform();
         dragonBones_internal::_tween.scaleX = dragonBones_internal::_tween.scaleY = 0;
         dragonBones_internal::_globalTransformMatrix = new Matrix();
         _visible = true;
      }
      
      public function get global() : DBTransform
      {
         return dragonBones_internal::_global;
      }
      
      public function get origin() : DBTransform
      {
         return _origin;
      }
      
      public function get offset() : DBTransform
      {
         return _offset;
      }
      
      public function get node() : DBTransform
      {
         return _offset;
      }
      
      public function get visible() : Boolean
      {
         return _visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         _visible = param1;
      }
      
      public function get parent() : Bone
      {
         return _parent;
      }
      
      dragonBones_internal function setParent(param1:Bone) : void
      {
         _parent = param1;
      }
      
      public function get armature() : Armature
      {
         return _armature;
      }
      
      dragonBones_internal function setArmature(param1:Armature) : void
      {
         if(_armature)
         {
            _armature.dragonBones_internal::removeDBObject(this);
         }
         _armature = param1;
         if(_armature)
         {
            _armature.dragonBones_internal::addDBObject(this);
         }
      }
      
      public function dispose() : void
      {
         userData = null;
         _parent = null;
         _armature = null;
         dragonBones_internal::_global = null;
         _origin = null;
         _offset = null;
         dragonBones_internal::_tween = null;
         dragonBones_internal::_globalTransformMatrix = null;
      }
      
      dragonBones_internal function update() : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc1_:Matrix = null;
         dragonBones_internal::_global.scaleX = (_origin.scaleX + dragonBones_internal::_tween.scaleX) * _offset.scaleX;
         dragonBones_internal::_global.scaleY = (_origin.scaleY + dragonBones_internal::_tween.scaleY) * _offset.scaleY;
         if(_parent)
         {
            _loc3_ = _origin.x + _offset.x + dragonBones_internal::_tween.x;
            _loc2_ = _origin.y + _offset.y + dragonBones_internal::_tween.y;
            _loc1_ = _parent.dragonBones_internal::_globalTransformMatrix;
            dragonBones_internal::_globalTransformMatrix.tx = dragonBones_internal::_global.x = _loc1_.a * _loc3_ + _loc1_.c * _loc2_ + _loc1_.tx;
            dragonBones_internal::_globalTransformMatrix.ty = dragonBones_internal::_global.y = _loc1_.d * _loc2_ + _loc1_.b * _loc3_ + _loc1_.ty;
            if(fixedRotation)
            {
               dragonBones_internal::_global.skewX = _origin.skewX + _offset.skewX + dragonBones_internal::_tween.skewX;
               dragonBones_internal::_global.skewY = _origin.skewY + _offset.skewY + dragonBones_internal::_tween.skewY;
            }
            else
            {
               dragonBones_internal::_global.skewX = _origin.skewX + _offset.skewX + dragonBones_internal::_tween.skewX + _parent.dragonBones_internal::_global.skewX;
               dragonBones_internal::_global.skewY = _origin.skewY + _offset.skewY + dragonBones_internal::_tween.skewY + _parent.dragonBones_internal::_global.skewY;
            }
            if(_parent.scaleMode >= _scaleType)
            {
               dragonBones_internal::_global.scaleX *= _parent.dragonBones_internal::_global.scaleX;
               dragonBones_internal::_global.scaleY *= _parent.dragonBones_internal::_global.scaleY;
            }
         }
         else
         {
            dragonBones_internal::_globalTransformMatrix.tx = dragonBones_internal::_global.x = _origin.x + _offset.x + dragonBones_internal::_tween.x;
            dragonBones_internal::_globalTransformMatrix.ty = dragonBones_internal::_global.y = _origin.y + _offset.y + dragonBones_internal::_tween.y;
            dragonBones_internal::_global.skewX = _origin.skewX + _offset.skewX + dragonBones_internal::_tween.skewX;
            dragonBones_internal::_global.skewY = _origin.skewY + _offset.skewY + dragonBones_internal::_tween.skewY;
         }
         dragonBones_internal::_globalTransformMatrix.a = dragonBones_internal::_global.scaleX * Math.cos(dragonBones_internal::_global.skewY);
         dragonBones_internal::_globalTransformMatrix.b = dragonBones_internal::_global.scaleX * Math.sin(dragonBones_internal::_global.skewY);
         dragonBones_internal::_globalTransformMatrix.c = -dragonBones_internal::_global.scaleY * Math.sin(dragonBones_internal::_global.skewX);
         dragonBones_internal::_globalTransformMatrix.d = dragonBones_internal::_global.scaleY * Math.cos(dragonBones_internal::_global.skewX);
      }
   }
}

