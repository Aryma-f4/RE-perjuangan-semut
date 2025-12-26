package starling.animation
{
   import starling.core.starling_internal;
   import starling.events.EventDispatcher;
   
   use namespace starling_internal;
   
   public class Tween extends EventDispatcher implements IAnimatable
   {
      
      private static var sTweenPool:Vector.<Tween> = new Vector.<Tween>(0);
      
      private var mTarget:Object;
      
      private var mTransitionFunc:Function;
      
      private var mTransitionName:String;
      
      private var mProperties:Vector.<String>;
      
      private var mStartValues:Vector.<Number>;
      
      private var mEndValues:Vector.<Number>;
      
      private var mOnStart:Function;
      
      private var mOnUpdate:Function;
      
      private var mOnRepeat:Function;
      
      private var mOnComplete:Function;
      
      private var mOnStartArgs:Array;
      
      private var mOnUpdateArgs:Array;
      
      private var mOnRepeatArgs:Array;
      
      private var mOnCompleteArgs:Array;
      
      private var mTotalTime:Number;
      
      private var mCurrentTime:Number;
      
      private var mProgress:Number;
      
      private var mDelay:Number;
      
      private var mRoundToInt:Boolean;
      
      private var mNextTween:Tween;
      
      private var mRepeatCount:int;
      
      private var mRepeatDelay:Number;
      
      private var mReverse:Boolean;
      
      private var mCurrentCycle:int;
      
      public function Tween(param1:Object, param2:Number, param3:Object = "linear")
      {
         super();
         reset(param1,param2,param3);
      }
      
      starling_internal static function fromPool(param1:Object, param2:Number, param3:Object = "linear") : Tween
      {
         if(sTweenPool.length)
         {
            return sTweenPool.pop().reset(param1,param2,param3);
         }
         return new Tween(param1,param2,param3);
      }
      
      starling_internal static function toPool(param1:Tween) : void
      {
         param1.mOnStart = param1.mOnUpdate = param1.mOnRepeat = param1.mOnComplete = null;
         param1.mOnStartArgs = param1.mOnUpdateArgs = param1.mOnRepeatArgs = param1.mOnCompleteArgs = null;
         param1.mTarget = null;
         param1.mTransitionFunc = null;
         param1.removeEventListeners();
         sTweenPool.push(param1);
      }
      
      public function reset(param1:Object, param2:Number, param3:Object = "linear") : Tween
      {
         mTarget = param1;
         mCurrentTime = 0;
         mTotalTime = Math.max(0.0001,param2);
         mProgress = 0;
         mDelay = mRepeatDelay = 0;
         mOnStart = mOnUpdate = mOnRepeat = mOnComplete = null;
         mOnStartArgs = mOnUpdateArgs = mOnRepeatArgs = mOnCompleteArgs = null;
         mRoundToInt = mReverse = false;
         mRepeatCount = 1;
         mCurrentCycle = -1;
         if(param3 is String)
         {
            this.transition = param3 as String;
         }
         else
         {
            if(!(param3 is Function))
            {
               throw new ArgumentError("Transition must be either a string or a function");
            }
            this.transitionFunc = param3 as Function;
         }
         if(mProperties)
         {
            mProperties.length = 0;
         }
         else
         {
            mProperties = new Vector.<String>(0);
         }
         if(mStartValues)
         {
            mStartValues.length = 0;
         }
         else
         {
            mStartValues = new Vector.<Number>(0);
         }
         if(mEndValues)
         {
            mEndValues.length = 0;
         }
         else
         {
            mEndValues = new Vector.<Number>(0);
         }
         return this;
      }
      
      public function animate(param1:String, param2:Number) : void
      {
         if(mTarget == null)
         {
            return;
         }
         mProperties[mProperties.length] = param1;
         mStartValues[mStartValues.length] = NaN;
         mEndValues[mEndValues.length] = param2;
      }
      
      public function scaleTo(param1:Number) : void
      {
         animate("scaleX",param1);
         animate("scaleY",param1);
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         animate("x",param1);
         animate("y",param2);
      }
      
      public function fadeTo(param1:Number) : void
      {
         animate("alpha",param1);
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc10_:Function = null;
         var _loc5_:Array = null;
         if(param1 == 0 || mRepeatCount == 1 && mCurrentTime == mTotalTime)
         {
            return;
         }
         var _loc12_:Number = mCurrentTime;
         var _loc11_:Number = mTotalTime - mCurrentTime;
         var _loc3_:Number = param1 > _loc11_ ? param1 - _loc11_ : 0;
         mCurrentTime += param1;
         if(mCurrentTime <= 0)
         {
            return;
         }
         if(mCurrentTime > mTotalTime)
         {
            mCurrentTime = mTotalTime;
         }
         if(mCurrentCycle < 0 && _loc12_ <= 0 && mCurrentTime > 0)
         {
            mCurrentCycle = mCurrentCycle + 1;
            if(mOnStart != null)
            {
               mOnStart.apply(this,mOnStartArgs);
            }
         }
         var _loc9_:Number = mCurrentTime / mTotalTime;
         var _loc13_:Boolean = mReverse && mCurrentCycle % 2 == 1;
         var _loc14_:int = int(mStartValues.length);
         mProgress = _loc13_ ? mTransitionFunc(1 - _loc9_) : mTransitionFunc(_loc9_);
         _loc7_ = 0;
         while(_loc7_ < _loc14_)
         {
            if(mStartValues[_loc7_] != mStartValues[_loc7_])
            {
               mStartValues[_loc7_] = mTarget[mProperties[_loc7_]] as Number;
            }
            _loc8_ = mStartValues[_loc7_];
            _loc2_ = mEndValues[_loc7_];
            _loc4_ = _loc2_ - _loc8_;
            _loc6_ = _loc8_ + mProgress * _loc4_;
            if(mRoundToInt)
            {
               _loc6_ = Math.round(_loc6_);
            }
            mTarget[mProperties[_loc7_]] = _loc6_;
            _loc7_++;
         }
         if(mOnUpdate != null)
         {
            mOnUpdate.apply(this,mOnUpdateArgs);
         }
         if(_loc12_ < mTotalTime && mCurrentTime >= mTotalTime)
         {
            if(mRepeatCount == 0 || mRepeatCount > 1)
            {
               mCurrentTime = -mRepeatDelay;
               mCurrentCycle = mCurrentCycle + 1;
               if(mRepeatCount > 1)
               {
                  mRepeatCount = mRepeatCount - 1;
               }
               if(mOnRepeat != null)
               {
                  mOnRepeat.apply(this,mOnRepeatArgs);
               }
            }
            else
            {
               _loc10_ = mOnComplete;
               _loc5_ = mOnCompleteArgs;
               dispatchEventWith("removeFromJuggler");
               if(_loc10_ != null)
               {
                  _loc10_.apply(this,_loc5_);
               }
            }
         }
         if(_loc3_)
         {
            advanceTime(_loc3_);
         }
      }
      
      public function getEndValue(param1:String) : Number
      {
         var _loc2_:int = int(mProperties.indexOf(param1));
         if(_loc2_ == -1)
         {
            throw new ArgumentError("The property \'" + param1 + "\' is not animated");
         }
         return mEndValues[_loc2_] as Number;
      }
      
      public function get isComplete() : Boolean
      {
         return mCurrentTime >= mTotalTime && mRepeatCount == 1;
      }
      
      public function get target() : Object
      {
         return mTarget;
      }
      
      public function get transition() : String
      {
         return mTransitionName;
      }
      
      public function set transition(param1:String) : void
      {
         mTransitionName = param1;
         mTransitionFunc = Transitions.getTransition(param1);
         if(mTransitionFunc == null)
         {
            throw new ArgumentError("Invalid transiton: " + param1);
         }
      }
      
      public function get transitionFunc() : Function
      {
         return mTransitionFunc;
      }
      
      public function set transitionFunc(param1:Function) : void
      {
         mTransitionName = "custom";
         mTransitionFunc = param1;
      }
      
      public function get totalTime() : Number
      {
         return mTotalTime;
      }
      
      public function get currentTime() : Number
      {
         return mCurrentTime;
      }
      
      public function get progress() : Number
      {
         return mProgress;
      }
      
      public function get delay() : Number
      {
         return mDelay;
      }
      
      public function set delay(param1:Number) : void
      {
         mCurrentTime = mCurrentTime + mDelay - param1;
         mDelay = param1;
      }
      
      public function get repeatCount() : int
      {
         return mRepeatCount;
      }
      
      public function set repeatCount(param1:int) : void
      {
         mRepeatCount = param1;
      }
      
      public function get repeatDelay() : Number
      {
         return mRepeatDelay;
      }
      
      public function set repeatDelay(param1:Number) : void
      {
         mRepeatDelay = param1;
      }
      
      public function get reverse() : Boolean
      {
         return mReverse;
      }
      
      public function set reverse(param1:Boolean) : void
      {
         mReverse = param1;
      }
      
      public function get roundToInt() : Boolean
      {
         return mRoundToInt;
      }
      
      public function set roundToInt(param1:Boolean) : void
      {
         mRoundToInt = param1;
      }
      
      public function get onStart() : Function
      {
         return mOnStart;
      }
      
      public function set onStart(param1:Function) : void
      {
         mOnStart = param1;
      }
      
      public function get onUpdate() : Function
      {
         return mOnUpdate;
      }
      
      public function set onUpdate(param1:Function) : void
      {
         mOnUpdate = param1;
      }
      
      public function get onRepeat() : Function
      {
         return mOnRepeat;
      }
      
      public function set onRepeat(param1:Function) : void
      {
         mOnRepeat = param1;
      }
      
      public function get onComplete() : Function
      {
         return mOnComplete;
      }
      
      public function set onComplete(param1:Function) : void
      {
         mOnComplete = param1;
      }
      
      public function get onStartArgs() : Array
      {
         return mOnStartArgs;
      }
      
      public function set onStartArgs(param1:Array) : void
      {
         mOnStartArgs = param1;
      }
      
      public function get onUpdateArgs() : Array
      {
         return mOnUpdateArgs;
      }
      
      public function set onUpdateArgs(param1:Array) : void
      {
         mOnUpdateArgs = param1;
      }
      
      public function get onRepeatArgs() : Array
      {
         return mOnRepeatArgs;
      }
      
      public function set onRepeatArgs(param1:Array) : void
      {
         mOnRepeatArgs = param1;
      }
      
      public function get onCompleteArgs() : Array
      {
         return mOnCompleteArgs;
      }
      
      public function set onCompleteArgs(param1:Array) : void
      {
         mOnCompleteArgs = param1;
      }
      
      public function get nextTween() : Tween
      {
         return mNextTween;
      }
      
      public function set nextTween(param1:Tween) : void
      {
         mNextTween = param1;
      }
   }
}

