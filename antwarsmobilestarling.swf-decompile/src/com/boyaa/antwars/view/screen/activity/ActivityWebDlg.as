package com.boyaa.antwars.view.screen.activity
{
   import com.boyaa.antwars.view.screen.BaseDialog;
   import com.boyaa.antwars.view.screen.shop.ShopCloseBtn;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   // import flash.media.StageWebView; // Likely AIR only
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class ActivityWebDlg extends BaseDialog
   {
      
      private var _url:String;
      
      private var _viewPort:Rectangle;
      
      // private var _webView:StageWebView;
      
      private var _closeBtn:ShopCloseBtn;
      
      private var _bg:Sprite;
      
      public function ActivityWebDlg(param1:String)
      {
         super();
         _url = param1;
         bgAlpha = 0.5;
         _isClickStageClose = false;
         Application.instance.currentMain.stage.addEventListener("resize",onResize);
      }
      
      override public function dispose() : void
      {
         if(Application.instance.currentMain.stage)
         {
            Application.instance.currentMain.stage.removeEventListener("resize",onResize);
         }
         // if(_webView)
         // {
         //    _webView.dispose();
         //    _webView = null;
         // }
         super.dispose();
      }
      
      private function onResize(param1:flash.events.Event) : void
      {
         updateViewPort();
      }
      
      override protected function initialize() : void
      {
         _bg = new Sprite();
         addDialog(_bg);
         _closeBtn = new ShopCloseBtn();
         _closeBtn.addEventListener("triggered",onClose);
         _bg.addChild(_closeBtn);
         updateViewPort();

         // Stubbed WebView logic for Web
         /*
         if(StageWebView.isSupported)
         {
            _webView = new StageWebView();
            _webView.stage = Application.instance.currentMain.stage;
            _webView.viewPort = _viewPort;
            _webView.loadURL(_url);
            Application.instance.application.removeEventListener("keyDown",Application.instance.currentMain.handleKeys);
            Application.instance.application.addEventListener("keyDown",handleKeys);
         }
         */
      }
      
      private function handleKeys(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 16777238 || param1.keyCode == 4)
         {
            param1.preventDefault();
            // if(_webView.isHistoryBackEnabled)
            // {
            //    _webView.historyBack();
            // }
            // else
            // {
               onClose();
            // }
         }
      }
      
      private function onClose(param1:starling.events.Event = null) : void
      {
         removeFromParent(true);
         // Application.instance.application.addEventListener("keyDown",Application.instance.currentMain.handleKeys);
         // Application.instance.application.removeEventListener("keyDown",handleKeys);
      }
      
      private function updateViewPort() : void
      {
         var _loc2_:Stage = Application.instance.currentMain.stage;
         var _loc1_:Number = 0;
         if(Constants.isPC)
         {
            _loc1_ = Constants.scaleFactor;
         }
         else
         {
            _loc1_ = _loc2_.stageWidth / 1365;
         }
         _viewPort = new Rectangle(68 * _loc1_,60 * _loc1_,1229 * _loc1_,663 * _loc1_);
         // if(_webView)
         // {
         //    _webView.viewPort = _viewPort;
         // }
         if(_closeBtn)
         {
            _closeBtn.x = 1260;
            _closeBtn.y = 40;
         }
      }
   }
}
