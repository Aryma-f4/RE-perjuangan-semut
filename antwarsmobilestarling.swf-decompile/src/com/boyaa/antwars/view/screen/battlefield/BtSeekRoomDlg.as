package com.boyaa.antwars.view.screen.battlefield
{
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.DlgMark;
   import feathers.controls.TextInput;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class BtSeekRoomDlg extends Sprite
   {
      
      private var markbg:DlgMark = null;
      
      private var roomid_text:TextInput = null;
      
      private var seek_btn:Button = null;
      
      private var close_btn:Button = null;
      
      public function BtSeekRoomDlg()
      {
         super();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         markbg = new DlgMark();
         removeEventListener("addedToStage",onAddedToStage);
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("find_create_system_bg"));
         Assets.positionDisplay(_loc5_,"btSeekRoomDlg","bg");
         addChild(_loc5_);
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("find_room"));
         Assets.positionDisplay(_loc2_,"btSeekRoomDlg","find_room");
         addChild(_loc2_);
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("buydlgtextbg"));
         Assets.positionDisplay(_loc3_,"btSeekRoomDlg","roomidbg");
         addChild(_loc3_);
         var _loc4_:Rectangle = Assets.getPosition("btSeekRoomDlg","roomidtext");
         roomid_text = new TextInput();
         roomid_text.width = _loc4_.width;
         roomid_text.height = _loc4_.height;
         roomid_text.x = _loc4_.x;
         roomid_text.y = _loc4_.y;
         roomid_text.textEditorProperties.autoCapitalize = "none";
         roomid_text.textEditorProperties.autoCorrect = false;
         roomid_text.textEditorProperties.color = 16777215;
         roomid_text.textEditorProperties.displayAsPassword = false;
         roomid_text.textEditorProperties.fontFamily = "Verdana";
         roomid_text.textEditorProperties.fontSize = 30;
         roomid_text.textEditorProperties.maxChars = 6;
         roomid_text.textEditorProperties.restrict = "0-9";
         addChild(roomid_text);
         roomid_text.text = LangManager.t("inputRoomID");
         roomid_text.addEventListener("focusIn",onFocusInHandle);
         close_btn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.positionDisplay(close_btn,"btSeekRoomDlg","closeBtn");
         addChild(close_btn);
         close_btn.addEventListener("triggered",onCloseTriggeredHandle);
         seek_btn = new Button(Assets.sAsset.getTexture("dzrs15"),"",Assets.sAsset.getTexture("dzrs16"));
         Assets.positionDisplay(seek_btn,"btSeekRoomDlg","dzrs15");
         addChild(seek_btn);
         seek_btn.addEventListener("triggered",onSeekTriggeredHandle);
         this.pivotX = 413;
         this.pivotY = 260;
         this.x = 480;
         this.y = 365;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.7,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeOutBack"
         });
         parent.addChild(markbg);
         parent.swapChildren(markbg,this);
      }
      
      private function onFocusInHandle(param1:Event) : void
      {
         roomid_text.text = "";
      }
      
      private function onSeekTriggeredHandle(param1:Event) : void
      {
         var e:Event = param1;
         if(roomid_text.text == "")
         {
            TextTip.instance.show(LangManager.t("srjrfjh"));
            return;
         }
         CopyServer.instance.findRoom(int(roomid_text.text),function(param1:Object):void
         {
            trace("查找房间回调：" + JSON.stringify(param1));
            if(param1.data.flag == 0)
            {
               TextTip.instance.showByLang("noRoom");
            }
            else if(param1.data.status == 1)
            {
               TextTip.instance.showByLang("teamList0");
            }
            else if(param1.data.maxPlayer == 1)
            {
               TextTip.instance.showByLang("teamList1");
            }
            else
            {
               Application.instance.currentGame._copyModeOptionsData.roomId = int(roomid_text.text);
               Application.instance.currentGame.navigator.showScreen("TEAMROOM");
               clearUp();
            }
         },CopyList.instance.currentCopyData.cpdtlid);
      }
      
      private function onCloseTriggeredHandle(param1:Event) : void
      {
         Starling.juggler.tween(this,0.5,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeInBack",
            "onComplete":clearUp
         });
      }
      
      private function clearUp() : void
      {
         markbg.removeFromParent();
         markbg = null;
         seek_btn.removeEventListener("triggered",onSeekTriggeredHandle);
         seek_btn = null;
         close_btn.removeEventListener("triggered",onCloseTriggeredHandle);
         close_btn = null;
         roomid_text.removeEventListener("focusIn",onFocusInHandle);
         roomid_text = null;
         removeFromParent(true);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

