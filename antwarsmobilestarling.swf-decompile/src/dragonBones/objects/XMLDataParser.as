package dragonBones.objects
{
   import dragonBones.core.dragonBones_internal;
   import dragonBones.utils.DBDataUtil;
   import dragonBones.utils.parseOldXMLData;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   use namespace dragonBones_internal;
   
   public final class XMLDataParser
   {
      
      public function XMLDataParser()
      {
         super();
      }
      
      public static function parseTextureAtlasData(param1:XML, param2:Number = 1) : Object
      {
         var _loc3_:String = null;
         var _loc4_:Rectangle = null;
         var _loc6_:Object = {};
         _loc6_.__name = param1["name"];
         for each(var _loc5_ in param1["SubTexture"])
         {
            _loc3_ = _loc5_["name"];
            _loc4_ = new Rectangle();
            _loc4_.x = int(_loc5_["x"]) / param2;
            _loc4_.y = int(_loc5_["y"]) / param2;
            _loc4_.width = int(_loc5_["width"]) / param2;
            _loc4_.height = int(_loc5_["height"]) / param2;
            _loc6_[_loc3_] = _loc4_;
         }
         return _loc6_;
      }
      
      public static function parseSkeletonData(param1:XML) : SkeletonData
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         var _loc5_:String;
         switch(_loc5_ = param1["version"])
         {
            case "1.5":
            case "2.0":
            case "2.1":
            case "2.1.1":
            case "2.1.2":
            case "2.2":
               break;
            case "2.3":
               var _loc4_:uint = uint(int(param1["frameRate"]));
               var _loc3_:SkeletonData = new SkeletonData();
               _loc3_.name = param1["name"];
               for each(var _loc2_ in param1["armature"])
               {
                  _loc3_.addArmatureData(parseArmatureData(_loc2_,_loc3_,_loc4_));
               }
               return _loc3_;
            default:
               throw new Error("Nonsupport version!");
         }
         return parseOldXMLData(param1 as XML);
      }
      
      private static function parseArmatureData(param1:XML, param2:SkeletonData, param3:uint) : ArmatureData
      {
         var _loc7_:ArmatureData = new ArmatureData();
         _loc7_.name = param1["name"];
         for each(var _loc5_ in param1["bone"])
         {
            _loc7_.addBoneData(parseBoneData(_loc5_));
         }
         for each(var _loc4_ in param1["skin"])
         {
            _loc7_.addSkinData(parseSkinData(_loc4_,param2));
         }
         DBDataUtil.transformArmatureData(_loc7_);
         _loc7_.sortBoneDataList();
         for each(var _loc6_ in param1["animation"])
         {
            _loc7_.addAnimationData(dragonBones_internal::parseAnimationData(_loc6_,_loc7_,param3));
         }
         return _loc7_;
      }
      
      private static function parseBoneData(param1:XML) : BoneData
      {
         var _loc2_:BoneData = new BoneData();
         _loc2_.name = param1["name"];
         _loc2_.parent = param1["parent"];
         _loc2_.length = Number(param1["length"]);
         parseTransform(param1["transform"][0],_loc2_.global);
         _loc2_.transform.copy(_loc2_.global);
         return _loc2_;
      }
      
      private static function parseSkinData(param1:XML, param2:SkeletonData) : SkinData
      {
         var _loc4_:SkinData = new SkinData();
         _loc4_.name = param1["name"];
         for each(var _loc3_ in param1["slot"])
         {
            _loc4_.addSlotData(parseSlotData(_loc3_,param2));
         }
         return _loc4_;
      }
      
      private static function parseSlotData(param1:XML, param2:SkeletonData) : SlotData
      {
         var _loc3_:SlotData = new SlotData();
         _loc3_.name = param1["name"];
         _loc3_.parent = param1["parent"];
         _loc3_.zOrder = Number(param1["z"]);
         for each(var _loc4_ in param1["display"])
         {
            _loc3_.addDisplayData(parseDisplayData(_loc4_,param2));
         }
         return _loc3_;
      }
      
      private static function parseDisplayData(param1:XML, param2:SkeletonData) : DisplayData
      {
         var _loc3_:DisplayData = new DisplayData();
         _loc3_.name = param1["name"];
         _loc3_.type = param1["type"];
         _loc3_.pivot = param2.addSubTexturePivot(0,0,_loc3_.name);
         parseTransform(param1["transform"][0],_loc3_.transform,_loc3_.pivot);
         return _loc3_;
      }
      
      dragonBones_internal static function parseAnimationData(param1:XML, param2:ArmatureData, param3:uint) : AnimationData
      {
         var _loc6_:TransformTimeline = null;
         var _loc5_:String = null;
         var _loc7_:AnimationData = new AnimationData();
         _loc7_.name = param1["name"];
         _loc7_.frameRate = param3;
         _loc7_.loop = int(param1["loop"]);
         _loc7_.fadeInTime = Number(param1["fadeInTime"]);
         _loc7_.duration = Number(param1["duration"]) / param3;
         _loc7_.scale = Number(param1["scale"]);
         _loc7_.tweenEasing = Number(param1["tweenEasing"]);
         parseTimeline(param1,_loc7_,parseMainFrame,param3);
         for each(var _loc4_ in param1["timeline"])
         {
            _loc6_ = parseTransformTimeline(_loc4_,_loc7_.duration,param3);
            _loc5_ = _loc4_["name"];
            _loc7_.addTimeline(_loc6_,_loc5_);
         }
         DBDataUtil.addHideTimeline(_loc7_,param2);
         DBDataUtil.transformAnimationData(_loc7_,param2);
         return _loc7_;
      }
      
      private static function parseTimeline(param1:XML, param2:Timeline, param3:Function, param4:uint) : void
      {
         var _loc6_:Frame = null;
         var _loc5_:Number = 0;
         for each(var _loc7_ in param1["frame"])
         {
            _loc6_ = param3(_loc7_,param4);
            _loc6_.position = _loc5_;
            param2.addFrame(_loc6_);
            _loc5_ += _loc6_.duration;
         }
         if(_loc6_)
         {
            _loc6_.duration = param2.duration - _loc6_.position;
         }
      }
      
      private static function parseTransformTimeline(param1:XML, param2:Number, param3:uint) : TransformTimeline
      {
         var _loc4_:TransformTimeline = new TransformTimeline();
         _loc4_.duration = param2;
         parseTimeline(param1,_loc4_,parseTransformFrame,param3);
         _loc4_.scale = Number(param1["scale"]);
         _loc4_.offset = Number(param1["offset"]);
         return _loc4_;
      }
      
      private static function parseFrame(param1:XML, param2:Frame, param3:uint) : void
      {
         param2.duration = Number(param1["duration"]) / param3;
         param2.action = param1["action"];
         param2.event = param1["event"];
         param2.sound = param1["sound"];
      }
      
      private static function parseMainFrame(param1:XML, param2:uint) : Frame
      {
         var _loc3_:Frame = new Frame();
         parseFrame(param1,_loc3_,param2);
         return _loc3_;
      }
      
      private static function parseTransformFrame(param1:XML, param2:uint) : TransformFrame
      {
         var _loc3_:TransformFrame = new TransformFrame();
         parseFrame(param1,_loc3_,param2);
         _loc3_.visible = uint(param1["hide"]) != 1;
         _loc3_.tweenEasing = Number(param1["tweenEasing"]);
         _loc3_.tweenRotate = Number(param1["tweenRotate"]);
         _loc3_.displayIndex = Number(param1["displayIndex"]);
         _loc3_.zOrder = Number(param1["z"][0]);
         parseTransform(param1["transform"][0],_loc3_.global,_loc3_.pivot);
         _loc3_.transform.copy(_loc3_.global);
         var _loc4_:XML = param1["colorTransform"][0];
         if(_loc4_)
         {
            _loc3_.color = new ColorTransform();
            _loc3_.color.alphaOffset = Number(_loc4_["aO"]);
            _loc3_.color.redOffset = Number(_loc4_["rO"]);
            _loc3_.color.greenOffset = Number(_loc4_["gO"]);
            _loc3_.color.blueOffset = Number(_loc4_["bO"]);
            _loc3_.color.alphaMultiplier = Number(_loc4_["aM"]) * 0.01;
            _loc3_.color.redMultiplier = Number(_loc4_["rM"]) * 0.01;
            _loc3_.color.greenMultiplier = Number(_loc4_["gM"]) * 0.01;
            _loc3_.color.blueMultiplier = Number(_loc4_["bM"]) * 0.01;
         }
         return _loc3_;
      }
      
      private static function parseTransform(param1:XML, param2:DBTransform, param3:Point = null) : void
      {
         if(param1)
         {
            if(param2)
            {
               param2.x = Number(param1["x"]);
               param2.y = Number(param1["y"]);
               param2.skewX = Number(param1["skX"]) * 0.017453292519943295;
               param2.skewY = Number(param1["skY"]) * 0.017453292519943295;
               param2.scaleX = Number(param1["scX"]);
               param2.scaleY = Number(param1["scY"]);
            }
            if(param3)
            {
               param3.x = Number(param1["pX"]);
               param3.y = Number(param1["pY"]);
            }
         }
      }
   }
}

