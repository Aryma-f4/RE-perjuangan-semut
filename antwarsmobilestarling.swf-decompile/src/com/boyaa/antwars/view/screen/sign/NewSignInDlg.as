package com.boyaa.antwars.view.screen.sign
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.activity.ActivityBase;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.layout.TiledRowsLayout;
   import org.osflash.signals.Signal;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class NewSignInDlg extends ActivityBase
   {
      
      public static var canSignDay:int;
      
      public static var SIGN_RECORD:String;
      
      public var signedSignal:Signal;
      
      private var signNumberSum:uint = 0;
      
      private var txt_dayNum:TextField;
      
      private var listData:Array;
      
      private var list:List;
      
      private var vipRewardSprite:Sprite;
      
      private var rewardSprite:Sprite;
      
      private var vipLevel:int;
      
      private var selectedItem:Object;
      
      public function NewSignInDlg(param1:Boolean = true)
      {
         super();
      }
      
      override protected function initLoadAsset() : void
      {
         super.initLoadAsset();
         _assetArr = ["asset/signIn.info","textures/{0}x/OTHER/signIn.png","textures/{0}x/OTHER/signIn.xml"];
         _layoutInfoName = "signIn";
         _layoutName = "SignInMainLayout";
         signedSignal = new Signal();
      }
      
      override protected function init() : void
      {
         super.init();
         txt_dayNum = getTextFieldByName("txt_dayNum");
         vipLevel = PlayerDataList.instance.selfData.vipLevel;
         initList();
         onGetSignInfo(PlayerDataList.instance.selfData.signData);
      }
      
      private function onGetSignInfo(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc6_:int = 0;
         var _loc2_:* = param1;
         if(_loc2_)
         {
            SIGN_RECORD = _loc2_[0];
            _loc3_ = String(_loc2_[0]);
            _loc4_ = _loc3_.split("");
            _loc5_ = uint(_loc3_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(_loc3_.charAt(_loc6_) != "0")
               {
                  signNumberSum = signNumberSum + 1;
               }
               _loc6_++;
            }
            if(signNumberSum >= 30)
            {
               signNumberSum = 0;
            }
            txt_dayNum.text = signNumberSum.toString();
            if(_loc2_[4])
            {
               listData = _loc2_[4];
               list.dataProvider = new ListCollection(listData);
            }
            if(PlayerDataList.instance.selfData.isSigned == false)
            {
               canSignDay = SIGN_RECORD.indexOf("0");
            }
            else
            {
               canSignDay = -1;
            }
         }
         else
         {
            trace("查询签到信息失败!");
         }
      }
      
      private function initList() : void
      {
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.useSquareTiles = false;
         _loc1_.gap = 5;
         _loc1_.paddingTop = 5;
         list = new List();
         list.itemRendererType = SignInDayItemRender;
         list.layout = _loc1_;
         list.addEventListener("change",onListChangeHandler);
         _displayObj.addChild(list);
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjByName("pos_list"),list);
      }
      
      private function onListChangeHandler(param1:Event) : void
      {
         var _loc2_:RewardsDlg = null;
         var _loc3_:List = List(param1.currentTarget);
         if(_loc3_.selectedIndex == -1)
         {
            return;
         }
         selectedItem = _loc3_.selectedItem;
         if(SIGN_RECORD.charAt(selectedItem.days - 1) == "1")
         {
            return;
         }
         if(PlayerDataList.instance.selfData.isSigned == false)
         {
            if(NewSignInDlg.canSignDay == selectedItem.days - 1)
            {
               Remoting.instance.getNSignRewards(onGetRewards);
               _loc2_ = new RewardsDlg(selectedItem,vipLevel);
               stage.addChild(_loc2_);
            }
         }
         else
         {
            TextTip.instance.show(LangManager.t("hasSigned"));
         }
      }
      
      private function onGetRewards(param1:Object) : void
      {
         var _loc2_:Array = null;
         Application.instance.log("领取奖励onGetRewards",JSON.stringify(param1));
         if(param1.ret == 0)
         {
            list.dataProvider = null;
            _loc2_ = param1.data as Array;
            if(_loc2_)
            {
               PlayerDataList.instance.selfData.signData[0] = _loc2_[0];
               PlayerDataList.instance.selfData.signData[1] = _loc2_[1];
               PlayerDataList.instance.selfData.signData[2] = _loc2_[2];
               PlayerDataList.instance.selfData.signData[3] = _loc2_[3];
               SIGN_RECORD = _loc2_[0];
               signNumberSum = signNumberSum + 1;
               txt_dayNum.text = signNumberSum.toString();
               list.dataProvider = new ListCollection(listData);
               if(selectedItem.reward_type == 1)
               {
                  AccountData.instance.gameGold += selectedItem.count;
               }
               else if(selectedItem.reward_type == 2)
               {
                  AccountData.instance.boyaaCoin += selectedItem.count;
               }
               if(_loc2_[1] == _loc2_[2])
               {
                  PlayerDataList.instance.selfData.isSigned = true;
                  canSignDay = -1;
               }
               else
               {
                  PlayerDataList.instance.selfData.isSigned = false;
               }
               if(param1.prop)
               {
                  GoodsList.instance.addGoodsByAry(param1.prop);
               }
               signedSignal.dispatch();
               TextTip.instance.show(LangManager.t("ljcg"));
               if(_loc2_[0].indexOf("0") == -1)
               {
                  Remoting.instance.resetSignRecord(reset);
               }
            }
         }
         else
         {
            trace("error:" + param1.ret);
            TextTip.instance.show(LangManager.t("ljsb") + param1.ret);
         }
      }
      
      private function reset(param1:Object) : void
      {
         if(param1.ret == 0)
         {
            PlayerDataList.instance.selfData.signData = param1.data as Array;
            TextTip.instance.show("reset sign record success");
            onGetSignInfo(PlayerDataList.instance.selfData.signData);
         }
         else
         {
            TextTip.instance.show(param1.ret);
         }
      }
   }
}

