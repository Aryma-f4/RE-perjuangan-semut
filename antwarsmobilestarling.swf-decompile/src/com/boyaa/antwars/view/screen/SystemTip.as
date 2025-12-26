package com.boyaa.antwars.view.screen
{
   import com.boyaa.antwars.view.ui.layout.TipDialogBg;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class SystemTip extends Sprite
   {
      
      public static const YES:String = "yes";
      
      public static const NO:String = "no";
      
      private static var _instance:SystemTip = null;
      
      private var txt:TextField;
      
      private var mark:Quad;
      
      private var timer:Timer;
      
      private var _countTime:int = 10;
      
      private var second:int = 0;
      
      private var tween:Tween = null;
      
      private var _yesCallBack:Function = null;
      
      private var _noCallBack:Function = null;
      
      private var _tipBg:TipDialogBg;
      
      public function SystemTip()
      {
         super();
         var _loc4_:Rectangle = Assets.getPosition("systemTip","bg");
         _tipBg = new TipDialogBg(_loc4_.width,_loc4_.height);
         _tipBg.x = _loc4_.x;
         _tipBg.y = _loc4_.y;
         addChild(_tipBg);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("system_tip"));
         Assets.positionDisplay(_loc1_,"systemTip","system_tip");
         addChild(_loc1_);
         txt = new TextField(640,200,"这里是提示内容...","Verdana",28);
         txt.hAlign = "center";
         txt.vAlign = "center";
         txt.x = 50;
         txt.y = 100;
         addChild(txt);
         var _loc2_:Button = new Button(Assets.sAsset.getTexture("img_publicSureBtn1"),"",Assets.sAsset.getTexture("img_publicSureBtn2"));
         Assets.positionDisplay(_loc2_,"systemTip","btnYes");
         _loc2_.addEventListener("triggered",onYes);
         addChild(_loc2_);
         var _loc3_:Button = new Button(Assets.sAsset.getTexture("img_publicCancelBtn1"),"",Assets.sAsset.getTexture("img_publicCancelBtn2"));
         Assets.positionDisplay(_loc3_,"systemTip","btnNo");
         _loc3_.addEventListener("triggered",onNo);
         addChild(_loc3_);
         mark = new Quad(1365,768,0);
         mark.alpha = 0;
         this.pivotX = this.width / 2;
         this.pivotY = this.height / 2;
         this.x = 1365 >> 1;
         this.y = 768 >> 1;
      }
      
      public static function get instance() : SystemTip
      {
         if(_instance == null)
         {
            _instance = new SystemTip();
         }
         return _instance;
      }
      
      public function show(param1:String) : void
      {
         txt.text = param1;
         Starling.current.stage.addChild(mark);
         Starling.current.stage.addChild(this);
         this.scaleX = this.scaleY = 0;
         tween = new Tween(this,0.3,"easeOut");
         tween.scaleTo(1);
         Starling.juggler.add(tween);
      }
      
      public function showSystemAlert(param1:String, param2:Function, param3:Function, param4:Boolean = false) : void
      {
         _yesCallBack = param2;
         _noCallBack = param3;
         show(param1);
         if(param4)
         {
            timer = new Timer(1000);
            timer.addEventListener("timer",onTimer);
            timer.start();
         }
      }
      
      public function hide() : void
      {
         Starling.juggler.remove(tween);
         mark.removeFromParent(true);
         Starling.current.stage.removeChild(this);
      }
      
      private function onYes(param1:Event) : void
      {
         if(_yesCallBack != null)
         {
            _yesCallBack();
            _yesCallBack = null;
            if(second > 0 && timer)
            {
               timer.stop();
               timer.removeEventListener("timer",onTimer);
               timer = null;
            }
         }
         hide();
      }
      
      private function onNo(param1:Event) : void
      {
         dispatchEventWith("no");
         if(_noCallBack != null)
         {
            _noCallBack();
            _noCallBack = null;
            if(second > 0 && timer)
            {
               timer.stop();
               timer.removeEventListener("timer",onTimer);
               timer = null;
            }
         }
         hide();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         second = second + 1;
         if(second == _countTime)
         {
            onNo(null);
            second = 0;
         }
      }
      
      public function get countTime() : int
      {
         return _countTime;
      }
      
      public function set countTime(param1:int) : void
      {
         _countTime = param1;
      }
   }
}

