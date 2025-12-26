package com.boyaa.antwars.view.screen.sign
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.filters.ColorMatrixFilter;
   import starling.text.TextField;
   
   public class SignInDayItemRender extends ListItemRenderer
   {
      
      private var _asset:ResAssetManager;
      
      private var _layout:LayoutUitl;
      
      private var goodsImage:Image;
      
      private var vip_symbol:Image;
      
      private var txt_goodsNum:TextField;
      
      private var txt_vipLevel:TextField;
      
      private var vipLevel:int;
      
      private var aniImage:Image;
      
      private var signedImage:Image;
      
      private var canSignState:Image;
      
      private var signedState:Image;
      
      public function SignInDayItemRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _asset = Assets.sAsset;
         this.bgFocusTexture = _asset.getTexture("canSignState");
         this.bgNormalTexture = _asset.getTexture("itemBg");
         this.bg = new Image(this.bgNormalTexture);
         _layout = new LayoutUitl(_asset.getOther("signIn"),_asset);
         _layout.buildLayout("DayItemLayout",this);
         vip_symbol = this.getChildByName("vip_symbol") as Image;
         canSignState = this.getChildByName("canSignState") as Image;
         signedState = this.getChildByName("signedState") as Image;
         txt_vipLevel = this.getChildByName("txt_vip") as TextField;
         txt_goodsNum = this.getChildByName("txt_num") as TextField;
         txt_goodsNum.nativeFilters = StarlingUITools.instance.getGlowFilter(0,1,4,4,10);
         aniImage = this.getChildByName("ani") as Image;
         signedImage = this.getChildByName("img_signed") as Image;
         aniImage.visible = false;
         signedImage.visible = false;
         signedState.visible = false;
         canSignState.visible = false;
         vipLevel = PlayerDataList.instance.selfData.vipLevel;
         if(vipLevel == 0)
         {
            vip_symbol.visible = false;
            txt_vipLevel.visible = false;
         }
         else
         {
            vip_symbol.visible = true;
            txt_vipLevel.visible = true;
            txt_vipLevel.text = "VIP" + vipLevel + "\ndobel";
         }
         txt_vipLevel.fontSize = 17;
         txt_vipLevel.x -= 15;
         txt_vipLevel.y -= 5;
         txt_vipLevel.nativeFilters = StarlingUITools.instance.getGlowFilter(0,1,4,4,10);
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         if(!this._data)
         {
            return;
         }
         if(goodsImage)
         {
            goodsImage.removeFromParent();
         }
         var _loc2_:Rectangle = new Rectangle(2,2,100,100);
         if(this._data.reward_type == 3)
         {
            goodsImage = _asset.getGoodsImageByRect(this._data.pcate,this._data.pframe,_loc2_);
         }
         else
         {
            if(this._data.reward_type == 1)
            {
               goodsImage = new Image(_asset.getTexture("goldCoin"));
            }
            else
            {
               goodsImage = new Image(_asset.getTexture("boyaa_coin"));
            }
            goodsImage.x = _loc2_.x;
            goodsImage.y = _loc2_.y;
            goodsImage.width = _loc2_.width;
            goodsImage.height = _loc2_.height;
         }
         if(goodsImage)
         {
            this.addChild(goodsImage);
            this.setChildIndex(goodsImage,1);
         }
         txt_goodsNum.text = "X" + this._data.count;
         var _loc1_:int = this._data.days - 1;
         if(NewSignInDlg.SIGN_RECORD.charAt(_loc1_) == "0")
         {
            if(PlayerDataList.instance.selfData.isSigned == false)
            {
               setSignState(false);
               if(NewSignInDlg.canSignDay == _loc1_)
               {
                  preScaleTarget();
                  this.setChildIndex(goodsImage,this.numChildren - 5);
               }
               else
               {
                  this.setChildIndex(goodsImage,this.numChildren - 5);
                  txt_vipLevel.color = 16777113;
                  txt_goodsNum.color = 16777215;
                  (this.getChildByName("vip_symbol") as Image).filter = null;
                  signedImage.visible = false;
                  signedState.visible = false;
                  aniImage.visible = false;
                  canSignState.visible = false;
                  Starling.juggler.removeTweens(aniImage);
               }
            }
            signedImage.visible = false;
         }
         else
         {
            setSignState(true);
            setGrayFitlers(this.getChildByName("vip_symbol") as Image);
            setGrayFitlers(goodsImage);
            txt_vipLevel.color = 6710886;
            txt_goodsNum.color = 6710886;
            this.setChildIndex(goodsImage,this.numChildren - 5);
         }
      }
      
      private function setSignState(param1:Boolean) : void
      {
         signedImage.visible = param1;
         signedState.visible = param1;
         canSignState.visible = !param1;
         aniImage.visible = !param1;
      }
      
      private function preScaleTarget() : void
      {
         Starling.juggler.tween(aniImage,1,{
            "scaleX":0.9,
            "scaleY":0.9,
            "onComplete":nextScaleTarget
         });
      }
      
      private function nextScaleTarget() : void
      {
         Starling.juggler.tween(aniImage,1,{
            "scaleX":0.8,
            "scaleY":0.8,
            "onComplete":preScaleTarget
         });
      }
      
      protected function setGrayFitlers(param1:Image) : void
      {
         var _loc2_:ColorMatrixFilter = new ColorMatrixFilter();
         _loc2_.adjustSaturation(-1);
         param1.filter = _loc2_;
      }
   }
}

