package dragonBones.objects
{
   public final class ArmatureData
   {
      
      public var name:String;
      
      private var _boneDataList:Vector.<BoneData>;
      
      private var _skinDataList:Vector.<SkinData>;
      
      private var _animationDataList:Vector.<AnimationData>;
      
      public function ArmatureData()
      {
         super();
         _boneDataList = new Vector.<BoneData>(0,true);
         _skinDataList = new Vector.<SkinData>(0,true);
         _animationDataList = new Vector.<AnimationData>(0,true);
      }
      
      public function get boneDataList() : Vector.<BoneData>
      {
         return _boneDataList;
      }
      
      public function get skinDataList() : Vector.<SkinData>
      {
         return _skinDataList;
      }
      
      public function get animationDataList() : Vector.<AnimationData>
      {
         return _animationDataList;
      }
      
      public function dispose() : void
      {
         var _loc1_:int = int(_boneDataList.length);
         while(_loc1_--)
         {
            _boneDataList[_loc1_].dispose();
         }
         _loc1_ = int(_skinDataList.length);
         while(_loc1_--)
         {
            _skinDataList[_loc1_].dispose();
         }
         _loc1_ = int(_animationDataList.length);
         while(_loc1_--)
         {
            _animationDataList[_loc1_].dispose();
         }
         _boneDataList.fixed = false;
         _boneDataList.length = 0;
         _skinDataList.fixed = false;
         _skinDataList.length = 0;
         _animationDataList.fixed = false;
         _animationDataList.length = 0;
         _boneDataList = null;
         _skinDataList = null;
         _animationDataList = null;
      }
      
      public function getBoneData(param1:String) : BoneData
      {
         var _loc2_:int = int(_boneDataList.length);
         while(_loc2_--)
         {
            if(_boneDataList[_loc2_].name == param1)
            {
               return _boneDataList[_loc2_];
            }
         }
         return null;
      }
      
      public function getSkinData(param1:String) : SkinData
      {
         if(!param1)
         {
            return _skinDataList[0];
         }
         var _loc2_:int = int(_skinDataList.length);
         while(_loc2_--)
         {
            if(_skinDataList[_loc2_].name == param1)
            {
               return _skinDataList[_loc2_];
            }
         }
         return null;
      }
      
      public function getAnimationData(param1:String) : AnimationData
      {
         var _loc2_:int = int(_animationDataList.length);
         while(_loc2_--)
         {
            if(_animationDataList[_loc2_].name == param1)
            {
               return _animationDataList[_loc2_];
            }
         }
         return null;
      }
      
      public function addBoneData(param1:BoneData) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         if(_boneDataList.indexOf(param1) < 0)
         {
            _boneDataList.fixed = false;
            _boneDataList[_boneDataList.length] = param1;
            _boneDataList.fixed = true;
            return;
         }
         throw new ArgumentError();
      }
      
      public function addSkinData(param1:SkinData) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         if(_skinDataList.indexOf(param1) < 0)
         {
            _skinDataList.fixed = false;
            _skinDataList[_skinDataList.length] = param1;
            _skinDataList.fixed = true;
            return;
         }
         throw new ArgumentError();
      }
      
      public function addAnimationData(param1:AnimationData) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         if(_animationDataList.indexOf(param1) < 0)
         {
            _animationDataList.fixed = false;
            _animationDataList[_animationDataList.length] = param1;
            _animationDataList.fixed = true;
         }
      }
      
      public function sortBoneDataList() : void
      {
         var _loc4_:BoneData = null;
         var _loc1_:int = 0;
         var _loc3_:* = null;
         var _loc5_:int = int(_boneDataList.length);
         if(_loc5_ == 0)
         {
            return;
         }
         var _loc2_:Array = [];
         while(_loc5_--)
         {
            _loc4_ = _boneDataList[_loc5_];
            _loc1_ = 0;
            _loc3_ = _loc4_;
            while(_loc3_ && _loc3_.parent)
            {
               _loc1_++;
               _loc3_ = getBoneData(_loc3_.parent);
            }
            _loc2_[_loc5_] = {
               "level":_loc1_,
               "boneData":_loc4_
            };
         }
         _loc2_.sortOn("level",16);
         _loc5_ = int(_loc2_.length);
         while(_loc5_--)
         {
            _boneDataList[_loc5_] = _loc2_[_loc5_].boneData;
         }
      }
   }
}

