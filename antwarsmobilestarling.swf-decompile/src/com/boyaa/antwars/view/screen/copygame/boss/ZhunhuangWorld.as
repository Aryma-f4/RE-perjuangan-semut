package com.boyaa.antwars.view.screen.copygame.boss
{
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.CopyMonsterRoleList;
   import com.boyaa.antwars.data.model.CopyDetailData;
   import com.boyaa.antwars.data.model.CopyMonster;
   import com.boyaa.antwars.data.model.CopyMonsterRole;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import com.boyaa.antwars.view.monster.Monster;
   import com.boyaa.antwars.view.monster.MonsterCtrl;
   import com.boyaa.antwars.view.monster.MonsterData;
   import com.boyaa.antwars.view.monster.MonsterFactory;
   import com.boyaa.antwars.view.screen.copygame.boss.member.BossCtrl;
   import com.boyaa.antwars.view.screen.copygame.boss.member.BossMonster;
   import com.boyaa.antwars.view.screen.copygame.boss.member.ZhunHuangBoss;
   import com.boyaa.antwars.view.screen.copygame.boss.member.ZhunHuangBossCtrl;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.utils.formatString;
   
   public class ZhunhuangWorld extends BossWorld
   {
      
      private var _isInit:Boolean = true;
      
      private var _bossPosition:Vector.<Point>;
      
      private var _currentPosition:Point;
      
      private var _lastId:int;
      
      private var _isFlush:int = 0;
      
      private const monsterNum:int = 6;
      
      public const maxMonsterNum:int = 7;
      
      private var _monsterBornPointArr:Array = [];
      
      private const SITENUM:uint = 4;
      
      private var roleIdArr:Array = [];
      
      private var _arr:Array = [];
      
      private var _oldStatus:String = "";
      
      public function ZhunhuangWorld()
      {
         super();
         playBgSound("Music 15");
      }
      
      private function setLeftNumTextPos() : void
      {
         txtBg.x = 15;
         txtLeftNum.x = 0;
      }
      
      override protected function loadAssets(param1:ResManager) : void
      {
         super.loadAssets(param1);
         Assets.btAsset.enqueue(param1.getResFile(formatString("textures/{0}x/COPYGAME/badstate.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYGAME/badstate.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill2.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYGAME/monsterskill2.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/spider.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/spider.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_spider.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/zhunhuang.png",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/zhunhuang.xml",Assets.sAsset.scaleFactor)),param1.getResFile(formatString("textures/{0}x/COPYCHAR/skeleton_zhunhuang.xml",Assets.sAsset
         .scaleFactor)));
      }
      
      override protected function addPlayer() : void
      {
         super.addPlayer();
      }
      
      override protected function switchCtrl() : void
      {
         super.switchCtrl();
         if(currentCtrl == 1)
         {
            zhunhuangSetStatus(bossCtrl);
         }
      }
      
      override protected function flushBoss() : void
      {
         var _loc2_:int = 0;
         var _loc5_:ZhunHuangBossCtrl = null;
         var _loc1_:CopyMonsterRole = null;
         var _loc7_:MonsterData = null;
         var _loc3_:ZhunHuangBoss = null;
         if(!_isInit)
         {
            return;
         }
         super.flushBoss();
         if(!_bossPosition)
         {
            Application.instance.currentGame.navigator.showScreen("SPIDERCITY");
            return;
         }
         var _loc6_:int = 0;
         _lastId = 4;
         for each(var _loc4_ in copyData.monsterList)
         {
            _loc2_ = _loc4_.roleid;
            _currentPosition = _bossPosition[0];
            _loc1_ = CopyMonsterRoleList.instance.getRoleById(_loc2_);
            _loc7_ = new MonsterData(_loc1_);
            _loc7_.isfly = true;
            _loc3_ = ZhunHuangBoss(MonsterFactory.instance.createBoss(_loc1_.remake,_loc7_));
            this.charatersLayer.addChild(_loc3_);
            _loc5_ = new ZhunHuangBossCtrl(this,_loc3_,_lastId + _loc6_);
            Starling.juggler.add(_loc5_);
            _loc5_.actionCompleteSignal.add(monsterActionCompleteHandle);
            _loc5_.attackSignal.add(bossAttackHandle);
            monsterCtrlVector.push(_loc5_);
            bossCtrl = _loc5_;
            _loc3_.x = _currentPosition.x;
            _loc3_.y = _currentPosition.y;
            _loc6_++;
            camera.swapFocus(_loc3_,20);
         }
         _isInit = false;
         showLeftNumText();
         trace("玩家当前的血量为" + selfCharacterCtrl.hp);
      }
      
      public function flushMonster() : void
      {
         var _loc1_:CopyDetailData = CopyList.instance.currentCopyData;
         switch(_loc1_.difficulty - 1)
         {
            case 0:
               flush(1);
               break;
            case 1:
               flush(3);
         }
         showLeftNumText();
      }
      
      private function flush(param1:int = 1) : void
      {
         var _loc8_:int = 0;
         var _loc2_:* = 0;
         var _loc6_:MonsterCtrl = null;
         var _loc7_:int = 0;
         var _loc3_:CopyMonsterRole = null;
         var _loc5_:MonsterData = null;
         var _loc4_:Monster = null;
         roleIdArr = [];
         roleIdArr = bossHitObject.data.monsterArr;
         _loc8_ = 0;
         while(_loc8_ < roleIdArr.length)
         {
            _lastId += 1;
            _loc2_ = uint(roleIdArr[_loc8_]);
            _loc7_ = int(_loc2_);
            _loc3_ = CopyMonsterRoleList.instance.getRoleById(_loc7_);
            _loc5_ = new MonsterData(_loc3_);
            _loc5_.move_speed = 70;
            _loc4_ = MonsterFactory.instance.create(_loc3_.remake,_loc5_);
            _loc6_ = new MonsterCtrl(this,_loc4_,_lastId);
            this.charatersLayer.addChild(_loc4_);
            Starling.juggler.add(_loc6_);
            _loc6_.actionCompleteSignal.add(monsterActionCompleteHandle);
            _loc6_.attackSignal.add(monsterAttackHandle);
            monsterCtrlVector.push(_loc6_);
            if(_loc5_.spiece_type == 11)
            {
               _loc4_.x = bossHitObject.data.posX + _loc8_ * 30;
               _loc4_.y = 100;
            }
            else
            {
               _loc4_.x = _monsterBornPointArr[_loc2_][0] + 50 * _loc8_;
               _loc4_.y = _monsterBornPointArr[_loc2_][1];
            }
            _loc6_.actionCompleteSignal.dispatch();
            camera.focusTarget = _loc4_;
            _loc8_++;
         }
      }
      
      override protected function slottingCompleteSignalHandle(param1:int, param2:Array) : void
      {
         super.slottingCompleteSignalHandle(param1,param2);
      }
      
      override protected function onBombPoint(param1:Object) : void
      {
         var retData:Object = param1;
         super.onBombPoint(retData);
         Starling.juggler.delayCall((function():*
         {
            var call:Function;
            return call = function():void
            {
               showLeftNumText();
            };
         })(),1);
      }
      
      override protected function bossAttackHandle(param1:String, param2:BossCtrl) : void
      {
         var _loc3_:Array = null;
         super.bossAttackHandle(param1,param2);
         if(param1.indexOf("dizzy") != -1 || param1.indexOf("call") != -1)
         {
            return;
         }
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         switch(param1)
         {
            case "hangfire":
            case "landimpale":
            case "wildimpale":
               _loc3_ = bossHitObject.data.playerHitArr;
               _loc4_ = int(bossHitObject.data.length);
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  dropHpByServer(param2,getCtrlBySiteID(_loc3_[_loc5_][0]),_loc3_[_loc5_][1],_loc3_[_loc5_][2]);
                  _loc5_++;
               }
               break;
            case "hangbuff":
               break;
            default:
               dropHpByServer(param2,getCtrlBySiteID(dizzySite),lossHpHitByBoss,Boolean(isPow));
         }
      }
      
      private function zhunhuangSetStatus(param1:ICharacterCtrl) : void
      {
         if(!(param1 is ZhunHuangBossCtrl))
         {
            return;
         }
         var _loc2_:ZhunHuangBossCtrl = ZhunHuangBossCtrl(param1);
         _loc2_.getHpPercentage();
         var _loc3_:BossMonster = BossMonster(_loc2_.icharacter);
         switch(_loc2_.currentState)
         {
            case _loc2_.spiderZhunHuangStatusArr[0]:
            case _loc2_.spiderZhunHuangStatusArr[1]:
            case _loc2_.spiderZhunHuangStatusArr[2]:
            case _loc2_.spiderZhunHuangStatusArr[3]:
         }
         _arr = _loc2_.spiderZhunHuangStatusArr;
         setPosition(_loc2_.currentState,_loc3_);
      }
      
      public function setPosition(param1:String, param2:BossMonster) : void
      {
         if(_oldStatus == param1)
         {
            return;
         }
         _oldStatus = param1;
         _currentPosition = _bossPosition[_arr.indexOf(param1)];
         param2.x = _currentPosition.x;
         param2.y = _currentPosition.y;
         if(param1 == "LAND" || param1 == "WILD")
         {
            param2.data.isfly = false;
            bossCtrl.downStatus = true;
         }
      }
      
      override protected function init() : void
      {
         var arr:Array;
         super.init();
         allMonsters = 1;
         _bossPosition = new Vector.<Point>();
         arr = [];
         CopyServer.instance.getBossBorning((function():*
         {
            var call:Function;
            return call = function(param1:Object):void
            {
               var _loc3_:int = 0;
               var _loc2_:Point = null;
               arr = param1.data.arr;
               _loc3_ = 0;
               while(_loc3_ < arr.length)
               {
                  _loc2_ = new Point(arr[_loc3_][0],arr[_loc3_][1]);
                  _bossPosition.push(_loc2_);
                  _loc3_++;
               }
            };
         })());
         Starling.juggler.delayCall((function():*
         {
            var delay:Function;
            return delay = function():void
            {
               if(arr.length == 0)
               {
                  _bossPosition.push(new Point(1350,150));
                  _bossPosition.push(new Point(1350,300));
                  _bossPosition.push(new Point(1350,680));
                  _bossPosition.push(new Point(1350,680));
               }
            };
         })(),0.5);
         _monsterBornPointArr[19] = [700,700];
         _monsterBornPointArr[25] = [700,700];
         _monsterBornPointArr[17] = [100,400];
         _monsterBornPointArr[23] = [100,400];
      }
      
      override public function showLeftNumText() : void
      {
         super.showLeftNumText();
         setLeftNumTextPos();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Assets.btAsset.removeTextureAtlas("badstate");
         Assets.btAsset.removeTextureAtlas("spider");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("spider");
         Assets.btAsset.removeTextureAtlas("zhunhuang");
         Assets.btAsset.removeSkeletonsAndBoneAtlases("zhunhuang");
         Assets.btAsset.removeTextureAtlas("monsterskill2");
         Assets.sAsset.removeTextureAtlas("copygameui");
         Assets.sAsset.removeTextureAtlas("skycity");
         Assets.sAsset.removeTextureAtlas("btdlg");
      }
      
      public function get currentPosition() : Point
      {
         return _currentPosition;
      }
      
      public function get isFlush() : int
      {
         return _isFlush;
      }
      
      public function set isFlush(param1:int) : void
      {
         _isFlush = param1;
      }
   }
}

