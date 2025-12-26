package dragonBones.objects
{
   import dragonBones.core.dragonBones_internal;
   import dragonBones.utils.DBDataUtil;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   use namespace dragonBones_internal;
   
   public final class ObjectDataParser
   {
      
      public function ObjectDataParser()
      {
         super();
      }
      
      public static function parseTextureAtlasData(param1:Object, param2:Number = 1) : Object
      {
         var _loc4_:String = null;
         var _loc5_:Rectangle = null;
         var _loc6_:Object = {};
         _loc6_.__name = param1["name"];
         for each(var _loc3_ in param1["SubTexture"])
         {
            _loc4_ = _loc3_["name"];
            _loc5_ = new Rectangle();
            _loc5_.x = int(_loc3_["x"]) / param2;
            _loc5_.y = int(_loc3_["y"]) / param2;
            _loc5_.width = int(_loc3_["width"]) / param2;
            _loc5_.height = int(_loc3_["height"]) / param2;
            _loc6_[_loc4_] = _loc5_;
         }
         return _loc6_;
      }
      
      public static function parseSkeletonData(param1:Object) : SkeletonData
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         var _loc5_:String;
         var _loc6_:* = _loc5_ = param1["version"];
         if("2.3" !== _loc6_)
         {
            throw new Error("Nonsupport version!");
         }
         var _loc4_:uint = uint(int(param1["frameRate"]));
         var _loc3_:SkeletonData = new SkeletonData();
         _loc3_.name = param1["name"];
         for each(var _loc2_ in param1["armature"])
         {
            _loc3_.addArmatureData(parseArmatureData(_loc2_,_loc3_,_loc4_));
         }
         return _loc3_;
      }
      
      private static function parseArmatureData(param1:Object, param2:SkeletonData, param3:uint) : ArmatureData
      {
         var _loc7_:ArmatureData = new ArmatureData();
         _loc7_.name = param1["name"];
         for each(var _loc6_ in param1["bone"])
         {
            _loc7_.addBoneData(parseBoneData(_loc6_));
         }
         for each(var _loc5_ in param1["skin"])
         {
            _loc7_.addSkinData(parseSkinData(_loc5_,param2));
         }
         DBDataUtil.transformArmatureData(_loc7_);
         _loc7_.sortBoneDataList();
         for each(var _loc4_ in param1["animation"])
         {
            _loc7_.addAnimationData(parseAnimationData(_loc4_,_loc7_,param3));
         }
         return _loc7_;
      }
      
      private static function parseBoneData(param1:Object) : BoneData
      {
         var _loc2_:BoneData = new BoneData();
         _loc2_.name = param1["name"];
         _loc2_.parent = param1["parent"];
         _loc2_.length = Number(param1["length"]) || 0;
         parseTransform(param1["transform"],_loc2_.global);
         _loc2_.transform.copy(_loc2_.global);
         return _loc2_;
      }
      
      private static function parseSkinData(param1:Object, param2:SkeletonData) : SkinData
      {
         var _loc3_:SkinData = new SkinData();
         _loc3_.name = param1["name"];
         for each(var _loc4_ in param1["slot"])
         {
            _loc3_.addSlotData(parseSlotData(_loc4_,param2));
         }
         return _loc3_;
      }
      
      private static function parseSlotData(param1:Object, param2:SkeletonData) : SlotData
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
      
      private static function parseDisplayData(param1:Object, param2:SkeletonData) : DisplayData
      {
         var _loc3_:DisplayData = new DisplayData();
         _loc3_.name = param1["name"];
         _loc3_.type = param1["type"];
         _loc3_.pivot = param2.addSubTexturePivot(0,0,_loc3_.name);
         parseTransform(param1["transform"],_loc3_.transform,_loc3_.pivot);
         return _loc3_;
      }
      
      private static function parseAnimationData(param1:Object, param2:ArmatureData, param3:uint) : AnimationData
      {
         var _loc6_:* = undefined;
         var _loc5_:TransformTimeline = null;
         var _loc4_:String = null;
         var _loc8_:AnimationData = new AnimationData();
         _loc8_.name = param1["name"];
         _loc8_.frameRate = param3;
         _loc8_.loop = int(param1["loop"]);
         _loc8_.fadeInTime = Number(param1["fadeInTime"]);
         _loc8_.duration = Number(param1["duration"]) / param3;
         _loc8_.scale = Number(param1["scale"]);
         if("tweenEasing" in param1)
         {
            _loc6_ = param1["tweenEasing"];
            if(_loc6_ == undefined || _loc6_ == null)
            {
               _loc8_.tweenEasing = NaN;
            }
            else
            {
               _loc8_.tweenEasing = Number(_loc6_);
            }
         }
         else
         {
            _loc8_.tweenEasing = NaN;
         }
         parseTimeline(param1,_loc8_,parseMainFrame,param3);
         for each(var _loc7_ in param1["timeline"])
         {
            _loc5_ = parseTransformTimeline(_loc7_,_loc8_.duration,param3);
            _loc4_ = _loc7_["name"];
            _loc8_.addTimeline(_loc5_,_loc4_);
         }
         DBDataUtil.addHideTimeline(_loc8_,param2);
         DBDataUtil.transformAnimationData(_loc8_,param2);
         return _loc8_;
      }
      
      private static function parseTimeline(param1:Object, param2:Timeline, param3:Function, param4:uint) : void
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
      
      private static function parseTransformTimeline(param1:Object, param2:Number, param3:uint) : TransformTimeline
      {
         var _loc4_:TransformTimeline = new TransformTimeline();
         _loc4_.duration = param2;
         parseTimeline(param1,_loc4_,parseTransformFrame,param3);
         _loc4_.scale = Number(param1["scale"]);
         _loc4_.offset = Number(param1["offset"]);
         return _loc4_;
      }
      
      private static function parseFrame(param1:Object, param2:Frame, param3:uint) : void
      {
         param2.duration = Number(param1["duration"]) / param3;
         param2.action = param1["action"];
         param2.event = param1["event"];
         param2.sound = param1["sound"];
      }
      
      private static function parseMainFrame(param1:Object, param2:uint) : Frame
      {
         var _loc3_:Frame = new Frame();
         parseFrame(param1,_loc3_,param2);
         return _loc3_;
      }
      
      private static function parseTransformFrame(param1:Object, param2:uint) : TransformFrame
      {
         var _loc5_:* = undefined;
         var _loc3_:TransformFrame = new TransformFrame();
         parseFrame(param1,_loc3_,param2);
         _loc3_.visible = uint(param1["hide"]) != 1;
         if("tweenEasing" in param1)
         {
            _loc5_ = param1["tweenEasing"];
            if(_loc5_ == undefined || _loc5_ == null)
            {
               _loc3_.tweenEasing = NaN;
            }
            else
            {
               _loc3_.tweenEasing = Number(_loc5_);
            }
         }
         else
         {
            _loc3_.tweenEasing = 0;
         }
         _loc3_.tweenRotate = Number(param1["tweenRotate"]);
         _loc3_.displayIndex = Number(param1["displayIndex"]);
         _loc3_.zOrder = Number(param1["z"]);
         parseTransform(param1["transform"],_loc3_.global,_loc3_.pivot);
         _loc3_.transform.copy(_loc3_.global);
         var _loc4_:Object = param1["colorTransform"];
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
      
      private static function parseTransform(param1:Object, param2:DBTransform, param3:Point = null) : void
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

