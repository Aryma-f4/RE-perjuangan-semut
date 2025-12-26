package com.boyaa.antwars.view.screen.fresh
{
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.display.DlgMark;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class FreshGifts extends Sprite
   {
      
      private var markBg:DlgMark;
      
      private var _level:String = "1";
      
      protected var txtSprite:Sprite;
      
      private var goodsImg:Sprite;
      
      private var timer:Timer;
      
      private var star:StarTween;
      
      private var txtName1:TextField;
      
      private var txtName2:TextField;
      
      private var txtName3:TextField;
      
      private var txtNum1:TextField;
      
      private var txtNum2:TextField;
      
      private var txtNum3:TextField;
      
      private var goodsImg1:Image;
      
      private var goodsImg2:Image;
      
      private var goodsImg3:Image;
      
      private var pos1:Rectangle;
      
      private var pos2:Rectangle;
      
      private var pos3:Rectangle;
      
      public function FreshGifts(param1:int)
      {
         super();
         _level = param1.toString();
         init();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function init() : void
      {
         var _loc5_:Image = null;
         var _loc6_:Array = null;
         var _loc4_:Image = null;
         var _loc1_:Image = null;
         var _loc9_:Rectangle = null;
         var _loc8_:Image = null;
         var _loc11_:int = 0;
         markBg = new DlgMark();
         var _loc7_:Image = new Image(Assets.sAsset.getTexture("bg3"));
         Assets.positionDisplay(_loc7_,"freshGifts","bg");
         addChild(_loc7_);
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("gift0"));
         Assets.positionDisplay(_loc3_,"freshGifts","title");
         addChild(_loc3_);
         var _loc10_:Image = new Image(Assets.sAsset.getTexture("gift1"));
         Assets.positionDisplay(_loc10_,"freshGifts","levelBg");
         addChild(_loc10_);
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("gift4"));
         Assets.positionDisplay(_loc2_,"freshGifts","levelUp");
         addChild(_loc2_);
         if(_level.length < 2)
         {
            _loc5_ = new Image(Assets.sAsset.getTexture("num" + _level));
            Assets.positionDisplay(_loc5_,"freshGifts","level");
            addChild(_loc5_);
         }
         else
         {
            _loc6_ = _level.split("");
            _loc4_ = new Image(Assets.sAsset.getTexture("num" + _loc6_[0]));
            _loc1_ = new Image(Assets.sAsset.getTexture("num" + _loc6_[1]));
            _loc9_ = Assets.getPosition("freshGifts","level");
            _loc4_.width = _loc1_.width = _loc9_.width;
            _loc4_.height = _loc1_.height = _loc9_.height;
            _loc4_.x = _loc9_.x - _loc4_.width / 2;
            _loc4_.y = _loc9_.y;
            addChild(_loc4_);
            _loc1_.x = _loc4_.x + _loc4_.width;
            _loc1_.y = _loc4_.y;
            addChild(_loc1_);
         }
         _loc11_ = 0;
         while(_loc11_ < 3)
         {
            _loc8_ = new Image(Assets.sAsset.getTexture("qd15"));
            Assets.positionDisplay(_loc8_,"freshGifts","box" + _loc11_);
            addChild(_loc8_);
            _loc11_++;
         }
         txtNum1 = new TextField(80,40,"","Verdana",28,16776960,true);
         txtNum2 = new TextField(80,40,"","Verdana",28,16776960,true);
         txtNum3 = new TextField(80,40,"","Verdana",28,16776960,true);
         Assets.positionDisplay(txtNum1,"freshGifts","num0");
         Assets.positionDisplay(txtNum2,"freshGifts","num1");
         Assets.positionDisplay(txtNum3,"freshGifts","num2");
         txtNum1.hAlign = txtNum2.hAlign = txtNum3.hAlign = "right";
         txtName1 = new TextField(157,28,"","Verdana",24,16777215,true);
         Assets.positionDisplay(txtName1,"freshGifts","name0");
         txtName2 = new TextField(157,28,"","Verdana",24,16777215,true);
         Assets.positionDisplay(txtName2,"freshGifts","name1");
         txtName3 = new TextField(157,28,"","Verdana",24,16777215,true);
         Assets.positionDisplay(txtName3,"freshGifts","name2");
         txtName1.autoScale = txtName2.autoScale = txtName3.autoScale = true;
         txtName1.nativeFilters = txtName2.nativeFilters = txtName3.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
         star = new StarTween(this);
         update();
         timer = new Timer(3000);
         timer.addEventListener("timer",onTimer);
      }
      
      private function update() : void
      {
         var onlyID:int;
         pos1 = Assets.getPosition("freshGifts","goodsImg0");
         pos2 = Assets.getPosition("freshGifts","goodsImg1");
         pos3 = Assets.getPosition("freshGifts","goodsImg2");
         switch(_level)
         {
            case "1":
               goodsImg1 = Assets.sAsset.getGoodsImageByRect(26,3,pos1);
               goodsImg2 = Assets.sAsset.getGoodsImageByRect(25,1013,pos2);
               txtName1.text = ShopDataList.instance.getSingleData(26,3).name;
               txtName2.text = ShopDataList.instance.getSingleData(25,1011).name;
               txtNum1.text = "X1";
               txtNum2.text = "X1";
               onlyID = int(GoodsList.instance.getOnlyIDArr(25,1011)[0]);
               break;
            case "3":
               goodsImg1 = Assets.sAsset.getGoodsImageByRect(26,3,pos1);
               goodsImg2 = Assets.sAsset.getGoodsImageByRect(7,1031,pos2);
               goodsImg3 = Assets.sAsset.getGoodsImageByRect(25,1013,pos3);
               txtName1.text = ShopDataList.instance.getSingleData(26,3).name;
               txtName2.text = ShopDataList.instance.getSingleData(7,1031).name;
               txtName3.text = ShopDataList.instance.getSingleData(25,1013).name;
               txtNum1.text = "X2";
               txtNum2.text = "X1";
               txtNum3.text = "X1";
               onlyID = int(GoodsList.instance.getOnlyIDArr(25,1012)[0]);
               break;
            case "5":
               goodsImg1 = Assets.sAsset.getGoodsImageByRect(26,3,pos1);
               goodsImg2 = Assets.sAsset.getGoodsImageByRect(2,1031,pos2);
               goodsImg3 = Assets.sAsset.getGoodsImageByRect(15,1013,pos3);
               txtName1.text = ShopDataList.instance.getSingleData(26,3).name;
               txtName2.text = ShopDataList.instance.getSingleData(2,1031).name;
               txtName3.text = ShopDataList.instance.getSingleData(15,1013).name;
               txtNum1.text = "X3";
               txtNum2.text = "X1";
               txtNum3.text = "X5";
               onlyID = int(GoodsList.instance.getOnlyIDArr(25,1013)[0]);
               break;
            case "8":
               goodsImg1 = Assets.sAsset.getGoodsImageByRect(26,3,pos1);
               goodsImg2 = Assets.sAsset.getGoodsImageByRect(6,1031,pos2);
               goodsImg3 = Assets.sAsset.getGoodsImageByRect(25,1015,pos3);
               txtName1.text = ShopDataList.instance.getSingleData(26,3).name;
               txtName2.text = ShopDataList.instance.getSingleData(6,1031).name;
               txtName3.text = ShopDataList.instance.getSingleData(25,1015).name;
               txtNum1.text = "X4";
               txtNum2.text = "X1";
               txtNum3.text = "X1";
               onlyID = int(GoodsList.instance.getOnlyIDArr(25,1014)[0]);
               break;
            case "10":
               goodsImg1 = Assets.sAsset.getGoodsImageByRect(26,3,pos1);
               goodsImg2 = Assets.sAsset.getGoodsImageByRect(1,1031,pos2);
               goodsImg3 = Assets.sAsset.getGoodsImageByRect(15,1013,pos3);
               txtName1.text = ShopDataList.instance.getSingleData(26,3).name;
               txtName2.text = ShopDataList.instance.getSingleData(1,1031).name;
               txtName3.text = ShopDataList.instance.getSingleData(15,1013).name;
               txtNum1.text = "X5";
               txtNum2.text = "X1";
               txtNum3.text = "X5";
               onlyID = int(GoodsList.instance.getOnlyIDArr(25,1015)[0]);
         }
         addChild(goodsImg1);
         addChild(goodsImg2);
         if(goodsImg3)
         {
            addChild(goodsImg3);
         }
         addChild(txtNum1);
         addChild(txtNum2);
         if(txtNum3)
         {
            addChild(txtNum3);
         }
         addChild(txtName1);
         addChild(txtName2);
         if(txtName3)
         {
            addChild(txtName3);
         }
         GameServer.instance.useGoods(onlyID,function(param1:Object):void
         {
         });
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         SoundManager.playSound("sound 27");
         this.removeEventListener("addedToStage",onAddedToStage);
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
         this.pivotX = this.width / 2;
         this.pivotY = this.height / 2;
         this.x = this.width / 2 + 180;
         this.y = this.height / 2 + 80;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.5,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut"
         });
         timer.start();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         timer.stop();
         timer.removeEventListener("timer",onTimer);
         Starling.juggler.tween(this,0.2,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":cleanUp
         });
      }
      
      private function cleanUp() : void
      {
         star.cleanUp();
         timer = null;
         Starling.juggler.removeTweens(this);
         markBg.removeFromParent();
         this.removeFromParent();
      }
   }
}

