package com.boyaa.antwars.view.screen.battlefield.element
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class ResultView extends Sprite
   {
      
      private var bg:Image;
      
      private var glow1:Image;
      
      private var glow2:Image;
      
      private var glow3:Image;
      
      private var wuyun:Image;
      
      private var topSprite:Sprite;
      
      private var rtopbg:Image;
      
      private var winOrlostImage:Image;
      
      private var infotxt:Image;
      
      private var bottomSprite:Sprite;
      
      private var tableTxt:Image;
      
      private var textureAtlas:ResAssetManager;
      
      private var character:Character;
      
      private var winer:Boolean;
      
      private var lostMC:MovieClip;
      
      public var completeSignal:Signal;
      
      public function ResultView(param1:Boolean = true)
      {
         super();
         textureAtlas = Assets.sAsset;
         completeSignal = new Signal();
         this.addEventListener("addedToStage",onAddedToStage);
         this.winer = param1;
         if(param1)
         {
            SoundManager.playBgSound("Music 12");
         }
         else
         {
            SoundManager.playBgSound("Music 13");
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         bg = new Image(textureAtlas.getTexture("resultbg"));
         bg.width = 1365 + 60;
         bg.height = 768 + 60;
         addChild(bg);
         bg.x = -30;
         bg.y = -30;
         topSprite = new Sprite();
         rtopbg = new Image(textureAtlas.getTexture("rtopbg"));
         rtopbg.width = 1000;
         rtopbg.scaleY = rtopbg.scaleX;
         topSprite.addChild(rtopbg);
         if(winer)
         {
            winOrlostImage = new Image(textureAtlas.getTexture("rwin"));
         }
         else
         {
            winOrlostImage = new Image(textureAtlas.getTexture("rlost"));
         }
         topSprite.addChild(winOrlostImage);
         infotxt = new Image(textureAtlas.getTexture("resulttext"));
         topSprite.addChild(infotxt);
         addChild(topSprite);
         bottomSprite = new Sprite();
         tableTxt = new Image(textureAtlas.getTexture("zdjs4"));
         addChild(bottomSprite);
         bottomSprite.addChild(tableTxt);
         character = CharacterFactory.instance.checkOutCharacter(PlayerDataList.instance.selfData.babySex);
         character.initData(PlayerDataList.instance.selfData.getPropData());
         if(!winer)
         {
            character.cryAnimation();
         }
         if(winer)
         {
            glow1 = new Image(textureAtlas.getTexture("g1"));
            glow1.pivotX = glow1.width >> 1;
            glow1.pivotY = glow1.height >> 1;
            addChild(glow1);
            glow1.scaleX = glow1.scaleY = 2;
            glow2 = new Image(textureAtlas.getTexture("g2"));
            glow2.pivotX = glow2.width >> 1;
            glow2.pivotY = glow2.height >> 1;
            addChild(glow2);
            glow2.scaleX = glow2.scaleY = 2;
            glow3 = new Image(textureAtlas.getTexture("g3"));
            glow3.pivotX = glow3.width >> 1;
            glow3.pivotY = glow3.height >> 1;
            addChild(glow3);
            glow3.scaleX = glow3.scaleY = 2;
            addChild(character);
         }
         else
         {
            addChild(character);
            wuyun = new Image(textureAtlas.getTexture("blackclouds"));
            wuyun.pivotX = wuyun.width >> 1;
            wuyun.pivotY = wuyun.height >> 1;
            addChild(wuyun);
            lostMC = new MovieClip(textureAtlas.getTextures("lost00"));
            lostMC.loop = true;
            lostMC.pivotX = lostMC.width >> 1;
            lostMC.pivotY = lostMC.height >> 1;
            addChild(lostMC);
         }
         positon();
      }
      
      public function setData(param1:Array, param2:Array, param3:Array) : void
      {
         var _loc7_:StaticNumerView = null;
         var _loc5_:TextField = null;
         var _loc4_:TextField = null;
         var _loc6_:TextField = null;
         var _loc11_:int = infotxt.x + infotxt.width + 230;
         var _loc9_:int = infotxt.y + 50;
         var _loc10_:int = 0;
         _loc10_ = 0;
         while(_loc10_ < param1.length)
         {
            _loc7_ = new StaticNumerView("num",param1[_loc10_],"+");
            addChild(_loc7_);
            _loc7_.x = _loc11_;
            _loc7_.y = _loc9_ + 60 * _loc10_;
            _loc7_.scaleX = _loc7_.scaleY = 0.5;
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < param2.length)
         {
            _loc5_ = new TextField(150,30,param2[_loc10_][0],"Verdana",22,16777215,true);
            _loc5_.y = 95 + 35 * _loc10_;
            bottomSprite.addChild(_loc5_);
            _loc4_ = new TextField(65,30,"LV " + param2[_loc10_][1],"Verdana",22,16777215,true);
            _loc4_.x = _loc5_.width + 60;
            _loc4_.y = 95 + 35 * _loc10_;
            bottomSprite.addChild(_loc4_);
            _loc6_ = new TextField(65,30,"+" + param2[_loc10_][2],"Verdana",22,16777215,true);
            _loc6_.x = _loc4_.x + _loc4_.width + 60;
            _loc6_.y = 95 + 35 * _loc10_;
            bottomSprite.addChild(_loc6_);
            _loc5_.autoScale = _loc4_.autoScale = _loc6_.autoScale = true;
            _loc10_++;
         }
         var _loc8_:int = 470;
         _loc10_ = 0;
         while(_loc10_ < param3.length)
         {
            _loc5_ = new TextField(150,30,param3[_loc10_][0],"Verdana",22,16777215,true);
            _loc5_.x = _loc8_;
            _loc5_.y = 95 + 35 * _loc10_;
            bottomSprite.addChild(_loc5_);
            _loc4_ = new TextField(65,30,"LV " + param3[_loc10_][1],"Verdana",22,16777215,true);
            _loc4_.x = _loc5_.x + _loc5_.width + 60;
            _loc4_.y = 95 + 35 * _loc10_;
            bottomSprite.addChild(_loc4_);
            _loc6_ = new TextField(65,30,"+" + param3[_loc10_][2],"Verdana",22,16777215,true);
            _loc6_.x = _loc4_.x + _loc4_.width + 60;
            _loc6_.y = 95 + 35 * _loc10_;
            bottomSprite.addChild(_loc6_);
            _loc5_.autoScale = _loc4_.autoScale = _loc6_.autoScale = true;
            _loc10_++;
         }
      }
      
      private function positon() : void
      {
         if(winer)
         {
            glow1.x = 470;
            glow1.y = 306;
            glow2.x = glow1.x;
            glow2.y = glow1.y;
            glow3.x = glow2.x;
            glow3.y = glow2.y;
         }
         else
         {
            wuyun.x = 450;
            wuyun.y = 100;
            lostMC.y = 100 + wuyun.height;
            lostMC.x = 300;
         }
         winOrlostImage.x = topSprite.width - winOrlostImage.width >> 1;
         rtopbg.y = winOrlostImage.height >> 1;
         infotxt.x = (rtopbg.width >> 1) + 20;
         infotxt.y = rtopbg.y + (rtopbg.height - infotxt.height >> 1);
         topSprite.x = 1365 - topSprite.width >> 1;
         bottomSprite.x = 1365 - bottomSprite.width >> 1;
         bottomSprite.y = 768 - bottomSprite.height;
         character.scaleX = character.scaleY = 0.7;
         if(winer)
         {
            character.x = 500;
         }
         else
         {
            character.x = 450;
         }
         character.y = 416;
      }
      
      public function play(param1:int = 3) : void
      {
         var rotation:Number;
         var time:int = param1;
         if(winer)
         {
            rotation = 2 * 3.141592653589793 * (time / 5);
            Starling.juggler.tween(glow1,time,{
               "rotation":rotation,
               "onComplete":function():void
               {
                  completeSignal.dispatch();
               }
            });
            Starling.juggler.tween(glow3,time,{"rotation":rotation});
            Starling.juggler.tween(glow2,time,{"rotation":-rotation});
         }
         else
         {
            Starling.juggler.add(lostMC);
            Starling.juggler.delayCall(function():void
            {
               completeSignal.dispatch();
            },time);
         }
         Starling.juggler.tween(topSprite,0.4,{"y":topSprite.y + 40});
         Starling.juggler.tween(bottomSprite,0.4,{"y":bottomSprite.y - 40});
      }
      
      override public function dispose() : void
      {
         CharacterFactory.instance.checkInCharacter(character);
         if(!winer)
         {
            Starling.juggler.remove(lostMC);
         }
         super.dispose();
      }
   }
}

