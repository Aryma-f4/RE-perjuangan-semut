package dragonBones.utils
{
   import flash.utils.ByteArray;
   
   public function checkBytesTailisXML(param1:ByteArray) : Boolean
   {
      var _loc2_:int = 0;
      var _loc4_:int = int(param1.length);
      var _loc3_:int = 20;
      while(_loc3_--)
      {
         if(_loc4_--)
         {
            switch(param1[_loc4_])
            {
               case charCodes[" "]:
               case charCodes["\t"]:
               case charCodes["\r"]:
               case charCodes["\n"]:
                  break;
               case charCodes[">"]:
                  _loc2_ = 20;
                  while(_loc2_--)
                  {
                     if(!_loc4_--)
                     {
                        break;
                     }
                     if(param1[_loc4_] == charCodes["<"])
                     {
                        return true;
                     }
                  }
                  return false;
            }
         }
      }
      return false;
   }
}

var c:String;

const charCodes:Object = {};

for each(c in " \t\r\n<>".split(""))
{
   charCodes[c] = c.charCodeAt(0);
}

