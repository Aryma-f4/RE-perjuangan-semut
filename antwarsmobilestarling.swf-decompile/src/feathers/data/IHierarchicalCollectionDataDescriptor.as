package feathers.data
{
   public interface IHierarchicalCollectionDataDescriptor
   {
      
      function isBranch(param1:Object) : Boolean;
      
      function getLength(param1:Object, ... rest) : int;
      
      function getItemAt(param1:Object, param2:int, ... rest) : Object;
      
      function setItemAt(param1:Object, param2:Object, param3:int, ... rest) : void;
      
      function addItemAt(param1:Object, param2:Object, param3:int, ... rest) : void;
      
      function removeItemAt(param1:Object, param2:int, ... rest) : Object;
      
      function getItemLocation(param1:Object, param2:Object, param3:Vector.<int> = null, ... rest) : Vector.<int>;
   }
}

