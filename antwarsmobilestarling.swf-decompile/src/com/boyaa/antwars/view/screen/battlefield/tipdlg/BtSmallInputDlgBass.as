package com.boyaa.antwars.view.screen.battlefield.tipdlg
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.TextInput;
   import starling.events.Event;
   
   public class BtSmallInputDlgBass extends UIExportSprite
   {
      
      protected var _infoName:String = "btRoom";
      
      protected var _layoutName:String = "";
      
      protected var _inputTextFieldName:String = "";
      
      protected var _okButtonName:String = "";
      
      protected var _inputChars:int = 4;
      
      protected var _input:TextInput;
      
      private var _okBtn:FashionStarlingButton;
      
      public function BtSmallInputDlgBass()
      {
         super();
      }
      
      public function initParams(param1:String, param2:String, param3:String, param4:String, param5:int = 4) : void
      {
         _infoName = param1;
         _layoutName = param2;
         _inputTextFieldName = param3;
         _okButtonName = param4;
         _inputChars = param5;
      }
      
      protected function init() : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther(_infoName));
         _layout.buildLayout(_layoutName,_displayObj);
         showMark();
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
         addCloseButtonEvent();
         initInput();
         _okBtn = new FashionStarlingButton(getButtonByName(_okButtonName));
         _okBtn.triggerFunction = onOkButtonHandle;
      }
      
      protected function onOkButtonHandle(param1:Event) : void
      {
         removeSelf();
      }
      
      protected function initInput() : void
      {
         _input = StarlingUITools.instance.createInputByTextField(getTextFieldByName(_inputTextFieldName),_inputChars);
         _input.restrict = "0-9";
      }
   }
}

