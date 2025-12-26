package com.boyaa.antwars.view.screen
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.mission.MissionManager;
   import feathers.controls.TextInput;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class AntiAddictionDlg extends Sprite
   {
      
      private var bg:Image;
      
      private var btnClose:Button;
      
      private var textInputBg:Image;
      
      private var textInputId:TextInput;
      
      private var textInputName:TextInput;
      
      private var commitBtn:Button;
      
      private var errorTxt:TextField;
      
      public var parentWin:AntiAddictionTip = null;
      
      public function AntiAddictionDlg()
      {
         super();
         init();
         addEventListener("addedToStage",onAddedToStage);
      }
      
      private function init() : void
      {
         bg = new Image(Assets.sAsset.getTexture("bb_bg"));
         Assets.positionDisplay(bg,"missionDlg","bg1");
         addChild(bg);
         var _loc7_:Image = new Image(Assets.sAsset.getTexture("55"));
         Assets.positionDisplay(_loc7_,"missionDlg","topbar");
         addChild(_loc7_);
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("bb46"));
         Assets.positionDisplay(_loc5_,"missionDlg","bottomBar");
         addChild(_loc5_);
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("chenmi2"));
         Assets.positionDisplay(_loc4_,"aniAddiction","title");
         addChild(_loc4_);
         _loc4_.x += 30;
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("text"));
         Assets.positionDisplay(_loc3_,"aniAddiction","text");
         addChild(_loc3_);
         btnClose = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         btnClose.addEventListener("triggered",onClose);
         Assets.positionDisplay(btnClose,"aniAddiction","btnClose");
         addChild(btnClose);
         btnClose.x += 67;
         commitBtn = new Button(Assets.sAsset.getTexture("but3"),"",Assets.sAsset.getTexture("but4"));
         commitBtn.addEventListener("triggered",onCommit);
         Assets.positionDisplay(commitBtn,"aniAddiction","btnCommit");
         addChild(commitBtn);
         var _loc2_:TextField = new TextField(800,35,LangManager.t("antiAddiction2"),"Verdana",24,4465669,true);
         Assets.positionDisplay(_loc2_,"aniAddiction","txt2");
         addChild(_loc2_);
         textInputBg = new Image(Assets.sAsset.getTexture("bg2"));
         textInputBg.touchable = false;
         Assets.positionDisplay(textInputBg,"aniAddiction","inputBg1");
         addChild(textInputBg);
         textInputBg = new Image(Assets.sAsset.getTexture("bg2"));
         textInputBg.touchable = false;
         Assets.positionDisplay(textInputBg,"aniAddiction","inputBg2");
         addChild(textInputBg);
         var _loc1_:TextField = new TextField(170,30,LangManager.t("id"),"Verdana",30,4465669,true);
         _loc1_.hAlign = "right";
         Assets.positionDisplay(_loc1_,"aniAddiction","txt3");
         addChild(_loc1_);
         var _loc6_:TextField = new TextField(170,30,LangManager.t("name"),"Verdana",30,4465669,true);
         _loc6_.hAlign = "right";
         Assets.positionDisplay(_loc6_,"aniAddiction","txt4");
         addChild(_loc6_);
         textInputId = new TextInput();
         textInputId.textEditorProperties.fontFamily = "Verdana";
         textInputId.textEditorProperties.color = 16777215;
         textInputId.textEditorProperties.fontSize = 28;
         Assets.positionDisplay(textInputId,"aniAddiction","txt5");
         addChild(textInputId);
         textInputName = new TextInput();
         textInputName.textEditorProperties.fontFamily = "Verdana";
         textInputName.textEditorProperties.color = 16777215;
         textInputName.textEditorProperties.fontSize = 28;
         Assets.positionDisplay(textInputName,"aniAddiction","txt6");
         addChild(textInputName);
         errorTxt = new TextField(300,30,LangManager.t("inputError"),"Verdana",20,16711680,true);
         errorTxt.hAlign = "left";
         Assets.positionDisplay(errorTxt,"aniAddiction","errorTxt");
         errorTxt.visible = false;
         addChild(errorTxt);
      }
      
      private function getIndulgeInfo(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Date = null;
         Application.instance.log("getIndulgeInfo防沉迷",JSON.stringify(param1));
         errorTxt.visible = false;
         if(param1.ret == 0)
         {
            _loc2_ = param1.info.birthday;
            _loc3_ = _loc2_.split("-");
            _loc4_ = int(_loc3_[0]);
            _loc5_ = new Date();
            if(_loc5_.getFullYear() - _loc4_ >= 18)
            {
               PlayerDataList.instance.selfData.isAdult = true;
               onClose();
               if(parentWin && parentWin.parent)
               {
                  parentWin.onClose();
                  parentWin = null;
               }
               return;
            }
            if(MissionManager.instance.onLineTime > 300)
            {
               Application.instance.currentGame.logout();
            }
            PlayerDataList.instance.selfData.isAdult = false;
         }
         else if(param1.ret == 120)
         {
            errorTxt.text = LangManager.t("nameError");
            errorTxt.visible = true;
         }
         else if(param1.ret == 110)
         {
            errorTxt.text = LangManager.t("idError");
            errorTxt.visible = true;
         }
         else
         {
            errorTxt.text = LangManager.t("inputError");
            errorTxt.visible = true;
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         this.pivotX = this.width >> 1;
         this.pivotY = this.height >> 1;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.5,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeOutBack"
         });
      }
      
      private function onCommit(param1:Event) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = null;
         if(textInputId.text == "")
         {
            errorTxt.text = LangManager.t("idError");
            errorTxt.visible = true;
         }
         else if(textInputName.text == "" || textInputName.text.length > 5 || textInputName.text.length < 2)
         {
            errorTxt.text = LangManager.t("nameError");
            errorTxt.visible = true;
         }
         else
         {
            errorTxt.visible = false;
            _loc3_ = textInputName.text;
            _loc2_ = textInputId.text;
            Remoting.instance.indulgeCheck(_loc3_,_loc2_,getIndulgeInfo);
            trace("提交认证:" + _loc3_,_loc2_);
         }
      }
      
      private function onClose(param1:Event = null) : void
      {
         Starling.juggler.tween(this,0.5,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeInBack",
            "onComplete":cleanUp
         });
      }
      
      private function cleanUp() : void
      {
         btnClose.removeEventListener("triggered",onClose);
         Starling.juggler.removeTweens(this);
         removeFromParent();
      }
   }
}

