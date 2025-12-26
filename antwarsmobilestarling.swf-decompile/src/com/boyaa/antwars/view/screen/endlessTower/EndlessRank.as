package com.boyaa.antwars.view.screen.endlessTower
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.CopyServer;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class EndlessRank
   {
      
      private var _view:Sprite;
      
      private var _backBtn:Button;
      
      private var _list:List;
      
      private var _listProviderData:ListCollection;
      
      private var _rankData:Array;
      
      public function EndlessRank(param1:Sprite)
      {
         super();
         _view = param1;
         CopyServer.instance.onEndlessRankList(onGetData);
         CopyServer.instance.getEndlessRankList();
      }
      
      private function onGetData(param1:Object) : void
      {
         Application.instance.log("EndlessRank",JSON.stringify(param1));
         _rankData = param1.data.playerArr;
         init();
      }
      
      private function init() : void
      {
         var _loc8_:int = 0;
         var _loc7_:SingleEndlessRankData = null;
         var _loc4_:int = 0;
         var _loc5_:TextField = null;
         _backBtn = StarlingUITools.instance.initStarlingButton(_view,"btnS_back",onBackHandle);
         _list = new List();
         _list.setSize(820,455);
         var _loc3_:Array = [];
         var _loc2_:Array = [];
         _loc8_ = 0;
         while(_loc8_ < _rankData.length)
         {
            _loc2_ = _rankData[_loc8_];
            _loc7_ = new SingleEndlessRankData(_loc2_[0],_loc2_[1],_loc2_[2],_loc2_[3],_loc2_[4]);
            _loc3_.push(_loc7_);
            _loc8_++;
         }
         _listProviderData = new ListCollection(_loc3_);
         _list.dataProvider = _listProviderData;
         _list.itemRendererType = EndlessRankRender;
         var _loc1_:DisplayObject = _view.getChildByName("rankList");
         SmallCodeTools.instance.setDisplayObjectInSamePos(_loc1_,_list);
         var _loc6_:Array = LangManager.getLang.getLangArray("endless_rank_titleArr");
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            _loc5_ = _view.getChildByName("title" + _loc4_) as TextField;
            _loc5_.text = _loc6_[_loc4_];
            _loc4_++;
         }
         _view.addChild(_list);
      }
      
      private function onBackHandle(param1:Event) : void
      {
         CopyServer.instance.disposeRecvFun(onGetData);
         param1.target.removeEventListener(param1.type,arguments.callee);
         _list.dispose();
         _view.removeFromParent(true);
      }
   }
}

