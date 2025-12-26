package com.boyaa.antwars.view.screen.chatRoom
{
   import com.boyaa.antwars.helper.StringUtil;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import feathers.controls.Label;
   import flash.text.TextFormat;
   import org.osflash.signals.Signal;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class ChatListItemRender extends ListItemRenderer
   {
      
      public static var singleSignal:Signal = new Signal();
      
      private var titleText:Label;
      
      private var nameText:Label;
      
      private var contentText:TextField;
      
      private var line1:Quad;
      
      private var meText:Label;
      
      private var toText:Label;
      
      private var sayText:Label;
      
      private const SAY_TITLE_SIZE:int = 25;
      
      private const OFFIST:int = 5;
      
      public function ChatListItemRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         if(!this.bg)
         {
            this.bgNormalTexture = Assets.emptyTexture();
            this.bgFocusTexture = Assets.emptyTexture();
            this.bg = new Image(this.bgNormalTexture);
            addChild(bg);
            titleText = new Label();
            titleText.touchable = false;
            meText = new Label();
            meText.textRendererProperties.textFormat = new TextFormat("Verdana",25,16711680);
            meText.addEventListener("touch",touchToSingle);
            toText = new Label();
            toText.text = LangManager.t("chat1");
            toText.textRendererProperties.textFormat = new TextFormat("Verdana",25,16777215);
            nameText = new Label();
            nameText.textRendererProperties.textFormat = new TextFormat("Verdana",25,65280);
            nameText.addEventListener("touch",touchToSingle);
            sayText = new Label();
            sayText.text = LangManager.t("chat2");
            sayText.textRendererProperties.textFormat = new TextFormat("Verdana",25,16777215);
            contentText = new TextField(900,60,"[]","Verdana",28,16777215);
            contentText.hAlign = "left";
            contentText.autoScale = true;
            contentText.x = titleText.x + 5;
            line1 = new Quad(900,1,4408131);
            line1.x = 5;
            addChild(titleText);
            addChild(meText);
            addChild(toText);
            addChild(nameText);
            addChild(sayText);
            addChild(contentText);
            addChild(line1);
         }
      }
      
      override protected function commitData() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         if(this.data)
         {
            _loc1_ = (this.data.msg as String).split("|");
            _loc2_ = _loc1_[0];
            titleText.text = _loc2_;
            switch(_loc2_)
            {
               case LangManager.t("loudspeaker"):
                  changeState(false);
                  titleText.textRendererProperties.textFormat = new TextFormat("Verdana",25,50943);
                  meText.text = _loc1_[1];
                  contentText.text = _loc1_[2];
                  break;
               case LangManager.t("chat_system"):
                  changeState(false);
                  meText.text = "";
                  nameText.text = "";
                  titleText.textRendererProperties.textFormat = new TextFormat("Verdana",25,16776960);
                  contentText.text = _loc1_[2];
                  break;
               case LangManager.t("unionChatTip"):
                  changeState(false);
                  meText.text = _loc1_[1];
                  titleText.textRendererProperties.textFormat = new TextFormat("Verdana",25,16776960);
                  contentText.text = _loc1_[3];
                  break;
               case LangManager.t("privateChat1"):
                  changeState(true);
                  meText.text = _loc1_[1];
                  nameText.text = _loc1_[2];
                  contentText.text = _loc1_[3];
                  if(_loc1_[1] == LangManager.t("chat0"))
                  {
                     meText.textRendererProperties.textFormat = new TextFormat("Verdana",25,16711680);
                     nameText.textRendererProperties.textFormat = new TextFormat("Verdana",25,65280);
                  }
                  else
                  {
                     meText.textRendererProperties.textFormat = new TextFormat("Verdana",25,65280);
                     nameText.textRendererProperties.textFormat = new TextFormat("Verdana",25,16711680);
                  }
                  titleText.textRendererProperties.textFormat = new TextFormat("Verdana",25,16737792);
                  break;
               case LangManager.t("current"):
                  changeState(false);
                  meText.text = _loc1_[1];
                  contentText.text = _loc1_[2];
                  titleText.textRendererProperties.textFormat = new TextFormat("Verdana",25,16777215);
            }
            validateLabel();
            updatePos();
         }
      }
      
      private function validateLabel() : void
      {
         titleText.validate();
         meText.validate();
         nameText.validate();
         toText.validate();
         sayText.validate();
      }
      
      private function changeState(param1:Boolean) : void
      {
         nameText.visible = param1;
         toText.visible = param1;
         sayText.visible = param1;
      }
      
      private function updatePos() : void
      {
         meText.x = titleText.x + titleText.width;
         toText.x = meText.x + meText.width + 5;
         nameText.x = toText.x + toText.width + 5;
         sayText.x = nameText.x + nameText.width + 5;
         contentText.y = titleText.y + titleText.height;
         line1.y = contentText.y + contentText.height;
         this.bg.height = contentText.y + contentText.height;
      }
      
      private function touchToSingle(param1:TouchEvent) : void
      {
         var _loc3_:Touch = param1.getTouch(nameText,"began");
         var _loc2_:Touch = param1.getTouch(meText,"began");
         if(_loc3_)
         {
            if(StringUtil.trim(nameText.text) == LangManager.t("chat0"))
            {
               return;
            }
            singleSignal.dispatch(nameText.text,this._data.mid);
         }
         if(_loc2_)
         {
            if(StringUtil.trim(meText.text) == LangManager.t("chat0"))
            {
               return;
            }
            if(meText.text.lastIndexOf(":") != -1)
            {
               singleSignal.dispatch(meText.text.substr(0,meText.text.length - 1),this._data.mid);
            }
            else
            {
               singleSignal.dispatch(meText.text,this._data.mid);
            }
         }
      }
   }
}

