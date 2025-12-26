package feathers.controls.popups
{
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.core.PopUpManager;
   import feathers.core.ValidationQueue;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import flash.errors.IllegalOperationError;
   import flash.events.KeyboardEvent;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.ResizeEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class DropDownPopUpContentManager extends EventDispatcher implements IPopUpContentManager
   {
      
      protected var content:DisplayObject;
      
      protected var source:DisplayObject;
      
      protected var _gap:Number = 0;
      
      public function DropDownPopUpContentManager()
      {
         super();
      }
      
      public function get isOpen() : Boolean
      {
         return this.content !== null;
      }
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(param1:Number) : void
      {
         this._gap = param1;
      }
      
      public function open(param1:DisplayObject, param2:DisplayObject) : void
      {
         if(this.isOpen)
         {
            throw new IllegalOperationError("Pop-up content is already open. Close the previous content before opening new content.");
         }
         this.content = param1;
         this.source = param2;
         PopUpManager.addPopUp(this.content,false,false);
         if(this.content is IFeathersControl)
         {
            this.content.addEventListener("resize",content_resizeHandler);
         }
         this.layout();
         var _loc4_:Stage = Starling.current.stage;
         _loc4_.addEventListener("touch",stage_touchHandler);
         _loc4_.addEventListener("resize",stage_resizeHandler);
         var _loc3_:int = -getDisplayObjectDepthFromStage(this.content);
         Starling.current.nativeStage.addEventListener("keyDown",nativeStage_keyDownHandler,false,_loc3_,true);
         this.dispatchEventWith("open");
      }
      
      public function close() : void
      {
         if(!this.isOpen)
         {
            return;
         }
         var _loc1_:Stage = Starling.current.stage;
         _loc1_.removeEventListener("touch",stage_touchHandler);
         _loc1_.removeEventListener("resize",stage_resizeHandler);
         Starling.current.nativeStage.removeEventListener("keyDown",nativeStage_keyDownHandler);
         if(this.content is IFeathersControl)
         {
            this.content.removeEventListener("resize",content_resizeHandler);
         }
         PopUpManager.removePopUp(this.content);
         this.content = null;
         this.source = null;
         this.dispatchEventWith("close");
      }
      
      public function dispose() : void
      {
         this.close();
      }
      
      protected function layout() : void
      {
         var _loc7_:Stage = Starling.current.stage;
         var _loc6_:Rectangle = this.source.getBounds(_loc7_);
         if(this.source is IValidating)
         {
            IValidating(this.source).validate();
         }
         var _loc3_:Number = this.source.width;
         var _loc9_:Boolean = false;
         var _loc8_:IFeathersControl = this.content as IFeathersControl;
         if(_loc8_ && _loc8_.minWidth < _loc3_)
         {
            _loc8_.minWidth = _loc3_;
            _loc9_ = true;
         }
         if(this.content is IValidating)
         {
            _loc8_.validate();
         }
         if(!_loc9_ && this.content.width < _loc3_)
         {
            this.content.width = _loc3_;
         }
         var _loc5_:ValidationQueue = ValidationQueue.forStarling(Starling.current);
         if(_loc5_ && !_loc5_.isValidating)
         {
            _loc5_.advanceTime(0);
         }
         var _loc2_:Number = _loc7_.stageHeight - this.content.height - (_loc6_.y + _loc6_.height + this._gap);
         if(_loc2_ >= 0)
         {
            layoutBelow(_loc6_);
            return;
         }
         var _loc1_:Number = _loc6_.y - this._gap - this.content.height;
         if(_loc1_ >= 0)
         {
            layoutAbove(_loc6_);
            return;
         }
         if(_loc1_ >= _loc2_)
         {
            layoutAbove(_loc6_);
         }
         else
         {
            layoutBelow(_loc6_);
         }
         var _loc4_:Number = _loc7_.stageHeight - (_loc6_.y + _loc6_.height);
         if(_loc8_)
         {
            if(_loc8_.maxHeight > _loc4_)
            {
               _loc8_.maxHeight = _loc4_;
            }
         }
         else if(this.content.height > _loc4_)
         {
            this.content.height = _loc4_;
         }
      }
      
      protected function layoutAbove(param1:Rectangle) : void
      {
         var _loc2_:Number = param1.x + (param1.width - this.content.width) / 2;
         var _loc3_:* = Starling.current.stage.stageWidth - this.content.width;
         if(_loc3_ > _loc2_)
         {
            _loc3_ = _loc2_;
         }
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         this.content.x = _loc3_;
         this.content.y = param1.y - this.content.height - this._gap;
      }
      
      protected function layoutBelow(param1:Rectangle) : void
      {
         var _loc2_:Number = param1.x;
         var _loc3_:* = Starling.current.stage.stageWidth - this.content.width;
         if(_loc3_ > _loc2_)
         {
            _loc3_ = _loc2_;
         }
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         this.content.x = _loc3_;
         this.content.y = param1.y + param1.height + this._gap;
      }
      
      protected function content_resizeHandler(param1:Event) : void
      {
         this.layout();
      }
      
      protected function nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(param1.keyCode != 16777238 && param1.keyCode != 27)
         {
            return;
         }
         param1.preventDefault();
         this.close();
      }
      
      protected function stage_resizeHandler(param1:ResizeEvent) : void
      {
         this.layout();
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:DisplayObject = DisplayObject(param1.target);
         if(this.content == _loc3_ || this.content is DisplayObjectContainer && Boolean(DisplayObjectContainer(this.content).contains(_loc3_)))
         {
            return;
         }
         if(this.source == _loc3_ || this.source is DisplayObjectContainer && Boolean(DisplayObjectContainer(this.source).contains(_loc3_)))
         {
            return;
         }
         if(!PopUpManager.isTopLevelPopUp(this.content))
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(Starling.current.stage,"began");
         if(!_loc2_)
         {
            return;
         }
         this.close();
      }
   }
}

