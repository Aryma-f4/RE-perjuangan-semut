package
{
   // import flash.filesystem.File;
   // import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import starling.utils.AssetManager;
   
   public class ResAssetManager extends AssetManager
   {
      
      public function ResAssetManager(param1:Number = 1, param2:Boolean = false)
      {
         super(param1,param2);
      }
      
      override protected function transformData(param1:ByteArray, param2:String) : ByteArray
      {
         return param1;
      }
      
      override protected function log(param1:String) : void
      {
         if(Constants.debug)
         {
            super.log(param1);
         }
      }
   }
}
