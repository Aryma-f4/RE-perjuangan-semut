package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.chatRoom.FriendData;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.screen.friends.SelectFriendView;
   import feathers.controls.TextInput;
   import starling.display.Button;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class PopInputDlg extends WeddingSmallDlgBase implements IGuideProcess
   {
      
      private var _inputText:TextInput;
      
      private var _goodData:GoodsData;
      
      private var _selectFriend:SelectFriendView;
      
      private var _chooseButton:Button;
      
      private var _friendData:FriendData;
      
      public function PopInputDlg(param1:GoodsData)
      {
         super();
         _goodData = param1;
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         var _loc2_:SubMissionData = MissionGuideValue.instance.getUnCompleteSubMissions();
         if(!_loc2_)
         {
            return;
         }
         switch(_loc2_.actioncode - 149)
         {
            case 0:
               if(param1 == "slecectFriendComplete")
               {
                  if("" == _inputText.text)
                  {
                     _inputText.text = LangManager.t("marryMe");
                  }
                  GuideEventManager.instance.dispactherEvent("newUI",[[_okBtn,50]]);
                  break;
               }
               GuideEventManager.instance.dispactherEvent("newUI",[[_chooseButton,40]]);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         buildLayout("popInputLayout");
         _chooseButton = getChildByName("chooseBtn") as Button;
         _chooseButton.addEventListener("triggered",onChooseFriendHandle);
         _inputText = new TextInput();
         SmallCodeTools.instance.setDisplayObjectInSame(getChildByName("inputText"),_inputText);
         this.addChild(_inputText);
         _inputText.maxChars = 150;
         _inputText.verticalAlign = "justify";
         _inputText.textEditorFactory = feathersInputTextFormat;
         _inputText.setFocus();
         _selectFriend = new SelectFriendView();
         _selectFriend.signal.add(onSetFriendDataHandle);
         guideProcess();
      }
      
      private function onSetFriendDataHandle(param1:Object) : void
      {
         _friendData = param1 as FriendData;
         TextField(getChildByName("friendName")).text = _friendData.nickName;
         _inputText.isEnabled = true;
         guideProcess("slecectFriendComplete");
      }
      
      private function onChooseFriendHandle(param1:Event) : void
      {
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_selectFriend);
         _selectFriend.show(1);
         _inputText.isEnabled = false;
      }
      
      override protected function onOkHandle(param1:Event) : void
      {
         if(_inputText.text == "")
         {
            TextTip.instance.showByLang("weddingTipMsg");
            return;
         }
         if(!_friendData)
         {
            TextTip.instance.showByLang("weddingTipMsg1");
            return;
         }
         if(_friendData.sex == PlayerDataList.instance.selfData.babySex)
         {
            TextTip.instance.showByLang("popTip0");
            return;
         }
         super.onOkHandle(param1);
         GameServer.instance.weddingSendPopMarryMsg(_friendData.antId,_goodData.onlyID,_inputText.text);
      }
   }
}

