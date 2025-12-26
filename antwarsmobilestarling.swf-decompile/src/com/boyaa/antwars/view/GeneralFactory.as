package com.boyaa.antwars.view
{
   import dragonBones.Armature;
   import dragonBones.factorys.StarlingFactory;
   import dragonBones.objects.SkeletonData;
   import starling.display.Image;
   
   public class GeneralFactory
   {
      
      private static var _instance:GeneralFactory = null;
      
      private var _factory:StarlingFactory;
      
      public function GeneralFactory(param1:Single)
      {
         super();
         _factory = new StarlingFactory();
      }
      
      public static function get instance() : GeneralFactory
      {
         if(!_instance)
         {
            _instance = new GeneralFactory(new Single());
         }
         return _instance;
      }
      
      public function addSkeletonByData(param1:SkeletonData) : void
      {
         _factory.addSkeletonData(param1);
      }
      
      public function addBoneAtalsByObject(param1:Object) : void
      {
         _factory.addTextureAtlas(param1);
      }
      
      public function buildArmature(param1:String) : Armature
      {
         return _factory.buildArmature(param1);
      }
      
      public function isSkeletonExist(param1:String) : Boolean
      {
         if(_factory.getSkeletonData(param1))
         {
            return true;
         }
         return false;
      }
      
      public function isBoneAltasExist(param1:String) : Boolean
      {
         if(_factory.getTextureAtlas(param1))
         {
            return true;
         }
         return false;
      }
      
      public function getTextureDisplay(param1:String, param2:String = null) : Image
      {
         var _loc3_:Image = _factory.getTextureDisplay(param1,param2) as Image;
         if(!_loc3_)
         {
            throw new Error("getTextureDisplay cann\'t find image...[name]",param1);
         }
         _loc3_.width /= Assets.sAsset.scaleFactor;
         _loc3_.height /= Assets.sAsset.scaleFactor;
         return _loc3_;
      }
      
      public function removeSkeletonAndAtlas(param1:String) : void
      {
         removeBoneAtlas(param1);
         removeSkeleton(param1);
      }
      
      public function removeSkeleton(param1:String) : void
      {
         _factory.getSkeletonData(param1) && _factory.removeSkeletonData(param1);
      }
      
      public function removeBoneAtlas(param1:String) : void
      {
         _factory.getTextureAtlas(param1) && _factory.removeTextureAtlas(param1);
      }
      
      public function removeAllSkeletonANdBonesData() : void
      {
         for each(var _loc1_ in Constants.SkelotonDataNameArr)
         {
            _factory.getSkeletonData(_loc1_) && _factory.removeSkeletonData(_loc1_);
            _factory.getTextureAtlas(_loc1_) && _factory.removeTextureAtlas(_loc1_);
         }
      }
      
      public function dispose() : void
      {
         _factory.dispose();
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
