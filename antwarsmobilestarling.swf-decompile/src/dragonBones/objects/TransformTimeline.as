package dragonBones.objects
{
   import flash.geom.Point;
   
   public final class TransformTimeline extends Timeline
   {
      
      public static const HIDE_TIMELINE:TransformTimeline = new TransformTimeline();
      
      public var transformed:Boolean;
      
      public var originTransform:DBTransform;
      
      public var originPivot:Point;
      
      private var _offset:Number;
      
      public function TransformTimeline()
      {
         super();
         originTransform = new DBTransform();
         originPivot = new Point();
         _offset = 0;
      }
      
      public function get offset() : Number
      {
         return _offset;
      }
      
      public function set offset(param1:Number) : void
      {
         _offset = (param1 || 0) % 1;
         if(_offset < 0)
         {
            _offset += 1;
         }
      }
      
      override public function dispose() : void
      {
         if(this == HIDE_TIMELINE)
         {
            return;
         }
         super.dispose();
         originTransform = null;
         originPivot = null;
      }
   }
}

