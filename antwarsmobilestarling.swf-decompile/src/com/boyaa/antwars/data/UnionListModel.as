package com.boyaa.antwars.data
{
   public class UnionListModel extends BaseModel
   {
      
      private var _curPageUnionArr:Array = null;
      
      private var _unionData:UnionListItemModel = null;
      
      public function UnionListModel()
      {
         super();
         _curPageUnionArr = [];
         _unionData = new UnionListItemModel();
      }
      
      public function removeData() : void
      {
         _unionData = null;
         _curPageUnionArr = [];
         _curPageUnionArr = null;
      }
      
      public function createUnion(param1:Object) : UnionListItemModel
      {
         _unionData.createData(param1);
         return unionData;
      }
      
      public function selfUnionData(param1:Object) : UnionListItemModel
      {
         _unionData.createData(param1.cinfo);
         _unionData.selfInUnionData(param1.minfo);
         return _unionData;
      }
      
      public function getCurPageUnionList(param1:Object) : void
      {
         _unionData = new UnionListItemModel();
         _unionData.createData(param1);
         _curPageUnionArr.push(_unionData);
      }
      
      public function getPosName(param1:int) : String
      {
         switch(param1 - 1)
         {
            case 0:
               return _unionData.honorName.fir;
            case 1:
               return _unionData.honorName.sec;
            case 7:
               return _unionData.honorName.thir;
            case 8:
               return _unionData.honorName.four;
            default:
               return "";
         }
      }
      
      public function get curPageUnionArr() : Array
      {
         return _curPageUnionArr;
      }
      
      public function set curPageUnionArr(param1:Array) : void
      {
         _curPageUnionArr = param1;
      }
      
      public function get unionData() : UnionListItemModel
      {
         return _unionData;
      }
   }
}

