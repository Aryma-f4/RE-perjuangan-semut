package feathers.controls.renderers
{
   import feathers.controls.GroupedList;
   import feathers.core.IFeathersControl;
   
   public interface IGroupedListHeaderOrFooterRenderer extends IFeathersControl
   {
      
      function get data() : Object;
      
      function set data(param1:Object) : void;
      
      function get groupIndex() : int;
      
      function set groupIndex(param1:int) : void;
      
      function get layoutIndex() : int;
      
      function set layoutIndex(param1:int) : void;
      
      function get owner() : GroupedList;
      
      function set owner(param1:GroupedList) : void;
   }
}

