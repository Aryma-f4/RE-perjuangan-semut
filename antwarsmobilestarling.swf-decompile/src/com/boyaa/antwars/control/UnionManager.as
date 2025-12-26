package com.boyaa.antwars.control
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.UnionListItemModel;
   import com.boyaa.antwars.data.UnionListModel;
   import com.boyaa.antwars.data.UnionMessageModel;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.union.UnionEvent;
   import starling.events.EventDispatcher;
   
   public class UnionManager extends EventDispatcher
   {
      
      private static var _instance:UnionManager;
      
      private var _unionAllModel:UnionListModel;
      
      private var _messageModel:UnionMessageModel;
      
      private var _isHave:Boolean = false;
      
      private var _applyUnionModel:UnionListModel;
      
      private var _myUnionModel:UnionListItemModel;
      
      public function UnionManager(param1:Singletoner)
      {
         super();
         if(param1 == null)
         {
            throw new Error("只能用getInstance()来获取实例");
         }
      }
      
      public static function getInstance() : UnionManager
      {
         if(_instance == null)
         {
            _instance = new UnionManager(new Singletoner());
            _instance.init();
         }
         return _instance;
      }
      
      private function init() : void
      {
         _unionAllModel = new UnionListModel();
         _applyUnionModel = new UnionListModel();
         _messageModel = new UnionMessageModel();
      }
      
      public function isHaveUnion() : void
      {
         Remoting.instance.gameTable.isHaveUnion();
         EventCenter.PHPEvent.addEventListener("isHaveUnion",isHaveUnionHandel);
      }
      
      public function cancelApplyUnion(param1:int) : void
      {
         Remoting.instance.gameTable.cancelApplyUnion(param1);
         EventCenter.PHPEvent.addEventListener("cancelApplyUnion",cancelApplyUnionHandel);
      }
      
      public function createUnion(param1:Object) : void
      {
         Remoting.instance.gameTable.createUnion(param1);
         EventCenter.PHPEvent.addEventListener("createUnion",createUnionHandel);
      }
      
      private function cancelApplyUnionHandel(param1:PHPEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
      }
      
      private function createUnionHandel(param1:PHPEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = param1.param;
         switch(_loc3_.ret)
         {
            case 0:
               _unionAllModel.selfUnionData(_loc3_.info);
               dispatchEvent(new UnionEvent(UnionEvent.UNION_CREATE_DONE));
               MissionManager.instance.updateMissionData(131);
               break;
            case 1033:
               TextTip.instance.showByLang("youLevelLess");
               break;
            case 100:
               TextTip.instance.showByLang("UnionCreateErrorCoinNotEnough");
               break;
            case 101:
         }
      }
      
      private function isHaveUnionHandel(param1:PHPEvent) : void
      {
         Application.instance.log("isHaveUnionHandle",param1.param as String);
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         if(_loc3_.ret != 0)
         {
            throw new Error("数据返回错误");
         }
         if(_loc3_.cinfo && _loc3_.cinfo.cid)
         {
            _myUnionModel = new UnionListItemModel();
            _myUnionModel.createData(_loc3_.cinfo);
            this._isHave = true;
            PlayerDataList.instance.selfData.cid = _loc3_.cinfo.cid;
            _myUnionModel.selfInUnionData(_loc3_.minfo);
            MissionManager.instance.updateMissionData(122);
         }
         else
         {
            PlayerDataList.instance.selfData.cid = 0;
            this._isHave = false;
         }
         dispatchEvent(new UnionEvent(UnionEvent.UNION_DATA_REFRESH));
      }
      
      public function get unionAllModel() : UnionListModel
      {
         return _unionAllModel;
      }
      
      public function get messageModel() : UnionMessageModel
      {
         return _messageModel;
      }
      
      public function get isHave() : Boolean
      {
         return _isHave;
      }
      
      public function set isHave(param1:Boolean) : void
      {
         _isHave = param1;
      }
      
      public function get applyUnionModel() : UnionListModel
      {
         return _applyUnionModel;
      }
      
      public function get myUnionModel() : UnionListItemModel
      {
         return _myUnionModel;
      }
   }
}

class Singletoner
{
   
   public function Singletoner()
   {
      super();
   }
}
