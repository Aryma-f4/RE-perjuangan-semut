package feathers.controls.renderers
{
   import feathers.controls.GroupedList;
   import feathers.core.IToggle;
   
   public interface IGroupedListItemRenderer extends IToggle
   {
      
      function get data() : Object;
      
      function set data(param1:Object) : void;
      
      function get groupIndex() : int;
      
      function set groupIndex(param1:int) : void;
      
      function get itemIndex() : int;
      
      function set itemIndex(param1:int) : void;
      
      function get layoutIndex() : int;
      
      function set layoutIndex(param1:int) : void;
      
      function get owner() : GroupedList;
      
      function set owner(param1:GroupedList) : void;
   }
}

