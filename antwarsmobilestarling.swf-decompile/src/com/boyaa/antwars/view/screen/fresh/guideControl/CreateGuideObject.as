package com.boyaa.antwars.view.screen.fresh.guideControl
{
   import starling.display.DisplayObject;
   
   public class CreateGuideObject
   {
      
      private var _helpMsg:String;
      
      private var _isCompulsory:Boolean;
      
      private var _movieClip:DisplayObject;
      
      private var _direction:String;
      
      private var _movieCenter:int;
      
      public function CreateGuideObject(param1:String = "", param2:Boolean = false, param3:String = "up", param4:int = 0, param5:DisplayObject = null)
      {
         super();
         _helpMsg = param1;
         _isCompulsory = param2;
         _direction = param3;
         _movieCenter = param4;
         if(param5)
         {
            movieClip = param5;
         }
      }
      
      public function get movieCenter() : int
      {
         return _movieCenter;
      }
      
      public function set movieCenter(param1:int) : void
      {
         _movieCenter = param1;
      }
      
      public function get direction() : String
      {
         return _direction;
      }
      
      public function set direction(param1:String) : void
      {
         _direction = param1;
      }
      
      public function get movieClip() : DisplayObject
      {
         return _movieClip;
      }
      
      public function set movieClip(param1:DisplayObject) : void
      {
         _movieClip = param1;
      }
      
      public function get isCompulsory() : Boolean
      {
         return _isCompulsory;
      }
      
      public function set isCompulsory(param1:Boolean) : void
      {
         _isCompulsory = param1;
      }
      
      public function get helpMsg() : String
      {
         return _helpMsg;
      }
      
      public function set helpMsg(param1:String) : void
      {
         _helpMsg = param1;
      }
   }
}

