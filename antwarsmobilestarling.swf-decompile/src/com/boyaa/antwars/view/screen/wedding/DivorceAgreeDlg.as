package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.net.server.GameServer;
   import starling.display.Button;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class DivorceAgreeDlg extends WeddingSmallDlgBase
   {
      
      private var _cancelBtn:Button;
      
      public function DivorceAgreeDlg(param1:Object)
      {
         super();
         show(param1);
      }
      
      override protected function init() : void
      {
         super.init();
         buildLayout("agreeDivorceLayout");
         _cancelBtn = getChildByName("cancelBtn") as Button;
         _cancelBtn.addEventListener("triggered",onCloseHandle);
      }
      
      private function show(param1:Object) : void
      {
         TextField(getChildByName("inputText")).autoSize = "vertical";
         TextField(getChildByName("inputText")).autoScale = false;
         TextField(getChildByName("inputText")).text = param1.word;
      }
      
      override protected function onOkHandle(param1:Event) : void
      {
         super.onOkHandle(param1);
         GameServer.instance.weddingSendDivorceAnswer(1);
      }
      
      override protected function onCloseHandle(param1:Event) : void
      {
         super.onCloseHandle(param1);
         GameServer.instance.weddingSendDivorceAnswer(2);
      }
   }
}

