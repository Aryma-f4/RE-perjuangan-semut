package dragonBones.utils
{
   import dragonBones.animation.TimelineState;
   import dragonBones.objects.AnimationData;
   import dragonBones.objects.ArmatureData;
   import dragonBones.objects.BoneData;
   import dragonBones.objects.DBTransform;
   import dragonBones.objects.Frame;
   import dragonBones.objects.SkinData;
   import dragonBones.objects.SlotData;
   import dragonBones.objects.TransformFrame;
   import dragonBones.objects.TransformTimeline;
   import flash.geom.Point;
   
   public final class DBDataUtil
   {
      
      private static const _helpTransform1:DBTransform = new DBTransform();
      
      private static const _helpTransform2:DBTransform = new DBTransform();
      
      public function DBDataUtil()
      {
         super();
      }
      
      public static function transformArmatureData(param1:ArmatureData) : void
      {
         var _loc3_:BoneData = null;
         var _loc2_:BoneData = null;
         var _loc4_:int = int(param1.boneDataList.length);
         while(_loc4_--)
         {
            _loc3_ = param1.boneDataList[_loc4_];
            if(_loc3_.parent)
            {
               _loc2_ = param1.getBoneData(_loc3_.parent);
               if(_loc2_)
               {
                  _loc3_.transform.copy(_loc3_.global);
                  TransformUtil.transformPointWithParent(_loc3_.transform,_loc2_.global);
               }
            }
         }
      }
      
      public static function transformArmatureDataAnimations(param1:ArmatureData) : void
      {
         var _loc2_:Vector.<AnimationData> = param1.animationDataList;
         var _loc3_:int = int(_loc2_.length);
         while(_loc3_--)
         {
            transformAnimationData(_loc2_[_loc3_],param1);
         }
      }
      
      public static function transformAnimationData(param1:AnimationData, param2:ArmatureData) : void
      {
         var _loc9_:BoneData = null;
         var _loc6_:TransformTimeline = null;
         var _loc3_:SlotData = null;
         var _loc16_:* = null;
         var _loc14_:TransformTimeline = null;
         var _loc17_:* = undefined;
         var _loc7_:DBTransform = null;
         var _loc13_:Point = null;
         var _loc12_:* = null;
         var _loc5_:* = 0;
         var _loc11_:TransformFrame = null;
         var _loc8_:int = 0;
         var _loc4_:Number = NaN;
         var _loc15_:SkinData = param2.getSkinData(null);
         var _loc10_:int = int(param2.boneDataList.length);
         while(_loc10_--)
         {
            _loc9_ = param2.boneDataList[_loc10_];
            _loc6_ = param1.getTimeline(_loc9_.name);
            if(_loc6_)
            {
               _loc3_ = null;
               for each(_loc3_ in _loc15_.slotDataList)
               {
                  if(_loc3_.parent == _loc9_.name)
                  {
                     break;
                  }
               }
               _loc14_ = _loc9_.parent ? param1.getTimeline(_loc9_.parent) : null;
               _loc17_ = _loc6_.frameList;
               _loc7_ = null;
               _loc13_ = null;
               _loc12_ = null;
               _loc5_ = _loc17_.length;
               _loc8_ = 0;
               while(_loc8_ < _loc5_)
               {
                  _loc11_ = _loc17_[_loc8_] as TransformFrame;
                  if(_loc14_)
                  {
                     _helpTransform1.copy(_loc11_.global);
                     getTimelineTransform(_loc14_,_loc11_.position,_helpTransform2);
                     TransformUtil.transformPointWithParent(_helpTransform1,_helpTransform2);
                     _loc11_.transform.copy(_helpTransform1);
                  }
                  else
                  {
                     _loc11_.transform.copy(_loc11_.global);
                  }
                  _loc11_.transform.x -= _loc9_.transform.x;
                  _loc11_.transform.y -= _loc9_.transform.y;
                  _loc11_.transform.skewX -= _loc9_.transform.skewX;
                  _loc11_.transform.skewY -= _loc9_.transform.skewY;
                  _loc11_.transform.scaleX -= _loc9_.transform.scaleX;
                  _loc11_.transform.scaleY -= _loc9_.transform.scaleY;
                  if(!_loc6_.transformed)
                  {
                     if(_loc3_)
                     {
                        _loc11_.zOrder -= _loc3_.zOrder;
                     }
                  }
                  if(!_loc7_)
                  {
                     _loc7_ = _loc6_.originTransform;
                     _loc7_.copy(_loc11_.transform);
                     _loc7_.skewX = TransformUtil.formatRadian(_loc7_.skewX);
                     _loc7_.skewY = TransformUtil.formatRadian(_loc7_.skewY);
                     _loc13_ = _loc6_.originPivot;
                     _loc13_.x = _loc11_.pivot.x;
                     _loc13_.y = _loc11_.pivot.y;
                  }
                  _loc11_.transform.x -= _loc7_.x;
                  _loc11_.transform.y -= _loc7_.y;
                  _loc11_.transform.skewX = TransformUtil.formatRadian(_loc11_.transform.skewX - _loc7_.skewX);
                  _loc11_.transform.skewY = TransformUtil.formatRadian(_loc11_.transform.skewY - _loc7_.skewY);
                  _loc11_.transform.scaleX -= _loc7_.scaleX;
                  _loc11_.transform.scaleY -= _loc7_.scaleY;
                  if(!_loc6_.transformed)
                  {
                     _loc11_.pivot.x -= _loc13_.x;
                     _loc11_.pivot.y -= _loc13_.y;
                  }
                  if(_loc12_)
                  {
                     _loc4_ = _loc11_.transform.skewX - _loc12_.transform.skewX;
                     if(_loc12_.tweenRotate)
                     {
                        if(_loc12_.tweenRotate > 0)
                        {
                           if(_loc4_ < 0)
                           {
                              _loc11_.transform.skewX += 3.141592653589793 * 2;
                              _loc11_.transform.skewY += 3.141592653589793 * 2;
                           }
                           if(_loc12_.tweenRotate > 1)
                           {
                              _loc11_.transform.skewX += 3.141592653589793 * 2 * (_loc12_.tweenRotate - 1);
                              _loc11_.transform.skewY += 3.141592653589793 * 2 * (_loc12_.tweenRotate - 1);
                           }
                        }
                        else
                        {
                           if(_loc4_ > 0)
                           {
                              _loc11_.transform.skewX -= 3.141592653589793 * 2;
                              _loc11_.transform.skewY -= 3.141592653589793 * 2;
                           }
                           if(_loc12_.tweenRotate < 1)
                           {
                              _loc11_.transform.skewX += 3.141592653589793 * 2 * (_loc12_.tweenRotate + 1);
                              _loc11_.transform.skewY += 3.141592653589793 * 2 * (_loc12_.tweenRotate + 1);
                           }
                        }
                     }
                     else
                     {
                        _loc11_.transform.skewX = _loc12_.transform.skewX + TransformUtil.formatRadian(_loc11_.transform.skewX - _loc12_.transform.skewX);
                        _loc11_.transform.skewY = _loc12_.transform.skewY + TransformUtil.formatRadian(_loc11_.transform.skewY - _loc12_.transform.skewY);
                     }
                  }
                  _loc12_ = _loc11_;
                  _loc8_++;
               }
               _loc6_.transformed = true;
            }
         }
      }
      
      public static function getTimelineTransform(param1:TransformTimeline, param2:Number, param3:DBTransform) : void
      {
         var _loc8_:TransformFrame = null;
         var _loc6_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:TransformFrame = null;
         var _loc7_:Vector.<Frame> = param1.frameList;
         var _loc9_:int = int(_loc7_.length);
         while(_loc9_--)
         {
            _loc8_ = _loc7_[_loc9_] as TransformFrame;
            if(_loc8_.position <= param2 && _loc8_.position + _loc8_.duration > param2)
            {
               _loc6_ = _loc8_.tweenEasing;
               if(_loc9_ == _loc7_.length - 1 || isNaN(_loc6_) || param2 == _loc8_.position)
               {
                  param3.copy(_loc8_.global);
                  break;
               }
               _loc4_ = (param2 - _loc8_.position) / _loc8_.duration;
               if(_loc6_)
               {
                  _loc4_ = TimelineState.getEaseValue(_loc4_,_loc6_);
               }
               _loc5_ = param1.frameList[_loc9_ + 1] as TransformFrame;
               param3.x = _loc8_.global.x + (_loc5_.global.x - _loc8_.global.x) * _loc4_;
               param3.y = _loc8_.global.y + (_loc5_.global.y - _loc8_.global.y) * _loc4_;
               param3.skewX = TransformUtil.formatRadian(_loc8_.global.skewX + (_loc5_.global.skewX - _loc8_.global.skewX) * _loc4_);
               param3.skewY = TransformUtil.formatRadian(_loc8_.global.skewY + (_loc5_.global.skewY - _loc8_.global.skewY) * _loc4_);
               param3.scaleX = _loc8_.global.scaleX + (_loc5_.global.scaleX - _loc8_.global.scaleX) * _loc4_;
               param3.scaleY = _loc8_.global.scaleY + (_loc5_.global.scaleY - _loc8_.global.scaleY) * _loc4_;
               break;
            }
         }
      }
      
      public static function addHideTimeline(param1:AnimationData, param2:ArmatureData) : void
      {
         var _loc4_:BoneData = null;
         var _loc3_:String = null;
         var _loc5_:Vector.<BoneData> = param2.boneDataList;
         var _loc6_:int = int(_loc5_.length);
         while(_loc6_--)
         {
            _loc4_ = _loc5_[_loc6_];
            _loc3_ = _loc4_.name;
            if(!param1.getTimeline(_loc3_))
            {
               param1.addTimeline(TransformTimeline.HIDE_TIMELINE,_loc3_);
            }
         }
      }
   }
}

