package com.boyaa.antwars.view.screen.unionBossFight
{
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.model.ServerData;
   import com.boyaa.antwars.helper.AnalysisPHPTimeData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import dragonBones.Armature;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class UnionBossFightDlg extends BaseDlg
   {
      
      private var _layout:LayoutUitl;
      
      private var _enter:Sprite = new Sprite();
      
      private var _rank:Sprite = new Sprite();
      
      private var _rankControl:UnionBossRank;
      
      private var _boss0:Armature;
      
      private var _bossContaner0:Sprite = new Sprite();
      
      private var _isFight:Boolean = false;
      
      private var _time1:String = "";
      
      public function UnionBossFightDlg(param1:Boolean = true)
      {
         super(param1);
         connectServer();
      }
      
      private function connectServer() : void
      {
         GameServer.instance.getServerIDByType(22,function(param1:Object):void
         {
            var data:Object = param1;
            var serData:ServerData = AllRoomData.instance.getDataByID(data.svid);
            CopyServer.instance.init(serData.ip,serData.port);
            Application.instance.log("UnionBossFight-connectServer",JSON.stringify(data));
            CopyServer.instance.connect();
            CopyServer.instance.serverType = 1;
            CopyServer.instance.loginSuccessful((function():*
            {
               var send:Function;
               return send = function():void
               {
                  bindNet();
                  loadAsset();
                  CopyServer.instance.sendUnionFightInfo();
               };
            })());
         });
      }
      
      private function bindNet() : void
      {
         CopyServer.instance.onUnionFightInfo(onUnionFightInfo);
         CopyServer.instance.onUnionFightState(onUnionFightState);
      }
      
      private function unBindNet() : void
      {
         CopyServer.instance.disposeRecvFun(onUnionFightInfo);
         CopyServer.instance.disposeRecvFun(onUnionFightState);
      }
      
      private function onUnionFightState(param1:Object) : void
      {
         Application.instance.log("onUnionFightState",JSON.stringify(param1));
         if(param1.data.reason == 1)
         {
            TextTip.instance.showByLang("unionFightTip1");
         }
         else if(param1.data.reason == 2)
         {
            TextTip.instance.showByLang("unionFightTip7");
         }
      }
      
      private function onUnionFightInfo(param1:Object) : void
      {
         Application.instance.log("onUnionFightInfo",JSON.stringify(param1));
         var _loc3_:Date = new Date();
         _loc3_.setTime(param1.data.startTime * 1000);
         var _loc2_:Date = new Date();
         _loc2_.setTime(param1.data.endTime * 1000);
         _time1 = AnalysisPHPTimeData.getDataString("-",param1.data.startTime) + "-" + AnalysisPHPTimeData.getDataString("-",param1.data.endTime).substr(11);
         Application.instance.currentGame._copyModeOptionsData = param1;
      }
      
      private function loadAsset() : void
      {
         Assets.sAsset.enqueue(Application.instance.resManager.getResFile(formatString("textures/{0}x/OTHER/unionBossFight.png",Assets.sAsset.scaleFactor)),Application.instance.resManager.getResFile(formatString("textures/{0}x/OTHER/unionBossFight.xml",Assets.sAsset.scaleFactor)),Application.instance.resManager.getResFile(formatString("textures/{0}x/COPYCHAR/scorpionKind.png",Assets.sAsset.scaleFactor)),Application.instance.resManager.getResFile(formatString("textures/{0}x/COPYCHAR/scorpionKind.xml",Assets.sAsset.scaleFactor)),Application.instance.resManager.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_scorpionKind.xml",Assets.sAsset.scaleFactor)));
         Application.instance.currentGame.showLoading();
         Assets.sAsset.loadQueue(loading);
      }
      
      private function loading(param1:Number) : void
      {
         if(param1 == 1)
         {
            Application.instance.currentGame.hiddenLoading();
            _layout = new LayoutUitl(Assets.sAsset.getOther("unionBossFight"),Assets.sAsset);
            _layout.buildLayout("unionBossLayout",_enter);
            _layout.buildLayout("unionRankLayout",_rank);
            SmallCodeTools.instance.setDisplayObjectInStageMiddle(_enter);
            SmallCodeTools.instance.setDisplayObjectInStageMiddle(_rank);
            _rankControl = new UnionBossRank(_rank);
            addChild(_enter);
            init();
            active();
         }
      }
      
      private function init() : void
      {
         _boss0 = SmallCodeTools.instance.createArmature("scorpionKind","stand");
         _bossContaner0.addChild(_boss0.display as DisplayObject);
         _enter.addChild(_bossContaner0);
         SmallCodeTools.instance.setDisplayObjectInSame(_enter.getChildByName("boss0"),_boss0.display as DisplayObject);
         _bossContaner0.addEventListener("touch",onTouchBossHandle);
         TextField(_enter.getChildByName("time1")).text = _time1;
         TextField(_enter.getChildByName("time2")).text = "";
         initEnterSprite();
      }
      
      private function onTouchBossHandle(param1:TouchEvent) : void
      {
         var e:TouchEvent = param1;
         var myTouch:Touch = e.getTouch(e.target as DisplayObject,"ended");
         if(myTouch)
         {
            SystemTip.instance.showSystemAlert(LangManager.t("unionFightTip0"),(function():*
            {
               var yes:Function;
               return yes = function():void
               {
                  CopyServer.instance.sendUnionFightStart(onGameStart);
               };
            })(),(function():*
            {
               var no:Function;
               return no = function():void
               {
                  _isFight = false;
               };
            })());
         }
      }
      
      private function onGameStart(param1:Object) : void
      {
         Application.instance.log("onGameStart",JSON.stringify(param1));
         _isFight = true;
         Application.instance.currentGame.navigator.showScreen("UNIONBOSSWORLD");
         this.removeFromParent(true);
      }
      
      private function initEnterSprite() : void
      {
         StarlingUITools.instance.initStarlingButton(_enter,"btnS_close",deactive);
         StarlingUITools.instance.initStarlingButton(_enter,"rankBtn",onShowRankHandle);
      }
      
      private function onShowRankHandle(param1:Event) : void
      {
         _rankControl.updateDate();
         addChild(_rank);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Assets.sAsset.removeTextureAtlas("unionBossFight");
         if(!_isFight)
         {
            Assets.sAsset.removeSkeletonsAndBoneAtlases("scorpionKind");
            CopyServer.instance.close();
         }
      }
   }
}

