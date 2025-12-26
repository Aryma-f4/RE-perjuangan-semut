package com.boyaa.antwars.view.screen.backpack
{
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class BackpackItemRenderer extends ListItemRenderer
   {
      
      private var goodsBox:Image;
      
      private var goodsName:TextField;
      
      private var level:TextField;
      
      private var txtValidate:TextField;
      
      protected var lowerlevelTxt:TextField;
      
      protected var countTxt:TextField;
      
      private var screenItems:Dictionary;
      
      private var pos:Rectangle;
      
      private var iconImage:Image;
      
      private var _txt:TextField;
      
      public function BackpackItemRenderer()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         var _loc1_:Image = null;
         if(!this.bg)
         {
            screenItems = Assets.getScreenPos("backpackitem");
            this.bgFocusTexture = Assets.sAsset.getTexture("item1");
            this.bgNormalTexture = Assets.sAsset.getTexture("item0");
            this.bg = new Image(this.bgNormalTexture);
            this.addChild(this.bg);
            pos = Assets.getPosition("backpackitem","bg1");
            _loc1_ = new Image(Assets.sAsset.getTexture("bg_item"));
            _loc1_.x = pos.x;
            _loc1_.y = pos.y;
            addChild(_loc1_);
            pos = Assets.getPosition("backpackitem","title");
            this.goodsName = new TextField(pos.width,pos.height,"","Verdana",26,4660230,true);
            this.goodsName.autoScale = true;
            this.goodsName.hAlign = "left";
            this.goodsName.vAlign = "center";
            this.goodsName.x = pos.x;
            this.goodsName.y = pos.y;
            addChild(this.goodsName);
            this.goodsName.touchable = false;
            this.goodsName.autoScale = true;
            pos = Assets.getPosition("backpackitem","level");
            this.level = new TextField(pos.width,pos.height,"","Verdana",24,4531203);
            this.level.hAlign = "left";
            this.level.x = pos.x;
            this.level.y = pos.y;
            addChild(this.level);
            this.level.touchable = false;
            this.level.autoScale = true;
            pos = Assets.getPosition("backpackitem","validate");
            this.txtValidate = new TextField(pos.width,pos.height,"","0x452403",24,4531203);
            this.txtValidate.hAlign = "left";
            this.txtValidate.vAlign = "center";
            this.txtValidate.x = pos.x;
            this.txtValidate.y = pos.y;
            addChild(this.txtValidate);
            this.txtValidate.touchable = false;
            this.txtValidate.autoScale = true;
            pos = Assets.getPosition("shopitem","lowerlevel");
            this.lowerlevelTxt = new TextField(pos.width,pos.height,"","Verdana",28,16776960,true);
            this.lowerlevelTxt.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
            lowerlevelTxt.autoScale = true;
            this.lowerlevelTxt.hAlign = "right";
            this.lowerlevelTxt.vAlign = "center";
            this.lowerlevelTxt.x = pos.x + 10;
            this.lowerlevelTxt.y = pos.y + 10;
            addChild(this.lowerlevelTxt);
            this.lowerlevelTxt.touchable = false;
            this.lowerlevelTxt.autoScale = true;
            countTxt = new TextField(pos.width,pos.height,"","Verdana",28,16776960,true);
            countTxt.autoScale = true;
            this.countTxt.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
            this.countTxt.hAlign = "right";
            this.countTxt.x = pos.x + 10;
            this.countTxt.y = pos.y + 10;
            addChild(this.countTxt);
            this.countTxt.touchable = false;
            this.countTxt.autoScale = true;
            _txt = new TextField(100,40,LangManager.t("bindTip"),"Verdana",20,16711680);
            _txt.autoScale = true;
            _txt.nativeFilters = [new GlowFilter(3677194,1,5,5,10)];
            _txt.hAlign = "right";
            Assets.positionDisplay(_txt,"backpackitem","iconbind");
            addChild(_txt);
            _txt.visible = false;
         }
      }
      
      override protected function commitData() : void
      {
         if(!this._data)
         {
            return;
         }
         var _loc1_:GoodsData = this._data as GoodsData;
         if(_loc1_.name)
         {
            this.goodsName.text = _loc1_.name;
         }
         if(this.goodsBox)
         {
            this.goodsBox.removeFromParent();
         }
         this.level.text = LangManager.t("needLevel") + _loc1_.lowerlevel + LangManager.t("levelUnit");
         this.txtValidate.text = _loc1_.expiration;
         if(_loc1_.expiration == "已过期")
         {
            this.txtValidate.color = 16711680;
         }
         else
         {
            this.txtValidate.color = 4531203;
         }
         pos = Assets.getPosition("backpackitem","box");
         try
         {
            this.goodsBox = Assets.sAsset.getGoodsImageByRect(_loc1_.typeID,_loc1_.frameID,pos);
            addChild(this.goodsBox);
         }
         catch(e:Error)
         {
            trace("显示物品图片失败:" + JSON.stringify(_loc1_));
         }
         if(!_loc1_.isEquipment)
         {
            this.countTxt.text = "x" + _loc1_.amount;
            if(this.goodsBox)
            {
               this.swapChildren(this.goodsBox,this.countTxt);
            }
            this.lowerlevelTxt.text = "";
         }
         else
         {
            this.lowerlevelTxt.text = "+" + _loc1_.strengthenNum;
            this.lowerlevelTxt.visible = _loc1_.strengthenNum == 0 ? false : true;
            if(this.goodsBox)
            {
               this.swapChildren(this.goodsBox,this.lowerlevelTxt);
            }
            this.countTxt.text = "";
         }
         if(_loc1_.typeID == 15)
         {
            trace(JSON.stringify(_loc1_));
         }
         if(_loc1_.isRentFromOther(_loc1_.onlyID))
         {
            _txt.text = LangManager.t("rent");
            _txt.visible = true;
         }
         else if(_loc1_.isbind != 0)
         {
            _txt.text = LangManager.t("bindTip");
            _txt.visible = true;
         }
         else
         {
            _txt.visible = false;
         }
      }
      
      private function showRentStatus(param1:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:Array = GoodsList.instance.rentArr;
         var _loc3_:int = int(_loc2_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_] == param1)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

