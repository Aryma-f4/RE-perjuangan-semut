package com.boyaa.antwars.view.screen.unionBossFight
{
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.sound.HelpDlg;
   import com.boyaa.antwars.view.TextTip;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.display.Button;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class UnionBossRank
   {
      
      private var _view:Sprite;
      
      private var _list:List;
      
      private var _listProviderData:ListCollection;
      
      private var _isCanReward:Boolean = false;
      
      private var _myNum:int = 0;
      
      private var _rewardButton:FashionStarlingButton;
      
      public function UnionBossRank(param1:Sprite)
      {
         super();
         _view = param1;
         init();
      }
      
      private function bindNet() : void
      {
      }
      
      private function unBindNet() : void
      {
      }
      
      private function init() : void
      {
         bindNet();
         Button(_view.getChildByName("btnS_close")).addEventListener("triggered",onCloseRankSpriteHandle);
         Button(_view.getChildByName("btnS_reward")).addEventListener("triggered",onRankRewardHandle);
         Button(_view.getChildByName("helpBtn")).addEventListener("triggered",onHelpBtnHandle);
         Button(_view.getChildByName("rankBtn")).upState = Button(_view.getChildByName("rankBtn")).downState;
         _rewardButton = new FashionStarlingButton(Button(_view.getChildByName("btnS_reward")));
         _list = new List();
         _list.itemRendererType = UnionBossFightRankRender;
         SmallCodeTools.instance.setDisplayObjectInSame(_view.getChildByName("listPos"),_list);
         _view.addChild(_list);
      }
      
      public function updateDate() : void
      {
         CopyServer.instance.sendUnionFightRankList(onUnionRank);
      }
      
      private function onUnionRank(param1:Object) : void
      {
         Application.instance.log("UnionBossRank\'s onUnionRank",JSON.stringify(param1));
         var _loc2_:Array = param1.data.unionArr;
         _listProviderData = new ListCollection(_loc2_);
         _list.dataProvider = _listProviderData;
         TextField(_view.getChildByName("myUnionRankInfo")).text = LangManager.t("unionFightTip5");
         if(param1.data.isRank)
         {
            _myNum = param1.data.rankNum;
            TextField(_view.getChildByName("myUnionRank")).text = _myNum + "";
         }
         else
         {
            _myNum = 0;
            TextField(_view.getChildByName("myUnionRank")).text = LangManager.t("unionFightTip6");
         }
         _isCanReward = Boolean(param1.data.isReward);
         _rewardButton.isGray = !_isCanReward;
      }
      
      private function onHelpBtnHandle(param1:Event) : void
      {
         HelpDlg.show(LangManager.t("unionBOssRankHelp"));
      }
      
      private function onRankRewardHandle(param1:Event) : void
      {
         var e:Event = param1;
         var onGetReward:* = function(param1:Object):void
         {
            if(param1.data.flag != 1)
            {
               TextTip.instance.show(LangManager.getLang.getreplaceLang("unionFightTip2",param1.data.devote));
               UnionManager.getInstance().myUnionModel.cdevote = UnionManager.getInstance().myUnionModel.cdevote + param1.data.devote;
            }
            else
            {
               TextTip.instance.showByLang("unionFightTip4");
            }
         };
         if(!_isCanReward)
         {
            if(_myNum == 0)
            {
               TextTip.instance.showByLang("unionFightTip3");
            }
            else
            {
               TextTip.instance.showByLang("unionFightTip4");
            }
            return;
         }
         CopyServer.instance.sendUnionFightGetReward(onGetReward);
      }
      
      private function onCloseRankSpriteHandle(param1:Event) : void
      {
         _view.parent && _view.removeFromParent();
      }
   }
}

