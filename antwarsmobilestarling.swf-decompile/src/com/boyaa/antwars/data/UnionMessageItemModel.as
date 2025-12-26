package com.boyaa.antwars.data
{
   public class UnionMessageItemModel extends BaseModel
   {
      
      private var _mName:String;
      
      private var _mTitle:String;
      
      private var _mDate:String;
      
      private var _mContent:String;
      
      public function UnionMessageItemModel()
      {
         super();
      }
      
      public function get mName() : String
      {
         return _mName;
      }
      
      public function set mName(param1:String) : void
      {
         _mName = param1;
      }
      
      public function get mTitle() : String
      {
         return _mTitle;
      }
      
      public function set mTitle(param1:String) : void
      {
         _mTitle = param1;
      }
      
      public function get mDate() : String
      {
         return _mDate;
      }
      
      public function set mDate(param1:String) : void
      {
         _mDate = param1;
      }
      
      public function get mContent() : String
      {
         return _mContent;
      }
      
      public function set mContent(param1:String) : void
      {
         _mContent = param1;
      }
   }
}

