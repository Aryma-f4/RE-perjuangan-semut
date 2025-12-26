package com.boyaa.antwars.view
{
   import com.boyaa.antwars.helper.StringUtil;
   import com.boyaa.antwars.view.ui.MCButton;
   import com.boyaa.tool.filter.DirtyWordFilter;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import org.osflash.signals.Signal;
   import swcs.screen.createRoleScreen;
   
   public class CreateRole
   {
      
      public var confirmSignal:Signal = null;
      
      private var _roleScreen:createRoleScreen = null;
      
      private var _sex:uint = 0;
      
      private var _deftext:String = "";
      
      private var _makenamebtn:MCButton = null;
      
      private var _enterGamebtn:MCButton = null;
      
      private var mViewPort:Rectangle;
      
      private var _stage:Stage;
      
      public function CreateRole(param1:Stage, param2:Rectangle)
      {
         super();
         _stage = param1;
         mViewPort = param2;
         confirmSignal = new Signal();
      }
      
      public function init() : void
      {
         _roleScreen = new createRoleScreen();
         _roleScreen.width = mViewPort.width;
         _roleScreen.height = mViewPort.height;
         _roleScreen.x = mViewPort.x;
         _roleScreen.y = mViewPort.y;
         _deftext = _roleScreen.roleName.text;
         _roleScreen.roleName.addEventListener("focusIn",onRoleNameTextFocus);
         _roleScreen.roleName.addEventListener("change",onChange);
         _roleScreen.roleName.maxChars = 6;
         _roleScreen.male.addEventListener("mouseDown",onMaleClick);
         _roleScreen.male.buttonMode = true;
         _roleScreen.female.addEventListener("mouseDown",onFemaleClick);
         _roleScreen.female.buttonMode = true;
         _roleScreen.male.stop();
         _roleScreen.female.stop();
         if(Constants.lanVersion == 2 || Constants.lanVersion == 3)
         {
            _roleScreen.makename.visible = false;
         }
         if(Constants.lanVersion != 2)
         {
            _makenamebtn = new MCButton(_roleScreen.makename);
            _makenamebtn.click = onMakeName;
         }
         _enterGamebtn = new MCButton(_roleScreen.enterGame);
         _enterGamebtn.click = onEnterClick;
      }
      
      private function onChange(param1:Event) : void
      {
         if(_roleScreen.roleName.text.length > 6)
         {
            _roleScreen.roleName.text = _roleScreen.roleName.text.substr(0,6);
         }
      }
      
      public function show() : void
      {
         _stage.addChild(_roleScreen);
      }
      
      public function setSex(param1:uint) : void
      {
         if(param1 == 0)
         {
            _roleScreen.male.gotoAndStop(2);
            _roleScreen.female.gotoAndStop(3);
         }
         else
         {
            _roleScreen.male.gotoAndStop(3);
            _roleScreen.female.gotoAndStop(2);
         }
         _sex = param1;
      }
      
      public function getSex() : uint
      {
         return _sex;
      }
      
      public function setName(param1:String) : void
      {
         var _loc3_:RegExp = null;
         var _loc2_:Array = null;
         if(param1)
         {
            _loc3_ = /“(.*?)”/g;
            _loc2_ = param1.match(_loc3_);
            if(_loc2_.length > 0)
            {
               param1 = _loc2_[0];
               param1 = param1.replace(/“/g,"");
               param1 = param1.replace(/”/g,"");
            }
            _roleScreen.roleName.textColor = 16777215;
            _roleScreen.roleName.text = param1;
         }
      }
      
      public function getName() : String
      {
         return _roleScreen.roleName.text;
      }
      
      public function hidden() : void
      {
         _stage.removeChild(_roleScreen);
      }
      
      public function destroy() : void
      {
         hidden();
         _roleScreen.male.removeEventListener("mouseDown",onMaleClick);
         _roleScreen.female.removeEventListener("mouseDown",onFemaleClick);
         _roleScreen.female.removeEventListener("change",onChange);
         _enterGamebtn.click = null;
         confirmSignal = null;
         _roleScreen = null;
         _enterGamebtn = null;
         if(Constants.lanVersion != 2)
         {
            _makenamebtn.click = null;
            _makenamebtn = null;
         }
      }
      
      public function judgeInputString(param1:String, param2:int) : void
      {
         param1 = StringUtil.trim(param1);
         if(param1 == "")
         {
            onMakeName();
            return;
         }
         if(param1.length > param2)
         {
            _roleScreen.roleName.text = param1.substr(0,param2);
         }
         param1 = DirtyWordFilter.getInstance().runFilter(param1);
         if(param1.indexOf("*") == -1)
         {
            confirmSignal.dispatch();
         }
         else
         {
            _roleScreen.roleName.text = "";
         }
      }
      
      private function makeName(param1:uint) : String
      {
         return Constants.makeName(param1);
      }
      
      private function onEnterClick(param1:MouseEvent) : void
      {
         judgeInputString(_roleScreen.roleName.text,6);
      }
      
      private function onMaleClick(param1:MouseEvent) : void
      {
         setSex(0);
      }
      
      private function onFemaleClick(param1:MouseEvent) : void
      {
         setSex(1);
      }
      
      private function onMakeName(param1:MouseEvent = null) : void
      {
         var _loc2_:String = makeName(getSex());
         setName(_loc2_);
      }
      
      private function onRoleNameTextFocus(param1:FocusEvent) : void
      {
         _roleScreen.roleName.removeEventListener("focusIn",onRoleNameTextFocus);
         if(_roleScreen.roleName.text == _deftext)
         {
            _roleScreen.roleName.text = "";
            _roleScreen.roleName.textColor = 16777215;
         }
      }
   }
}

