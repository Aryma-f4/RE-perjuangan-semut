package dragonBones.objects
{
   import dragonBones.utils.BytesType;
   import dragonBones.utils.checkBytesTailisXML;
   import flash.utils.ByteArray;
   
   public final class DataParser
   {
      
      public function DataParser()
      {
         super();
      }
      
      public static function compressData(param1:Object, param2:Object, param3:ByteArray) : ByteArray
      {
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeBytes(param3);
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeObject(param2);
         _loc5_.compress();
         _loc4_.position = _loc4_.length;
         _loc4_.writeBytes(_loc5_);
         _loc4_.writeInt(_loc5_.length);
         _loc5_.length = 0;
         _loc5_.writeObject(param1);
         _loc5_.compress();
         _loc4_.position = _loc4_.length;
         _loc4_.writeBytes(_loc5_);
         _loc4_.writeInt(_loc5_.length);
         return _loc4_;
      }
      
      public static function decompressData(param1:ByteArray) : DecompressedData
      {
         var _loc4_:int = 0;
         var _loc2_:* = 0;
         var _loc6_:ByteArray = null;
         var _loc3_:Object = null;
         var _loc8_:Object = null;
         var _loc7_:DecompressedData = null;
         var _loc5_:String;
         switch(_loc5_ = BytesType.getType(param1))
         {
            case "swf":
            case "png":
            case "jpg":
            case "atf":
               break;
            case "zip":
               throw new Error("Can not decompress zip!");
            default:
               throw new Error("Nonsupport data!");
         }
         try
         {
            param1.position = param1.length - 4;
            _loc4_ = param1.readInt();
            _loc2_ = uint(param1.length - 4 - _loc4_);
            _loc6_ = new ByteArray();
            _loc6_.writeBytes(param1,_loc2_,_loc4_);
            _loc6_.uncompress();
            param1.length = _loc2_;
            if(checkBytesTailisXML(_loc6_))
            {
               _loc3_ = XML(_loc6_.readUTFBytes(_loc6_.length));
            }
            else
            {
               _loc3_ = _loc6_.readObject();
            }
            param1.position = param1.length - 4;
            _loc4_ = param1.readInt();
            _loc2_ = uint(param1.length - 4 - _loc4_);
            _loc6_.length = 0;
            _loc6_.writeBytes(param1,_loc2_,_loc4_);
            _loc6_.uncompress();
            param1.length = _loc2_;
            if(checkBytesTailisXML(_loc6_))
            {
               _loc8_ = XML(_loc6_.readUTFBytes(_loc6_.length));
            }
            else
            {
               _loc8_ = _loc6_.readObject();
            }
         }
         catch(e:Error)
         {
            throw new Error("Data error!");
         }
         _loc7_ = new DecompressedData(_loc3_,_loc8_,param1);
         _loc7_.textureBytesDataType = _loc5_;
         return _loc7_;
      }
      
      public static function parseTextureAtlas(param1:Object, param2:Number = 1) : Object
      {
         if(param1 is XML)
         {
            return XMLDataParser.parseTextureAtlasData(param1 as XML,param2);
         }
         return ObjectDataParser.parseTextureAtlasData(param1,param2);
      }
      
      public static function parseData(param1:Object) : SkeletonData
      {
         if(param1 is XML)
         {
            return XMLDataParser.parseSkeletonData(param1 as XML);
         }
         return ObjectDataParser.parseSkeletonData(param1);
      }
   }
}

