package com.boyaa.antwars.view.screen.battlefield.element
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.copygame.Star;
   import com.boyaa.antwars.view.vipSystem.VipManager;
   import flash.filters.DropShadowFilter;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class PokerView extends Sprite
   {
      
      public static const ONE_LINE_CARD_NUM:int = 6;
      
      private var bg:Image;
      
      private var titleImage:Image;
      
      public var timeView:TimerView;
      
      private var textureAtlas:ResAssetManager;
      
      private var _pokerNum:int = 12;
      
      private var _pokerNumSelf:int = 1;
      
      private var errorMsg:String = "";
      
      private var _noTurnPokerIdArr:Array = [];
      
      private var pokerItems:Vector.<PokerItem>;
      
      private var pokerMove:int = 30;
      
      public var showTimeView:Boolean = true;
      
      public var expText:TextField;
      
      private var vipExpText:TextField;
      
      private var _vipExp:int;
      
      public var star:Star;
      
      public var clickPokerSignal:Signal;
      
      public var disableMsg:String = null;
      
      private var canOverturnPoker:Boolean = false;
      
      public function PokerView(param1:int = 1)
      {
         super();
         _pokerNumSelf = param1;
         if(_pokerNumSelf <= 0)
         {
            errorMsg = LangManager.t("noReward");
         }
         else
         {
            if(PlayerDataList.instance.selfData.vipLevel >= 3)
            {
               _pokerNumSelf = _pokerNumSelf + 1;
            }
            errorMsg = LangManager.t("open") + _pokerNumSelf + LangManager.t("pokerNum");
         }
         clickPokerSignal = new Signal(int);
         textureAtlas = Assets.sAsset;
         expText = new TextField(200,60,"","AvenirNextCondensed-HeavyItalic",50,16777215,true);
         expText.autoScale = true;
         expText.nativeFilters = [new DropShadowFilter(0,45,16776960,1,3.2,3.2,10)];
         expText.hAlign = "center";
         vipExpText = new TextField(200,60,"","AvenirNextCondensed-HeavyItalic",50,267386880,true);
         vipExpText.autoScale = true;
         vipExpText.nativeFilters = [new DropShadowFilter(0,45,16776960,1,3.2,3.2,10)];
         vipExpText.hAlign = "center";
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var _loc3_:Sprite = null;
         var _loc2_:Image = null;
         var _loc9_:int = 0;
         var _loc4_:PokerItem = null;
         this.removeEventListener("addedToStage",onAddedToStage);
         bg = new Image(textureAtlas.getTexture("resultbg"));
         bg.width = 1365 + 60;
         bg.height = 768 + 60;
         addChild(bg);
         bg.x = -30;
         bg.y = -30;
         titleImage = new Image(textureAtlas.getTexture("rtitle"));
         titleImage.x = 1365 - titleImage.width >> 1;
         titleImage.y = 50;
         addChild(titleImage);
         var _loc5_:Number = titleImage.y + titleImage.height + 10;
         var _loc8_:Quad = new Quad(1365 >> 1,4,13871411);
         _loc8_.setVertexAlpha(0,0);
         _loc8_.setVertexAlpha(1,1);
         _loc8_.setVertexAlpha(2,0);
         _loc8_.setVertexAlpha(3,1);
         _loc8_.y = _loc5_;
         addChild(_loc8_);
         var _loc10_:Quad = new Quad(1365 >> 1,4,13871411);
         _loc10_.setVertexAlpha(0,1);
         _loc10_.setVertexAlpha(1,0);
         _loc10_.setVertexAlpha(2,1);
         _loc10_.setVertexAlpha(3,0);
         _loc10_.x = _loc8_.width;
         _loc10_.y = _loc5_;
         addChild(_loc10_);
         if(showTimeView)
         {
            timeView = new TimerView();
            addChild(timeView);
            timeView.x = 1365 - timeView.width >> 1;
            timeView.y = _loc8_.y + 5;
         }
         else
         {
            star = new Star();
            star.scaleX = star.scaleY = 2;
            star.x = (1365 >> 1) - star.width - 20;
            star.y = _loc8_.y + 50;
            addChild(star);
            _loc3_ = new Sprite();
            _loc2_ = new Image(Assets.sAsset.getTexture("rwExp"));
            _loc3_.addChild(_loc2_);
            expText.scaleX = expText.scaleY = 0;
            expText.x = _loc2_.width;
            expText.y = 15;
            vipExpText.scaleX = vipExpText.scaleY = 0;
            vipExpText.x = expText.x + expText.textBounds.width + 20;
            vipExpText.y = 15;
            _loc3_.addChild(expText);
            _loc3_.addChild(vipExpText);
            _loc3_.x = 702;
            _loc3_.y = _loc8_.y + 30;
            addChild(_loc3_);
            Starling.juggler.tween(expText,1,{
               "scaleX":1,
               "scaleY":1,
               "transition":"easeOutBack"
            });
            Starling.juggler.tween(vipExpText,1,{
               "scaleX":1,
               "scaleY":1,
               "transition":"easeOutBack"
            });
         }
         var _loc7_:Number = 0;
         pokerItems = new Vector.<PokerItem>();
         var _loc6_:Number = 10;
         _loc9_ = 0;
         while(_loc9_ < pokerNum)
         {
            _loc4_ = new PokerItem(_loc9_);
            pokerItems.push(_loc4_);
            _loc4_.visible = false;
            addChild(_loc4_);
            _loc4_.addEventListener("triggered",onClickPokerItem);
            if(_loc9_ == 0)
            {
               _loc7_ = (Assets.width - _loc4_.width * 6) / (6 + 1);
            }
            if(_loc9_ < 6)
            {
               _loc4_.x = Assets.leftTop.x + _loc7_ * (_loc9_ + 1) + _loc4_.width * _loc9_;
            }
            else
            {
               _loc4_.x = Assets.leftTop.x + _loc7_ * (_loc9_ - 6 + 1) + _loc4_.width * (_loc9_ - 6);
            }
            if(_loc9_ < 6)
            {
               _loc4_.y = Assets.leftTop.y + (Assets.height - _loc4_.height >> 1) + _loc6_;
            }
            else
            {
               _loc4_.y = Assets.leftTop.y + (Assets.height - _loc4_.height >> 1) + _loc6_ + _loc4_.height + 10;
            }
            _noTurnPokerIdArr.push(_loc9_);
            _loc9_++;
         }
      }
      
      public function play(param1:int) : void
      {
         var _loc2_:int = 0;
         timeView && timeView.start(param1);
         _loc2_ = 0;
         while(_loc2_ < pokerNum)
         {
            Starling.juggler.delayCall(playDealPoker,0.08 * _loc2_,pokerItems[_loc2_],_loc2_);
            _loc2_++;
         }
      }
      
      public function playDealPoker(param1:PokerItem, param2:int) : void
      {
         var pokeritem:PokerItem = param1;
         var i:int = param2;
         pokeritem.visible = true;
         if(i != pokerNum - 1)
         {
            Starling.juggler.tween(pokeritem,0.2,{"y":pokeritem.y - pokerMove});
         }
         else
         {
            Starling.juggler.tween(pokeritem,0.2,{
               "y":pokeritem.y - pokerMove,
               "onComplete":function():void
               {
                  canOverturnPoker = true;
               }
            });
         }
      }
      
      public function autoTurnCard() : void
      {
         _pokerNumSelf = _pokerNumSelf - 1;
         var _loc1_:int = int(PlayerDataList.instance.selfData.siteID);
         if(_loc1_ > _noTurnPokerIdArr.length)
         {
            clickPokerSignal.dispatch(_noTurnPokerIdArr[_noTurnPokerIdArr.length - 1]);
            _noTurnPokerIdArr.pop();
         }
         else
         {
            clickPokerSignal.dispatch(_loc1_);
            _noTurnPokerIdArr.splice(_loc1_,1);
         }
      }
      
      public function onClickPokerItem(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(!canOverturnPoker)
         {
            return;
         }
         var _loc3_:PokerItem = param1.currentTarget as PokerItem;
         if(!disableMsg)
         {
            if(_noTurnPokerIdArr.indexOf(_loc3_.id) == -1)
            {
               return;
            }
            if(_loc3_.id >= 6)
            {
               _loc2_ = VipManager.instance.getVipPowerTimes(7,PlayerDataList.instance.selfData.vipLevel);
               if(_loc2_ <= 0)
               {
                  TextTip.instance.showByLang("vipTurnCardFailTip");
                  return;
               }
            }
            if(pokerNumSelf == 0)
            {
               TextTip.instance.show(errorMsg);
            }
            else
            {
               clickPokerSignal.dispatch(_loc3_.id);
               _noTurnPokerIdArr.splice(_noTurnPokerIdArr.indexOf(_loc3_.id),1);
            }
         }
         else
         {
            TextTip.instance.show(disableMsg);
         }
      }
      
      public function overturnPoker(param1:int, param2:*, param3:Function) : void
      {
         _noTurnPokerIdArr.splice(param1,1);
         pokerItems[param1].play(param3);
         if(param2)
         {
            if(param2 is GoodsData)
            {
               pokerItems[param1].setData(param2 as GoodsData);
            }
            else if(param2.hasOwnProperty("goldCount") && param2.goldCount > 0)
            {
               pokerItems[param1].setGold(param2.goldCount);
            }
            else if(param2.hasOwnProperty("prop"))
            {
               pokerItems[param1].setDataById(param2.prop[0],param2.prop[1]);
            }
            else
            {
               pokerItems[param1].setGold(0);
            }
            if(param2.hasOwnProperty("uname"))
            {
               pokerItems[param1].setUserName(param2.uname);
            }
            if(param2.hasOwnProperty("uid") && param2.uid == PlayerDataList.instance.selfData.uid)
            {
               trace("自己翻的牌，计数-1");
               _pokerNumSelf = _pokerNumSelf - 1;
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         trace("[PokerView] dispose");
         _loc1_ = 0;
         while(_loc1_ < pokerNum)
         {
            pokerItems[_loc1_].removeEventListener("triggered",onClickPokerItem);
            _loc1_++;
         }
         pokerItems = null;
         super.dispose();
      }
      
      public function get pokerNumSelf() : int
      {
         return _pokerNumSelf;
      }
      
      public function get pokerNum() : int
      {
         var _loc1_:Array = ["BATTLEFIELD","ROBOTBATTLEFIELD","ROBOT_2VS2_BATTLEFIELD"];
         if(_loc1_.indexOf(Application.instance.currentGame.navigator.activeScreenID) != -1)
         {
            return 6 * 2;
         }
         return 6;
      }
      
      public function get vipExp() : int
      {
         return _vipExp;
      }
      
      public function set vipExp(param1:int) : void
      {
         _vipExp = param1;
         vipExpText.text = "+" + param1;
      }
   }
}

