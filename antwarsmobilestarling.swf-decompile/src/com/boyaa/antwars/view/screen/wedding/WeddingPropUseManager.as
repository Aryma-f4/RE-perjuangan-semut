package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.GoodsData;
   import flash.utils.Dictionary;
   
   public class WeddingPropUseManager
   {
      
      private static var _instance:WeddingPropUseManager = null;
      
      private var _dic:Dictionary = new Dictionary();
      
      public function WeddingPropUseManager(param1:Single)
      {
         super();
         init();
      }
      
      public static function get instance() : WeddingPropUseManager
      {
         if(_instance == null)
         {
            _instance = new WeddingPropUseManager(new Single());
         }
         return _instance;
      }
      
      private function init() : void
      {
         _dic[1071] = PopInputDlg;
         _dic[1081] = DivorceInputDlg;
      }
      
      public function showWeddingPopDlg(param1:int, param2:int) : void
      {
         if(param1 != 36)
         {
            return;
         }
         var _loc5_:GoodsData = GoodsList.instance.getGoodsById(param1,param2);
         if(!_loc5_)
         {
            return;
         }
         var _loc4_:Class = _dic[param2];
         var _loc3_:WeddingSmallDlgBase = new _loc4_(_loc5_);
         Application.instance.currentGame.addChild(_loc3_);
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
