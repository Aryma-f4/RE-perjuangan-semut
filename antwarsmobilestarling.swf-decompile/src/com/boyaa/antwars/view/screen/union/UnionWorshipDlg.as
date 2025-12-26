package com.boyaa.antwars.view.screen.union
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.sound.HelpDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.layout.HorizontalLayout;
   import starling.display.Button;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class UnionWorshipDlg extends UnionCoreDlg
   {
      
      private var _closeBtn:Button;
      
      private var _worshipList:List;
      
      private var _worshipTime:int;
      
      private var _vipWorship:int = 0;
      
      private var _worshiped:int;
      
      private var _unionWorshipRewardBtn:FashionStarlingButton;
      
      public function UnionWorshipDlg()
      {
         super();
      }
      
      override protected function getRawAssets() : Array
      {
         _rawAssets = [rmger.getResFile(formatString("asset/UnionWorship.info")),rmger.getResFile(formatString("textures/{0}x/Union/UnionWorship.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/Union/UnionWorship.xml",Assets.sAsset.scaleFactor))];
         return _rawAssets;
      }
      
      override protected function loadAssetDone(param1:int) : void
      {
         var _loc2_:LayoutUitl = null;
         var _loc3_:HorizontalLayout = null;
         if(param1 == 1)
         {
            _loc2_ = new LayoutUitl(_asset.getOther("UnionWorship"),_asset);
            _loc2_.buildLayout("UnionWorshipLayOut",_displayObj);
            getButtonByName("btnS_close").addEventListener("triggered",onclose);
            _worshipList = new List();
            _worshipList.width = 850;
            _worshipList.height = 470;
            _worshipList.x = 78;
            _worshipList.y = 147;
            _displayObj.addChild(_worshipList);
            _unionWorshipRewardBtn = new FashionStarlingButton(getButtonByName("btnS_UnionWorshipRewardBtn"));
            _unionWorshipRewardBtn.triggerFunction = unionWorshipRewardHandel;
            getButtonByName("btnS_UnionWorshipInfoBtn").addEventListener("triggered",onHelpHandle);
            _loc3_ = new HorizontalLayout();
            _loc3_.verticalAlign = "justify";
            _loc3_.gap = 30;
            _worshipList.layout = _loc3_;
            _worshipList.itemRendererType = UnionWorshipItemRender;
            LoadData.show(this);
            EventCenter.PHPEvent.addEventListener("getUnionMember",getUnionMemberHandler);
            Remoting.instance.gameTable.getUnionMember();
            LoadData.show(this);
            EventCenter.PHPEvent.addEventListener("getWorshipInfoDone",getUnionWorshipHandler);
            Remoting.instance.gameTable.getWorshipInfo();
            UnionManager.getInstance().addEventListener("worshipThisBody",worshipThisBody);
            SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
         }
         super.loadAssetDone(param1);
      }
      
      private function onHelpHandle(param1:Event) : void
      {
         HelpDlg.show(LangManager.t("unionWorldShipHelp"));
      }
      
      private function unionWorshipRewardHandel(param1:Event) : void
      {
         if(_worshiped == 0)
         {
            TextTip.instance.showByLang("unionNoWorshiped");
            return;
         }
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("getWorshipDone",worshipRewardDone);
         Remoting.instance.gameTable.getWorshipReward();
      }
      
      private function worshipRewardDone(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         if(_loc3_.ret == 0)
         {
            _worshiped = 0;
            _unionWorshipRewardBtn.isGray = true;
            UnionManager.getInstance().myUnionModel.mdevote = UnionManager.getInstance().myUnionModel.mdevote + _loc3_.addedDevote;
            TextTip.instance.show(LangManager.getLang.getreplaceLang("worshipReceiveMyDevote",_loc3_.addedDevote));
            refreshWorshipInfo();
         }
         else
         {
            TextTip.instance.show(_loc3_.msg);
         }
      }
      
      private function worshipThisBody(param1:UnionEvent) : void
      {
         var _loc2_:PlayerData = null;
         if(_worshipTime <= 0)
         {
            TextTip.instance.showByLang("TodayWorshiped");
            return;
         }
         _loc2_ = param1.eventData as PlayerData;
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("worshipDone",worshipDone);
         Remoting.instance.gameTable.worship(_loc2_.uid);
      }
      
      private function worshipDone(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         if(_loc3_.ret == 0)
         {
            if(_vipWorship == 0)
            {
               _worshipTime = _worshipTime - 1;
            }
            else
            {
               _vipWorship = _vipWorship - 1;
            }
            if(_worshipTime <= 0)
            {
               UnionWorshipItemRender.isBtnGray = true;
            }
            UnionManager.getInstance().myUnionModel.mdevote = UnionManager.getInstance().myUnionModel.mdevote + _loc3_.addedDevote;
            TextTip.instance.show(LangManager.getLang.getreplaceLang("worshipReceiveMyDevote",_loc3_.addedDevote));
            refreshWorshipInfo();
         }
         else
         {
            TextTip.instance.show(LangManager.replace("unionworshipLevel",5));
         }
      }
      
      private function getUnionWorshipHandler(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         if(_loc3_.ret == 0)
         {
            _worshipTime = _loc3_.oddtimes - _loc3_.extratimes;
            _vipWorship = _loc3_.extratimes;
            if(_worshipTime == 0)
            {
               UnionWorshipItemRender.isBtnGray = true;
            }
            _worshiped = _loc3_.worshiped.length;
            if(_worshiped == 0)
            {
               _unionWorshipRewardBtn.isGray = true;
            }
            else
            {
               _unionWorshipRewardBtn.isGray = false;
            }
            refreshWorshipInfo();
         }
         else
         {
            TextTip.instance.show(_loc3_.msg);
         }
      }
      
      private function refreshWorshipInfo() : void
      {
         (this._displayObj.getChildByName("leftTF") as TextField).text = LangManager.getLang.getreplaceLang("UnionWorshipLeftNum",_worshipTime);
         (this._displayObj.getChildByName("vipTimeTF") as TextField).text = LangManager.getLang.getreplaceLang("UnionWorshipVipLeft",_vipWorship);
         (this._displayObj.getChildByName("numTF") as TextField).text = LangManager.getLang.getreplaceLang("UnionWorshipNum",_worshiped);
      }
      
      private function getUnionMemberHandler(param1:PHPEvent) : void
      {
         var _loc6_:Array = null;
         var _loc5_:int = 0;
         var _loc4_:PlayerData = null;
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         if(_loc3_.ret == 0)
         {
            _loc6_ = [];
            _loc5_ = 0;
            while(_loc5_ < _loc3_.list.length)
            {
               _loc4_ = new PlayerData();
               _loc4_.addData(_loc3_.list[_loc5_]);
               _loc4_.addOtherPropInfo(_loc3_.list[_loc5_][17]);
               if(PlayerDataList.instance.selfData.level < _loc4_.level)
               {
                  _loc6_.push(_loc4_);
               }
               _loc5_++;
            }
            _worshipList.dataProvider = new ListCollection(_loc6_);
            return;
         }
         throw new Error(_loc3_.msg);
      }
      
      private function onclose(param1:Event) : void
      {
         this.deactive();
      }
   }
}

import com.boyaa.antwars.control.UnionManager;
import com.boyaa.antwars.data.model.GoodsData;
import com.boyaa.antwars.data.model.PlayerData;
import com.boyaa.antwars.data.model.ShopData;
import com.boyaa.antwars.helper.tools.FashionStarlingButton;
import com.boyaa.antwars.view.character.Character;
import com.boyaa.antwars.view.character.CharacterFactory;
import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

class UnionWorshipItemRender extends ListItemRenderer
{
   
   private static var _isBtnGray:Boolean = false;
   
   private var _layout:LayoutUitl;
   
   private var _asset:ResAssetManager;
   
   private var _unionWorshipItemBtn:FashionStarlingButton;
   
   private var character:Character;
   
   public function UnionWorshipItemRender()
   {
      super();
   }
   
   public static function get isBtnGray() : Boolean
   {
      return _isBtnGray;
   }
   
   public static function set isBtnGray(param1:Boolean) : void
   {
      _isBtnGray = param1;
   }
   
   override protected function initialize() : void
   {
      super.initialize();
      _asset = Assets.sAsset;
      this.bgFocusTexture = _asset.getTexture("UnionWorshipItemBgNull");
      this.bgNormalTexture = _asset.getTexture("UnionWorshipItemBgNull");
      this.bg = new Image(this.bgNormalTexture);
      this.addChild(this.bg);
      _layout = new LayoutUitl(_asset.getOther("UnionWorship"),_asset);
      _layout.buildLayout("UnionWorshipItemLayOut",this);
      _unionWorshipItemBtn = new FashionStarlingButton(this.getChildByName("btnS_UnionWorshipItemBtn") as Button);
      _unionWorshipItemBtn.triggerFunction = unionWorshipHandel;
   }
   
   private function unionWorshipHandel(param1:Event) : void
   {
      UnionManager.getInstance().dispatchEvent(new UnionEvent("worshipThisBody",this._data));
   }
   
   override protected function commitData() : void
   {
      var _loc4_:int = 0;
      var _loc1_:ShopData = null;
      var _loc5_:int = 0;
      super.commitData();
      if(!this._data)
      {
         return;
      }
      var _loc3_:PlayerData = this._data as PlayerData;
      character && character.removeFromParent(true);
      character = CharacterFactory.instance.checkOutCharacter(_loc3_.babySex);
      character.initData([]);
      character.height = 220;
      character.scaleX = character.scaleY;
      character.x = 130;
      character.y = 230;
      this.addChild(character);
      var _loc2_:Array = _loc3_.getPropData();
      if(_loc2_)
      {
         _loc4_ = int(_loc2_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc2_[_loc5_] is GoodsData)
            {
               _loc1_ = _loc2_[_loc5_];
               character.wear(Constants.getGoodsNameById(_loc1_.typeID),_loc1_.typeID,_loc1_.frameID);
            }
            _loc5_++;
         }
      }
      (this.getChildByName("nameTF") as TextField).text = _loc3_.babyName;
      (this.getChildByName("levelTF") as TextField).text = _loc3_.level + "";
      (this.getChildByName("fightTF") as TextField).text = _loc3_.totalAblility + "";
      _unionWorshipItemBtn.isGray = isBtnGray;
   }
   
   override public function dispose() : void
   {
   }
}
