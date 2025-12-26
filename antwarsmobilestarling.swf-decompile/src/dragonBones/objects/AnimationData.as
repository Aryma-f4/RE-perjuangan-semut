package dragonBones.objects
{
   public final class AnimationData extends Timeline
   {
      
      public var frameRate:uint;
      
      public var name:String;
      
      public var loop:int;
      
      public var tweenEasing:Number;
      
      private var _timelines:Object;
      
      private var _fadeTime:Number;
      
      public function AnimationData()
      {
         super();
         loop = 0;
         tweenEasing = NaN;
         _timelines = {};
         _fadeTime = 0;
      }
      
      public function get timelines() : Object
      {
         return _timelines;
      }
      
      public function get fadeInTime() : Number
      {
         return _fadeTime;
      }
      
      public function set fadeInTime(param1:Number) : void
      {
         if(isNaN(param1))
         {
            param1 = 0;
         }
         _fadeTime = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         for(var _loc1_ in _timelines)
         {
            (_timelines[_loc1_] as TransformTimeline).dispose();
         }
         _timelines = null;
      }
      
      public function getTimeline(param1:String) : TransformTimeline
      {
         return _timelines[param1] as TransformTimeline;
      }
      
      public function addTimeline(param1:TransformTimeline, param2:String) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         _timelines[param2] = param1;
      }
   }
}

