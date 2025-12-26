package feathers.motion.transitions
{
   import feathers.controls.ScreenNavigator;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   
   public class ScreenFadeTransitionManager
   {
      
      protected var navigator:ScreenNavigator;
      
      protected var _activeTransition:Tween;
      
      protected var _savedOtherTarget:DisplayObject;
      
      protected var _savedCompleteHandler:Function;
      
      public var duration:Number = 0.25;
      
      public var delay:Number = 0.1;
      
      public var ease:Object = "easeOut";
      
      public var skipNextTransition:Boolean = false;
      
      public function ScreenFadeTransitionManager(param1:ScreenNavigator)
      {
         super();
         if(!param1)
         {
            throw new ArgumentError("ScreenNavigator cannot be null.");
         }
         this.navigator = param1;
         this.navigator.transition = this.onTransition;
      }
      
      protected function onTransition(param1:DisplayObject, param2:DisplayObject, param3:Function) : void
      {
         if(!param1 && !param2)
         {
            throw new ArgumentError("Cannot transition if both old screen and new screen are null.");
         }
         if(this._activeTransition)
         {
            this._savedOtherTarget = null;
            this._activeTransition.advanceTime(this._activeTransition.totalTime);
            this._activeTransition = null;
         }
         if(this.skipNextTransition)
         {
            this.skipNextTransition = false;
            this._savedCompleteHandler = null;
            if(param2)
            {
               param2.x = 0;
               param2.alpha = 1;
            }
            if(param3 != null)
            {
               param3();
            }
            return;
         }
         this._savedCompleteHandler = param3;
         if(param2)
         {
            param2.alpha = 0;
            if(param1)
            {
               param1.alpha = 1;
            }
            this._savedOtherTarget = param1;
            this._activeTransition = new Tween(param2,this.duration,this.ease);
            this._activeTransition.fadeTo(1);
            this._activeTransition.delay = this.delay;
            this._activeTransition.onUpdate = activeTransition_onUpdate;
            this._activeTransition.onComplete = activeTransition_onComplete;
            Starling.juggler.add(this._activeTransition);
         }
         else
         {
            param1.alpha = 1;
            this._activeTransition = new Tween(param1,this.duration,this.ease);
            this._activeTransition.fadeTo(0);
            this._activeTransition.delay = this.delay;
            this._activeTransition.onComplete = activeTransition_onComplete;
            Starling.juggler.add(this._activeTransition);
         }
      }
      
      protected function activeTransition_onUpdate() : void
      {
         var _loc1_:DisplayObject = null;
         if(this._savedOtherTarget)
         {
            _loc1_ = DisplayObject(this._activeTransition.target);
            this._savedOtherTarget.alpha = 1 - _loc1_.alpha;
         }
      }
      
      protected function activeTransition_onComplete() : void
      {
         this._savedOtherTarget = null;
         this._activeTransition = null;
         if(this._savedCompleteHandler != null)
         {
            this._savedCompleteHandler();
         }
      }
   }
}

