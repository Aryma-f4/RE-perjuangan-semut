package com.boyaa.antwars.view.ui
{
   import feathers.controls.List;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.core.FeathersControl;
   import flash.geom.Point;
   import starling.display.Image;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.textures.Texture;
   
   public class ListItemRenderer extends FeathersControl implements IListItemRenderer
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      protected var bg:Image;
      
      protected var bgNormalTexture:Texture;
      
      protected var bgFocusTexture:Texture;
      
      protected var _index:int = -1;
      
      protected var _owner:List;
      
      protected var _data:Object;
      
      protected var _isSelected:Boolean;
      
      protected var _touchPointID:int = -1;
      
      public function ListItemRenderer()
      {
         super();
         this.addEventListener("touch",touchHandler);
         this.addEventListener("removedFromStage",removedFromStageHandler);
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         if(this._index == param1)
         {
            return;
         }
         this._index = param1;
         this.invalidate("data");
      }
      
      public function get owner() : List
      {
         return List(this._owner);
      }
      
      public function set owner(param1:List) : void
      {
         if(this._owner == param1)
         {
            return;
         }
         if(this._owner)
         {
            this._owner.removeEventListener("scroll",owner_scrollHandler);
         }
         this._owner = param1;
         if(this._owner)
         {
            this._owner.addEventListener("scroll",owner_scrollHandler);
         }
         this.invalidate("data");
      }
      
      protected function owner_scrollHandler(param1:Event) : void
      {
         this.touchPointID = -1;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data == param1)
         {
            return;
         }
         this._data = param1;
         this.invalidate("data");
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         if(this._isSelected == param1)
         {
            return;
         }
         this._isSelected = param1;
         this.invalidate("selected");
         this.dispatchEventWith("change");
      }
      
      override protected function draw() : void
      {
         var _loc3_:Boolean = this.isInvalid("data");
         var _loc1_:Boolean = this.isInvalid("selected");
         var _loc2_:Boolean = this.isInvalid("size");
         if(_loc3_)
         {
            this.commitData();
         }
         if(_loc1_)
         {
            this.selectDraw();
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         if(_loc3_ || _loc2_)
         {
            this.layout();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc2_:Boolean = isNaN(this.explicitWidth);
         var _loc4_:Boolean = isNaN(this.explicitHeight);
         if(!_loc2_ && !_loc4_)
         {
            return false;
         }
         var _loc3_:Number = this.explicitWidth;
         if(_loc2_)
         {
            _loc3_ = this.bg.width;
         }
         var _loc1_:Number = this.explicitHeight;
         if(_loc4_)
         {
            _loc1_ = this.bg.height;
         }
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function layout() : void
      {
      }
      
      override protected function initialize() : void
      {
      }
      
      protected function commitData() : void
      {
      }
      
      protected function selectDraw() : void
      {
      }
      
      protected function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:Vector.<Touch> = param1.getTouches(this);
         if(_loc3_.length == 0)
         {
            return;
         }
         if(this.touchPointID >= 0)
         {
            for each(var _loc4_ in _loc3_)
            {
               if(_loc4_.id == this.touchPointID)
               {
                  _loc2_ = _loc4_;
                  break;
               }
            }
            if(!_loc2_)
            {
               return;
            }
            if(_loc2_.phase == "ended")
            {
               this.touchPointID = -1;
               _loc2_.getLocation(this,HELPER_POINT);
               if(this.hitTest(HELPER_POINT,true) != null && !this._isSelected)
               {
                  this.isSelected = true;
               }
               return;
            }
         }
         else
         {
            for each(_loc2_ in _loc3_)
            {
               if(_loc2_.phase == "began")
               {
                  this.touchPointID = _loc2_.id;
                  return;
               }
            }
         }
      }
      
      protected function set touchPointID(param1:int) : void
      {
         if(_touchPointID != param1)
         {
            _touchPointID = param1;
            if(_touchPointID == -1)
            {
               this.bg.texture = bgNormalTexture;
            }
            else
            {
               this.bg.texture = bgFocusTexture;
            }
         }
      }
      
      protected function get touchPointID() : int
      {
         return _touchPointID;
      }
      
      protected function removedFromStageHandler(param1:Event) : void
      {
         this.touchPointID = -1;
      }
   }
}

