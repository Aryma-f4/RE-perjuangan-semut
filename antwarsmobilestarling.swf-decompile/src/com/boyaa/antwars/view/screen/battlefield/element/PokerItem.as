package com.boyaa.antwars.view.screen.battlefield.element
{
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.display.ClickSprite;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.filters.ColorMatrixFilter;
   import starling.text.TextField;
   
   public class PokerItem extends ClickSprite
   {
      
      private var textureAtlas:ResAssetManager;
      
      private var poker:MovieClip;
      
      private var _name:TextField;
      
      private var goodsBox:Image;
      
      private var _username:TextField;
      
      public var id:int;
      
      private var _vipTxt:TextField;
      
      private var _callBack:Function;
      
      public function PokerItem(param1:int)
      {
         super();
         this.id = param1;
         textureAtlas = Assets.sAsset;
         this.addEventListener("addedToStage",onAddedToStage);
         _username = new TextField(130,50,"","Verdana",20,4465669);
         _username.autoScale = true;
         _username.vAlign = "center";
         _username.hAlign = "center";
         _username.visible = false;
         _vipTxt = new TextField(100,100,"VIP","Verdana",30,16777215,true);
         _vipTxt.visible = false;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         poker = new MovieClip(textureAtlas.getTextures("poker00"),30);
         poker.loop = false;
         poker.addEventListener("complete",onShowData);
         addChild(poker);
         _username.x = 0;
         _username.y = 135;
         addChild(_username);
         if(this.id >= 6)
         {
            _vipTxt.x = 20;
            _vipTxt.y = poker.height - 70;
            addChild(_vipTxt);
            _vipTxt.nativeFilters = StarlingUITools.instance.getGlowFilter(0);
            _vipTxt.visible = true;
         }
      }
      
      public function setData(param1:GoodsData) : void
      {
         _name = new TextField(130,50,param1.name,"Verdana",20,16777215);
         _name.autoScale = true;
         _name.vAlign = "center";
         _name.hAlign = "center";
         addChild(_name);
         _name.visible = false;
         goodsBox = Assets.sAsset.getGoodsImageByRect(param1.typeID,param1.frameID,new Rectangle(15,50,100,100));
         if(goodsBox)
         {
            addChild(goodsBox);
            goodsBox.visible = false;
         }
      }
      
      public function setUserName(param1:String) : void
      {
         trace("setUserName:",param1);
         _username.text = param1;
      }
      
      public function setDataById(param1:int, param2:int) : void
      {
         var _loc3_:ShopData = ShopDataList.instance.getSingleData(param1,param2);
         _name = new TextField(130,50,_loc3_.name,"Verdana",20,16777215);
         _name.autoScale = true;
         _name.vAlign = "center";
         _name.hAlign = "center";
         addChild(_name);
         _name.visible = false;
         goodsBox = Assets.sAsset.getGoodsImageByRect(param1,param2,new Rectangle(15,50,100,100));
         if(goodsBox)
         {
            addChild(goodsBox);
            goodsBox.visible = false;
         }
      }
      
      public function setGold(param1:int) : void
      {
         _name = new TextField(130,50,param1 + LangManager.t("gold"),"Verdana",20,16777215);
         _name.vAlign = "center";
         _name.hAlign = "center";
         addChild(_name);
         _name.visible = false;
         goodsBox = new Image(Assets.sAsset.getTexture("rwCoin"));
         addChild(goodsBox);
         goodsBox.x = 20;
         goodsBox.y = 50;
         goodsBox.width = 100;
         goodsBox.scaleY = goodsBox.scaleX;
         goodsBox.visible = false;
      }
      
      private function onShowData(param1:Event) : void
      {
         _callBack && _callBack();
         _callBack = null;
         if(_name)
         {
            _name.visible = true;
         }
         if(goodsBox)
         {
            goodsBox.visible = true;
         }
         _username.visible = true;
      }
      
      public function play(param1:Function) : void
      {
         _callBack = param1;
         Starling.juggler.add(poker);
         _vipTxt.removeFromParent();
      }
      
      override public function dispose() : void
      {
         Starling.juggler.remove(poker);
         super.dispose();
      }
      
      public function changeToVIPColor() : void
      {
         var _loc4_:int = 0;
         var _loc1_:Array = [1,0,0,0,100,0,1,0,0,60,0,0,0,0,67,0,0,0,1,0];
         var _loc2_:Vector.<Number> = new Vector.<Number>();
         _loc4_ = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc2_.push(_loc1_[_loc4_]);
            _loc4_++;
         }
         var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(_loc2_);
         this.filter = _loc3_;
      }
   }
}

