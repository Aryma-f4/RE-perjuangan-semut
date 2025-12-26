package com.boyaa.antwars.view.screen.union.warehouse
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.UnionListItemModel;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.union.UnionCoreDlg;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.LoadData;
   import starling.display.Button;
   import starling.events.Event;
   import starling.utils.formatString;
   
   public class WarehouseClassifyDlg extends UnionCoreDlg
   {
      
      private var _levelupBtn:Button;
      
      private var _needLevel:Array = [1,1,3,3,5,5,7,7,9,10];
      
      public const UP_LEVEL_PRICE:Array = [0,300,900,1500,2400,3600,6000,9600,14400,20400];
      
      public function WarehouseClassifyDlg()
      {
         super();
      }
      
      override protected function getRawAssets() : Array
      {
         _rawAssets = [rmger.getResFile(formatString("asset/warehouse.info")),rmger.getResFile(formatString("textures/{0}x/Union/warehouse.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/Union/warehouse.xml",Assets.sAsset.scaleFactor))];
         return _rawAssets;
      }
      
      override protected function loadAssetDone(param1:int) : void
      {
         var _loc2_:LayoutUitl = null;
         if(param1 == 1)
         {
            _loc2_ = new LayoutUitl(_asset.getOther("warehouse"),_asset);
            _loc2_.buildLayout("WarehouseClassify",_displayObj);
            SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
            init();
         }
         super.loadAssetDone(param1);
      }
      
      private function init() : void
      {
         initCommandButton();
         StarlingUITools.instance.initStarlingButton(_displayObj,"btnS_rent",onRentGoodsBtn);
         StarlingUITools.instance.initStarlingButton(_displayObj,"btnS_myware",onMywareHouseBtn);
         _levelupBtn = _displayObj.getChildByName("btnS_unionLevelBtn") as Button;
         _levelupBtn.addEventListener("triggered",onLevelUpHandel);
         getTextFieldByName("LevelTF").text = UnionManager.getInstance().myUnionModel.storelevel + "";
      }
      
      private function onMywareHouseBtn(param1:Event) : void
      {
         var _loc2_:MyWarehouseDlg = new MyWarehouseDlg();
         this.addChild(_loc2_);
      }
      
      private function onRentGoodsBtn(param1:Event) : void
      {
         var _loc2_:UnionWarehouseDlg = new UnionWarehouseDlg();
         this.addChild(_loc2_);
      }
      
      private function closeHandel(param1:Event) : void
      {
         this.deactive();
      }
      
      private function onLevelUpHandel(param1:Event) : void
      {
         if(UnionManager.getInstance().myUnionModel.position == 8 || UnionManager.getInstance().myUnionModel.position == 9)
         {
            TextTip.instance.showByLang("canUplevelUnion");
            return;
         }
         var _loc2_:int = UnionManager.getInstance().myUnionModel.storelevel;
         if(_loc2_ >= 10)
         {
            TextTip.instance.showByLang("union_storage_maxlevel");
            return;
         }
         if(UnionManager.getInstance().myUnionModel.clevel < _needLevel[_loc2_])
         {
            TextTip.instance.show(LangManager.getLang.getreplaceLang("unionNeedLevel",_needLevel[_loc2_]));
            return;
         }
         SystemTip.instance.showSystemAlert(LangManager.getLang.getreplaceLang("payUpLevelUnionStore",UP_LEVEL_PRICE[_loc2_]),okHandler,null);
      }
      
      private function upUnionLevelHandler(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc4_:Object = JSON.parse(param1.param as String);
         var _loc3_:int = UnionManager.getInstance().myUnionModel.storelevel;
         if(_loc4_.ret == 0)
         {
            TextTip.instance.show(LangManager.getLang.getLangByStr("uplevelOK"));
            UnionManager.getInstance().myUnionModel.storelevel = _loc4_.clevel;
            UnionManager.getInstance().myUnionModel.cdevote = UnionManager.getInstance().myUnionModel.cdevote - UP_LEVEL_PRICE[_loc3_];
            getTextFieldByName("LevelTF").text = UnionManager.getInstance().myUnionModel.storelevel + "";
            return;
         }
         throw new Error(_loc4_.msg);
      }
      
      private function okHandler() : void
      {
         var _loc2_:UnionListItemModel = UnionManager.getInstance().myUnionModel;
         var _loc1_:int = _loc2_.storelevel;
         if(_loc2_.cdevote < UP_LEVEL_PRICE[_loc1_])
         {
            TextTip.instance.show(LangManager.getLang.getLangByStr("noContributor"));
            return;
         }
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("upUnionLevel",upUnionLevelHandler);
         Remoting.instance.gameTable.upUnionLevel(3);
      }
   }
}

