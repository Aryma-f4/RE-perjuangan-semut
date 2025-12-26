package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import feathers.controls.TextInput;
   import starling.events.Event;
   
   public class DivorceInputDlg extends WeddingSmallDlgBase
   {
      
      private var _inputText:TextInput;
      
      private var _goodData:GoodsData;
      
      public function DivorceInputDlg(param1:GoodsData)
      {
         super();
         _goodData = param1;
      }
      
      override protected function init() : void
      {
         super.init();
         buildLayout("divorceInputLayout");
         _inputText = new TextInput();
         SmallCodeTools.instance.setDisplayObjectInSame(getChildByName("inputText"),_inputText);
         this.addChild(_inputText);
         _inputText.maxChars = 150;
         _inputText.verticalAlign = "justify";
         _inputText.textEditorFactory = feathersInputTextFormat;
         _inputText.setFocus();
      }
      
      override protected function onOkHandle(param1:Event) : void
      {
         if(_inputText.text == "")
         {
            TextTip.instance.show(LangManager.t("weddingTipMsg"));
            return;
         }
         super.onOkHandle(param1);
         GameServer.instance.weddingSendDivorceMsg(1,_goodData.onlyID,_inputText.text);
      }
   }
}

