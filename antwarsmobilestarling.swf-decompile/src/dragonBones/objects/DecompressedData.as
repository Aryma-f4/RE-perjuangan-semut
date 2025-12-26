package dragonBones.objects
{
   import flash.utils.ByteArray;
   
   public final class DecompressedData
   {
      
      public var textureBytesDataType:String;
      
      public var dragonBonesData:Object;
      
      public var textureAtlasData:Object;
      
      public var textureBytes:ByteArray;
      
      public function DecompressedData(param1:Object, param2:Object, param3:ByteArray)
      {
         super();
         this.dragonBonesData = param1;
         this.textureAtlasData = param2;
         this.textureBytes = param3;
      }
      
      public function dispose() : void
      {
         dragonBonesData = null;
         textureAtlasData = null;
         textureBytes = null;
      }
   }
}

