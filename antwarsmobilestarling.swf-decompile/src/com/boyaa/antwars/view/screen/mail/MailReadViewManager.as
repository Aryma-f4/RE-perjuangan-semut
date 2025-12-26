package com.boyaa.antwars.view.screen.mail
{
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.net.server.GameServer;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class MailReadViewManager extends MailViewManager
   {
      
      private var _currentMail:Object;
      
      private var _backBtn:Button;
      
      private var _oneKeyReceiveBtn:Button;
      
      private var _fileListArr:Array;
      
      public function MailReadViewManager(param1:Sprite)
      {
         super(param1);
      }
      
      override protected function initView() : void
      {
         super.initView();
         _backBtn = this._targetView.getChildByName("btnS_back") as Button;
         _backBtn.addEventListener("triggered",onBackFunc);
         _oneKeyReceiveBtn = this._targetView.getChildByName("btnS_oneKeyReceive") as Button;
         _oneKeyReceiveBtn.addEventListener("triggered",oneKeyReceiveHandel);
      }
      
      private function oneKeyReceiveHandel(param1:Event) : void
      {
         clearFileList();
         this._oneKeyReceiveBtn.visible = false;
         GameServer.instance.send.getMailFile([_currentMail.mail_id]);
      }
      
      private function onBackFunc(param1:Event) : void
      {
         dispatchEvent(new MailBoxEvent(MailBoxEvent.MAIL_GOBACK_LIST_EVENT));
      }
      
      public function get currentMail() : Object
      {
         return _currentMail;
      }
      
      public function set currentMail(param1:Object) : void
      {
         _oneKeyReceiveBtn.visible = false;
         _currentMail = param1;
         clearFileList();
         GameServer.instance.readMail(param1.mail_id,readMailDone);
         (this._targetView.getChildByName("friendName_tf") as TextField).text = param1.from_name + "";
         (this._targetView.getChildByName("title_tf") as TextField).text = param1.title + "";
         (this._targetView.getChildByName("content_tf") as TextField).text = "";
      }
      
      private function readMailDone(param1:Object) : void
      {
         var _loc6_:int = 0;
         var _loc3_:Object = null;
         var _loc2_:ShopData = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         (this._targetView.getChildByName("content_tf") as TextField).text = param1.content + "";
         _fileListArr = [];
         _loc6_ = 0;
         while(_loc6_ < param1.files.length)
         {
            _loc3_ = param1.files[_loc6_];
            _loc2_ = ShopDataList.instance.getSingleData(_loc3_.pcate,_loc3_.pframe);
            showFileImage(_loc6_,_loc2_);
            _fileListArr.push(_loc2_);
            _loc6_++;
         }
         if(param1.files.length > 0)
         {
            _loc4_ = 1;
            while(_loc4_ < 5)
            {
               (this._targetView.getChildByName("file_" + _loc4_) as Image).visible = true;
               _loc4_++;
            }
            _oneKeyReceiveBtn.visible = true;
         }
         else
         {
            _loc5_ = 1;
            while(_loc5_ < 5)
            {
               (this._targetView.getChildByName("file_" + _loc5_) as Image).visible = false;
               _loc5_++;
            }
         }
      }
   }
}

