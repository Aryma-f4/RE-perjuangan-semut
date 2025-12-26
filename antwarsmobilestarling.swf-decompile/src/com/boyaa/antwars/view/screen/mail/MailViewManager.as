package com.boyaa.antwars.view.screen.mail
{
   import com.boyaa.antwars.data.model.ShopData;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.display.Sprite;
   
   public class MailViewManager extends EventDispatcher
   {
      
      protected var _targetView:Sprite;
      
      protected var _goodsBoxs:Array = [];
      
      public function MailViewManager(param1:Sprite)
      {
         super();
         _targetView = param1;
         initView();
      }
      
      protected function initView() : void
      {
      }
      
      public function active() : void
      {
         this._targetView.visible = true;
      }
      
      public function deactive() : void
      {
         this._targetView.visible = false;
      }
      
      public function dispose() : void
      {
      }
      
      protected function clearFileList() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            if(_goodsBoxs[_loc1_])
            {
               _goodsBoxs[_loc1_].removeFromParent();
               _goodsBoxs[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      protected function showFileImage(param1:int, param2:ShopData) : void
      {
         if(_goodsBoxs[param1])
         {
            _goodsBoxs[param1].removeFromParent();
            _goodsBoxs[param1] = null;
         }
         var _loc3_:* = param2;
         var _loc4_:Rectangle = new Rectangle((this._targetView.getChildByName("file_" + (param1 + 1)) as Image).x,(this._targetView.getChildByName("file_" + (param1 + 1)) as Image).y,(this._targetView.getChildByName("file_" + (param1 + 1)) as Image).width,(this._targetView.getChildByName("file_" + (param1 + 1)) as Image).height);
         try
         {
            _goodsBoxs[param1] = Assets.sAsset.getGoodsImageByRect(_loc3_.typeID,_loc3_.frameID,_loc4_);
            (_goodsBoxs[param1] as Image).touchable = false;
            _targetView.addChild(_goodsBoxs[param1]);
         }
         catch(e:Error)
         {
            trace("显示物品图片失败:" + e.message);
         }
      }
   }
}

