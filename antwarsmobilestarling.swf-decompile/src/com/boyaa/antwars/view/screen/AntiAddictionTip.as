package com.boyaa.antwars.view.screen
{
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.display.DlgMark;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class AntiAddictionTip extends Sprite
   {
      
      private var bg:Image;
      
      private var btnCertificate:Button;
      
      public var btnClose:Button;
      
      public var tipHour:TextField;
      
      public var tipMin:TextField;
      
      public var tipText2:TextField;
      
      private var _antiAddiction:AntiAddictionDlg;
      
      private var markBg:DlgMark;
      
      public function AntiAddictionTip()
      {
         super();
         markBg = new DlgMark();
         bg = new Image(Assets.sAsset.getTexture("bg3"));
         bg.touchable = false;
         Assets.positionDisplay(bg,"anitAddictionTip","bg");
         addChild(bg);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("chenmi"));
         Assets.positionDisplay(_loc1_,"anitAddictionTip","title");
         addChild(_loc1_);
         var _loc2_:TextField = new TextField(400,35,LangManager.t("antiAddiction3"),"Verdana",28,4465669);
         Assets.positionDisplay(_loc2_,"anitAddictionTip","tip1");
         _loc2_.autoScale = true;
         addChild(_loc2_);
         var _loc3_:TextField = new TextField(185,35,LangManager.t("antiAddiction4"),"Verdana",28,4465669);
         Assets.positionDisplay(_loc3_,"anitAddictionTip","txt2");
         _loc3_.autoScale = true;
         _loc3_.hAlign = "left";
         addChild(_loc3_);
         tipText2 = new TextField(246,35,LangManager.t("antiAddiction5"),"Verdana",28,4465669);
         Assets.positionDisplay(tipText2,"anitAddictionTip","txt3");
         tipText2.autoScale = true;
         tipText2.hAlign = "left";
         addChild(tipText2);
         tipHour = new TextField(200,35,"4:45" + LangManager.t("tipHour"),"Verdana",28,16711680);
         tipHour.autoScale = true;
         Assets.positionDisplay(tipHour,"anitAddictionTip","txtHour");
         addChild(tipHour);
         tipMin = new TextField(110,35,15 + LangManager.t("tipMin"),"Verdana",28,16711680);
         tipMin.autoScale = true;
         Assets.positionDisplay(tipMin,"anitAddictionTip","txtMin");
         addChild(tipMin);
         btnCertificate = new Button(Assets.sAsset.getTexture("but1"),"",Assets.sAsset.getTexture("but2"));
         Assets.positionDisplay(btnCertificate,"anitAddictionTip","btnCertificate");
         btnCertificate.addEventListener("triggered",onCertificateBtn);
         addChild(btnCertificate);
         btnClose = new Button(Assets.sAsset.getTexture("but5"),"",Assets.sAsset.getTexture("but6"));
         Assets.positionDisplay(btnClose,"anitAddictionTip","btnClose");
         btnClose.addEventListener("triggered",onClose);
         addChild(btnClose);
         addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
      }
      
      private function onCertificateBtn(param1:Event) : void
      {
         _antiAddiction = new AntiAddictionDlg();
         _antiAddiction.parentWin = this;
         Starling.current.stage.addChild(_antiAddiction);
         _antiAddiction.x = (1365 - _antiAddiction.width >> 1) + 15;
         _antiAddiction.y = 768 - _antiAddiction.height >> 1;
      }
      
      public function onClose(param1:Event = null) : void
      {
         markBg.removeFromParent();
         removeFromParent();
      }
   }
}

