package com.boyaa.antwars.view.screen.sign
{
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import flash.geom.Rectangle;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class RewardsDlg extends Sprite
   {
      
      private var bg:Image;
      
      private var btnClose:Button;
      
      private var listData:Array;
      
      private var mark:Quad;
      
      private var _type:int = 0;
      
      private var _layout:LayoutUitl;
      
      private var goodsImage:Image;
      
      private var goodsImage1:Image;
      
      private var txt:TextField;
      
      private var txt1:TextField;
      
      private var txt2:TextField;
      
      public var signal:Signal;
      
      public function RewardsDlg(param1:Object, param2:int)
      {
         var _loc5_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         listData = [];
         super();
         _layout = new LayoutUitl(Assets.sAsset.getOther("signIn"),Assets.sAsset);
         if(param2 > 0)
         {
            _layout.buildLayout("SignVipFrame",this);
            SmallCodeTools.instance.setDisplayObjectInStageMiddle(this);
            _loc5_ = this.getBounds(this.getChildByName("item0")) as Rectangle;
            _loc3_ = this.getBounds(this.getChildByName("item1")) as Rectangle;
            if(param1.reward_type == 1)
            {
               goodsImage = new Image(Assets.sAsset.getTexture("goldCoin"));
               goodsImage1 = new Image(Assets.sAsset.getTexture("goldCoin"));
            }
            else if(param1.reward_type == 2)
            {
               goodsImage = new Image(Assets.sAsset.getTexture("boyaa_coin"));
               goodsImage1 = new Image(Assets.sAsset.getTexture("boyaa_coin"));
            }
            else
            {
               goodsImage = Assets.sAsset.getGoodsImageByRect(param1.pcate,param1.pframe,_loc5_);
               goodsImage1 = Assets.sAsset.getGoodsImageByRect(param1.pcate,param1.pframe,_loc5_);
            }
            if(goodsImage)
            {
               this.addChild(goodsImage);
               this.addChild(goodsImage1);
               SmallCodeTools.instance.setDisplayObjectInSame(this.getChildByName("item0"),goodsImage);
               SmallCodeTools.instance.setDisplayObjectInSame(this.getChildByName("item1"),goodsImage1);
            }
            txt1 = this.getChildByName("txt_num1") as TextField;
            txt1.nativeFilters = StarlingUITools.instance.getGlowFilter(0,1,4,4,10);
            txt1.text = "X" + param1.count;
            this.setChildIndex(txt1,this.numChildren - 1);
            txt2 = this.getChildByName("txt_vipTip") as TextField;
            txt2.text = "VIP" + param2 + "Hadiah";
         }
         else
         {
            _layout.buildLayout("SignFrame",this);
            SmallCodeTools.instance.setDisplayObjectInStageMiddle(this);
            if(param1.reward_type == 1)
            {
               goodsImage = new Image(Assets.sAsset.getTexture("goldCoin"));
            }
            else if(param1.reward_type == 2)
            {
               goodsImage = new Image(Assets.sAsset.getTexture("boyaa_coin"));
            }
            else
            {
               _loc4_ = this.getBounds(this.getChildByName("item0")) as Rectangle;
               goodsImage = Assets.sAsset.getGoodsImageByRect(param1.pcate,param1.pframe,_loc4_);
            }
            if(goodsImage)
            {
               this.addChild(goodsImage);
               SmallCodeTools.instance.setDisplayObjectInSame(this.getChildByName("item0"),goodsImage);
            }
         }
         txt = this.getChildByName("txt_num") as TextField;
         txt.nativeFilters = StarlingUITools.instance.getGlowFilter(0,1,4,4,10);
         txt.text = "X" + param1.count;
         this.setChildIndex(txt,this.numChildren - 1);
         init();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function init() : void
      {
         signal = new Signal();
         mark = new Quad(1365,768,0);
         mark.alpha = 0;
         btnClose = this.getChildByName("btn_sure") as Button;
         btnClose.addEventListener("triggered",onClose);
      }
      
      private function parseData(param1:Array) : void
      {
         var _loc2_:ShopData = null;
         var _loc4_:int = 0;
         var _loc3_:int = int(param1.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = ShopDataList.instance.getSingleData(param1[_loc4_][0],param1[_loc4_][1]);
            _loc2_.amount = param1[_loc4_][3];
            listData.push(_loc2_);
            _loc4_++;
         }
      }
      
      private function onGetRewards(param1:Object) : void
      {
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         Starling.current.stage.addChild(mark);
         Starling.current.stage.swapChildren(this,mark);
         this.pivotX = this.width / 2;
         this.pivotY = this.height / 2;
         this.x = 1365 >> 1;
         this.y = 768 >> 1;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.4,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeOut"
         });
      }
      
      private function onClose(param1:Event) : void
      {
         Starling.juggler.tween(this,0.3,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":cleanUp
         });
      }
      
      private function onRewards(param1:Event) : void
      {
      }
      
      public function cleanUp() : void
      {
         mark.removeFromParent(true);
         btnClose.removeEventListener("triggered",onClose);
         this.removeEventListener("addedToStage",onAddedToStage);
         removeFromParent();
      }
   }
}

