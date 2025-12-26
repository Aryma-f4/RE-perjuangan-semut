package dragonBones.animation
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.events.AnimationEvent;
   import dragonBones.objects.AnimationData;
   import dragonBones.objects.Frame;
   import dragonBones.objects.TransformTimeline;
   
   use namespace dragonBones_internal;
   
   public final class AnimationState
   {
      
      private static var _pool:Vector.<AnimationState> = new Vector.<AnimationState>();
      
      public var enabled:Boolean;
      
      public var tweenEnabled:Boolean;
      
      public var blend:Boolean;
      
      public var group:String;
      
      public var weight:Number;
      
      dragonBones_internal var _timelineStates:Object;
      
      dragonBones_internal var _fadeWeight:Number;
      
      private var _armature:Armature;
      
      private var _currentFrame:Frame;
      
      private var _mixingTransforms:Object;
      
      private var _fadeState:int;
      
      private var _fadeInTime:Number;
      
      private var _fadeOutTime:Number;
      
      private var _fadeOutBeginTime:Number;
      
      private var _fadeOutWeight:Number;
      
      private var _fadeIn:Boolean;
      
      private var _fadeOut:Boolean;
      
      private var _pauseBeforeFadeInComplete:Boolean;
      
      private var _name:String;
      
      private var _clip:AnimationData;
      
      private var _loopCount:int;
      
      private var _loop:int;
      
      private var _layer:uint;
      
      private var _isPlaying:Boolean;
      
      private var _isComplete:Boolean;
      
      private var _totalTime:Number;
      
      private var _currentTime:Number;
      
      private var _timeScale:Number;
      
      private var _displayControl:Boolean;
      
      public function AnimationState()
      {
         super();
         dragonBones_internal::_timelineStates = {};
      }
      
      dragonBones_internal static function borrowObject() : AnimationState
      {
         if(_pool.length == 0)
         {
            return new AnimationState();
         }
         return _pool.pop();
      }
      
      dragonBones_internal static function returnObject(param1:AnimationState) : void
      {
         param1.clear();
         if(_pool.indexOf(param1) < 0)
         {
            _pool[_pool.length] = param1;
         }
      }
      
      dragonBones_internal static function clear() : void
      {
         var _loc1_:int = int(_pool.length);
         while(_loc1_--)
         {
            _pool[_loc1_].clear();
         }
         _pool.length = 0;
         TimelineState.dragonBones_internal::clear();
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get clip() : AnimationData
      {
         return _clip;
      }
      
      public function get loopCount() : int
      {
         return _loopCount;
      }
      
      public function get loop() : int
      {
         return _loop;
      }
      
      public function get layer() : uint
      {
         return _layer;
      }
      
      public function get isPlaying() : Boolean
      {
         return _isPlaying && !_isComplete;
      }
      
      public function get isComplete() : Boolean
      {
         return _isComplete;
      }
      
      public function get fadeInTime() : Number
      {
         return _fadeInTime;
      }
      
      public function get totalTime() : Number
      {
         return _totalTime;
      }
      
      public function get currentTime() : Number
      {
         return _currentTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
         if(param1 < 0 || isNaN(param1))
         {
            param1 = 0;
         }
         _currentTime = param1;
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
         else if(isNaN(param1))
         {
            param1 = 1;
         }
         else if(_timeScale == Infinity)
         {
            _timeScale = 1;
         }
         _timeScale = param1;
      }
      
      public function get displayControl() : Boolean
      {
         return _displayControl;
      }
      
      public function set displayControl(param1:Boolean) : void
      {
         if(_displayControl != param1)
         {
            _displayControl = param1;
         }
      }
      
      dragonBones_internal function fadeIn(param1:Armature, param2:AnimationData, param3:Number, param4:Number, param5:int, param6:uint, param7:Boolean, param8:Boolean) : void
      {
         _armature = param1;
         _clip = param2;
         _name = _clip.name;
         _layer = param6;
         _totalTime = _clip.duration;
         if(Math.round(_clip.duration * _clip.frameRate) < 2 || param4 == Infinity)
         {
            _timeScale = 1;
            _currentTime = _totalTime;
            if(_loop >= 0)
            {
               _loop = 1;
            }
            else
            {
               _loop = -1;
            }
         }
         else
         {
            _timeScale = param4;
            _currentTime = 0;
            _loop = param5;
         }
         _pauseBeforeFadeInComplete = param8;
         _fadeInTime = param3 * _timeScale;
         _loopCount = -1;
         _fadeState = 1;
         _fadeOutBeginTime = 0;
         _fadeOutWeight = NaN;
         dragonBones_internal::_fadeWeight = 0;
         _displayControl = param7;
         _isPlaying = true;
         _isComplete = false;
         _fadeIn = true;
         _fadeOut = false;
         weight = 1;
         blend = true;
         enabled = true;
         tweenEnabled = true;
         updateTimelineStates();
      }
      
      public function fadeOut(param1:Number, param2:Boolean = false) : void
      {
         if(!isNaN(_fadeOutWeight))
         {
            return;
         }
         _fadeState = -1;
         _fadeOutWeight = dragonBones_internal::_fadeWeight;
         _fadeOutTime = param1 * _timeScale;
         _fadeOutBeginTime = _currentTime;
         _isPlaying = !param2;
         _fadeOut = true;
         _displayControl = false;
         for each(var _loc3_ in dragonBones_internal::_timelineStates)
         {
            _loc3_.fadeOut();
         }
         enabled = true;
      }
      
      public function play() : void
      {
         _isPlaying = true;
      }
      
      public function stop() : void
      {
         _isPlaying = false;
      }
      
      public function getMixingTransform(param1:String) : int
      {
         if(_mixingTransforms)
         {
            return int(_mixingTransforms[param1]);
         }
         return -1;
      }
      
      public function addMixingTransform(param1:String, param2:int = 2, param3:Boolean = true) : void
      {
         var _loc6_:int = 0;
         var _loc5_:Bone = null;
         var _loc4_:* = null;
         if(_clip && _clip.getTimeline(param1))
         {
            if(!_mixingTransforms)
            {
               _mixingTransforms = {};
            }
            if(param3)
            {
               _loc6_ = int(_armature.dragonBones_internal::_boneList.length);
               while(_loc6_--)
               {
                  _loc5_ = _armature.dragonBones_internal::_boneList[_loc6_];
                  if(_loc5_.name == param1)
                  {
                     _loc4_ = _loc5_;
                  }
                  if(_loc4_ && (_loc4_ == _loc5_ || _loc4_.contains(_loc5_)))
                  {
                     _mixingTransforms[_loc5_.name] = param2;
                  }
               }
            }
            else
            {
               _mixingTransforms[param1] = param2;
            }
            updateTimelineStates();
            return;
         }
         throw new ArgumentError();
      }
      
      public function removeMixingTransform(param1:String = null, param2:Boolean = true) : void
      {
         var _loc6_:int = 0;
         var _loc4_:Bone = null;
         var _loc3_:* = null;
         var _loc5_:Boolean = false;
         if(param1)
         {
            if(param2)
            {
               _loc6_ = int(_armature.dragonBones_internal::_boneList.length);
               while(_loc6_--)
               {
                  _loc4_ = _armature.dragonBones_internal::_boneList[_loc6_];
                  if(_loc4_.name == param1)
                  {
                     _loc3_ = _loc4_;
                  }
                  if(_loc3_ && (_loc3_ == _loc4_ || _loc3_.contains(_loc4_)))
                  {
                     delete _mixingTransforms[_loc4_.name];
                  }
               }
            }
            else
            {
               delete _mixingTransforms[param1];
            }
            var _loc8_:int = 0;
            var _loc7_:Object = _mixingTransforms;
            for each(param1 in _loc7_)
            {
               _loc5_ = true;
            }
            if(!_loc5_)
            {
               _mixingTransforms = null;
            }
         }
         else
         {
            _mixingTransforms = null;
         }
         updateTimelineStates();
      }
      
      public function advanceTime(param1:Number) : Boolean
      {
         var _loc5_:AnimationEvent = null;
         var _loc4_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc7_:int = 0;
         if(!enabled)
         {
            return false;
         }
         if(_fadeIn)
         {
            _fadeIn = false;
            if(_armature.hasEventListener("fadeIn"))
            {
               _loc5_ = new AnimationEvent("fadeIn");
               _loc5_.animationState = this;
               _armature.dragonBones_internal::_eventList.push(_loc5_);
            }
         }
         if(_fadeOut)
         {
            _fadeOut = false;
            if(_armature.hasEventListener("fadeOut"))
            {
               _loc5_ = new AnimationEvent("fadeOut");
               _loc5_.animationState = this;
               _armature.dragonBones_internal::_eventList.push(_loc5_);
            }
         }
         _currentTime += param1 * _timeScale;
         if(_isPlaying && !_isComplete)
         {
            if(_pauseBeforeFadeInComplete)
            {
               _pauseBeforeFadeInComplete = false;
               _isPlaying = false;
               _loc2_ = 0;
               _loc8_ = _loc2_;
            }
            else
            {
               _loc2_ = _currentTime / _totalTime;
               _loc8_ = _loc2_;
               if(_loc8_ != _loopCount)
               {
                  if(_loopCount == -1)
                  {
                     if(_armature.hasEventListener("start"))
                     {
                        _loc5_ = new AnimationEvent("start");
                        _loc5_.animationState = this;
                        _armature.dragonBones_internal::_eventList.push(_loc5_);
                     }
                  }
                  _loopCount = _loc8_;
                  if(_loopCount)
                  {
                     if(_loop && _loopCount * _loopCount >= _loop * _loop - 1)
                     {
                        _loc4_ = true;
                        _loc2_ = 1;
                        _loc8_ = 0;
                        if(_armature.hasEventListener("complete"))
                        {
                           _loc5_ = new AnimationEvent("complete");
                           _loc5_.animationState = this;
                           _armature.dragonBones_internal::_eventList.push(_loc5_);
                        }
                     }
                     else if(_armature.hasEventListener("loopComplete"))
                     {
                        _loc5_ = new AnimationEvent("loopComplete");
                        _loc5_.animationState = this;
                        _armature.dragonBones_internal::_eventList.push(_loc5_);
                     }
                  }
               }
            }
            for each(var _loc6_ in dragonBones_internal::_timelineStates)
            {
               _loc6_.update(_loc2_);
            }
            if(_clip.frameList.length > 0)
            {
               _loc9_ = _totalTime * (_loc2_ - _loc8_);
               _loc3_ = false;
               while(!_currentFrame || _loc9_ > _currentFrame.position + _currentFrame.duration || _loc9_ < _currentFrame.position)
               {
                  if(_loc3_)
                  {
                     _armature.dragonBones_internal::arriveAtFrame(_currentFrame,null,this,true);
                  }
                  _loc3_ = true;
                  if(_currentFrame)
                  {
                     _loc7_ = int(_clip.frameList.indexOf(_currentFrame));
                     if(++_loc7_ >= _clip.frameList.length)
                     {
                        _loc7_ = 0;
                     }
                     _currentFrame = _clip.frameList[_loc7_];
                  }
                  else
                  {
                     _currentFrame = _clip.frameList[0];
                  }
               }
               if(_loc3_)
               {
                  _armature.dragonBones_internal::arriveAtFrame(_currentFrame,null,this,false);
               }
            }
         }
         if(_fadeState > 0)
         {
            if(_fadeInTime == 0)
            {
               dragonBones_internal::_fadeWeight = 1;
               _fadeState = 0;
               _isPlaying = true;
               if(_armature.hasEventListener("fadeInComplete"))
               {
                  _loc5_ = new AnimationEvent("fadeInComplete");
                  _loc5_.animationState = this;
                  _armature.dragonBones_internal::_eventList.push(_loc5_);
               }
            }
            else
            {
               dragonBones_internal::_fadeWeight = _currentTime / _fadeInTime;
               if(dragonBones_internal::_fadeWeight >= 1)
               {
                  dragonBones_internal::_fadeWeight = 1;
                  _fadeState = 0;
                  if(!_isPlaying)
                  {
                     _currentTime -= _fadeInTime;
                  }
                  _isPlaying = true;
                  if(_armature.hasEventListener("fadeInComplete"))
                  {
                     _loc5_ = new AnimationEvent("fadeInComplete");
                     _loc5_.animationState = this;
                     _armature.dragonBones_internal::_eventList.push(_loc5_);
                  }
               }
            }
         }
         else if(_fadeState < 0)
         {
            if(_fadeOutTime == 0)
            {
               dragonBones_internal::_fadeWeight = 0;
               _fadeState = 0;
               if(_armature.hasEventListener("fadeOutComplete"))
               {
                  _loc5_ = new AnimationEvent("fadeOutComplete");
                  _loc5_.animationState = this;
                  _armature.dragonBones_internal::_eventList.push(_loc5_);
               }
               return true;
            }
            dragonBones_internal::_fadeWeight = (1 - (_currentTime - _fadeOutBeginTime) / _fadeOutTime) * _fadeOutWeight;
            if(dragonBones_internal::_fadeWeight <= 0)
            {
               dragonBones_internal::_fadeWeight = 0;
               _fadeState = 0;
               if(_armature.hasEventListener("fadeOutComplete"))
               {
                  _loc5_ = new AnimationEvent("fadeOutComplete");
                  _loc5_.animationState = this;
                  _armature.dragonBones_internal::_eventList.push(_loc5_);
               }
               return true;
            }
         }
         if(_loc4_)
         {
            _isComplete = true;
            if(_loop < 0)
            {
               fadeOut((_fadeOutWeight || _fadeInTime) / _timeScale,true);
            }
         }
         return false;
      }
      
      private function updateTimelineStates() : void
      {
         if(_mixingTransforms)
         {
            for(var _loc1_ in dragonBones_internal::_timelineStates)
            {
               if(_mixingTransforms[_loc1_] == null)
               {
                  removeTimelineState(_loc1_);
               }
            }
            for(_loc1_ in _mixingTransforms)
            {
               if(!dragonBones_internal::_timelineStates[_loc1_])
               {
                  addTimelineState(_loc1_);
               }
            }
         }
         else
         {
            for(_loc1_ in _clip.timelines)
            {
               if(!dragonBones_internal::_timelineStates[_loc1_])
               {
                  addTimelineState(_loc1_);
               }
            }
         }
      }
      
      private function addTimelineState(param1:String) : void
      {
         var _loc4_:TimelineState = null;
         var _loc3_:TransformTimeline = null;
         var _loc2_:Bone = _armature.getBone(param1);
         if(_loc2_)
         {
            _loc4_ = TimelineState.dragonBones_internal::borrowObject();
            _loc3_ = _clip.getTimeline(param1);
            _loc4_.fadeIn(_loc2_,this,_loc3_);
            dragonBones_internal::_timelineStates[param1] = _loc4_;
         }
      }
      
      private function removeTimelineState(param1:String) : void
      {
         TimelineState.dragonBones_internal::returnObject(dragonBones_internal::_timelineStates[param1] as TimelineState);
         delete dragonBones_internal::_timelineStates[param1];
      }
      
      private function clear() : void
      {
         _armature = null;
         _currentFrame = null;
         _clip = null;
         _mixingTransforms = null;
         enabled = false;
         for(var _loc1_ in dragonBones_internal::_timelineStates)
         {
            removeTimelineState(_loc1_);
         }
      }
   }
}

