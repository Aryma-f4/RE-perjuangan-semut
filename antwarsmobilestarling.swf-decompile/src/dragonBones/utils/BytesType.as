package dragonBones.utils
{
   import flash.utils.ByteArray;
   
   public class BytesType
   {
      
      public static const SWF:String = "swf";
      
      public static const PNG:String = "png";
      
      public static const JPG:String = "jpg";
      
      public static const ATF:String = "atf";
      
      public static const ZIP:String = "zip";
      
      public function BytesType()
      {
         super();
      }
      
      public static function getType(param1:ByteArray) : String
      {
         var _loc6_:String = null;
         var _loc2_:uint = uint(param1[0]);
         var _loc4_:uint = uint(param1[1]);
         var _loc3_:uint = uint(param1[2]);
         var _loc5_:uint = uint(param1[3]);
         if((_loc2_ == 70 || _loc2_ == 67 || _loc2_ == 90) && _loc4_ == 87 && _loc3_ == 83)
         {
            _loc6_ = "swf";
         }
         else if(_loc2_ == 137 && _loc4_ == 80 && _loc3_ == 78 && _loc5_ == 71)
         {
            _loc6_ = "png";
         }
         else if(_loc2_ == 255)
         {
            _loc6_ = "jpg";
         }
         else if(_loc2_ == 65 && _loc4_ == 84 && _loc3_ == 70)
         {
            _loc6_ = "atf";
         }
         else if(_loc2_ == 80 && _loc4_ == 75)
         {
            _loc6_ = "zip";
         }
         return _loc6_;
      }
   }
}

