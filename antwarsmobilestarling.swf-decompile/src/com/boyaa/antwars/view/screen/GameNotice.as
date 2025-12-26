package com.boyaa.antwars.view.screen
{
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.tool.smallTools.boyaaCode.scrollText.BoyaaScrollText;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class GameNotice extends Sprite
   {
      
      public static var content:String = "";
      
      private var closeBtn:Button;
      
      private var btnSure:Button;
      
      private var _scrollText:BoyaaScrollText;
      
      public function GameNotice()
      {
         super();
         init();
         addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var event:Event = param1;
         this.pivotX = this.width >> 1;
         this.pivotY = this.height >> 1;
         this.x = this.width >> 1;
         this.y = this.height >> 1;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.5,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeOutBack",
            "onComplete":function():void
            {
               _scrollText.visible = true;
            }
         });
      }
      
      public function show(param1:Boolean = false) : void
      {
         var in_hall:Boolean = param1;
         if(GameNotice.content == "")
         {
            Remoting.instance.getNotice(Application.instance.version,function(param1:Object):void
            {
               if(in_hall && param1.ret == 0 || !in_hall)
               {
                  if(param1.msg != "")
                  {
                     content = param1.msg;
                     showNoticeContent();
                  }
               }
            });
         }
         else
         {
            showNoticeContent();
         }
      }
      
      public function showNoticeContent() : void
      {
         _scrollText.text = content;
         Application.instance.currentGame.stage.addChild(this);
         this.x = 1365 - this.width >> 1;
         this.y = 768 - this.height >> 1;
      }
      
      private function init() : void
      {
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("bg3"));
         Assets.positionDisplay(_loc2_,"notice","bg");
         addChild(_loc2_);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("notice"));
         Assets.positionDisplay(_loc1_,"notice","title");
         addChild(_loc1_);
         closeBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.positionDisplay(closeBtn,"notice","closeBtn");
         closeBtn.addEventListener("triggered",onCloseBtn);
         addChild(closeBtn);
         btnSure = new Button(Assets.sAsset.getTexture("btn_sure0"),"",Assets.sAsset.getTexture("btn_sure1"));
         Assets.positionDisplay(btnSure,"notice","btn_sure");
         btnSure.addEventListener("triggered",onCloseBtn);
         addChild(btnSure);
         var _loc3_:Rectangle = Assets.getPosition("notice","txt_content");
         _scrollText = new BoyaaScrollText(_loc3_.width,_loc3_.height,"","Verdana",24,4465669,true);
         Assets.positionDisplay(_scrollText,"notice","txt_content");
         addChild(_scrollText);
         _scrollText.visible = false;
      }
      
      private function onCloseBtn(param1:Event) : void
      {
         _scrollText.text = "";
         Starling.juggler.tween(this,0.5,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeInBack",
            "onComplete":cleanUp
         });
      }
      
      private function cleanUp() : void
      {
         closeBtn.removeEventListener("triggered",onCloseBtn);
         btnSure.removeEventListener("triggered",onCloseBtn);
         Starling.juggler.removeTweens(this);
         this.removeFromParent();
      }
   }
}

