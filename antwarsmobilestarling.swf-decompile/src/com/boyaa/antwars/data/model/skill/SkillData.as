package com.boyaa.antwars.data.model.skill
{
   public class SkillData
   {
      
      public var ID:int = 0;
      
      public var odds:int = 0;
      
      public var secode:int = 0;
      
      public var name:String = "";
      
      public var skdesc:String = "";
      
      public var value:int = 0;
      
      public function SkillData()
      {
         super();
      }
      
      public function updateForData(param1:XML) : void
      {
         ID = int(param1["skid"]);
         secode = int(param1["secode"]);
         name = param1["skname"];
         skdesc = param1["skdesc"];
         if(skdesc == null)
         {
            skdesc = "";
         }
         odds = int(param1["skrate"]);
         value = int(param1["addvalue"]);
      }
   }
}

