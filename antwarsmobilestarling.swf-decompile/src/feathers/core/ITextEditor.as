package feathers.core
{
   import flash.geom.Point;
   
   public interface ITextEditor extends IFeathersControl, ITextBaselineControl
   {
      
      function get text() : String;
      
      function set text(param1:String) : void;
      
      function get displayAsPassword() : Boolean;
      
      function set displayAsPassword(param1:Boolean) : void;
      
      function get maxChars() : int;
      
      function set maxChars(param1:int) : void;
      
      function get restrict() : String;
      
      function set restrict(param1:String) : void;
      
      function get isEditable() : Boolean;
      
      function set isEditable(param1:Boolean) : void;
      
      function get setTouchFocusOnEndedPhase() : Boolean;
      
      function get selectionBeginIndex() : int;
      
      function get selectionEndIndex() : int;
      
      function setFocus(param1:Point = null) : void;
      
      function clearFocus() : void;
      
      function selectRange(param1:int, param2:int) : void;
      
      function measureText(param1:Point = null) : Point;
   }
}

