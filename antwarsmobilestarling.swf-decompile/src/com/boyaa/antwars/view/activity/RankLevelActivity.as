package com.boyaa.antwars.view.activity
{
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.model.ServerData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.debug.Logging.LevelLogger;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.display.Button;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class RankLevelActivity extends ActivityBase
   {
      
      private var _buttonAssetArr:Array = [];
      
      private var _fightBtn:Button;
      
      private var _levelBtn:Button;
      
      private var _rankList:Sprite;
      
      private var _rankListTitleArr:Array = [];
      
      private var _list:List;
      
      private var _levelData:Array;
      
      private var _fightData:Array;
      
      public function RankLevelActivity()
      {
         super();
      }
      
      override protected function initLoadAsset() : void
      {
         super.initLoadAsset();
         _assetArr = ["asset/rankActivity.info","textures/{0}x/ACTIVITY/rankActivity.png","textures/{0}x/ACTIVITY/rankActivity.xml"];
         _layoutInfoName = "rankActivity";
         _layoutName = "rankListLayout";
      }
      
      override protected function init() : void
      {
         var _loc4_:int = 0;
         var _loc2_:Button = null;
         super.init();
         _rankList = getDisplayObjectByName("rankList") as Sprite;
         _fightBtn = getDisplayObjectByName("btnS_fightNum") as Button;
         _levelBtn = getDisplayObjectByName("btnS_level") as Button;
         var _loc3_:Array = [_fightBtn,_levelBtn];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc4_];
            _buttonAssetArr.push([_loc2_,_loc2_.upState,_loc2_.downState]);
            _loc2_.addEventListener("triggered",onBtnTouchHandle);
            _loc4_++;
         }
         var _loc1_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < 30)
         {
            _loc1_.push([_loc4_ + 1,"name" + _loc4_,"level" + _loc4_]);
            _loc4_++;
         }
         _list = new List();
         _list.itemRendererType = RankRender;
         _rankList.addChild(_list);
         SmallCodeTools.instance.setDisplayObjectInSame(_rankList.getChildByName("list"),_list);
         _rankListTitleArr = LangManager.getLang.getLangArray("rankActivityTipArr");
         _fightBtn.upState = _fightBtn.downState;
         showFightLayout();
         initServer();
      }
      
      private function onBtnTouchHandle(param1:Event) : void
      {
         if(Button(param1.currentTarget).upState == Button(param1.currentTarget).downState)
         {
            return;
         }
         resetButtons();
         Button(param1.currentTarget).upState = Button(param1.currentTarget).downState;
         switch(Button(param1.currentTarget).name)
         {
            case "btnS_fightNum":
               showFightLayout();
               break;
            case "btnS_level":
               showLevelLayout();
         }
      }
      
      private function showFightLayout() : void
      {
         TextField(_rankList.getChildByName("bold_title2")).text = _rankListTitleArr[2];
         _list.dataProvider = new ListCollection(_fightData);
      }
      
      private function showLevelLayout() : void
      {
         TextField(_rankList.getChildByName("bold_title2")).text = _rankListTitleArr[3];
         _list.dataProvider = new ListCollection(_levelData);
      }
      
      private function resetButtons() : void
      {
         var _loc1_:Button = null;
         var _loc3_:int = 0;
         var _loc2_:Array = null;
         _loc3_ = 0;
         while(_loc3_ < _buttonAssetArr.length)
         {
            _loc2_ = _buttonAssetArr[_loc3_];
            _loc1_ = _loc2_[0];
            _loc1_.upState = _loc2_[1];
            _loc1_.downState = _loc2_[2];
            _loc3_++;
         }
      }
      
      private function initServer() : void
      {
         if(BattleServer.instance.isConnect)
         {
            return;
         }
         GameServer.instance.getServerIDByType(1,function(param1:Object):void
         {
            var serData:ServerData;
            var data:Object = param1;
            LevelLogger.getLogger("RankListScreen").info(JSON.stringify(data));
            if(data.ret == 0)
            {
               serData = AllRoomData.instance.getDataByID(data.svid);
               BattleServer.instance.init(serData.ip,serData.port);
               BattleServer.instance.connect();
               BattleServer.instance.login(function(param1:Object):void
               {
                  LevelLogger.getLogger("BtRoom").info(JSON.stringify(param1));
                  if(param1.ret == 1)
                  {
                     return;
                  }
                  BattleServer.instance.getRankActivityFightData(onFightData);
                  BattleServer.instance.getRankActivityLevelData(onLevelData);
               });
            }
         });
      }
      
      private function onLevelData(param1:Object) : void
      {
         Application.instance.log("onLevelData",JSON.stringify(param1));
         _levelData = param1.data.dataArr;
      }
      
      private function onFightData(param1:Object) : void
      {
         Application.instance.log("onFightData",JSON.stringify(param1));
         _fightData = param1.data.dataArr;
         showFightLayout();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         BattleServer.instance.close();
      }
   }
}

import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import starling.display.Image;
import starling.text.TextField;

class RankRender extends ListItemRenderer
{
   
   private var _layout:LayoutUitl;
   
   private var _txtArr:Array = [];
   
   public function RankRender()
   {
      super();
   }
   
   override protected function initialize() : void
   {
      var _loc2_:int = 0;
      var _loc1_:TextField = null;
      super.initialize();
      this.bgFocusTexture = Assets.emptyTexture();
      this.bgNormalTexture = Assets.emptyTexture();
      this.bg = new Image(Assets.emptyTexture());
      this.bg.width = 620;
      this.bg.height = 30;
      addChild(bg);
      _layout = new LayoutUitl(Assets.sAsset.getOther("rankActivity"),Assets.sAsset);
      _layout.buildLayout("rankItemLayout",this);
      _loc2_ = 0;
      while(_loc2_ < 3)
      {
         _loc1_ = this.getChildByName("title" + _loc2_) as TextField;
         _txtArr.push(_loc1_);
         _loc2_++;
      }
   }
   
   override protected function commitData() : void
   {
      var _loc2_:int = 0;
      super.commitData();
      var _loc1_:Array = this._data as Array;
      _loc2_ = 0;
      while(_loc2_ < _txtArr.length)
      {
         _txtArr[_loc2_].text = _loc1_[_loc2_];
         _loc2_++;
      }
   }
}
