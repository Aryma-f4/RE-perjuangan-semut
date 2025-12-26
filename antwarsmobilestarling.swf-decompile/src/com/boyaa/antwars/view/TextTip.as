package com.boyaa.antwars.view
{
   import com.boyaa.antwars.lang.LangManager;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class TextTip extends Sprite
   {
      
      private static var _instance:TextTip = null;
      
      private var bg:Quad;
      
      private var mark:Quad;
      
      private var textField:TextField;
      
      private var tween:Tween = null;
      
      private var _autoHidden:Boolean = true;
      
      public function TextTip(param1:Single)
      {
         super();
         mark = new Quad(Assets.width,Assets.height,0);
         mark.alpha = 0;
         bg = new Quad(Assets.width,Assets.height / 8,0);
         bg.setVertexAlpha(0,0.1);
         bg.setVertexAlpha(1,1);
         bg.setVertexAlpha(2,1);
         bg.setVertexAlpha(3,0.1);
         addChild(bg);
         bg.alpha = 0.6;
         textField = new TextField(bg.width,bg.height,"","Verdana",28,16777215,true);
         addChild(textField);
         this.pivotX = this.width / 2;
         this.pivotY = this.height / 2;
         this.x = Assets.leftTop.x + this.width / 2;
         this.y = Assets.leftTop.y + (Assets.height - this.height >> 1);
      }
      
      public static function get instance() : TextTip
      {
         if(_instance == null)
         {
            _instance = new TextTip(new Single());
         }
         return _instance;
      }
      
      public function show(param1:String, param2:Boolean = true, param3:Boolean = true) : void
      {
         if(!_autoHidden)
         {
            return;
         }
         textField.text = param1;
         this.scaleX = this.scaleY = 0;
         this.alpha = 1;
         Starling.current.stage.addChild(this);
         tween = new Tween(this,0.2,"easeOut");
         tween.scaleTo(1);
         Starling.juggler.add(tween);
         if(param2)
         {
            mark.removeFromParent();
         }
         else
         {
            Starling.current.stage.addChild(mark);
         }
         if(param3)
         {
            tween.onComplete = hidden;
         }
         _autoHidden = param3;
      }
      
      public function hidden(param1:int = 2) : void
      {
         var time:int = param1;
         if(!this.parent)
         {
            return;
         }
         if(!tween)
         {
            tween = new Tween(this,time,"easeIn");
         }
         else
         {
            tween.reset(this,time,"easeIn");
         }
         tween.fadeTo(0);
         Starling.juggler.add(tween);
         tween.onComplete = function():void
         {
            removeFromParent();
            Starling.juggler.remove(tween);
            mark.removeFromParent();
         };
         _autoHidden = true;
      }
      
      public function showByLang(param1:String) : void
      {
         var _loc2_:String = LangManager.t(param1);
         show(_loc2_);
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
