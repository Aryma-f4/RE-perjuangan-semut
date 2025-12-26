package feathers.controls.popups
{
   import feathers.controls.Callout;
   import flash.errors.IllegalOperationError;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   public class CalloutPopUpContentManager extends EventDispatcher implements IPopUpContentManager
   {
      
      public var calloutFactory:Function;
      
      public var direction:String = "any";
      
      public var isModal:Boolean = true;
      
      protected var content:DisplayObject;
      
      protected var callout:Callout;
      
      public function CalloutPopUpContentManager()
      {
         super();
      }
      
      public function get isOpen() : Boolean
      {
         return this.content !== null;
      }
      
      public function open(param1:DisplayObject, param2:DisplayObject) : void
      {
         if(this.isOpen)
         {
            throw new IllegalOperationError("Pop-up content is already open. Close the previous content before opening new content.");
         }
         this.content = param1;
         this.callout = Callout.show(param1,param2,this.direction,this.isModal,this.calloutFactory);
         this.callout.addEventListener("close",callout_closeHandler);
         this.dispatchEventWith("open");
      }
      
      public function close() : void
      {
         if(!this.isOpen)
         {
            return;
         }
         this.callout.close();
      }
      
      public function dispose() : void
      {
         this.close();
      }
      
      protected function cleanup() : void
      {
         this.content = null;
         this.callout.content = null;
         this.callout.removeEventListener("close",callout_closeHandler);
         this.callout = null;
      }
      
      protected function callout_closeHandler(param1:Event) : void
      {
         this.cleanup();
         this.dispatchEventWith("close");
      }
   }
}

