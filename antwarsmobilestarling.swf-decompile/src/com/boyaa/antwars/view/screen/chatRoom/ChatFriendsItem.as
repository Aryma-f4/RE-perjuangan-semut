package com.boyaa.antwars.view.screen.chatRoom
{
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.view.ui.LayoutListItemRender;
   import starling.text.TextField;
   
   public class ChatFriendsItem extends LayoutListItemRender
   {
      
      private var textAntId:TextField;
      
      private var textNickName:TextField;
      
      private var textFightPower:TextField;
      
      private var _txtArr:Array = [];
      
      private var _btBtn:FashionStarlingButton;
      
      public function ChatFriendsItem()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         buildLayoutByName("chatFriends","ChatFriendListItem");
         textAntId = getTextFieldByName("playerId");
         textNickName = getTextFieldByName("playerName");
         textFightPower = getTextFieldByName("level");
         _btBtn = new FashionStarlingButton(getButtonByName("btn"));
         textAntId.touchable = textNickName.touchable = textFightPower.touchable = false;
         _txtArr.push(textAntId);
         _txtArr.push(textNickName);
         _txtArr.push(textFightPower);
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
         textFightPower.text = this._data.level;
      }
      
      private function setAllTextColor(param1:uint = 0) : void
      {
         for each(var _loc2_ in _txtArr)
         {
            _loc2_.color = param1;
         }
      }
   }
}

