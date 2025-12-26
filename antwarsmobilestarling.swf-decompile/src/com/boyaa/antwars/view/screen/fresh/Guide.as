package com.boyaa.antwars.view.screen.fresh
{
   import com.boyaa.antwars.view.screen.Hall;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.text.TextField;
   import starling.utils.deg2rad;
   
   public class Guide extends Sprite
   {
      
      private static var _instance:Guide;
      
      public var circle:Scale9Image;
      
      public var focusSprite:Sprite;
      
      public var focus:Image;
      
      private var focusK:int = 0;
      
      private var dk:Boolean = true;
      
      private var point:Point;
      
      public var textSprite:Sprite;
      
      public var textBg:Scale9Image;
      
      public var _text:TextField;
      
      private const TextWidth:uint = 270;
      
      private const TextHeight:uint = 90;
      
      private const Font:String = "Verdana";
      
      private const FontSize:uint = 28;
      
      private const FontColor:uint = 16777215;
      
      private var _isRunning:Boolean = false;
      
      public function Guide(param1:Single)
      {
         super();
         if(_instance)
         {
            throw new Error("只能用instance来获取实例");
         }
         init();
      }
      
      public static function get instance() : Guide
      {
         if(_instance == null)
         {
            _instance = new Guide(new Single());
         }
         return _instance;
      }
      
      private function init() : void
      {
         focusSprite = new Sprite();
         textSprite = new Sprite();
         circle = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("guide_dotLine"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         circle.width = circle.height = 100;
         focus = new Image(Assets.sAsset.getTexture("focusFinger"));
         focusSprite.addChild(focus);
         textBg = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         textBg.width = 270;
         textBg.height = 90;
         _text = new TextField(270 - 10,90,"","Verdana",28,16777215);
         _text.autoScale = true;
         _text.x = textBg.x + 5;
         _text.y = textBg.y;
         textSprite.addChild(textBg);
         textSprite.addChild(_text);
         addChild(circle);
         addChild(focusSprite);
         addChild(textSprite);
         this.touchable = false;
      }
      
      private function edgeDetection(param1:DisplayObject = null) : void
      {
         var _loc3_:Number = 0;
         if(param1)
         {
            _loc3_ = param1.height;
         }
         trace("focusSprite:",focusSprite.x,focusSprite.y);
         if(focusSprite.y <= 0)
         {
            focus.rotation = deg2rad(-180);
            focusSprite.y += textSprite.height + focusSprite.height + circle.height + _loc3_;
            focusSprite.x += focusSprite.width;
         }
         var _loc2_:Number = Assets.width - (textSprite.x + textSprite.width);
         trace("textSprite:" + textSprite.x,textSprite.y,_loc2_);
         if(_loc2_ <= 0)
         {
            textSprite.x += _loc2_;
         }
         if(textSprite.y <= 0)
         {
            textSprite.y = focusSprite.y;
            textSprite.x = focusSprite.x - textSprite.width;
            if(textSprite.x <= 0)
            {
               textSprite.x = focusSprite.x + focusSprite.width;
            }
         }
      }
      
      private function onFrame(param1:EnterFrameEvent) : void
      {
         focus.y = -20 - focusK;
         if(focusK == 24 || focusK == 0)
         {
            dk = !dk;
         }
         if(dk)
         {
            focusK -= 2;
         }
         else
         {
            focusK += 2;
         }
      }
      
      public function show(param1:Number, param2:Number, param3:String = "", param4:Number = 100, param5:Number = 100) : void
      {
         var _loc6_:int = 0;
         circle.x = param1;
         circle.y = param2;
         circle.width = param4;
         circle.height = param5;
         focusSprite.x = (circle.width - focusSprite.width >> 1) + circle.x;
         focusSprite.y = circle.y - focusSprite.height + 20;
         if(param3 == "")
         {
            textSprite.visible = false;
         }
         else
         {
            _loc6_ = param3.length;
            if(_loc6_ <= 8)
            {
               textBg.height = 60;
               _text.height = 60;
               textSprite.height = 60;
            }
            else
            {
               textBg.height = 90;
               _text.height = 90;
               textSprite.height = 90;
            }
            textSprite.visible = true;
            _text.text = param3;
         }
         textSprite.y = focusSprite.y - textSprite.height - textSprite.height / 2;
         textSprite.x = focusSprite.x - textSprite.width / 2 + focusSprite.width / 2;
         edgeDetection();
         Starling.current.stage.addEventListener("enterFrame",onFrame);
         Starling.current.stage.addChild(this);
         _isRunning = true;
      }
      
      public function guide(param1:DisplayObject, param2:String = "", param3:Boolean = false) : void
      {
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         if(param3)
         {
            if(param1.parent)
            {
               _loc4_ = param1.parent.localToGlobal(new Point(param1.x,param1.y));
               circle.x = _loc4_.x;
               circle.y = _loc4_.y;
            }
         }
         else
         {
            circle.x = param1.x;
            circle.y = param1.y;
         }
         circle.width = param1.width;
         circle.height = param1.height;
         focusSprite.x = (circle.width - focusSprite.width >> 1) + circle.x;
         focusSprite.y = circle.y - focusSprite.height + 20;
         if(param2 == "")
         {
            textSprite.visible = false;
         }
         else
         {
            _loc5_ = param2.length;
            if(_loc5_ <= 8)
            {
               textBg.height = 60;
               _text.height = 60;
               textSprite.height = 60;
            }
            else
            {
               textBg.height = 90;
               _text.height = 90;
               textSprite.height = 90;
            }
            textSprite.visible = true;
            _text.text = param2;
         }
         textSprite.y = focusSprite.y - textSprite.height - textSprite.height / 2 + 10;
         textSprite.x = focusSprite.x - textSprite.width / 2 + focusSprite.width / 2;
         edgeDetection(param1);
         Starling.current.stage.addEventListener("enterFrame",onFrame);
         Starling.current.stage.addChild(this);
         _isRunning = true;
      }
      
      public function stop() : void
      {
         var _loc1_:int = 0;
         if(Starling.current.stage.hasEventListener("enterFrame"))
         {
            Starling.current.stage.removeEventListener("enterFrame",onFrame);
            Starling.current.stage.removeChild(this);
            _loc1_ = 0;
            while(_loc1_ < this.numChildren)
            {
               this.getChildAt(_loc1_).x = 0;
               this.getChildAt(_loc1_).y = 0;
               _loc1_++;
            }
            if(focus.rotation != 0)
            {
               focus.rotation = 0;
            }
            this.x = 0;
            this.y = 0;
         }
         _isRunning = false;
      }
      
      public function onBackHall() : void
      {
         var _loc1_:Hall = null;
         Application.instance.currentGame._guideOptionsData.pos = "mission";
         if(Application.instance.currentGame.navigator.activeScreenID == "HALL")
         {
            _loc1_ = Application.instance.currentGame.navigator.activeScreen as Hall;
            _loc1_.posGuide();
            _isRunning = true;
         }
      }
      
      public function get isRunning() : Boolean
      {
         return _isRunning;
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
