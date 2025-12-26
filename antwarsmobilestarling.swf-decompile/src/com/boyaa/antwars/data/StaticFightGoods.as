package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.FightGoodsData;
   import com.boyaa.antwars.lang.LangManager;
   
   public class StaticFightGoods
   {
      
      private var _list:Vector.<FightGoodsData>;
      
      public function StaticFightGoods()
      {
         super();
         _list = new Vector.<FightGoodsData>();
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_gjk2")[0],LangManager.getLang.getLangArray("fightGoodsInfo_gjk2")[1],0,110,0,1]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_gjk1")[0],LangManager.getLang.getLangArray("fightGoodsInfo_gjk1")[1],0,110,1,1]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_ddtk")[0],LangManager.getLang.getLangArray("fightGoodsInfo_ddtk")[1],0,110,2,1]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_jck5")[0],LangManager.getLang.getLangArray("fightGoodsInfo_jck5")[1],0,85,3,1]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_jck4")[0],LangManager.getLang.getLangArray("fightGoodsInfo_jck4")[1],0,80,5,1]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_jck3")[0],LangManager.getLang.getLangArray("fightGoodsInfo_jck3")[1],0,70,6,1]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_jck2")[0],LangManager.getLang.getLangArray("fightGoodsInfo_jck2")[1],0,55,7,1]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_jck1")[0],LangManager.getLang.getLangArray("fightGoodsInfo_jck1")[1],0,50,8,1]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_csk")[0],LangManager.getLang.getLangArray("fightGoodsInfo_csk")[1],20,150,10,2]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_smhfk")[0],LangManager.getLang.getLangArray("fightGoodsInfo_smhfk")[1],30,150,11,2]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_tdhf")[0],LangManager.getLang.getLangArray("fightGoodsInfo_tdhf")[1],40,170,12,2]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_ltk")[0],LangManager.getLang.getLangArray("fightGoodsInfo_ltk")[1],20,100,15,2]);
         addData([LangManager.getLang.getLangArray("fightGoodsInfo_csk")[0],LangManager.getLang.getLangArray("fightGoodsInfo_csk")[1],20,150,4,3]);
         addData(["释放怒气","释放怒气",0,0,99,3]);
         addData(["复活","复活",0,0,50,3]);
         addData(["自动战斗","自动战斗",0,0,51,3]);
      }
      
      private function addData(param1:Array) : void
      {
         var _loc2_:FightGoodsData = new FightGoodsData();
         _loc2_.readData(param1);
         _list.push(_loc2_);
      }
      
      public function getDataByID(param1:int) : FightGoodsData
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            if(_list[_loc2_].frame == param1)
            {
               return _list[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getPriceByFrame(param1:int) : int
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            if(_list[_loc2_].frame == param1)
            {
               return _list[_loc2_].price;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function getListByType(param1:int) : Vector.<FightGoodsData>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<FightGoodsData> = new Vector.<FightGoodsData>();
         _loc3_ = 0;
         while(_loc3_ < _list.length)
         {
            if(_list[_loc3_].type == param1)
            {
               _loc2_.push(_list[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

