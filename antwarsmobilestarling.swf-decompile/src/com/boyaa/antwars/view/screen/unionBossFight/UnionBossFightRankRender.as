package com.boyaa.antwars.view.screen.unionBossFight
{
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class UnionBossFightRankRender extends ListItemRenderer
   {
      
      private var _rankTxt:TextField;
      
      private var _nameTxt:TextField;
      
      private var _fightTimeTxt:TextField;
      
      private var _normalColor:uint;
      
      private var _txtArr:Array = [];
      
      public function UnionBossFightRankRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.bgFocusTexture = Assets.sAsset.getTexture("talk39");
         this.bgNormalTexture = Assets.sAsset.getTexture("talk38");
         this.bg = new Image(Assets.sAsset.getTexture("talk38"));
         this.bg.width = 840;
         addChild(bg);
         var _loc1_:int = 11;
         _rankTxt = StarlingUITools.instance.createTextField("100000",30,_loc1_,140);
         _nameTxt = StarlingUITools.instance.createTextField("100000",310,_loc1_,170);
         _fightTimeTxt = StarlingUITools.instance.createTextField("100000",630,_loc1_,170);
         addChild(_rankTxt);
         addChild(_nameTxt);
         addChild(_fightTimeTxt);
         _normalColor = _rankTxt.color;
         _txtArr = [_rankTxt,_nameTxt,_fightTimeTxt];
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         var _loc1_:Array = this._data as Array;
         _rankTxt.text = _loc1_[5];
         _nameTxt.text = _loc1_[1];
         _fightTimeTxt.text = getFormatTime(_loc1_[4]);
         setTextColor(_normalColor);
         if(_loc1_[0] == UnionManager.getInstance().myUnionModel.cid)
         {
            setTextColor(208);
         }
      }
      
      protected function setTextColor(param1:uint) : void
      {
         for each(var _loc2_ in _txtArr)
         {
            _loc2_.color = param1;
         }
      }
      
      private function getFormatTime(param1:int) : String
      {
         var _loc5_:* = param1;
         var _loc6_:int = _loc5_ / 3600;
         _loc5_ %= 3600;
         var _loc2_:int = _loc5_ / 60;
         var _loc4_:* = _loc5_ %= 60;
         var _loc3_:String = "";
         if(_loc6_ > 0)
         {
            _loc3_ += (String(_loc6_ + 100)).substr(1) + ":";
         }
         if(_loc2_ > 0)
         {
            _loc3_ += (String(_loc2_ + 100)).substr(1) + ":";
         }
         return _loc3_ + (String(_loc4_ + 100)).substr(1);
      }
   }
}

