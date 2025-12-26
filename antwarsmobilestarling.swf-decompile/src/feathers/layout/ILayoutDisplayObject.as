package feathers.layout
{
   import feathers.core.IFeathersDisplayObject;
   
   public interface ILayoutDisplayObject extends IFeathersDisplayObject
   {
      
      function get layoutData() : ILayoutData;
      
      function set layoutData(param1:ILayoutData) : void;
      
      function get includeInLayout() : Boolean;
      
      function set includeInLayout(param1:Boolean) : void;
   }
}

