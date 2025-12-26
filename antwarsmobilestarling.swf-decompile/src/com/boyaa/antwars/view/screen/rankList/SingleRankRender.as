package com.boyaa.antwars.view.screen.rankList
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.view.ui.LayoutListItemRender;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.antwars.view.vipSystem.PictureNumber;
   import com.boyaa.antwars.view.vipSystem.VipLevelText;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class SingleRankRender extends LayoutListItemRender
   {
      
      protected var _rankTxt:TextField;
      
      protected var _nameTxt:TextField;
      
      protected var _fightNumTxt:TextField;
      
      protected var _playerUID:int;
      
      protected var _layoutName:String = "";
      
      private var _normalColor:uint;
      
      private var _vipText:VipLevelText;
      
      private var _faceBookHead:FacebookHeadPicture;
      
      private var _headPos:DisplayObject;
      
      private var _honorIcon:Image;
      
      private const HONOR_TEXTURE_NAME:String = "img_rankListIcon";
      
      private var _number:PictureNumber;
      
      public function SingleRankRender()
      {
         super();
         _layoutName = "rankListOneItem";
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _layoutUtil = new LayoutUitl(Assets.sAsset.getOther("rankList"));
         _layoutUtil.buildLayout(_layoutName,_displayObject);
         _headPos = getSpriteByName("head").getChildByName("posHead");
         _rankTxt = getTextFieldByName("rankNum");
         _nameTxt = getTextFieldByName("playerName");
         _fightNumTxt = getTextFieldByName("fightNum");
         _normalColor = _rankTxt.color;
         _vipText = new VipLevelText();
         _displayObject.addChild(_vipText);
         _faceBookHead = new FacebookHeadPicture(getSpriteByName("head"),_headPos.bounds);
         _honorIcon = new Image(Assets.sAsset.getTexture("img_rankListIcon1"));
         _displayObject.addChild(_honorIcon);
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("pos_icon"),_honorIcon);
         initOriginRenderItems();
      }
      
      private function showHead(param1:String) : void
      {
         _faceBookHead.update(param1);
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         var _loc1_:SingleRankData = this._data as SingleRankData;
         _rankTxt.text = _loc1_.rank.toString();
         if(_loc1_.rank <= 3)
         {
            _honorIcon.visible = true;
            _honorIcon.texture = Assets.sAsset.getTexture("img_rankListIcon" + _loc1_.rank);
            _rankTxt.visible = false;
         }
         else
         {
            _rankTxt.visible = true;
            _honorIcon.visible = false;
         }
         _nameTxt.text = _loc1_.playerName;
         _fightNumTxt.text = _loc1_.fightNum.toString();
         _playerUID = _loc1_.playerUID;
         setTextColor([_rankTxt,_nameTxt,_fightNumTxt],_normalColor);
         if(_loc1_.vipLevel > 0)
         {
            setTextColor([_rankTxt,_nameTxt,_fightNumTxt],16750848,true);
         }
         if(_playerUID == PlayerDataList.instance.selfData.uid)
         {
            setTextColor([_rankTxt,_nameTxt,_fightNumTxt]);
         }
         var _loc2_:String = RankListPlayerPictures.instance.getPlayerFaceBookImageUrlByUID(_loc1_.playerUID);
         if(_loc2_ != "" && _loc2_ != null)
         {
            showHead(_loc2_);
         }
         else
         {
            _faceBookHead.clear();
         }
         _vipText.level = _loc1_.vipLevel;
         SmallCodeTools.instance.setDisplayObjectInSameScale(getDisplayObjectByName("pos_vip"),_vipText,1);
      }
      
      private function setTextColor(param1:Array, param2:uint = 208, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            TextField(param1[_loc4_]).color = param2;
            if(param3)
            {
               TextField(param1[_loc4_]).nativeFilters = StarlingUITools.instance.getDropShadowFilter(3735581);
            }
            else
            {
               TextField(param1[_loc4_]).nativeFilters = [];
            }
            _loc4_++;
         }
      }
      
      override protected function selectDraw() : void
      {
         super.selectDraw();
      }
   }
}

