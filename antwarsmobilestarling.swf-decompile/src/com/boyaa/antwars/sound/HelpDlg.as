package com.boyaa.antwars.sound
{
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.display.DlgMark;
   import feathers.controls.ScrollText;
   import flash.text.TextFormat;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class HelpDlg extends Sprite
   {
      
      private var _bgImage:Image;
      
      private var _closeBtn:Button;
      
      private var _atlas:ResAssetManager;
      
      private var _scrollText:ScrollText;
      
      private var markBg:DlgMark;
      
      public function HelpDlg()
      {
         super();
         markBg = new DlgMark();
         _atlas = Assets.sAsset;
         _bgImage = new Image(_atlas.getTexture("sz10"));
         addChild(_bgImage);
         _closeBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.positionDisplay(_closeBtn,"configDlg","closeBtn2");
         _closeBtn.addEventListener("triggered",onCloseBtn);
         addChild(_closeBtn);
         _scrollText = new ScrollText();
         _scrollText.textFormat = new TextFormat("Verdana,Heiti SC,Helvetica Neue,Helvetica,Roboto,Arial,_sans",25,16777215,true);
         var _loc1_:String = LangManager.t("helpInfo").toString();
         _scrollText.text = _loc1_;
         Assets.positionDisplay(_scrollText,"configDlg","helpText");
         addChild(_scrollText);
         _scrollText.visible = false;
         addEventListener("addedToStage",onAddedToStage);
      }
      
      public static function show(param1:String = "help") : void
      {
         var _loc2_:HelpDlg = new HelpDlg();
         _loc2_.txt = param1;
         Application.instance.currentGame.stage.addChild(_loc2_);
         _loc2_.x = 1365 - _loc2_.width >> 1;
         _loc2_.y = 768 - _loc2_.height >> 1;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var event:Event = param1;
         this.removeEventListener("addedToStage",onAddedToStage);
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
         this.pivotX = this.width >> 1;
         this.pivotY = this.height >> 1;
         this.x = 515;
         this.y = 384;
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
      
      public function set txt(param1:String) : void
      {
         _scrollText.text = param1;
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
         _closeBtn.removeEventListener("triggered",onCloseBtn);
         Starling.juggler.removeTweens(this);
         parent.removeChild(this);
         markBg.removeFromParent(true);
      }
   }
}

