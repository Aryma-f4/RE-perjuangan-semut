package com.boyaa.antwars.data.model
{
   import com.boyaa.antwars.data.RLGSDataList;
   import com.boyaa.antwars.data.ShopDataList;
   
   public class SuitData
   {
      
      public var id:int = 0;
      
      public var name:String = "";
      
      public var dec:String = "";
      
      public var skill:int = 0;
      
      public var type:int = 1;
      
      private var _suitContents:Array;
      
      private var _suitattributes:Array;
      
      public function SuitData()
      {
         super();
         _suitContents = [];
         _suitattributes = [];
      }
      
      public function isSuit(param1:int, param2:int) : Array
      {
         var _loc6_:int = 0;
         var _loc3_:Array = null;
         var _loc5_:Array = null;
         var _loc4_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < _suitContents.length)
         {
            _loc3_ = _suitContents[_loc6_];
            _loc5_ = RLGSDataList.instance.matchsuit(param1,param2);
            if(_loc5_[0] == _loc3_[1] && _loc5_[1] == _loc3_[2])
            {
               if(_loc4_.length == 0)
               {
                  _loc4_.push(id);
               }
               _loc4_.push(_loc3_[0]);
            }
            _loc6_++;
         }
         if(_loc4_.length)
         {
            return _loc4_;
         }
         return null;
      }
      
      public function getAttribute(param1:int) : Array
      {
         var _loc3_:int = 0;
         var _loc2_:Array = [0,0,0,0,0,0,0];
         _loc3_ = 0;
         while(_loc3_ < _suitattributes.length)
         {
            if(_suitattributes[_loc3_][0] > param1)
            {
               break;
            }
            switch(_suitattributes[_loc3_][1])
            {
               case 106:
                  var _loc4_:* = 4;
                  var _loc5_:* = _loc2_[_loc4_] + _suitattributes[_loc3_][2];
                  _loc2_[_loc4_] = _loc5_;
                  break;
               case 105:
                  _loc5_ = 5;
                  _loc4_ = _loc2_[_loc5_] + _suitattributes[_loc3_][2];
                  _loc2_[_loc5_] = _loc4_;
                  break;
               case 102:
                  _loc4_ = 0;
                  _loc5_ = _loc2_[_loc4_] + _suitattributes[_loc3_][2];
                  _loc2_[_loc4_] = _loc5_;
                  break;
               case 101:
                  _loc5_ = 1;
                  _loc4_ = _loc2_[_loc5_] + _suitattributes[_loc3_][2];
                  _loc2_[_loc5_] = _loc4_;
                  break;
               case 103:
                  _loc4_ = 2;
                  _loc5_ = _loc2_[_loc4_] + _suitattributes[_loc3_][2];
                  _loc2_[_loc4_] = _loc5_;
                  break;
               case 104:
                  _loc5_ = 3;
                  _loc4_ = _loc2_[_loc5_] + _suitattributes[_loc3_][2];
                  _loc2_[_loc5_] = _loc4_;
            }
            _loc3_++;
         }
         if(param1 >= _suitContents.length)
         {
            if(skill != 0)
            {
               _loc2_[6] = skill;
            }
         }
         return _loc2_;
      }
      
      public function updateForData(param1:XML) : void
      {
         id = int(param1["stid"]);
         name = param1["stname"];
         dec = param1["stdesc"];
         skill = int(param1["skid1"]);
         if(param1.hasOwnProperty("suitattributes"))
         {
            updateAttributes(param1.suitattributes[0]);
         }
         if(param1.hasOwnProperty("suitcontents"))
         {
            updateSuitcontents(param1.suitcontents[0]);
         }
         type = param1["sttype"];
      }
      
      private function updateSuitcontents(param1:XML) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = null;
         _loc3_ = 0;
         while(_loc3_ < param1.suitcontent.length())
         {
            _loc2_ = [];
            _loc2_[0] = int(param1.suitcontent[_loc3_]["position"]);
            _loc2_[1] = int(param1.suitcontent[_loc3_]["pcate"]);
            _loc2_[2] = int(param1.suitcontent[_loc3_]["pframe"]);
            ShopDataList.instance.getSingleData(_loc2_[1],_loc2_[2]).isSuit = true;
            _suitContents.push(_loc2_);
            _loc3_++;
         }
      }
      
      private function updateAttributes(param1:XML) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = null;
         _loc3_ = 0;
         while(_loc3_ < param1.suitattribute.length())
         {
            _loc2_ = [];
            _loc2_[0] = int(param1.suitattribute[_loc3_]["num"]);
            _loc2_[1] = int(param1.suitattribute[_loc3_]["atid"]);
            _loc2_[2] = int(param1.suitattribute[_loc3_]["value"]);
            _suitattributes.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function get suitattributes() : Array
      {
         return _suitattributes;
      }
      
      public function get suitContents() : Array
      {
         return _suitContents;
      }
   }
}

