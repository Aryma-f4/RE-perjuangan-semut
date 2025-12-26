package com.boyaa.antwars.view.screen.battlefield.element
{
   import starling.animation.IAnimatable;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   
   public class AngerMovieClip extends Sprite implements IAnimatable
   {
      
      private var textureAtlas:ResAssetManager;
      
      private var bg:Image;
      
      private var charBg:Sprite;
      
      private var char:Image;
      
      private var charFg:Sprite;
      
      private var stones:Vector.<Image>;
      
      private var lines:Vector.<Image>;
      
      private var lightning:Vector.<MovieClip>;
      
      private var bigfire:MovieClip;
      
      private var stonePoints:Array;
      
      private var linePoints:Array;
      
      private var k:Number = 1;
      
      private var time:Number = 0;
      
      private var lightShow:Boolean = false;
      
      public function AngerMovieClip()
      {
         var _loc5_:int = 0;
         var _loc1_:Image = null;
         var _loc4_:Image = null;
         var _loc2_:MovieClip = null;
         super();
         textureAtlas = Assets.sAsset;
         bg = new Image(textureAtlas.getTexture("5ytdhgb"));
         bg.width = 1365;
         bg.height = 768;
         bg.alpha = 0;
         addChild(bg);
         charBg = new Sprite();
         addChild(charBg);
         charBg.x = 150;
         char = new Image(textureAtlas.getTexture("y6uykjik"));
         char.pivotX = (char.width >> 1) + 20;
         char.pivotY = char.height >> 1;
         char.scaleX = char.scaleY = 2;
         char.x = 1365 >> 1;
         char.y = 768 >> 1;
         char.alpha = 0;
         addChild(char);
         charFg = new Sprite();
         addChild(charFg);
         bigfire = new MovieClip(textureAtlas.getTextures("fire0"),20);
         bigfire.pivotX = bigfire.width >> 1;
         bigfire.pivotY = bigfire.height - 40;
         bigfire.x = 532;
         bigfire.y = 768;
         bigfire.width = 1365;
         bigfire.scaleY = bigfire.scaleX;
         bigfire.visible = false;
         charBg.addChild(bigfire);
         lines = new Vector.<Image>();
         linePoints = [[1,10,670,10],[3,40,768,20],[2,80,1800,30],[1,100,1700,30],[4,160,1400,30],[3,130,1300,30],[1,200,1100,30],[2,260,1560,30],[5,342,1430,30],[1,790,670,10],[3,820,768,20],[2,860,1800,30],[1,890,1700,30],[4,940,1400,30],[3,960,1300,30],[1,990,1100,30],[2,1015,1560,30]];
         _loc5_ = 0;
         while(_loc5_ < linePoints.length)
         {
            _loc1_ = new Image(textureAtlas.getTexture("lineio"));
            _loc1_.pivotX = _loc1_.width >> 1;
            _loc1_.pivotY = 0;
            _loc1_.scaleY = linePoints[_loc5_][0];
            _loc1_.x = linePoints[_loc5_][1];
            _loc1_.y = linePoints[_loc5_][2];
            _loc1_.alpha = 0.25;
            charBg.addChild(_loc1_);
            lines.push(_loc1_);
            _loc5_++;
         }
         stones = new Vector.<Image>();
         stonePoints = [[1,0,250,670,2,0],[0.6,1.6,548,768,2.5,1],[1,0.8,710,800,4,1],[1,2,450,268,3,1],[1.2,3,852,630,30,0],[0.5,1.6,990,500,8,0],[1,2.5,890,1000,10,1],[0.6,5.2,490,1800,20,1],[1.5,1.5,346,1400,15,0],[0.6,5,410,1300,18,0]];
         _loc5_ = 0;
         while(_loc5_ < stonePoints.length)
         {
            _loc4_ = new Image(textureAtlas.getTexture("yjh"));
            _loc4_.pivotX = _loc4_.width >> 1;
            _loc4_.pivotY = _loc4_.height >> 1;
            _loc4_.scaleX = _loc4_.scaleY = stonePoints[_loc5_][0];
            _loc4_.rotation = stonePoints[_loc5_][1];
            _loc4_.x = stonePoints[_loc5_][2];
            _loc4_.y = stonePoints[_loc5_][3];
            if(stonePoints[_loc5_][5] == 0)
            {
               charBg.addChild(_loc4_);
            }
            else
            {
               charFg.addChild(_loc4_);
            }
            _loc4_.visible = false;
            stones.push(_loc4_);
            _loc5_++;
         }
         lightning = new Vector.<MovieClip>();
         var _loc3_:Array = [[1.2,2.5,190,0,0],[-1.5,2,320,0,1],[-1.8,2,809,0,0]];
         _loc5_ = 0;
         while(_loc5_ < 3)
         {
            _loc2_ = new MovieClip(textureAtlas.getTextures("sd100"),10);
            _loc2_.pivotX = _loc2_.width >> 1;
            _loc2_.pivotY = 20;
            _loc2_.scaleX = _loc3_[_loc5_][0];
            _loc2_.scaleY = _loc3_[_loc5_][1];
            _loc2_.x = _loc3_[_loc5_][2];
            _loc2_.y = _loc3_[_loc5_][3];
            if(_loc3_[_loc5_][4] == 0)
            {
               charBg.addChild(_loc2_);
            }
            else
            {
               charFg.addChild(_loc2_);
            }
            _loc2_.visible = false;
            lightning.push(_loc2_);
            _loc5_++;
         }
         _loc3_ = [[0.5,2,650,768,0],[-0.6,2,900,768,0]];
         _loc5_ = 0;
         while(_loc5_ < 2)
         {
            _loc2_ = new MovieClip(textureAtlas.getTextures("sd100"),10);
            _loc2_.pivotX = _loc2_.width >> 1;
            _loc2_.pivotY = 20;
            _loc2_.rotation = 3.141592653589793;
            _loc2_.scaleX = _loc3_[_loc5_][0];
            _loc2_.scaleY = _loc3_[_loc5_][1];
            _loc2_.x = _loc3_[_loc5_][2];
            _loc2_.y = _loc3_[_loc5_][3];
            if(_loc3_[_loc5_][4] == 0)
            {
               charBg.addChild(_loc2_);
            }
            else
            {
               charFg.addChild(_loc2_);
            }
            _loc2_.visible = false;
            lightning.push(_loc2_);
            _loc5_++;
         }
         Starling.juggler.add(this);
      }
      
      public function advanceTime(param1:Number) : void
      {
         time += param1;
         if(time > 0.06)
         {
            time = 0;
            k = k > 0 ? -1 : 1;
            char.x += k;
         }
         if(bg.alpha < 0.8)
         {
            bg.alpha += 0.1;
         }
         else
         {
            start();
         }
      }
      
      private function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(char.alpha < 1)
         {
            char.alpha += 0.12;
         }
         if(char.alpha >= 1 && char.y > 200)
         {
            char.y -= 1.4;
         }
         _loc1_ = int(stones.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(stones[_loc2_].y > -100)
            {
               stones[_loc2_].y -= stonePoints[_loc2_][4];
            }
            _loc2_++;
         }
         _loc1_ = int(lines.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(lines[_loc2_].y > -300)
            {
               lines[_loc2_].y -= linePoints[_loc2_][3];
            }
            else
            {
               lines[_loc2_].y = linePoints[_loc2_][2];
            }
            _loc2_++;
         }
         if(!lightShow)
         {
            _loc1_ = int(lightning.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               lightning[_loc2_].visible = true;
               Starling.juggler.add(lightning[_loc2_]);
               _loc2_++;
            }
            _loc1_ = int(stones.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               stones[_loc2_].visible = true;
               _loc2_++;
            }
            bigfire.visible = true;
            Starling.juggler.add(bigfire);
            lightShow = true;
         }
      }
      
      public function remove(param1:Function) : void
      {
         var callBack:Function = param1;
         Starling.juggler.tween(this,0.5,{
            "alpha":0,
            "onComplete":function():void
            {
               removeFromParent(true);
               callBack();
            }
         });
      }
      
      override public function dispose() : void
      {
         Starling.juggler.remove(bigfire);
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = int(lightning.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            Starling.juggler.remove(lightning[_loc2_]);
            _loc2_++;
         }
         Starling.juggler.remove(this);
         super.dispose();
      }
   }
}

