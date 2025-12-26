package com.boyaa.antwars.view.screen.chatRoom
{
   public class ChatData
   {
      
      private var _msg:String;
      
      private var _mid:int;
      
      public function ChatData()
      {
         super();
      }
      
      public function readData(param1:String, param2:int = 1) : void
      {
         _msg = param1;
         _mid = param2;
      }
      
      public function get msg() : String
      {
         return _msg;
      }
      
      public function set msg(param1:String) : void
      {
         _msg = param1;
      }
      
      public function get mid() : int
      {
         return _mid;
      }
      
      public function set mid(param1:int) : void
      {
         _mid = param1;
      }
   }
}

