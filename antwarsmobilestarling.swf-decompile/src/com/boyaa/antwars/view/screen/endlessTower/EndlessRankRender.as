package com.boyaa.antwars.view.screen.endlessTower
{
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class EndlessRankRender extends ListItemRenderer
   {
      
      private var _rankTxt:TextField;
      
      private var _nameTxt:TextField;
      
      private var _fightNumTxt:TextField;
      
      private var _levelTxt:TextField;
      
      public function EndlessRankRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.bgFocusTexture = Assets.sAsset.getTexture("talk39");
         this.bgNormalTexture = Assets.sAsset.getTexture("talk38");
         this.bg = new Image(Assets.sAsset.getTexture("talk38"));
         this.bg.width = 820;
         addChild(bg);
         var _loc1_:int = 15;
         _rankTxt = StarlingUITools.instance.createTextField("100000",13,_loc1_,140);
         _nameTxt = StarlingUITools.instance.createTextField("100000",180,_loc1_,170);
         _fightNumTxt = StarlingUITools.instance.createTextField("100000",400,_loc1_,170);
         _levelTxt = StarlingUITools.instance.createTextField("100000",640,_loc1_,140);
         addChild(_rankTxt);
         addChild(_nameTxt);
         addChild(_fightNumTxt);
         addChild(_levelTxt);
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         var _loc1_:SingleEndlessRankData = this._data as SingleEndlessRankData;
         _rankTxt.text = _loc1_.rank.toString();
         _nameTxt.text = _loc1_.playerName;
         _fightNumTxt.text = _loc1_.fightNum.toString();
         _levelTxt.text = _loc1_.levelNum.toString();
      }
   }
}

