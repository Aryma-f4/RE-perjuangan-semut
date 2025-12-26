package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideSprite;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.text.TextFieldTextEditor;
   import feathers.core.ITextEditor;
   import flash.text.TextFormat;
   import starling.display.Button;
   import starling.events.Event;
   
   public class WeddingSmallDlgBase extends GuideSprite
   {
      
      protected var _layout:LayoutUitl;
      
      private var _markBg:DlgMark;
      
      protected var _closeBtn:Button;
      
      protected var _okBtn:Button;
      
      private var _txtFormat:TextFormat;
      
      public function WeddingSmallDlgBase()
      {
         super();
         init();
         this.addEventListener("addedToStage",onAddToStageHandle);
      }
      
      protected function init() : void
      {
         initFormat();
      }
      
      private function initFormat() : void
      {
         _txtFormat = new TextFormat();
         _txtFormat.leading = 10;
         _txtFormat.size = 25;
         _txtFormat.font = "Verdana";
      }
      
      private function onAddToStageHandle(param1:Event) : void
      {
         removeEventListener("addedToStage",onAddToStageHandle);
         _markBg = new DlgMark();
         _markBg.setTouchHandle(remove);
         parent.addChild(_markBg);
         parent.swapChildren(_markBg,this);
      }
      
      protected function buildLayout(param1:String) : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther("weddingInfo"),Assets.sAsset);
         _layout.buildLayout(param1,this);
         this.x = (1365 - this.width) / 2;
         this.y = (768 - this.height) / 2;
         initButton();
      }
      
      private function initButton() : void
      {
         _closeBtn = Button(this.getChildByName("closeBtn"));
         _closeBtn && _closeBtn.addEventListener("triggered",onCloseHandle);
         _okBtn = Button(this.getChildByName("okBtn"));
         _okBtn && _okBtn.addEventListener("triggered",onOkHandle);
      }
      
      protected function onOkHandle(param1:Event) : void
      {
         remove();
      }
      
      protected function remove() : void
      {
         _markBg.removeFromParent(true);
         this.removeFromParent(true);
      }
      
      protected function onCloseHandle(param1:Event) : void
      {
         remove();
      }
      
      protected function setFeatherFormat(param1:TextFormat) : void
      {
         _txtFormat = param1;
      }
      
      protected function feathersInputTextFormat() : ITextEditor
      {
         var _loc1_:TextFieldTextEditor = new TextFieldTextEditor();
         _loc1_.wordWrap = true;
         _loc1_.textFormat = _txtFormat;
         return _loc1_;
      }
   }
}

