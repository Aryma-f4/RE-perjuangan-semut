package dragonBones.objects
{
   public class Timeline
   {
      
      private var _frameList:Vector.<Frame>;
      
      private var _duration:Number;
      
      private var _scale:Number;
      
      public function Timeline()
      {
         super();
         _frameList = new Vector.<Frame>(0,true);
         _duration = 0;
         _scale = 1;
      }
      
      public function get frameList() : Vector.<Frame>
      {
         return _frameList;
      }
      
      public function get duration() : Number
      {
         return _duration;
      }
      
      public function set duration(param1:Number) : void
      {
         _duration = param1 >= 0 ? param1 : 0;
      }
      
      public function get scale() : Number
      {
         return _scale;
      }
      
      public function set scale(param1:Number) : void
      {
         _scale = param1 >= 0 ? param1 : 1;
      }
      
      public function dispose() : void
      {
         var _loc1_:int = int(_frameList.length);
         while(_loc1_--)
         {
            _frameList[_loc1_].dispose();
         }
         _frameList.fixed = false;
         _frameList.length = 0;
         _frameList = null;
      }
      
      public function addFrame(param1:Frame) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         if(_frameList.indexOf(param1) < 0)
         {
            _frameList.fixed = false;
            _frameList[_frameList.length] = param1;
            _frameList.fixed = true;
            return;
         }
         throw new ArgumentError();
      }
   }
}

