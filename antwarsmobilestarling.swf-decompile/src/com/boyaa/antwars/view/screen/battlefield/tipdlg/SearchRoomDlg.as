package com.boyaa.antwars.view.screen.battlefield.tipdlg
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.net.server.BattleServer;
   import feathers.controls.TextInput;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class SearchRoomDlg extends BtSmallInputDlgBass
   {
      
      private var _inputPassword:TextInput;
      
      private var _tip2:TextField;
      
      private var _type:int;
      
      public function SearchRoomDlg()
      {
         super();
         initParams("btRoom","btHallSearchRoomDlg","searchCode","okBtn");
         init();
         _tip2 = getTextFieldByName("info1");
         bindNet();
      }
      
      private function bindNet() : void
      {
         BattleServer.instance.onFindRoomEmpty(onFindRoomEmptyHandle);
         BattleServer.instance.onFindRoomError(onFindRoomErrorHandle);
      }
      
      private function unBindNet() : void
      {
         BattleServer.instance.disposeRecvFun(onFindRoomEmptyHandle);
         BattleServer.instance.disposeRecvFun(onFindRoomErrorHandle);
      }
      
      private function onFindRoomErrorHandle(param1:Object) : void
      {
         switch(param1.data.ret)
         {
            case 2:
               dispose();
               break;
            case 4:
               _tip2.color = 16711680;
               _inputPassword.setFocus();
         }
      }
      
      private function onFindRoomEmptyHandle(param1:Object) : void
      {
         _input.setFocus();
      }
      
      override protected function initInput() : void
      {
         super.initInput();
         _inputPassword = StarlingUITools.instance.createInputByTextField(getTextFieldByName("password"),6);
         _inputPassword.restrict = "0-9";
      }
      
      override protected function onOkButtonHandle(param1:Event) : void
      {
         EventCenter.GameEvent.dispatchEvent(new GameEvent("searchBtRoom",{
            "roomId":_input.text,
            "password":_inputPassword.text
         }));
      }
      
      override protected function removeSelf() : void
      {
         super.removeSelf();
         unBindNet();
      }
      
      public function set type(param1:int) : void
      {
         _type = param1;
      }
      
      public function get searchInput() : TextInput
      {
         return _input;
      }
      
      public function get passwordInput() : TextInput
      {
         return _inputPassword;
      }
   }
}

