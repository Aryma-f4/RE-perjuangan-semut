package dragonBones.factorys
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.Slot;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.objects.ArmatureData;
   import dragonBones.objects.BoneData;
   import dragonBones.objects.DataParser;
   import dragonBones.objects.DecompressedData;
   import dragonBones.objects.DisplayData;
   import dragonBones.objects.SkeletonData;
   import dragonBones.objects.SkinData;
   import dragonBones.objects.SlotData;
   import dragonBones.textures.ITextureAtlas;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   use namespace dragonBones_internal;
   
   public class BaseFactory extends EventDispatcher
   {
      
      protected static const _helpMatirx:Matrix = new Matrix();
      
      private static const _loaderContext:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
      
      protected var _dataDic:Object;
      
      protected var _textureAtlasDic:Object;
      
      protected var _textureAtlasLoadingDic:Object;
      
      protected var _currentDataName:String;
      
      protected var _currentTextureAtlasName:String;
      
      public function BaseFactory(param1:BaseFactory)
      {
         super(this);
         if(param1 != this)
         {
            throw new IllegalOperationError("Abstract class can not be instantiated!");
         }
         _dataDic = {};
         _textureAtlasDic = {};
         _textureAtlasLoadingDic = {};
         _loaderContext.allowCodeImport = true;
      }
      
      public function parseData(param1:ByteArray, param2:String = null) : SkeletonData
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         var _loc5_:DecompressedData = DataParser.decompressData(param1);
         var _loc4_:SkeletonData = DataParser.parseData(_loc5_.dragonBonesData);
         param2 ||= _loc4_.name;
         addSkeletonData(_loc4_,param2);
         var _loc3_:Loader = new Loader();
         _loc3_.name = param2;
         _textureAtlasLoadingDic[param2] = _loc5_.textureAtlasData;
         _loc3_.contentLoaderInfo.addEventListener("complete",loaderCompleteHandler);
         _loc3_.loadBytes(_loc5_.textureBytes,_loaderContext);
         _loc5_.dispose();
         return _loc4_;
      }
      
      public function getSkeletonData(param1:String) : SkeletonData
      {
         return _dataDic[param1];
      }
      
      public function addSkeletonData(param1:SkeletonData, param2:String = null) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         param2 ||= param1.name;
         if(!param2)
         {
            throw new ArgumentError("Unnamed data!");
         }
         if(!_dataDic[param2])
         {
         }
         _dataDic[param2] = param1;
      }
      
      public function removeSkeletonData(param1:String) : void
      {
         delete _dataDic[param1];
      }
      
      public function getTextureAtlas(param1:String) : Object
      {
         return _textureAtlasDic[param1];
      }
      
      public function addTextureAtlas(param1:Object, param2:String = null) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         if(!param2 && param1 is ITextureAtlas)
         {
            param2 = param1.name;
         }
         if(!param2)
         {
            throw new ArgumentError("Unnamed data!");
         }
         if(!_textureAtlasDic[param2])
         {
         }
         _textureAtlasDic[param2] = param1;
      }
      
      public function removeTextureAtlas(param1:String) : void
      {
         delete _textureAtlasDic[param1];
      }
      
      public function dispose(param1:Boolean = true) : void
      {
         if(param1)
         {
            for each(var _loc3_ in _dataDic)
            {
               _loc3_.dispose();
            }
            for each(var _loc2_ in _textureAtlasDic)
            {
               _loc2_.dispose();
            }
         }
         _dataDic = null;
         _textureAtlasDic = null;
         _textureAtlasLoadingDic = null;
         _currentDataName = null;
         _currentTextureAtlasName = null;
      }
      
      public function buildArmature(param1:String, param2:String = null, param3:String = null, param4:String = null, param5:String = null) : Armature
      {
         var _loc8_:SkeletonData = null;
         var _loc18_:ArmatureData = null;
         var _loc13_:Bone = null;
         var _loc7_:ArmatureData = null;
         var _loc17_:Slot = null;
         var _loc16_:DisplayData = null;
         var _loc14_:Armature = null;
         var _loc10_:int = 0;
         if(param3)
         {
            _loc8_ = _dataDic[param3];
            if(_loc8_)
            {
               _loc18_ = _loc8_.getArmatureData(param1);
            }
         }
         else
         {
            for(param3 in _dataDic)
            {
               _loc8_ = _dataDic[param3];
               _loc18_ = _loc8_.getArmatureData(param1);
               if(_loc18_)
               {
                  break;
               }
            }
         }
         if(!_loc18_)
         {
            return null;
         }
         _currentDataName = param3;
         _currentTextureAtlasName = param4 || param3;
         var _loc11_:Armature = generateArmature();
         _loc11_.name = param1;
         for each(var _loc9_ in _loc18_.boneDataList)
         {
            _loc13_ = new Bone();
            _loc13_.name = _loc9_.name;
            _loc13_.origin.copy(_loc9_.transform);
            if(_loc18_.getBoneData(_loc9_.parent))
            {
               _loc11_.addBone(_loc13_,_loc9_.parent);
            }
            else
            {
               _loc11_.addBone(_loc13_);
            }
         }
         if(param2 && param2 != param1)
         {
            _loc7_ = _loc8_.getArmatureData(param2);
            if(!_loc7_)
            {
               for(param3 in _dataDic)
               {
                  _loc8_ = _dataDic[param3];
                  _loc7_ = _loc8_.getArmatureData(param2);
                  if(_loc7_)
                  {
                     break;
                  }
               }
            }
         }
         if(_loc7_)
         {
            _loc11_.animation.animationDataList = _loc7_.animationDataList;
         }
         else
         {
            _loc11_.animation.animationDataList = _loc18_.animationDataList;
         }
         var _loc15_:SkinData = _loc18_.getSkinData(param5);
         if(!_loc15_)
         {
            throw new ArgumentError();
         }
         var _loc12_:Array = [];
         for each(var _loc6_ in _loc15_.slotDataList)
         {
            _loc13_ = _loc11_.getBone(_loc6_.parent);
            if(_loc13_)
            {
               _loc17_ = generateSlot();
               _loc17_.name = _loc6_.name;
               _loc17_.dragonBones_internal::_originZOrder = _loc6_.zOrder;
               _loc17_.dragonBones_internal::_dislayDataList = _loc6_.displayDataList;
               _loc12_.length = 0;
               _loc10_ = int(_loc6_.displayDataList.length);
               while(_loc10_--)
               {
                  switch((_loc16_ = _loc6_.displayDataList[_loc10_]).type)
                  {
                     case "armature":
                        _loc14_ = buildArmature(_loc16_.name,null,_currentDataName,_currentTextureAtlasName);
                        if(_loc14_)
                        {
                           _loc12_[_loc10_] = _loc14_;
                        }
                        break;
                     case "image":
                        _loc12_[_loc10_] = generateDisplay(_textureAtlasDic[_currentTextureAtlasName],_loc16_.name,_loc16_.pivot.x,_loc16_.pivot.y);
                  }
               }
               _loc17_.displayList = _loc12_;
               _loc17_.dragonBones_internal::changeDisplay(0);
               _loc13_.addChild(_loc17_);
            }
         }
         _loc11_.dragonBones_internal::_slotsZOrderChanged = true;
         _loc11_.advanceTime(0);
         return _loc11_;
      }
      
      public function getTextureDisplay(param1:String, param2:String = null, param3:Number = NaN, param4:Number = NaN) : Object
      {
         var _loc6_:Object = null;
         var _loc7_:SkeletonData = null;
         var _loc5_:Point = null;
         if(param2)
         {
            _loc6_ = _textureAtlasDic[param2];
         }
         if(!_loc6_)
         {
            for(param2 in _textureAtlasDic)
            {
               _loc6_ = _textureAtlasDic[param2];
               if(_loc6_.getRegion(param1))
               {
                  break;
               }
               _loc6_ = null;
            }
         }
         if(_loc6_)
         {
            if(isNaN(param3) || isNaN(param4))
            {
               _loc7_ = _dataDic[param2];
               if(_loc7_)
               {
                  _loc5_ = _loc7_.getSubTexturePivot(param1);
                  if(_loc5_)
                  {
                     param3 = _loc5_.x;
                     param4 = _loc5_.y;
                  }
               }
            }
            return generateDisplay(_loc6_,param1,param3,param4);
         }
         return null;
      }
      
      protected function loaderCompleteHandler(param1:Event) : void
      {
         var _loc4_:Object = null;
         param1.target.removeEventListener("complete",loaderCompleteHandler);
         var _loc5_:Loader = param1.target.loader;
         var _loc2_:Object = param1.target.content;
         _loc5_.unloadAndStop();
         var _loc6_:String = _loc5_.name;
         var _loc3_:Object = _textureAtlasLoadingDic[_loc6_];
         delete _textureAtlasLoadingDic[_loc6_];
         if(_loc6_ && _loc3_)
         {
            if(_loc2_ is Bitmap)
            {
               _loc2_ = (_loc2_ as Bitmap).bitmapData;
            }
            else if(_loc2_ is Sprite)
            {
               _loc2_ = (_loc2_ as Sprite).getChildAt(0) as MovieClip;
            }
            _loc4_ = generateTextureAtlas(_loc2_,_loc3_);
            addTextureAtlas(_loc4_,_loc6_);
            _loc6_ = null;
            var _loc8_:int = 0;
            var _loc7_:Object = _textureAtlasLoadingDic;
            for(_loc6_ in _loc7_)
            {
            }
            if(!_loc6_ && this.hasEventListener("complete"))
            {
               this.dispatchEvent(new Event("complete"));
            }
         }
      }
      
      protected function generateTextureAtlas(param1:Object, param2:Object) : ITextureAtlas
      {
         return null;
      }
      
      protected function generateArmature() : Armature
      {
         return null;
      }
      
      protected function generateSlot() : Slot
      {
         return null;
      }
      
      protected function generateDisplay(param1:Object, param2:String, param3:Number, param4:Number) : Object
      {
         return null;
      }
   }
}

