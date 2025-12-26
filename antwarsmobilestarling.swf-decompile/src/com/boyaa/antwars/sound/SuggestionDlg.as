package com.boyaa.antwars.sound
{
   import com.boyaa.antwars.data.LoginData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import feathers.controls.TextInput;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class SuggestionDlg extends Sprite
   {
      
      private var _bgImage:Image;
      
      private var _closeBtn:Button;
      
      private var atlas:ResAssetManager;
      
      private var _submitBtn:Button;
      
      private var _input:TextInput;
      
      private var _dftxt:String;
      
      private var email:TextField;
      
      private var fanpage:TextField;
      
      private const EMAIL:String = "cskh.vuongquockien@gmail.com";
      
      public function SuggestionDlg()
      {
         super();
         atlas = Assets.sAsset;
         _bgImage = new Image(atlas.getTexture("sz11"));
         addChild(_bgImage);
         _closeBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.positionDisplay(_closeBtn,"configDlg","closeBtn1");
         _closeBtn.addEventListener("triggered",onCloseBtn);
         addChild(_closeBtn);
         _submitBtn = new Button(Assets.sAsset.getTexture("sz12"),"",Assets.sAsset.getTexture("sz13"));
         Assets.positionDisplay(_submitBtn,"configDlg","submit");
         _submitBtn.addEventListener("triggered",onSubmitBtn);
         _submitBtn.x = _bgImage.width - _submitBtn.width - 50;
         _input = new TextInput();
         _input.addEventListener("focusIn",onFocusIn);
         Assets.positionDisplay(_input,"configDlg","suggestionText");
         _dftxt = LangManager.t("suggestion");
         _input.text = _dftxt;
         _input.textEditorProperties.color = 16777215;
         addChild(_input);
         fanpage = new TextField(700,160,LangManager.t("fanpage"),"Verdana",22,16777215);
         fanpage.vAlign = "center";
         fanpage.hAlign = "left";
         fanpage.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
         fanpage.x = 45;
         fanpage.y = _submitBtn.y - 100;
         fanpage.autoScale = true;
         addChild(fanpage);
         addChild(_submitBtn);
         fanpage.addEventListener("touch",onTouchFanpage);
         email = new TextField(400,160,LangManager.t("sugemail"),"Verdana",18,16777215);
         email.vAlign = "center";
         email.hAlign = "left";
         email.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
         email.x = 50;
         email.y = _submitBtn.y - 30;
         addChild(email);
         email.addEventListener("touch",onTouchEmail);
         this.pivotX = this.width / 2;
         this.pivotY = this.height / 2;
         this.x = this.width / 2;
         this.y = this.height / 2;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.6,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeOutBack"
         });
      }
      
      private function onTouchFanpage(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(fanpage,"ended");
         if(_loc2_)
         {
            switch(Constants.lanVersion - 2)
            {
               case 0:
                  navigateToURL(new URLRequest("https://www.facebook.com/vuongquockienmobile"));
                  break;
               case 1:
                  navigateToURL(new URLRequest("https://www.facebook.com/PerjuangansemutAndroid"));
            }
         }
      }
      
      private function onTouchEmail(param1:TouchEvent) : void
      {
         var _loc2_:String = null;
         if(Constants.lanVersion == 3)
         {
            return;
         }
         var _loc3_:Touch = param1.getTouch(email,"ended");
         if(_loc3_)
         {
            _loc2_ = "mailto:cskh.vuongquockien@gmail.com?subject=" + LangManager.t("fkxx") + "id:" + LoginData.instance.mid + ",ver:" + Application.instance.version + "&body=" + _input.text;
            trace(_loc2_);
            navigateToURL(new URLRequest(_loc2_));
         }
      }
      
      private function onFocusIn(param1:Event) : void
      {
         if(_input.text == _dftxt)
         {
            _input.text = "";
         }
      }
      
      private function onSubmitBtn(param1:Event) : void
      {
         var _loc2_:String = null;
         if(_input.text != _dftxt && _input.text != "")
         {
            switch(Constants.lanVersion - 2)
            {
               case 0:
                  _loc2_ = "mailto:cskh.vuongquockien@gmail.com?subject=" + LangManager.t("fkxx") + "id:" + LoginData.instance.mid + ",ver:" + Application.instance.version + "&body=" + _input.text;
                  trace(_loc2_);
                  navigateToURL(new URLRequest(_loc2_));
                  break;
               case 1:
                  Remoting.instance.onFeedBack(42,"bug",_input.text,onFeedBack);
            }
         }
         else
         {
            TextTip.instance.show(LangManager.t("entercontent"));
         }
      }
      
      private function onCloseBtn(param1:Event) : void
      {
         Starling.juggler.tween(this,0.6,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeInBack",
            "onComplete":cleanUp
         });
      }
      
      private function cleanUp() : void
      {
         _closeBtn.removeEventListener("triggered",onCloseBtn);
         Starling.juggler.removeTweens(this);
         parent.removeChild(this);
      }
      
      private function onFeedBack(param1:Object) : void
      {
         Application.instance.log("onFeedBack",JSON.stringify(param1));
         cleanUp();
         switch(param1.ret)
         {
            case 0:
               TextTip.instance.showByLang("feedBackTip");
               break;
            case 100:
               TextTip.instance.showByLang("feedBackError");
         }
      }
   }
}

