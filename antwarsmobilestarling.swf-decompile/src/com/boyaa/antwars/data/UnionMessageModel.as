package com.boyaa.antwars.data
{
   import com.boyaa.tool.TimeUtil;
   
   public class UnionMessageModel extends BaseModel
   {
      
      private var _mesages:Array = [];
      
      public function UnionMessageModel()
      {
         super();
         initMessage();
      }
      
      private function initMessage() : void
      {
         var _loc2_:int = 0;
         var _loc1_:UnionMessageItemModel = null;
         _loc2_ = 0;
         while(_loc2_ < 20)
         {
            _loc1_ = new UnionMessageItemModel();
            _loc1_.mDate = TimeUtil.timestampToDateString(1408010288 + Math.random() * 10000);
            _loc1_.mName = "公务员" + _loc2_;
            _loc1_.mTitle = "message title" + _loc2_;
            _loc1_.mContent = "message content....." + _loc2_;
            _mesages.push(_loc1_);
            _loc2_++;
         }
      }
      
      public function get mesages() : Array
      {
         return _mesages;
      }
   }
}

