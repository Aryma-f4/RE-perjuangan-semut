package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.screen.chatRoom.FriendData;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import starling.display.Button;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class PopAgreeDlg extends WeddingSmallDlgBase
   {
      
      private var _cancelBtn:Button;
      
      private var _data:Object;
      
      public function PopAgreeDlg(param1:Object)
      {
         super();
         _data = param1;
         show();
      }
      
      override protected function init() : void
      {
         super.init();
         buildLayout("agreePopLayout");
         _cancelBtn = getChildByName("cancelBtn") as Button;
         _cancelBtn.addEventListener("triggered",onCloseHandle);
      }
      
      private function show() : void
      {
         var _loc1_:FriendData = FriendsList.instance.getFriendByUID(_data.uid);
         TextField(getChildByName("inputText")).autoSize = "vertical";
         TextField(getChildByName("inputText")).autoScale = false;
         TextField(getChildByName("babyName")).text = LangManager.t("weddingMarryInfo0") + PlayerDataList.instance.selfData.babyName + ":";
         TextField(getChildByName("inputText")).text = _data.word;
         TextField(getChildByName("popMan")).text = "";
      }
      
      override protected function onOkHandle(param1:Event) : void
      {
         super.onOkHandle(param1);
         GameServer.instance.weddingSendPopAnswer(2,_data.uid);
      }
      
      override protected function onCloseHandle(param1:Event) : void
      {
         super.onCloseHandle(param1);
         GameServer.instance.weddingSendPopAnswer(1,_data.uid);
      }
   }
}

