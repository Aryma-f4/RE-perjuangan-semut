package dragonBones.animation
{
   import dragonBones.Bone;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.objects.DBTransform;
   import dragonBones.objects.TransformFrame;
   import dragonBones.objects.TransformTimeline;
   import dragonBones.utils.TransformUtil;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   use namespace dragonBones_internal;
   
   public final class TimelineState
   {
      
      private static const HALF_PI:Number = 1.5707963267948966;
      
      private static const DOUBLE_PI:Number = 6.283185307179586;
      
      private static var _pool:Vector.<TimelineState> = new Vector.<TimelineState>();
      
      public var transform:DBTransform;
      
      public var pivot:Point;
      
      public var tweenActive:Boolean;
      
      private var _updateState:int;
      
      private var _animationState:AnimationState;
      
      private var _bone:Bone;
      
      private var _timeline:TransformTimeline;
      
      private var _currentFrame:TransformFrame;
      
      private var _currentFramePosition:Number;
      
      private var _currentFrameDuration:Number;
      
      private var _durationTransform:DBTransform;
      
      private var _durationPivot:Point;
      
      private var _durationColor:ColorTransform;
      
      private var _originTransform:DBTransform;
      
      private var _originPivot:Point;
      
      private var _tweenEasing:Number;
      
      private var _tweenTransform:Boolean;
      
      private var _tweenColor:Boolean;
      
      private var _totalTime:Number;
      
      public function TimelineState()
      {
         super();
         transform = new DBTransform();
         pivot = new Point();
         _durationTransform = new DBTransform();
         _durationPivot = new Point();
         _durationColor = new ColorTransform();
      }
      
      dragonBones_internal static function borrowObject() : TimelineState
      {
         if(_pool.length == 0)
         {
            return new TimelineState();
         }
         return _pool.pop();
      }
      
      dragonBones_internal static function returnObject(param1:TimelineState) : void
      {
         if(_pool.indexOf(param1) < 0)
         {
            _pool[_pool.length] = param1;
         }
         param1.clear();
      }
      
      dragonBones_internal static function clear() : void
      {
         var _loc1_:int = int(_pool.length);
         while(_loc1_--)
         {
            _pool[_loc1_].clear();
         }
         _pool.length = 0;
      }
      
      public static function getEaseValue(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = NaN;
         if(param2 > 1)
         {
            _loc3_ = 0.5 * (1 - Math.cos(param1 * 3.141592653589793)) - param1;
            param2 -= 1;
         }
         else if(param2 > 0)
         {
            _loc3_ = Math.sin(param1 * 1.5707963267948966) - param1;
         }
         else if(param2 < 0)
         {
            _loc3_ = 1 - Math.cos(param1 * 1.5707963267948966) - param1;
            param2 *= -1;
         }
         return _loc3_ * param2 + param1;
      }
      
      public function fadeIn(param1:Bone, param2:AnimationState, param3:TransformTimeline) : void
      {
         _bone = param1;
         _animationState = param2;
         _timeline = param3;
         _originTransform = _timeline.originTransform;
         _originPivot = _timeline.originPivot;
         _tweenTransform = false;
         _tweenColor = false;
         _totalTime = _animationState.totalTime;
         transform.x = 0;
         transform.y = 0;
         transform.scaleX = 0;
         transform.scaleY = 0;
         transform.skewX = 0;
         transform.skewY = 0;
         pivot.x = 0;
         pivot.y = 0;
         _durationTransform.x = 0;
         _durationTransform.y = 0;
         _durationTransform.scaleX = 0;
         _durationTransform.scaleY = 0;
         _durationTransform.skewX = 0;
         _durationTransform.skewY = 0;
         _durationPivot.x = 0;
         _durationPivot.y = 0;
         switch(int(_timeline.frameList.length))
         {
            case 0:
               _bone.dragonBones_internal::arriveAtFrame(null,this,_animationState,false);
               _updateState = 0;
               break;
            case 1:
               _updateState = -1;
               break;
            default:
               _updateState = 1;
         }
      }
      
      public function fadeOut() : void
      {
         transform.skewX = TransformUtil.formatRadian(transform.skewX);
         transform.skewY = TransformUtil.formatRadian(transform.skewY);
      }
      
      public function update(param1:Number) : void
      {
         var _loc3_:int = 0;
         var _loc7_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc6_:int = 0;
         var _loc2_:TransformFrame = null;
         var _loc8_:DBTransform = null;
         var _loc5_:Point = null;
         if(_updateState)
         {
            if(_updateState > 0)
            {
               if(_timeline.scale == 0)
               {
                  param1 = 1;
               }
               else
               {
                  param1 /= _timeline.scale;
               }
               if(param1 == 1)
               {
                  param1 = 0.99999999;
               }
               param1 += _timeline.offset;
               _loc3_ = param1;
               param1 -= _loc3_;
               _loc7_ = _totalTime * param1;
               _loc4_ = false;
               while(!_currentFrame || _loc7_ > _currentFramePosition + _currentFrameDuration || _loc7_ < _currentFramePosition)
               {
                  if(_loc4_)
                  {
                     _bone.dragonBones_internal::arriveAtFrame(_currentFrame,this,_animationState,true);
                  }
                  _loc4_ = true;
                  if(_currentFrame)
                  {
                     _loc6_ = _timeline.frameList.indexOf(_currentFrame) + 1;
                     if(_loc6_ >= _timeline.frameList.length)
                     {
                        _loc6_ = 0;
                     }
                     _currentFrame = _timeline.frameList[_loc6_] as TransformFrame;
                  }
                  else
                  {
                     _loc6_ = 0;
                     _currentFrame = _timeline.frameList[0] as TransformFrame;
                  }
                  _currentFrameDuration = _currentFrame.duration;
                  _currentFramePosition = _currentFrame.position;
               }
               if(_loc4_)
               {
                  tweenActive = _currentFrame.displayIndex >= 0;
                  if(++_loc6_ >= _timeline.frameList.length)
                  {
                     _loc6_ = 0;
                  }
                  _loc2_ = _timeline.frameList[_loc6_] as TransformFrame;
                  if(_loc6_ == 0 && _animationState.loop && _animationState.loopCount >= Math.abs(_animationState.loop) - 1 && ((_currentFramePosition + _currentFrameDuration) / _totalTime + _loc3_ - _timeline.offset) * _timeline.scale > 0.99999999)
                  {
                     _updateState = 0;
                     _tweenEasing = NaN;
                  }
                  else if(_currentFrame.displayIndex < 0 || _loc2_.displayIndex < 0 || !_animationState.tweenEnabled)
                  {
                     _tweenEasing = NaN;
                  }
                  else if(isNaN(_animationState.clip.tweenEasing))
                  {
                     _tweenEasing = _currentFrame.tweenEasing;
                  }
                  else
                  {
                     _tweenEasing = _animationState.clip.tweenEasing;
                  }
                  if(isNaN(_tweenEasing))
                  {
                     _tweenTransform = false;
                     _tweenColor = false;
                  }
                  else
                  {
                     _durationTransform.x = _loc2_.transform.x - _currentFrame.transform.x;
                     _durationTransform.y = _loc2_.transform.y - _currentFrame.transform.y;
                     _durationTransform.skewX = _loc2_.transform.skewX - _currentFrame.transform.skewX;
                     _durationTransform.skewY = _loc2_.transform.skewY - _currentFrame.transform.skewY;
                     _durationTransform.scaleX = _loc2_.transform.scaleX - _currentFrame.transform.scaleX;
                     _durationTransform.scaleY = _loc2_.transform.scaleY - _currentFrame.transform.scaleY;
                     if(_loc6_ == 0)
                     {
                        _durationTransform.skewX = TransformUtil.formatRadian(_durationTransform.skewX);
                        _durationTransform.skewY = TransformUtil.formatRadian(_durationTransform.skewY);
                     }
                     _durationPivot.x = _loc2_.pivot.x - _currentFrame.pivot.x;
                     _durationPivot.y = _loc2_.pivot.y - _currentFrame.pivot.y;
                     if(_durationTransform.x != 0 || _durationTransform.y != 0 || _durationTransform.skewX != 0 || _durationTransform.skewY != 0 || _durationTransform.scaleX != 0 || _durationTransform.scaleY != 0 || _durationPivot.x != 0 || _durationPivot.y != 0)
                     {
                        _tweenTransform = true;
                     }
                     else
                     {
                        _tweenTransform = false;
                     }
                     if(_currentFrame.color && _loc2_.color)
                     {
                        _durationColor.alphaOffset = _loc2_.color.alphaOffset - _currentFrame.color.alphaOffset;
                        _durationColor.redOffset = _loc2_.color.redOffset - _currentFrame.color.redOffset;
                        _durationColor.greenOffset = _loc2_.color.greenOffset - _currentFrame.color.greenOffset;
                        _durationColor.blueOffset = _loc2_.color.blueOffset - _currentFrame.color.blueOffset;
                        _durationColor.alphaMultiplier = _loc2_.color.alphaMultiplier - _currentFrame.color.alphaMultiplier;
                        _durationColor.redMultiplier = _loc2_.color.redMultiplier - _currentFrame.color.redMultiplier;
                        _durationColor.greenMultiplier = _loc2_.color.greenMultiplier - _currentFrame.color.greenMultiplier;
                        _durationColor.blueMultiplier = _loc2_.color.blueMultiplier - _currentFrame.color.blueMultiplier;
                        if(_durationColor.alphaOffset != 0 || _durationColor.redOffset != 0 || _durationColor.greenOffset != 0 || _durationColor.blueOffset != 0 || _durationColor.alphaMultiplier != 0 || _durationColor.redMultiplier != 0 || _durationColor.greenMultiplier != 0 || _durationColor.blueMultiplier != 0)
                        {
                           _tweenColor = true;
                        }
                        else
                        {
                           _tweenColor = false;
                        }
                     }
                     else if(_currentFrame.color)
                     {
                        _tweenColor = true;
                        _durationColor.alphaOffset = -_currentFrame.color.alphaOffset;
                        _durationColor.redOffset = -_currentFrame.color.redOffset;
                        _durationColor.greenOffset = -_currentFrame.color.greenOffset;
                        _durationColor.blueOffset = -_currentFrame.color.blueOffset;
                        _durationColor.alphaMultiplier = 1 - _currentFrame.color.alphaMultiplier;
                        _durationColor.redMultiplier = 1 - _currentFrame.color.redMultiplier;
                        _durationColor.greenMultiplier = 1 - _currentFrame.color.greenMultiplier;
                        _durationColor.blueMultiplier = 1 - _currentFrame.color.blueMultiplier;
                     }
                     else if(_loc2_.color)
                     {
                        _tweenColor = true;
                        _durationColor.alphaOffset = _loc2_.color.alphaOffset;
                        _durationColor.redOffset = _loc2_.color.redOffset;
                        _durationColor.greenOffset = _loc2_.color.greenOffset;
                        _durationColor.blueOffset = _loc2_.color.blueOffset;
                        _durationColor.alphaMultiplier = _loc2_.color.alphaMultiplier - 1;
                        _durationColor.redMultiplier = _loc2_.color.redMultiplier - 1;
                        _durationColor.greenMultiplier = _loc2_.color.greenMultiplier - 1;
                        _durationColor.blueMultiplier = _loc2_.color.blueMultiplier - 1;
                     }
                     else
                     {
                        _tweenColor = false;
                     }
                  }
                  if(!_tweenTransform)
                  {
                     if(_animationState.blend)
                     {
                        transform.x = _originTransform.x + _currentFrame.transform.x;
                        transform.y = _originTransform.y + _currentFrame.transform.y;
                        transform.skewX = _originTransform.skewX + _currentFrame.transform.skewX;
                        transform.skewY = _originTransform.skewY + _currentFrame.transform.skewY;
                        transform.scaleX = _originTransform.scaleX + _currentFrame.transform.scaleX;
                        transform.scaleY = _originTransform.scaleY + _currentFrame.transform.scaleY;
                        pivot.x = _originPivot.x + _currentFrame.pivot.x;
                        pivot.y = _originPivot.y + _currentFrame.pivot.y;
                     }
                     else
                     {
                        transform.x = _currentFrame.transform.x;
                        transform.y = _currentFrame.transform.y;
                        transform.skewX = _currentFrame.transform.skewX;
                        transform.skewY = _currentFrame.transform.skewY;
                        transform.scaleX = _currentFrame.transform.scaleX;
                        transform.scaleY = _currentFrame.transform.scaleY;
                        pivot.x = _currentFrame.pivot.x;
                        pivot.y = _currentFrame.pivot.y;
                     }
                  }
                  if(!_tweenColor)
                  {
                     if(_currentFrame.color)
                     {
                        _bone.dragonBones_internal::updateColor(_currentFrame.color.alphaOffset,_currentFrame.color.redOffset,_currentFrame.color.greenOffset,_currentFrame.color.blueOffset,_currentFrame.color.alphaMultiplier,_currentFrame.color.redMultiplier,_currentFrame.color.greenMultiplier,_currentFrame.color.blueMultiplier,true);
                     }
                     else if(_bone.dragonBones_internal::_isColorChanged)
                     {
                        _bone.dragonBones_internal::updateColor(0,0,0,0,1,1,1,1,false);
                     }
                  }
                  _bone.dragonBones_internal::arriveAtFrame(_currentFrame,this,_animationState,false);
               }
               if(_tweenTransform || _tweenColor)
               {
                  param1 = (_loc7_ - _currentFramePosition) / _currentFrameDuration;
                  if(_tweenEasing)
                  {
                     param1 = getEaseValue(param1,_tweenEasing);
                  }
               }
               if(_tweenTransform)
               {
                  _loc8_ = _currentFrame.transform;
                  _loc5_ = _currentFrame.pivot;
                  if(_animationState.blend)
                  {
                     transform.x = _originTransform.x + _loc8_.x + _durationTransform.x * param1;
                     transform.y = _originTransform.y + _loc8_.y + _durationTransform.y * param1;
                     transform.skewX = _originTransform.skewX + _loc8_.skewX + _durationTransform.skewX * param1;
                     transform.skewY = _originTransform.skewY + _loc8_.skewY + _durationTransform.skewY * param1;
                     transform.scaleX = _originTransform.scaleX + _loc8_.scaleX + _durationTransform.scaleX * param1;
                     transform.scaleY = _originTransform.scaleY + _loc8_.scaleY + _durationTransform.scaleY * param1;
                     pivot.x = _originPivot.x + _loc5_.x + _durationPivot.x * param1;
                     pivot.y = _originPivot.y + _loc5_.y + _durationPivot.y * param1;
                  }
                  else
                  {
                     transform.x = _loc8_.x + _durationTransform.x * param1;
                     transform.y = _loc8_.y + _durationTransform.y * param1;
                     transform.skewX = _loc8_.skewX + _durationTransform.skewX * param1;
                     transform.skewY = _loc8_.skewY + _durationTransform.skewY * param1;
                     transform.scaleX = _loc8_.scaleX + _durationTransform.scaleX * param1;
                     transform.scaleY = _loc8_.scaleY + _durationTransform.scaleY * param1;
                     pivot.x = _loc5_.x + _durationPivot.x * param1;
                     pivot.y = _loc5_.y + _durationPivot.y * param1;
                  }
               }
               if(_tweenColor)
               {
                  if(_currentFrame.color)
                  {
                     _bone.dragonBones_internal::updateColor(_currentFrame.color.alphaOffset + _durationColor.alphaOffset * param1,_currentFrame.color.redOffset + _durationColor.redOffset * param1,_currentFrame.color.greenOffset + _durationColor.greenOffset * param1,_currentFrame.color.blueOffset + _durationColor.blueOffset * param1,_currentFrame.color.alphaMultiplier + _durationColor.alphaMultiplier * param1,_currentFrame.color.redMultiplier + _durationColor.redMultiplier * param1,_currentFrame.color.greenMultiplier + _durationColor.greenMultiplier * param1,_currentFrame.color.blueMultiplier + _durationColor.blueMultiplier * param1,true);
                  }
                  else
                  {
                     _bone.dragonBones_internal::updateColor(_durationColor.alphaOffset * param1,_durationColor.redOffset * param1,_durationColor.greenOffset * param1,_durationColor.blueOffset * param1,1 + _durationColor.alphaMultiplier * param1,1 + _durationColor.redMultiplier * param1,1 + _durationColor.greenMultiplier * param1,1 + _durationColor.blueMultiplier * param1,true);
                  }
               }
            }
            else
            {
               _updateState = 0;
               if(_animationState.blend)
               {
                  transform.copy(_originTransform);
                  pivot.x = _originPivot.x;
                  pivot.y = _originPivot.y;
               }
               else
               {
                  transform.x = transform.y = transform.skewX = transform.skewY = transform.scaleX = transform.scaleY = 0;
                  pivot.x = 0;
                  pivot.y = 0;
               }
               _currentFrame = _timeline.frameList[0] as TransformFrame;
               tweenActive = _currentFrame.displayIndex >= 0;
               if(_currentFrame.color)
               {
                  _bone.dragonBones_internal::updateColor(_currentFrame.color.alphaOffset,_currentFrame.color.redOffset,_currentFrame.color.greenOffset,_currentFrame.color.blueOffset,_currentFrame.color.alphaMultiplier,_currentFrame.color.redMultiplier,_currentFrame.color.greenMultiplier,_currentFrame.color.blueMultiplier,true);
               }
               else
               {
                  _bone.dragonBones_internal::updateColor(0,0,0,0,1,1,1,1,false);
               }
               _bone.dragonBones_internal::arriveAtFrame(_currentFrame,this,_animationState,false);
            }
         }
      }
      
      private function clear() : void
      {
         _updateState = 0;
         _bone = null;
         _animationState = null;
         _timeline = null;
         _currentFrame = null;
         _originTransform = null;
         _originPivot = null;
      }
   }
}

