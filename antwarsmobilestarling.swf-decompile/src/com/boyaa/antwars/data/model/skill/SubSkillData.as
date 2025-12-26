package com.boyaa.antwars.data.model.skill
{
   public class SubSkillData
   {
      
      public var type:int = 0;
      
      private var _name:String = "";
      
      public var triggerType:int = 0;
      
      private var _target:int = 0;
      
      private var _computemode:int = 0;
      
      private var _porn:int = 0;
      
      public var lasttime:int = 0;
      
      public var lastType:int = 0;
      
      public var active:Boolean = false;
      
      public function SubSkillData()
      {
         super();
      }
      
      public function updateForData(param1:XML) : void
      {
         type = int(param1["secode"]);
         _name = param1["sename"];
         triggerType = int(param1["condition"]);
         _target = int(param1["target"]);
         _porn = int(param1["porn"]);
         _computemode = int(param1["computemode"]);
         lasttime = int(param1["lasttime"]);
         lastType = int(param1["lasttype"]);
         if(type == 107 || type == 123 || type == 110 || type == 111 || type == 108 || type == 112 || type == 124 || type == 109)
         {
            active = true;
         }
      }
   }
}

