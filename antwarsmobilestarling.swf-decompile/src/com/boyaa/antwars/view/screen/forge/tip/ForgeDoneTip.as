package com.boyaa.antwars.view.screen.forge.tip
{
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class ForgeDoneTip extends UIExportSprite
   {
      
      public static const SYNTHESIS:int = 0;
      
      public static const ADDITION:int = 1;
      
      private const itemNum:int = 4;
      
      private var _choice:int = 0;
      
      private var _baseBefore:Array = [];
      
      private var _synthesisBefore:Array = [];
      
      protected var _markBg:Quad;
      
      private var _itemNameArr:Array = ["title","attr0","attr1","attr2","attr3"];
      
      private var _aniRunning:Boolean = false;
      
      public function ForgeDoneTip(param1:int = 0)
      {
         super();
         _markBg = new Quad(1365,768,0);
         _markBg.alpha = 0.2;
         this.addChildAt(_markBg,0);
         _choice = param1;
         init();
         addEventListener("addedToStage",onAddToStage);
      }
      
      private function onAddToStage(param1:Event) : void
      {
         removeEventListener("addedToStage",onAddToStage);
         stage.addEventListener("touch",onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(stage,"ended");
         if(_loc2_)
         {
            if(_aniRunning)
            {
               forceStopAnimation();
            }
            else
            {
               remove();
            }
         }
      }
      
      private function remove() : void
      {
         this.removeFromParent();
      }
      
      private function init() : void
      {
         var _loc3_:int = 0;
         var _loc2_:Sprite = null;
         _layout = new LayoutUitl(Assets.sAsset.getOther("synthesisView"));
         _layout.buildLayout("hccgTipLayout",_displayObj);
         var _loc1_:Array = LangManager.getLang.getLangArray("attr_tips");
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc2_ = getSpriteByName("attr" + _loc3_);
            getTextFieldByName("attrText",_loc2_).text = _loc1_[_loc3_] + ":";
            _loc3_++;
         }
         if(0 == _choice)
         {
            initSynthesis();
         }
         else
         {
            initAddition();
         }
      }
      
      private function initSynthesis() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Sprite = null;
         Image(getDisplayObjectByName("title")).texture = Assets.sAsset.getTexture("forgeHccgTitleImg");
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc1_ = getSpriteByName("attr" + _loc2_);
            Image(getDisplayObjectByName("img",_loc1_)).texture = Assets.sAsset.getTexture("forgePlusIcon");
            _loc2_++;
         }
      }
      
      private function initAddition() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Sprite = null;
         Image(getDisplayObjectByName("title")).texture = Assets.sAsset.getTexture("forgejccgTitleImg");
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc1_ = getSpriteByName("attr" + _loc2_);
            Image(getDisplayObjectByName("img",_loc1_)).texture = Assets.sAsset.getTexture("forgebg14");
            _loc2_++;
         }
      }
      
      private function animationIn() : void
      {
         var _loc2_:int = 0;
         var _loc1_:DisplayObject = null;
         Timepiece.instance.addDelayCall(animationOut,3000);
         _aniRunning = true;
         _loc2_ = 0;
         while(_loc2_ < _itemNameArr.length)
         {
            _loc1_ = getDisplayObjectByName(_itemNameArr[_loc2_]);
            TweenLite.from(_loc1_,0.3 * (_loc2_ + 1),{
               "alpha":0,
               "x":-200,
               "ease":Back.easeIn
            });
            _loc2_++;
         }
      }
      
      private function animationOut() : void
      {
         var _loc2_:int = 0;
         var _loc1_:DisplayObject = null;
         Timepiece.instance.removeFun(animationOut,2);
         _aniRunning = false;
         _loc2_ = 0;
         while(_loc2_ < _itemNameArr.length)
         {
            _loc1_ = getDisplayObjectByName(_itemNameArr[_loc2_]);
            if(_loc2_ < _itemNameArr.length - 1)
            {
               TweenLite.to(_loc1_,0.3 * (_loc2_ + 1),{
                  "alpha":0,
                  "x":_loc1_.x + 300,
                  "ease":Back.easeOut
               });
            }
            else
            {
               TweenLite.to(_loc1_,0.3 * (_loc2_ + 1),{
                  "alpha":0,
                  "x":_loc1_.x + 300,
                  "ease":Back.easeOut,
                  "onComplete":remove
               });
            }
            _loc2_++;
         }
         _loc1_ = getDisplayObjectByName("bg");
         TweenLite.to(_loc1_,1,{
            "alpha":0,
            "ease":Back.easeOut
         });
      }
      
      private function forceStopAnimation() : void
      {
         var _loc1_:int = 0;
         _aniRunning = false;
         Timepiece.instance.removeFun(animationOut,2);
         _loc1_ = 0;
         while(_loc1_ < _itemNameArr.length)
         {
            TweenLite.killTweensOf(getDisplayObjectByName(_itemNameArr[_loc1_]),true);
            _loc1_++;
         }
      }
      
      public function setBeforeForgeData(param1:GoodsData) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Sprite = null;
         _baseBefore = [param1.attack,param1.nimble,param1.defense,param1.lucky];
         _synthesisBefore = [param1.attackLevel,param1.nimbleLevel,param1.defenseLevel,param1.luckyLevel];
         _loc3_ = 0;
         while(_loc3_ < _baseBefore.length)
         {
            _loc2_ = getSpriteByName("attr" + _loc3_);
            getTextFieldByName("base_bold",_loc2_).text = _baseBefore[_loc3_] + "";
            getTextFieldByName("add_bold",_loc2_).color = 16777215;
            getTextFieldByName("add_bold",_loc2_).text = _synthesisBefore[_loc3_] * 10 + "";
            _loc3_++;
         }
      }
      
      public function setAfterForgeData(param1:GoodsData) : void
      {
         var _loc2_:Sprite = null;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:Array = [param1.attack,param1.nimble,param1.defense,param1.lucky];
         var _loc5_:Array = [param1.attackLevel,param1.nimbleLevel,param1.defenseLevel,param1.luckyLevel];
         if(0 == _choice)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc2_ = getSpriteByName("attr" + _loc6_);
               if(_synthesisBefore[_loc6_] < _loc5_[_loc6_])
               {
                  getTextFieldByName("add_bold",_loc2_).color = 16711680;
               }
               getTextFieldByName("add_bold",_loc2_).text = _loc5_[_loc6_] * 10 + "";
               _loc6_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_ = getSpriteByName("attr" + _loc4_);
               if(_baseBefore[_loc4_] < _loc3_[_loc4_])
               {
                  getTextFieldByName("add_bold",_loc2_).color = 16711680;
               }
               getTextFieldByName("add_bold",_loc2_).text = _loc3_[_loc4_] + "";
               _loc4_++;
            }
         }
      }
      
      public function show() : void
      {
         animationIn();
         Application.instance.currentGame.addChild(this);
      }
   }
}

