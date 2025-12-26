package com.boyaa.tool.filter
{
   import flash.utils.ByteArray;
   
   public class RegExpFilter
   {
      
      private var _reg:RegExp = null;
      
      public function RegExpFilter()
      {
         super();
      }
      
      public function filter(param1:String) : Array
      {
         var _loc2_:ByteArray = null;
         _reg = /[;:'"\{\}\[\]\\\|\,\.\/\<\>\ \?]/;
         if(!_reg.exec(param1))
         {
            _loc2_ = new ByteArray();
            _loc2_.writeUTF(param1);
            return [param1,_loc2_.length];
         }
         return ["",0];
      }
      
      public function expectSpace(param1:String) : Array
      {
         var _loc2_:ByteArray = null;
         _reg = /[;:'"\{\}\[\]\\\|\,\.\/\<\>\?]/;
         if(!_reg.exec(param1))
         {
            _loc2_ = new ByteArray();
            _loc2_.writeUTF(param1);
            return [param1,_loc2_.length];
         }
         return ["",0];
      }
   }
}

