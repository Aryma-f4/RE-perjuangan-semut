package com.boyaa.antwars.helper.autoFight
{
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.monster.Monster;
   import com.boyaa.antwars.view.screen.battlefield.BtUILayer;
   import com.boyaa.antwars.view.screen.battlefield.element.SelfCharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.SkillBox;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.UseSkillData;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.UseSkillManager;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class AutoFightManager
   {
      
      private static var _instance:AutoFightManager = null;
      
      private var _selfCharcterCtrl:SelfCharacterCtrl;
      
      private var _skillBoxs:Vector.<SkillBox>;
      
      private var _skillDataArr:Vector.<UseSkillData>;
      
      private var _isRunning:Boolean = false;
      
      private var _skillUseRule:Array = [[1,3],[0,3],[2,1],[2,0]];
      
      private var _attckTarget:DisplayObject;
      
      private var _mark:DlgMark = new DlgMark();
      
      private var _text:TextField;
      
      private var _btUILayer:BtUILayer;
      
      private var _callBackParam:Object = null;
      
      private var _autoTrunCallBack:Function = null;
      
      public function AutoFightManager(param1:Single)
      {
         super();
         _text = StarlingUITools.instance.createTextField("",1365 / 2,768 / 2,600,100);
         _text.fontSize = 70;
         _text.bold = true;
         _text.text = LangManager.t("autoFightTip");
         _text.nativeFilters = StarlingUITools.instance.getGlowFilter();
         _text.x -= _text.textBounds.width / 2;
         _text.y -= _text.textBounds.height / 2;
      }
      
      public static function get instance() : AutoFightManager
      {
         if(_instance == null)
         {
            _instance = new AutoFightManager(new Single());
         }
         return _instance;
      }
      
      public function setBTUILLayer(param1:BtUILayer) : void
      {
         _btUILayer = param1;
      }
      
      public function startShoot(param1:SelfCharacterCtrl) : void
      {
         if(!isRunning)
         {
            return;
         }
         if(!param1.isCtrl || param1.isDie)
         {
            return;
         }
         _selfCharcterCtrl = param1;
         addEvent();
         findTarget();
         move();
         _btUILayer.addChild(_text);
      }
      
      public function stop() : void
      {
         _isRunning = false;
         removeEvent();
         _text.removeFromParent();
      }
      
      private function move() : void
      {
         if(Application.instance.currentGame.navigator.activeScreenID == "LEIENTWORLD")
         {
            return;
         }
         var _loc2_:int = _selfCharcterCtrl.character.x - _attckTarget.x;
         var _loc3_:int = 100;
         var _loc1_:int = 30;
         if(Math.abs(_loc2_) <= _loc3_)
         {
            _selfCharcterCtrl.moveInAutoFight(_loc2_);
         }
      }
      
      public function autoTurnPocket(param1:Function, param2:Object = null) : void
      {
         _callBackParam = param2;
         _autoTrunCallBack = param1;
         if(isRunning)
         {
            Timepiece.instance.addDelayCall(autoTurnCallBack,2000);
         }
      }
      
      private function autoTurnCallBack() : void
      {
         if(_callBackParam != null)
         {
            _autoTrunCallBack(_callBackParam);
         }
         else
         {
            _autoTrunCallBack();
         }
      }
      
      private function addEvent() : void
      {
         Timepiece.instance.addDelayCall(initFightGoods,500);
         Timepiece.instance.addDelayCall(shoot,3000);
      }
      
      private function removeEvent() : void
      {
         Timepiece.instance.removeFun(initFightGoods,2);
         Timepiece.instance.removeFun(shoot,2);
      }
      
      private function findTarget() : void
      {
         var _loc4_:int = 0;
         var _loc3_:DisplayObject = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:Sprite = _selfCharcterCtrl.gameworld.charatersLayer;
         var _loc2_:Array = [];
         _loc4_ = 0;
         for(; _loc4_ <= _loc1_.numChildren - 1; _loc4_++)
         {
            _loc3_ = _loc1_.getChildAt(_loc4_);
            if(_loc3_ is ICharacter)
            {
               if(_loc3_ is Character)
               {
                  if(PlayerDataList.instance.getDataBySiteID(Character(_loc3_).characterCtrl.siteID).team == PlayerDataList.instance.selfData.team)
                  {
                     continue;
                  }
               }
               if(_loc3_ is Monster)
               {
                  if(Monster(_loc3_).data.influ_through == 0)
                  {
                     continue;
                  }
               }
               _loc2_.push(_loc3_);
            }
         }
         _loc5_ = 0;
         while(_loc5_ < _selfCharcterCtrl.gameworld.mapBackCharatersLayer.numChildren - 1)
         {
            _loc3_ = _selfCharcterCtrl.gameworld.mapBackCharatersLayer.getChildAt(_loc5_);
            if(_loc3_ is ICharacter)
            {
               _loc2_.push(_loc3_);
            }
            _loc5_++;
         }
         _attckTarget = SmallCodeTools.instance.getRandItemInArr(_loc2_) as DisplayObject;
         _loc6_ = 0;
         while(_loc6_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc6_];
            _loc4_ = _loc6_ + 1;
            while(_loc4_ < _loc2_.length)
            {
               if(ICharacter(_loc2_[_loc6_]).icharacterCtrl.hp > ICharacter(_loc2_[_loc4_]).icharacterCtrl.hp)
               {
                  _loc2_[_loc6_] = _loc2_[_loc4_];
                  _loc2_[_loc4_] = _loc3_;
                  _loc3_ = _loc2_[_loc6_];
               }
               _loc4_++;
            }
            _loc6_++;
         }
      }
      
      private function shoot() : void
      {
         _selfCharcterCtrl.shootTargetInAuto(_attckTarget);
      }
      
      private function initFightGoods() : void
      {
         var _loc4_:int = 0;
         _skillDataArr = UseSkillManager.instance.skillDataVector;
         var _loc1_:Vector.<UseSkillData> = new Vector.<UseSkillData>();
         for each(var _loc3_ in _skillDataArr)
         {
            if(_loc3_.isEnable)
            {
               if(_loc3_.id == 11 || _loc3_.id == 12)
               {
                  if(_selfCharcterCtrl.hp / _selfCharcterCtrl.maxHp * 100 <= 30)
                  {
                     _selfCharcterCtrl.useSkillById(_loc3_.id);
                  }
               }
               else
               {
                  _loc1_.push(_loc3_);
               }
            }
         }
         if(_selfCharcterCtrl.gameworld.UILayer.bomb.bombValue >= 100)
         {
            SoundManager.playSound("sound 17");
            _selfCharcterCtrl.gameworld.UILayer.bomb.bombValue = 0;
            _selfCharcterCtrl.gameworld.UILayer.bombSignal.dispatch();
         }
         var _loc2_:Array = _skillUseRule[MathHelper.randomWithinRange(0,_skillUseRule.length - 1)].concat();
         trace("自动战斗-使用技能：",JSON.stringify(_loc2_));
         _loc4_ = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc4_];
            if(_selfCharcterCtrl.actionPoint < GoodsList.instance.getMyFightGoodsMinActionPoint())
            {
               break;
            }
            if(_loc2_.length != 0 && _loc2_[0] == _loc3_.id)
            {
               if(_loc3_.id == 2)
               {
                  trace("");
               }
               _selfCharcterCtrl.useSkillById(_loc3_.id);
               _loc2_.shift();
               _loc4_ = 0;
            }
            else if(_loc2_.length == 0)
            {
               _selfCharcterCtrl.useSkillById(_loc3_.id);
            }
            _loc4_++;
         }
      }
      
      public function get selfCharcterCtrl() : SelfCharacterCtrl
      {
         return _selfCharcterCtrl;
      }
      
      public function get isRunning() : Boolean
      {
         return _isRunning;
      }
      
      public function set isRunning(param1:Boolean) : void
      {
         _isRunning = param1;
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
