package com.boyaa.antwars.view.screen.exchangeCenter
{
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.ExchangePropItem;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import flash.geom.Rectangle;
   import starling.display.Button;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class ExchangePropButton extends ListItemRenderer
   {
      
      private var _layout:LayoutUitl;
      
      private var _asset:ResAssetManager;
      
      private var _image:Image;
      
      private var _btn:Button;
      
      private var _btnArr:Array = [];
      
      public function ExchangePropButton()
      {
         super();
      }
      
      override protected function selectDraw() : void
      {
         super.selectDraw();
         selectItem(isSelected);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _asset = Assets.sAsset;
         this.bgFocusTexture = Assets.sAsset.getTexture("btnS_frame1");
         this.bgNormalTexture = Assets.sAsset.getTexture("btnS_frame2");
         this.bg = new Image(this.bgNormalTexture);
         this.bg.width = 320;
         this.bg.visible = false;
         this.addChild(this.bg);
         _layout = new LayoutUitl(_asset.getOther("exchange"),_asset);
         _layout.buildLayout("propLayout",this);
         _btn = this.getChildByName("propItem") as Button;
         _btnArr = [_btn,_btn.upState,_btn.downState];
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         if(!this._data)
         {
            return;
         }
         var _loc2_:ExchangePropItem = this._data as ExchangePropItem;
         var _loc3_:ShopData = ShopDataList.instance.getSingleData(_loc2_.pcate,_loc2_.pframe);
         (this.getChildByName("propName") as TextField).text = _loc3_.name;
         (this.getChildByName("propCount") as TextField).text = LangManager.getLang.getLangByStr("excg_count") + _loc2_.quantity;
         if(_loc2_.validperiod)
         {
            (this.getChildByName("propValidDate") as TextField).text = LangManager.getLang.getLangByStr("excg_expire") + _loc2_.validperiod;
         }
         else
         {
            (this.getChildByName("propValidDate") as TextField).text = LangManager.getLang.getLangByStr("excg_forever");
         }
         if(this._image)
         {
            this._image.removeFromParent();
         }
         var _loc1_:Rectangle = new Rectangle(getChildByName("propPos").x,getChildByName("propPos").y,getChildByName("propPos").width,getChildByName("propPos").height);
         try
         {
            this._image = Assets.sAsset.getGoodsImageByRect(_loc2_.pcate,_loc2_.pframe,_loc1_);
            this._image.touchable = false;
            this.addChild(this._image);
         }
         catch(e:Error)
         {
            trace("显示物品图片失败:" + e.message);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      public function selectItem(param1:Boolean) : void
      {
         if(param1)
         {
            _btn.upState = _btnArr[2];
         }
         else
         {
            _btn.upState = _btnArr[1];
         }
      }
   }
}

