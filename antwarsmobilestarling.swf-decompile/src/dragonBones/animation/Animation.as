package dragonBones.animation
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.objects.AnimationData;
   import dragonBones.objects.DBTransform;
   import flash.geom.Point;
   
   use namespace dragonBones_internal;
   
   public class Animation
   {
      
      public static const NONE:String = "none";
      
      public static const SAME_LAYER:String = "sameLayer";
      
      public static const SAME_GROUP:String = "sameGroup";
      
      public static const SAME_LAYER_AND_GROUP:String = "sameLayerAndGroup";
      
      public static const ALL:String = "all";
      
      public var tweenEnabled:Boolean;
      
      dragonBones_internal var _animationLayer:Vector.<Vector.<AnimationState>>;
      
      private var _armature:Armature;
      
      private var _isPlaying:Boolean;
      
      dragonBones_internal var _lastAnimationState:AnimationState;
      
      private var _animationList:Vector.<String>;
      
      private var _animationDataList:Vector.<AnimationData>;
      
      private var _timeScale:Number = 1;
      
      public function Animation(param1:Armature)
      {
         super();
         _armature = param1;
         dragonBones_internal::_animationLayer = new Vector.<Vector.<AnimationState>>();
         _animationList = new Vector.<String>();
         tweenEnabled = true;
      }
      
      public function get movementList() : Vector.<String>
      {
         return _animationList;
      }
      
      public function get movementID() : String
      {
         return dragonBones_internal::_lastAnimationState ? dragonBones_internal::_lastAnimationState.name : null;
      }
      
      public function get lastAnimationState() : AnimationState
      {
         return dragonBones_internal::_lastAnimationState;
      }
      
      public function get animationList() : Vector.<String>
      {
         return _animationList;
      }
      
      public function get isPlaying() : Boolean
      {
         return _isPlaying && !isComplete;
      }
      
      public function get isComplete() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:* = undefined;
         var _loc3_:int = 0;
         if(dragonBones_internal::_lastAnimationState)
         {
            if(!dragonBones_internal::_lastAnimationState.isComplete)
            {
               return false;
            }
            _loc2_ = int(dragonBones_internal::_animationLayer.length);
            while(_loc2_--)
            {
               _loc1_ = dragonBones_internal::_animationLayer[_loc2_];
               _loc3_ = int(_loc1_.length);
               while(_loc3_--)
               {
                  if(!_loc1_[_loc3_].isComplete)
                  {
                     return false;
                  }
               }
            }
            return true;
         }
         return false;
      }
      
      public function get animationDataList() : Vector.<AnimationData>
      {
         return _animationDataList;
      }
      
      public function set animationDataList(param1:Vector.<AnimationData>) : void
      {
         _animationDataList = param1;
         _animationList.length = 0;
         for each(var _loc2_ in _animationDataList)
         {
            _animationList[_animationList.length] = _loc2_.name;
         }
      }
      
      public function get timeScale() : Number
      {
         return _timeScale;
      }
      
      public function set timeScale(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         _timeScale = param1;
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         if(!_armature)
         {
            return;
         }
         stop();
         var _loc3_:int = int(dragonBones_internal::_animationLayer.length);
         while(_loc3_--)
         {
            _loc1_ = dragonBones_internal::_animationLayer[_loc3_];
            _loc2_ = int(_loc1_.length);
            while(_loc2_--)
            {
               AnimationState.dragonBones_internal::returnObject(_loc1_[_loc2_]);
            }
            _loc1_.length = 0;
         }
         dragonBones_internal::_animationLayer.length = 0;
         _animationList.length = 0;
         _armature = null;
         dragonBones_internal::_animationLayer = null;
         _animationDataList = null;
         _animationList = null;
      }
      
      public function gotoAndPlay(param1:String, param2:Number = -1, param3:Number = -1, param4:Number = NaN, param5:uint = 0, param6:String = null, param7:String = "sameLayerAndGroup", param8:Boolean = true, param9:Boolean = true, param10:Boolean = true) : AnimationState
      {
         var _loc14_:AnimationData = null;
         var _loc15_:Number = NaN;
         var _loc11_:AnimationState = null;
         var _loc12_:* = undefined;
         var _loc13_:int = 0;
         var _loc17_:Bone = null;
         if(!_animationDataList)
         {
            return null;
         }
         var _loc16_:int = int(_animationDataList.length);
         while(_loc16_--)
         {
            if(_animationDataList[_loc16_].name == param1)
            {
               _loc14_ = _animationDataList[_loc16_];
               break;
            }
         }
         if(!_loc14_)
         {
            return null;
         }
         _isPlaying = true;
         param2 = param2 < 0 ? (_loc14_.fadeInTime < 0 ? 0.3 : _loc14_.fadeInTime) : param2;
         if(param3 < 0)
         {
            _loc15_ = _loc14_.scale < 0 ? 1 : _loc14_.scale;
         }
         else
         {
            _loc15_ = param3 / _loc14_.duration;
         }
         param4 = Number(isNaN(param4) ? _loc14_.loop : param4);
         param5 = addLayer(param5);
         switch(param7)
         {
            case "none":
               break;
            case "sameLayer":
               _loc12_ = dragonBones_internal::_animationLayer[param5];
               _loc16_ = int(_loc12_.length);
               while(_loc16_--)
               {
                  _loc11_ = _loc12_[_loc16_];
                  _loc11_.fadeOut(param2,param9);
               }
               break;
            case "sameGroup":
               _loc13_ = int(dragonBones_internal::_animationLayer.length);
               while(_loc13_--)
               {
                  _loc12_ = dragonBones_internal::_animationLayer[_loc13_];
                  _loc16_ = int(_loc12_.length);
                  while(_loc16_--)
                  {
                     _loc11_ = _loc12_[_loc16_];
                     if(_loc11_.group == param6)
                     {
                        _loc11_.fadeOut(param2,param9);
                     }
                  }
               }
               break;
            case "all":
               _loc13_ = int(dragonBones_internal::_animationLayer.length);
               while(_loc13_--)
               {
                  _loc12_ = dragonBones_internal::_animationLayer[_loc13_];
                  _loc16_ = int(_loc12_.length);
                  while(_loc16_--)
                  {
                     _loc11_ = _loc12_[_loc16_];
                     _loc11_.fadeOut(param2,param9);
                  }
               }
               break;
            case "sameLayerAndGroup":
            default:
               _loc12_ = dragonBones_internal::_animationLayer[param5];
               _loc16_ = int(_loc12_.length);
               while(_loc16_--)
               {
                  _loc11_ = _loc12_[_loc16_];
                  if(_loc11_.group == param6)
                  {
                     _loc11_.fadeOut(param2,param9);
                  }
               }
         }
         dragonBones_internal::_lastAnimationState = AnimationState.dragonBones_internal::borrowObject();
         dragonBones_internal::_lastAnimationState.group = param6;
         dragonBones_internal::_lastAnimationState.tweenEnabled = tweenEnabled;
         dragonBones_internal::_lastAnimationState.dragonBones_internal::fadeIn(_armature,_loc14_,param2,1 / _loc15_,param4,param5,param8,param10);
         addState(dragonBones_internal::_lastAnimationState);
         var _loc18_:Vector.<Bone> = _armature.dragonBones_internal::_boneList;
         _loc16_ = int(_loc18_.length);
         while(_loc16_--)
         {
            _loc17_ = _loc18_[_loc16_];
            if(_loc17_.childArmature)
            {
               _loc17_.childArmature.animation.gotoAndPlay(param1,param2);
            }
         }
         dragonBones_internal::_lastAnimationState.advanceTime(0);
         return dragonBones_internal::_lastAnimationState;
      }
      
      public function play() : void
      {
         if(!_animationDataList || _animationDataList.length == 0)
         {
            return;
         }
         if(!dragonBones_internal::_lastAnimationState)
         {
            gotoAndPlay(_animationDataList[0].name);
         }
         else if(!_isPlaying)
         {
            _isPlaying = true;
         }
         else
         {
            gotoAndPlay(dragonBones_internal::_lastAnimationState.name);
         }
      }
      
      public function stop() : void
      {
         _isPlaying = false;
      }
      
      public function getState(param1:String, param2:uint = 0) : AnimationState
      {
         var _loc4_:int = int(dragonBones_internal::_animationLayer.length);
         if(_loc4_ == 0)
         {
            return null;
         }
         if(param2 >= _loc4_)
         {
            param2 = uint(_loc4_ - 1);
         }
         var _loc3_:Vector.<AnimationState> = dragonBones_internal::_animationLayer[param2];
         if(!_loc3_)
         {
            return null;
         }
         var _loc5_:int = int(_loc3_.length);
         while(_loc5_--)
         {
            if(_loc3_[_loc5_].name == param1)
            {
               return _loc3_[_loc5_];
            }
         }
         return null;
      }
      
      public function hasAnimation(param1:String) : Boolean
      {
         var _loc2_:int = int(_animationDataList.length);
         while(_loc2_--)
         {
            if(_animationDataList[_loc2_].name == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc18_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:* = 0;
         var _loc21_:Bone = null;
         var _loc10_:String = null;
         var _loc22_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc9_:* = undefined;
         var _loc7_:AnimationState = null;
         var _loc12_:TimelineState = null;
         var _loc6_:Number = NaN;
         var _loc20_:DBTransform = null;
         var _loc19_:Point = null;
         if(!_isPlaying)
         {
            return;
         }
         param1 *= _timeScale;
         var _loc11_:int;
         var _loc17_:* = _loc11_ = int(_armature.dragonBones_internal::_boneList.length);
         _loc11_--;
         while(_loc17_--)
         {
            _loc21_ = _armature.dragonBones_internal::_boneList[_loc17_];
            _loc10_ = _loc21_.name;
            _loc22_ = 1;
            _loc24_ = 0;
            _loc23_ = 0;
            _loc15_ = 0;
            _loc16_ = 0;
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            _loc8_ = 0;
            _loc18_ = int(dragonBones_internal::_animationLayer.length);
            while(_loc18_--)
            {
               _loc2_ = 0;
               _loc9_ = dragonBones_internal::_animationLayer[_loc18_];
               _loc14_ = _loc9_.length;
               _loc13_ = 0;
               for(; _loc13_ < _loc14_; _loc13_++)
               {
                  _loc7_ = _loc9_[_loc13_];
                  if(_loc17_ == _loc11_)
                  {
                     if(_loc7_.advanceTime(param1))
                     {
                        removeState(_loc7_);
                        _loc13_--;
                        _loc14_--;
                        continue;
                     }
                  }
                  _loc12_ = _loc7_.dragonBones_internal::_timelineStates[_loc10_];
                  if(_loc12_ && _loc12_.tweenActive)
                  {
                     _loc6_ = _loc7_.dragonBones_internal::_fadeWeight * _loc7_.weight * _loc22_;
                     _loc20_ = _loc12_.transform;
                     _loc19_ = _loc12_.pivot;
                     _loc24_ += _loc20_.x * _loc6_;
                     _loc23_ += _loc20_.y * _loc6_;
                     _loc15_ += _loc20_.skewX * _loc6_;
                     _loc16_ += _loc20_.skewY * _loc6_;
                     _loc3_ += _loc20_.scaleX * _loc6_;
                     _loc4_ += _loc20_.scaleY * _loc6_;
                     _loc5_ += _loc19_.x * _loc6_;
                     _loc8_ += _loc19_.y * _loc6_;
                     _loc2_ += _loc6_;
                  }
               }
               if(_loc2_ >= _loc22_)
               {
                  break;
               }
               _loc22_ -= _loc2_;
            }
            _loc20_ = _loc21_.dragonBones_internal::_tween;
            _loc19_ = _loc21_.dragonBones_internal::_tweenPivot;
            _loc20_.x = _loc24_;
            _loc20_.y = _loc23_;
            _loc20_.skewX = _loc15_;
            _loc20_.skewY = _loc16_;
            _loc20_.scaleX = _loc3_;
            _loc20_.scaleY = _loc4_;
            _loc19_.x = _loc5_;
            _loc19_.y = _loc8_;
         }
      }
      
      private function addLayer(param1:uint) : uint
      {
         if(param1 >= dragonBones_internal::_animationLayer.length)
         {
            param1 = dragonBones_internal::_animationLayer.length;
            dragonBones_internal::_animationLayer[param1] = new Vector.<AnimationState>();
         }
         return param1;
      }
      
      private function addState(param1:AnimationState) : void
      {
         var _loc2_:Vector.<AnimationState> = dragonBones_internal::_animationLayer[param1.layer];
         _loc2_.push(param1);
      }
      
      private function removeState(param1:AnimationState) : void
      {
         var _loc3_:int = int(param1.layer);
         var _loc2_:Vector.<AnimationState> = dragonBones_internal::_animationLayer[_loc3_];
         _loc2_.splice(_loc2_.indexOf(param1),1);
         AnimationState.dragonBones_internal::returnObject(param1);
         if(_loc2_.length == 0 && _loc3_ == dragonBones_internal::_animationLayer.length - 1)
         {
            dragonBones_internal::_animationLayer.length--;
         }
      }
   }
}

