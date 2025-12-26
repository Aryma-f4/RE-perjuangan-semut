package com.boyaa.antwars.view.screen.copygame
{
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.screen.IMainMenu;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import feathers.controls.Screen;
   import flash.filters.GlowFilter;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class CopyGame extends Screen implements IMainMenu, IGuideProcess
   {
      
      public static const LSZC:String = "lszc";
      
      public static const JLXG:String = "jlxg";
      
      public static const TKZC:String = "tkzc";
      
      private var bg:Image;
      
      private var tkzc:Button;
      
      private var jlxg:Button;
      
      private var lszc:Button;
      
      private var selectDif:SelectDiffDlg;
      
      private var nameArr:Array = [LangManager.t("skycity"),LangManager.t("spidercity"),LangManager.t("spritecity")];
      
      private var _whichBtnClick:String = "tkzc";
      
      public function CopyGame()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         var rmger:ResManager;
         Application.instance.currentGame.showLoading();
         rmger = Application.instance.resManager;
         Assets.sAsset.enqueue(rmger.getResFile(formatString("textures/{0}x/COPYGAME/copygame.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/copygame.xml",Assets.sAsset.scaleFactor)));
         Assets.sAsset.loadQueue((function():*
         {
            var onProgress:Function;
            return onProgress = function(param1:Number):void
            {
               var ratio:Number = param1;
               if(ratio == 1)
               {
                  Starling.juggler.delayCall(function():void
                  {
                     init();
                     Application.instance.currentGame.hiddenLoading();
                  },0.15);
               }
            };
         })());
         Remoting.instance.getCopyGrade(function(param1:Object):void
         {
            if(param1.ret == 0)
            {
               CopyList.instance.setGradeData(param1.info);
            }
         });
         Remoting.instance.backBTProp([],function(param1:Object):void
         {
            if(param1.ret == 0)
            {
               GoodsList.instance.payPorpIdArr = param1.props.split("|");
            }
         });
      }
      
      private function init() : void
      {
         var _loc3_:Image = null;
         var _loc6_:int = 0;
         var _loc2_:TextField = null;
         var _loc4_:int = 0;
         bg = new Image(Assets.sAsset.getTexture("fbbg1"));
         bg.x = (1365 - bg.width) / 2;
         addChild(bg);
         tkzc = new Button(Assets.sAsset.getTexture("fb1"),"",Assets.sAsset.getTexture("fb2"));
         Assets.positionDisplay(tkzc,"copygame","tkzc");
         addChild(tkzc);
         tkzc.addEventListener("triggered",onTKZC);
         jlxg = new Button(Assets.sAsset.getTexture("fb3"),"",Assets.sAsset.getTexture("fb4"));
         Assets.positionDisplay(jlxg,"copygame","jlxg");
         jlxg.addEventListener("triggered",onJLXG);
         addChild(jlxg);
         lszc = new Button(Assets.sAsset.getTexture("fb5"),"",Assets.sAsset.getTexture("fb6"));
         Assets.positionDisplay(lszc,"copygame","lszc");
         lszc.addEventListener("triggered",onLSZC);
         addChild(lszc);
         _loc6_ = 1;
         while(_loc6_ < 7)
         {
            _loc3_ = new Image(Assets.sAsset.getTexture("fb7"));
            Assets.positionDisplay(_loc3_,"copygame","wait" + _loc6_);
            addChild(_loc3_);
            _loc6_++;
         }
         var _loc1_:GlowFilter = new GlowFilter(4660230,1,6,6,10);
         var _loc5_:Array = [];
         _loc5_.push(_loc1_);
         _loc4_ = 0;
         while(_loc4_ < nameArr.length)
         {
            _loc2_ = new TextField(132,32,nameArr[_loc4_],"Verdana",28,16777215,true);
            _loc2_.nativeFilters = _loc5_;
            Assets.positionDisplay(_loc2_,"copygame","name" + _loc4_);
            addChild(_loc2_);
            _loc4_++;
         }
         Application.instance.currentGame.mainMenu.show(this);
         Application.instance.currentGame.mainMenu.ReturnBtn.visible = true;
         selectDif = new SelectDiffDlg();
         selectDif.x = (1365 >> 1) - selectDif.width / 2;
         selectDif.y = (768 >> 1) - selectDif.height / 2;
         selectDif.visible = false;
         addChild(selectDif);
         addEventListener("touch",onTouch);
         if(Application.instance.currentGame._guideOptionsData.pos == "copyGame")
         {
            Guide.instance.guide(tkzc);
            Application.instance.currentGame.mainMenu.isEnable(false);
            lszc.enabled = false;
         }
         guideProcess();
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:Vector.<Touch> = param1.getTouches(this);
         if(_loc2_.length > 0 && _loc2_[0].phase == "began")
         {
            if(selectDif)
            {
               _loc3_ = param1.getTouches(selectDif);
               if(_loc3_.length == 0)
               {
                  selectDif.visible = false;
               }
            }
         }
      }
      
      override protected function draw() : void
      {
      }
      
      override public function dispose() : void
      {
         Starling.juggler.removeTweens(selectDif);
         Assets.sAsset.removeTextureAtlas("copygame");
         super.dispose();
      }
      
      public function exit() : void
      {
         Application.instance.currentGame.mainMenu.ReturnBtn.visible = false;
         this.dispatchEventWith("complete");
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         GuideTipManager.instance.currentProcess = this;
         var _loc3_:String = MissionGuideValue.instance.getMissionFlag();
         var _loc4_:SubMissionData = MissionGuideValue.instance.getUnCompleteSubMissions();
         if(!_loc4_)
         {
            return;
         }
         var _loc5_:Array = [tkzc,lszc,jlxg];
         var _loc2_:int = _loc4_.pframe / 10;
         _loc2_ /= 2;
         var _loc6_:* = _loc3_;
         if("copyMission" === _loc6_)
         {
            GuideEventManager.instance.dispactherEvent("newUI",[[_loc5_[_loc2_],20]]);
         }
      }
      
      private function onTKZC(param1:Event) : void
      {
         selectCopy("tkzc");
         if(Application.instance.currentGame._guideOptionsData.pos == "copyGame")
         {
            Guide.instance.guide(selectDif.btnNormal,"",true);
            removeEventListener("touch",onTouch);
         }
      }
      
      private function onJLXG(param1:Event) : void
      {
         selectCopy("jlxg");
      }
      
      private function selectCopy(param1:String) : void
      {
         var _loc2_:int = 1;
         switch(param1)
         {
            case "tkzc":
               _loc2_ = 1;
               break;
            case "lszc":
               _loc2_ = 2;
               break;
            case "jlxg":
               _loc2_ = 3;
               break;
            default:
               _loc2_ = 1;
         }
         _whichBtnClick = param1;
         selectDif.update(CopyList.instance.countGradeByCpId(_loc2_,1));
         selectDif.updateHero(CopyList.instance.countGradeByCpId(_loc2_,2));
         selectDif.visible = true;
         selectDif.alpha = 0;
         Starling.juggler.tween(selectDif,0.8,{
            "alpha":1,
            "transition":"easeOutBack"
         });
         selectDif.guideProcess();
      }
      
      private function onLSZC(param1:Event) : void
      {
         selectCopy("lszc");
      }
      
      public function get whichBtnClick() : String
      {
         return _whichBtnClick;
      }
   }
}

