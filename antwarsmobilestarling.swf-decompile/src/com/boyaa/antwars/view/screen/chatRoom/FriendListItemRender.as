package com.boyaa.antwars.view.screen.chatRoom
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.ui.LayoutListItemRender;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class FriendListItemRender extends LayoutListItemRender
   {
      
      private static var stateArr:Array = LangManager.getLang.getLangArray("marryStateArr");
      
      private var textAntId:TextField;
      
      private var textNickName:TextField;
      
      private var textLevel:TextField;
      
      private var textMarryState:TextField;
      
      private var _btBtn:FashionStarlingButton;
      
      private var _marryState:int;
      
      private var _marryImage:Image;
      
      private var _txtArr:Array = [];
      
      private const colorArr:Array = [160,16720529];
      
      public function FriendListItemRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         buildLayoutByName("FriendDlg","FriendItemLayout");
         textAntId = getTextFieldByName("playerId");
         textNickName = getTextFieldByName("playerName");
         textLevel = getTextFieldByName("level");
         _btBtn = new FashionStarlingButton(getButtonByName("btn"));
         textAntId.touchable = textNickName.touchable = textLevel.touchable = false;
         _txtArr.push(textAntId);
         _txtArr.push(textNickName);
         _txtArr.push(textLevel);
         _marryImage = new Image(Assets.sAsset.getTexture("img_friendMarryState1"));
         SmallCodeTools.instance.setDisplayObjectInSamePos(getDisplayObjectByName("pos_marry"),_marryImage);
         _displayObject.addChild(_marryImage);
         initOriginRenderItems();
      }
      
      override protected function selectDraw() : void
      {
         super.selectDraw();
      }
      
      override protected function commitData() : void
      {
         if(!this._data)
         {
            return;
         }
         setAllTextColor();
         textAntId.text = this._data.antId;
         textNickName.text = this._data.nickName;
         textLevel.text = this._data.level;
         marryState = FriendData(this._data).marrayState;
         if(PlayerDataList.instance.selfData.partnerID == this._data.antId && FriendData(this._data).marrayState != 3)
         {
            setAllTextColor(colorArr[FriendData(this._data).marrayState - 1]);
         }
      }
      
      private function setAllTextColor(param1:uint = 0) : void
      {
         for each(var _loc2_ in _txtArr)
         {
            _loc2_.color = param1;
         }
      }
      
      public function set marryState(param1:int) : void
      {
         _marryState = param1;
         _marryImage.texture = Assets.sAsset.getTexture("img_friendMarryState" + param1);
      }
   }
}

