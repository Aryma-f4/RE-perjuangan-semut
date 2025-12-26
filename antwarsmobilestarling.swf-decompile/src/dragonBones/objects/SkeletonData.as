package dragonBones.objects
{
   import flash.geom.Point;
   
   public class SkeletonData
   {
      
      public var name:String;
      
      private var _subTexturePivots:Object;
      
      private var _armatureDataList:Vector.<ArmatureData>;
      
      public function SkeletonData()
      {
         super();
         _armatureDataList = new Vector.<ArmatureData>(0,true);
         _subTexturePivots = {};
      }
      
      public function get armatureNames() : Vector.<String>
      {
         var _loc1_:Vector.<String> = new Vector.<String>();
         for each(var _loc2_ in _armatureDataList)
         {
            _loc1_[_loc1_.length] = _loc2_.name;
         }
         return _loc1_;
      }
      
      public function get armatureDataList() : Vector.<ArmatureData>
      {
         return _armatureDataList;
      }
      
      public function dispose() : void
      {
         for each(var _loc1_ in _armatureDataList)
         {
            _loc1_.dispose();
         }
         _armatureDataList.fixed = false;
         _armatureDataList.length = 0;
         _armatureDataList = null;
         _subTexturePivots = null;
      }
      
      public function getArmatureData(param1:String) : ArmatureData
      {
         var _loc2_:int = int(_armatureDataList.length);
         while(_loc2_--)
         {
            if(_armatureDataList[_loc2_].name == param1)
            {
               return _armatureDataList[_loc2_];
            }
         }
         return null;
      }
      
      public function addArmatureData(param1:ArmatureData) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         if(_armatureDataList.indexOf(param1) < 0)
         {
            _armatureDataList.fixed = false;
            _armatureDataList[_armatureDataList.length] = param1;
            _armatureDataList.fixed = true;
            return;
         }
         throw new ArgumentError();
      }
      
      public function removeArmatureData(param1:ArmatureData) : void
      {
         var _loc2_:int = int(_armatureDataList.indexOf(param1));
         if(_loc2_ >= 0)
         {
            _armatureDataList.fixed = false;
            _armatureDataList.splice(_loc2_,1);
            _armatureDataList.fixed = true;
         }
      }
      
      public function removeArmatureDataByName(param1:String) : void
      {
         var _loc2_:int = int(_armatureDataList.length);
         while(_loc2_--)
         {
            if(_armatureDataList[_loc2_].name == param1)
            {
               _armatureDataList.fixed = false;
               _armatureDataList.splice(_loc2_,1);
               _armatureDataList.fixed = true;
            }
         }
      }
      
      public function getSubTexturePivot(param1:String) : Point
      {
         return _subTexturePivots[param1];
      }
      
      public function addSubTexturePivot(param1:Number, param2:Number, param3:String) : Point
      {
         var _loc4_:Point = _subTexturePivots[param3];
         if(_loc4_)
         {
            _loc4_.x = param1;
            _loc4_.y = param2;
         }
         else
         {
            _subTexturePivots[param3] = _loc4_ = new Point(param1,param2);
         }
         return _loc4_;
      }
      
      public function removeSubTexturePivot(param1:String) : void
      {
         if(param1)
         {
            delete _subTexturePivots[param1];
         }
         else
         {
            for(param1 in _subTexturePivots)
            {
               delete _subTexturePivots[param1];
            }
         }
      }
   }
}

