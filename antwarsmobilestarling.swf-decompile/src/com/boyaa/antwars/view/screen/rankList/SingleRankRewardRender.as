package com.boyaa.antwars.view.screen.rankList
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.net.server.BattleServer;
   import starling.display.Image;
   import starling.events.Event;
   
   public class SingleRankRewardRender extends SingleRankRender
   {
      
      private var _rewardBtn:FashionStarlingButton;
      
      private var _rewardImg:Image;
      
      private var _time:uint;
      
      private var _rewardDoneIcon:Image;
      
      public function SingleRankRewardRender()
      {
         super();
         _layoutName = "rankListTwoItem";
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _rewardBtn = new FashionStarlingButton(getButtonByName("rewardBtn"));
         _rewardBtn.starlingBtn.visible = false;
         _rewardBtn.triggerFunction = onRewardBtnHandle;
         _rewardImg = new Image(Assets.sAsset.getTexture("img_rankListRewardFlag1"));
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("pos_win"),_rewardImg);
         _displayObject.addChild(_rewardImg);
         _rewardDoneIcon = getImageByName("rewardIcon");
         _rewardDoneIcon.visible = false;
         _fightNumTxt.visible = false;
      }
      
      private function onRewardBtnHandle(param1:Event) : void
      {
         trace("click");
         _rewardBtn.starlingBtn.visible = false;
         showRewadTexture();
         BattleServer.instance.getRankReward(PlayerDataList.instance.selfData.uid,int(_time));
      }
      
      private function showRewadTexture() : void
      {
         _rewardDoneIcon.visible = true;
         _rewardDoneIcon.touchable = false;
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         var _loc1_:SingleRankData = this._data as SingleRankData;
         _time = _loc1_.rank;
         _rankTxt.text = getData(_time);
         _nameTxt.text = _loc1_.playerName;
         if(_loc1_.isCanReward)
         {
            _rewardImg.texture = Assets.sAsset.getTexture("img_rankListRewardFlag1");
         }
         else
         {
            _rewardImg.texture = Assets.sAsset.getTexture("img_rankListRewardFlag2");
         }
         _playerUID = _loc1_.playerUID;
         _rewardBtn.starlingBtn.visible = !_loc1_.isReward;
         if(_loc1_.isReward)
         {
            showRewadTexture();
         }
      }
      
      private function getData(param1:uint) : String
      {
         var _loc2_:* = null;
         var _loc5_:Date = new Date();
         _loc5_.setTime(param1 * 1000);
         var _loc3_:int = _loc5_.getMonth() + 1;
         var _loc4_:int = int(_loc5_.getDate());
         return _loc4_ + "/" + _loc3_;
      }
   }
}

