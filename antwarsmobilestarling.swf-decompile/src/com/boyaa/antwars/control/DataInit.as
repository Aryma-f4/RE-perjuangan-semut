package com.boyaa.antwars.control
{
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.read.ReadSelfData;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.CreateRole;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.wedding.WeddingManager;
   import com.boyaa.antwars.view.vipSystem.VipManager;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import org.osflash.signals.Signal;
   
   public class DataInit
   {
      
      public static const STATE_INIT_DATA:String = "STATE_INIT_DATA";
      
      public static const STATE_CREATE_ROLE:String = "STATE_CREATE_ROLE";
      
      public static const STATE_CONNECT_SERVER:String = "STATE_CONNECT_SERVER";
      
      public static const STATE_COMPLETE:String = "STATE_COMPLETE";
      
      public var dataInitStateSignal:Signal = null;
      
      private var _rsd:ReadSelfData;
      
      private var _createRoleDlg:CreateRole = null;
      
      private var _propsArr:Array = null;
      
      private var _bodyPropsArr:Array = null;
      
      private var mViewPort:Rectangle;
      
      private var _stage:Stage;
      
      private var freshpack:int;
      
      public function DataInit(param1:Stage, param2:Rectangle)
      {
         super();
         _stage = param1;
         mViewPort = param2;
         dataInitStateSignal = new Signal(String);
      }
      
      public function init() : void
      {
         readXMLDataAndRoleInfo();
         dataInitStateSignal.dispatch("STATE_INIT_DATA");
      }
      
      public function readXMLDataAndRoleInfo() : void
      {
         Application.instance.log("DataInit","readXMLDataAndRoleInfo");
         _rsd = new ReadSelfData();
         _rsd.createRoleSignal.addOnce(createRole);
         _rsd.readCompleteSignal.addOnce(readSelfDataComplete);
         _rsd.read();
      }
      
      private function createRole() : void
      {
         _createRoleDlg = new CreateRole(_stage,mViewPort);
         _createRoleDlg.init();
         _createRoleDlg.show();
         _createRoleDlg.setSex(PlayerDataList.instance.selfData.sex);
         _createRoleDlg.setName(PlayerDataList.instance.selfData.name);
         _createRoleDlg.confirmSignal.addOnce(createRoleConfirm);
      }
      
      private function createRoleConfirm() : void
      {
         dataInitStateSignal.dispatch("STATE_CREATE_ROLE");
         Remoting.instance.create([_createRoleDlg.getName(),_createRoleDlg.getSex(),"1|1|1|1"],createRoleComplete);
         _createRoleDlg.destroy();
      }
      
      private function createRoleComplete(param1:Object) : void
      {
         if(param1.ret == 1)
         {
            _rsd.setRoleData(param1);
         }
      }
      
      private function readSelfDataComplete(param1:int) : void
      {
         this.freshpack = param1;
         dataInitStateSignal.dispatch("STATE_CONNECT_SERVER");
         Application.instance.log("readSelfDataCompplete","getConnectServer");
         Remoting.instance.getCenterSever(getCenterSeverCallBack);
         MissionManager.instance.getMissionState();
      }
      
      private function getCenterSeverCallBack(param1:Object) : void
      {
         var _loc2_:* = 0;
         Application.instance.log("getCenterServer","mgid:" + Constants.mgid);
         if(param1.ret == 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.list.length)
            {
               if(param1.list[_loc2_]["mgid"] == Constants.mgid && param1.list[_loc2_]["svtype"] == 2)
               {
                  connectServer(param1.list[_loc2_]["svip"],param1.list[_loc2_]["svport"]);
                  return;
               }
               _loc2_++;
            }
         }
      }
      
      private function connectServer(param1:String, param2:int) : void
      {
         Application.instance.log("connectServer","host:" + param1 + " port:" + param2);
         GameServer.instance.init(param1,param2);
         GameServer.instance.socketSignal.addOnce(socketSignalHandle);
         GameServer.instance.connect();
      }
      
      private function socketSignalHandle(param1:String) : void
      {
         var type:String = param1;
         var _loc2_:String = type;
         if("Connect" === _loc2_)
         {
            WeddingManager.instance.init();
            GameServer.instance.getAllGoods(getAllGoodsCallBack);
            GameServer.instance.getBagItemRentStatus(function(param1:Object):void
            {
               GoodsList.instance.rentArr = param1 as Array;
            });
            GameServer.instance.nobodyRentBacktoMystore(function(param1:Object):void
            {
               GoodsList.instance.nobodyRentBacktoMystore(param1 as Array);
            });
            GameServer.instance.getServerList(function(param1:Object):void
            {
               Application.instance.log("获取服务器ip",JSON.stringify(param1));
               AllRoomData.instance.addRoomInServer(param1 as Array);
            });
            VipManager.instance.getSelfVipInfo();
            rentalGoodsOvertimeCallback();
         }
      }
      
      private function getAllGoodsCallBack(param1:Object) : void
      {
         if(param1.ret == 0)
         {
            _propsArr = param1.list;
         }
         GameServer.instance.getMemBody(getMemBodyCallBack);
      }
      
      private function getMemBodyCallBack(param1:Array) : void
      {
         trace(JSON.stringify(param1));
         _bodyPropsArr = param1;
         saveGoods();
         dataInitStateSignal.dispatch("STATE_COMPLETE");
         if(this.freshpack == 0)
         {
         }
      }
      
      private function saveGoods() : void
      {
         var _loc8_:int = 0;
         var _loc3_:Array = null;
         var _loc10_:GoodsData = null;
         var _loc7_:int = 0;
         var _loc12_:Array = null;
         var _loc14_:int = 0;
         GoodsList.instance.init();
         var _loc4_:Array = _bodyPropsArr;
         var _loc5_:Array = _loc4_[3];
         var _loc13_:Object = {};
         var _loc9_:String = _loc4_[4];
         var _loc2_:Array = _loc9_.split(",");
         _loc8_ = 0;
         while(_loc8_ < _loc2_.length)
         {
            _loc3_ = (_loc2_[_loc8_] as String).split("|");
            _loc13_[_loc3_[0]] = _loc3_[1];
            _loc8_++;
         }
         var _loc11_:Array = [];
         _loc7_ = 0;
         while(_loc7_ < _propsArr.length)
         {
            _loc12_ = _propsArr[_loc7_];
            _loc14_ = 0;
            if(_loc13_ && _loc13_.hasOwnProperty(_loc12_[0]))
            {
               _loc14_ = int(_loc13_[_loc12_[0]]);
            }
            if(_loc14_ == 1)
            {
               _loc14_ = 0;
            }
            if(_loc11_.indexOf(_loc14_) != -1)
            {
               _loc14_ = 0;
            }
            if(_loc5_.indexOf(String(_loc12_[0])) != -1)
            {
               _loc14_ = 1;
            }
            _loc11_.push(_loc14_);
            _loc10_ = GoodsList.instance.addGoodsByStr(_propsArr[_loc7_]);
            _loc10_.place = _loc14_;
            GoodsList.instance.holdPositions(_loc10_.onlyID,_loc10_.place);
            _loc7_++;
         }
         var _loc1_:Object = _loc4_[1] as Object;
         for(var _loc15_ in _loc1_)
         {
            if(_loc15_ != "package")
            {
               if(_loc1_[_loc15_] != 0)
               {
                  _loc10_ = GoodsList.instance.getGoodsByOnlyID(_loc1_[_loc15_]);
                  _loc10_.placeDec = _loc15_;
                  if(_loc10_.stutas == 0)
                  {
                     GoodsList.instance.inBodyExpiration.push(_loc10_);
                     _loc10_.place = 0;
                     GameServer.instance.setMemBody([_loc10_.placeDec,0,_loc10_.onlyID],setMemBodyCallBack);
                  }
               }
            }
         }
         var _loc6_:Array = GoodsList.instance.inBodyExpiration;
         if(_loc6_.length > 0)
         {
         }
         _propsArr = null;
         _bodyPropsArr = null;
      }
      
      private function setMemBodyCallBack(param1:Array) : void
      {
         trace(JSON.stringify(param1));
      }
      
      private function rentalGoodsOvertimeCallback() : void
      {
         GameServer.instance.deleteOvertimeRentalGoods(function(param1:Object):void
         {
            GoodsList.instance._rentalGoodsOvertime.push((param1 as Array)[1]);
            if(PlayerDataList.instance.selfData.inFight == false)
            {
               GoodsList.instance.removeOvertimeRentalEquip();
            }
         });
      }
   }
}

