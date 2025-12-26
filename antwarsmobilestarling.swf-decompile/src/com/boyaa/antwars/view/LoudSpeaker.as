package com.boyaa.antwars.view
{
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.screen.chatRoom.ChatRoomDlg;
   import com.boyaa.debug.Logging.LevelLogger;
   import feathers.controls.ScreenNavigator;
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.filters.BlurFilter;
   import starling.text.TextField;
   import starling.textures.Texture;
   
   public class LoudSpeaker extends Sprite
   {
      
      private static var _instance:LoudSpeaker = null;
      
      private var _bg:Quad;
      
      private var _icon:Image;
      
      private var _text:TextField;
      
      private var _sysArr:Array = [];
      
      private var _rollOver:Boolean = true;
      
      private var _speed:int = 3;
      
      private const SHOW_TIME:int = 25;
      
      private const OFFIST_X:int = 170;
      
      private const LoudSpeakIcon:Class = loudSpeak_png$1e1e100c1a70a7607d090f55248d65f31504655265;
      
      public function LoudSpeaker()
      {
         super();
         init();
      }
      
      public static function get instance() : LoudSpeaker
      {
         if(_instance == null)
         {
            _instance = new LoudSpeaker();
         }
         return _instance;
      }
      
      private function init() : void
      {
         var _loc2_:Bitmap = new LoudSpeakIcon();
         var _loc4_:Texture = Texture.fromBitmap(_loc2_);
         _icon = new Image(_loc4_);
         _bg = new Quad(1365,_icon.height,0);
         _bg.alpha = 0.3;
         _bg.touchable = false;
         _text = new TextField(1024,_bg.height,"","Verdana",20,16777215,true);
         _text.x = 1365 - 170;
         _text.bold = true;
         _text.touchable = false;
         _text.hAlign = "left";
         _text.autoScale = true;
         var _loc3_:Quad = new Quad(1365,2);
         var _loc1_:Quad = new Quad(1365,2);
         _loc3_.y = _bg.y;
         _loc1_.y = _bg.y + _bg.height;
         _loc3_.alpha = _loc1_.alpha = 0.8;
         _loc3_.touchable = _loc1_.touchable = false;
         var _loc5_:BlurFilter = BlurFilter.createDropShadow(3,0.5,0,1);
         _text.filter = _loc5_;
         addChild(_bg);
         addChild(_text);
         addChild(_icon);
         addChild(_loc3_);
         addChild(_loc1_);
         this.y = 2;
         GameServer.instance.onLoudSpeaker(playerLoudSpeaker);
         GameServer.instance.getLoudSpeakFromServer(ServerLoudSpeaker);
         this.clipRect = new Rectangle(0,0,1024,this.height);
         this.x = 170;
         this.y = 10;
      }
      
      public function showMessage(param1:String, param2:int = 0, param3:Boolean = false) : void
      {
         var _loc4_:* = null;
         if(param2 > 0)
         {
            param3 = true;
         }
         if(_rollOver)
         {
            playLoudSpeaker(param1,param2);
         }
         else if(param3)
         {
            _sysArr.unshift([param1,param2]);
         }
         else
         {
            _sysArr.push([param1,param2]);
         }
      }
      
      private function playLoudSpeaker(param1:String, param2:int) : void
      {
         if(Application.instance.currentGame.navigator.activeScreenID == "FRESHGAMEWORLD")
         {
            return;
         }
         if(this && this.parent)
         {
            remove();
         }
         if(param2 == 0)
         {
            _icon.visible = true;
            _text.color = 16777215;
         }
         else
         {
            _icon.visible = false;
            _text.color = 16776960;
         }
         _text.text = param1;
         _text.x = 1365 - 170;
         Timepiece.instance.addFun(srollText);
         Timepiece.instance.addDelayCall(remove,25 * 1000);
         _rollOver = false;
         Application.instance.currentGame.frontLayer.addChild(this);
      }
      
      private function srollText() : void
      {
         if(_text.x <= _icon.width && _icon.visible || _text.x <= 0)
         {
            Timepiece.instance.removeFun(srollText,0);
            _rollOver = true;
            if(_sysArr.length != 0)
            {
               playLoudSpeaker(_sysArr[0][0],_sysArr[0][1]);
               _sysArr.shift();
            }
         }
         _text.x -= _speed;
      }
      
      private function playerLoudSpeaker(param1:Object) : void
      {
         var _loc2_:ScreenNavigator = null;
         LevelLogger.getLogger("playerLoudSpeaker").info(JSON.stringify(param1));
         var _loc5_:int = int(param1.data.userId);
         var _loc4_:String = param1.data.name;
         var _loc6_:int = int(param1.data.type);
         var _loc3_:String = param1.data.str;
         if(_loc6_ == 3)
         {
            _loc2_ = Application.instance.currentGame.navigator;
            if(_loc2_.activeScreenID == "HALL" || _loc2_.activeScreenID == "SHOP")
            {
            }
         }
         else
         {
            showMessage(_loc4_ + "：" + _loc3_);
         }
      }
      
      private function ServerLoudSpeaker(param1:Object) : void
      {
         var _loc5_:Array = null;
         var _loc14_:String = null;
         var _loc7_:String = null;
         var _loc10_:int = 0;
         var _loc2_:String = null;
         var _loc15_:int = 0;
         var _loc8_:int = 0;
         LevelLogger.getLogger("ServerLoudSpeadker").info(JSON.stringify(param1));
         var _loc4_:int = int(param1.data.type);
         var _loc6_:String = "";
         var _loc12_:int = 0;
         var _loc13_:String = "";
         var _loc11_:String = "";
         var _loc9_:String = "";
         switch(_loc4_ - 1)
         {
            case 0:
               _loc11_ = param1.data.name;
               _loc6_ = param1.data.propName;
               _loc12_ = int(param1.data.mid);
               _loc13_ = param1.data.place;
               _loc9_ = LangManager.getLang.getreplaceLang("sysinfo1",_loc12_,_loc11_,_loc13_,_loc6_);
               break;
            case 1:
               _loc5_ = param1.data.arr;
               _loc14_ = "";
               switch(param1.data.copyID)
               {
                  case 1:
                     _loc14_ = LangManager.t("butterflyName");
                     break;
                  case 2:
                     _loc14_ = LangManager.t("spiderEmperorName");
                     break;
                  case 3:
               }
               _loc7_ = "";
               _loc10_ = 0;
               switch(param1.data.copyDif)
               {
                  case 1:
                     _loc7_ = LangManager.t("difficult1");
                     break;
                  case 2:
                     _loc7_ = LangManager.t("difficult2");
                     break;
                  case 3:
                     _loc7_ = LangManager.t("difficult3");
                     break;
                  case 4:
                     _loc7_ = LangManager.t("difficult4");
               }
               _loc2_ = "";
               switch(param1.data.firstCopyKill)
               {
                  case 0:
                     break;
                  case 1:
                     break;
                  case 2:
               }
               break;
            case 2:
               _loc11_ = param1.data.name;
               _loc12_ = int(param1.data.mid);
               _loc15_ = int(param1.data.ranking);
               _loc9_ = LangManager.getLang.getreplaceLang("sysinfo6",_loc15_,_loc11_);
               showMessage(_loc9_,_loc4_);
               break;
            case 3:
               _loc11_ = param1.data.name;
               _loc12_ = int(param1.data.mid);
               _loc8_ = int(param1.data.level);
               _loc6_ = param1.data.propName;
               _loc9_ = LangManager.getLang.getreplaceLang("sysinfo7",_loc11_,_loc6_,_loc8_);
               showMessage(_loc9_,_loc4_);
               break;
            case 4:
               _loc11_ = param1.data.name;
               _loc12_ = int(param1.data.mid);
               _loc8_ = int(param1.data.level);
               _loc6_ = param1.data.propName;
               _loc9_ = LangManager.getLang.getreplaceLang("sysinfo5",_loc12_,_loc11_,_loc6_);
               showMessage(_loc9_,_loc4_);
               break;
            case 5:
               _loc9_ = LangManager.getLang.getLangByStr("chat_system");
               _loc9_ = _loc9_ + param1.data.str;
               showMessage(_loc9_,_loc4_);
         }
         Application.instance.log("LoudSpeaker","这是系统消息" + JSON.stringify(param1));
         var _loc3_:int = int(_loc9_.indexOf("]"));
         _loc9_ = _loc9_.substr(_loc3_ + 1);
         ChatRoomDlg.getInstance().showSystemMessage(_loc9_);
      }
      
      private function remove() : void
      {
         Application.instance.log("喇叭被移除","");
         Timepiece.instance.removeFun(srollText,0);
         Timepiece.instance.removeFun(remove,2);
         this && this.parent && this.parent.removeChild(this);
      }
   }
}

