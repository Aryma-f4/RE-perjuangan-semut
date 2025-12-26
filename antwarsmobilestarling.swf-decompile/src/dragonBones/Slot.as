package dragonBones
{
   import dragonBones.core.DBObject;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.display.IDisplayBridge;
   import dragonBones.objects.DisplayData;
   import flash.geom.Matrix;
   
   use namespace dragonBones_internal;
   
   public class Slot extends DBObject
   {
      
      dragonBones_internal var _dislayDataList:Vector.<DisplayData>;
      
      dragonBones_internal var _displayBridge:IDisplayBridge;
      
      dragonBones_internal var _originZOrder:Number;
      
      dragonBones_internal var _tweenZorder:Number;
      
      dragonBones_internal var _isDisplayOnStage:Boolean;
      
      private var _isHideDisplay:Boolean;
      
      private var _offsetZOrder:Number;
      
      private var _displayIndex:int;
      
      private var _displayList:Array;
      
      public function Slot(param1:IDisplayBridge)
      {
         super();
         dragonBones_internal::_displayBridge = param1;
         _displayList = [];
         _displayIndex = -1;
         _scaleType = 1;
         dragonBones_internal::_originZOrder = 0;
         dragonBones_internal::_tweenZorder = 0;
         _offsetZOrder = 0;
         dragonBones_internal::_isDisplayOnStage = false;
         _isHideDisplay = false;
      }
      
      public function get zOrder() : Number
      {
         return dragonBones_internal::_originZOrder + dragonBones_internal::_tweenZorder + _offsetZOrder;
      }
      
      public function set zOrder(param1:Number) : void
      {
         if(zOrder != param1)
         {
            _offsetZOrder = param1 - dragonBones_internal::_originZOrder - dragonBones_internal::_tweenZorder;
            if(this._armature)
            {
               this._armature.dragonBones_internal::_slotsZOrderChanged = true;
            }
         }
      }
      
      public function get display() : Object
      {
         var _loc1_:Object = _displayList[_displayIndex];
         if(_loc1_ is Armature)
         {
            return _loc1_.display;
         }
         return _loc1_;
      }
      
      public function set display(param1:Object) : void
      {
         _displayList[_displayIndex] = param1;
         setDisplay(param1);
      }
      
      public function get childArmature() : Armature
      {
         return _displayList[_displayIndex] as Armature;
      }
      
      public function set childArmature(param1:Armature) : void
      {
         _displayList[_displayIndex] = param1;
         if(param1)
         {
            setDisplay(param1.display);
         }
      }
      
      public function get displayList() : Array
      {
         return _displayList;
      }
      
      public function set displayList(param1:Array) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         var _loc2_:int = int(_displayList.length = param1.length);
         while(_loc2_--)
         {
            _displayList[_loc2_] = param1[_loc2_];
         }
         if(_displayIndex >= 0)
         {
            _displayIndex = -1;
            dragonBones_internal::changeDisplay(_displayIndex);
         }
      }
      
      private function setDisplay(param1:Object) : void
      {
         if(dragonBones_internal::_displayBridge.display)
         {
            dragonBones_internal::_displayBridge.display = param1;
         }
         else
         {
            dragonBones_internal::_displayBridge.display = param1;
            if(this._armature)
            {
               dragonBones_internal::_displayBridge.addDisplay(this._armature.display);
               this._armature.dragonBones_internal::_slotsZOrderChanged = true;
            }
         }
         updateChildArmatureAnimation();
         if(!_isHideDisplay && dragonBones_internal::_displayBridge.display)
         {
            dragonBones_internal::_isDisplayOnStage = true;
         }
         else
         {
            dragonBones_internal::_isDisplayOnStage = false;
         }
      }
      
      dragonBones_internal function changeDisplay(param1:int) : void
      {
         var _loc4_:Boolean = false;
         var _loc3_:* = 0;
         var _loc2_:Object = null;
         if(param1 < 0)
         {
            if(!_isHideDisplay)
            {
               _isHideDisplay = true;
               dragonBones_internal::_displayBridge.removeDisplay();
               updateChildArmatureAnimation();
            }
         }
         else
         {
            if(_isHideDisplay)
            {
               _isHideDisplay = false;
               _loc4_ = true;
               if(this._armature)
               {
                  dragonBones_internal::_displayBridge.addDisplay(this._armature.display);
                  this._armature.dragonBones_internal::_slotsZOrderChanged = true;
               }
            }
            _loc3_ = _displayList.length;
            if(param1 >= _loc3_ && _loc3_ > 0)
            {
               param1 = _loc3_ - 1;
            }
            if(_displayIndex != param1)
            {
               _displayIndex = param1;
               _loc2_ = _displayList[_displayIndex];
               if(_loc2_ is Armature)
               {
                  setDisplay((_loc2_ as Armature).display);
               }
               else
               {
                  setDisplay(_loc2_);
               }
               if(dragonBones_internal::_dislayDataList && _displayIndex <= dragonBones_internal::_dislayDataList.length)
               {
                  this._origin.copy(dragonBones_internal::_dislayDataList[_displayIndex].transform);
               }
            }
            else if(_loc4_)
            {
               updateChildArmatureAnimation();
            }
         }
         if(!_isHideDisplay && dragonBones_internal::_displayBridge.display)
         {
            dragonBones_internal::_isDisplayOnStage = true;
         }
         else
         {
            dragonBones_internal::_isDisplayOnStage = false;
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(param1 != this._visible)
         {
            this._visible = param1;
            dragonBones_internal::updateVisible(this._visible);
         }
      }
      
      override dragonBones_internal function setArmature(param1:Armature) : void
      {
         super.dragonBones_internal::setArmature(param1);
         if(this._armature)
         {
            this._armature.dragonBones_internal::_slotsZOrderChanged = true;
            dragonBones_internal::_displayBridge.addDisplay(this._armature.display);
         }
         else
         {
            dragonBones_internal::_displayBridge.removeDisplay();
         }
      }
      
      override public function dispose() : void
      {
         if(!dragonBones_internal::_displayBridge)
         {
            return;
         }
         super.dispose();
         dragonBones_internal::_displayBridge.dispose();
         _displayList.length = 0;
         dragonBones_internal::_displayBridge = null;
         _displayList = null;
         dragonBones_internal::_dislayDataList = null;
      }
      
      override dragonBones_internal function update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Matrix = null;
         super.dragonBones_internal::update();
         if(dragonBones_internal::_isDisplayOnStage)
         {
            _loc1_ = _parent.dragonBones_internal::_tweenPivot.x;
            _loc2_ = _parent.dragonBones_internal::_tweenPivot.y;
            if(_loc1_ || _loc2_)
            {
               _loc3_ = _parent.dragonBones_internal::_globalTransformMatrix;
               this.dragonBones_internal::_globalTransformMatrix.tx += _loc3_.a * _loc1_ + _loc3_.c * _loc2_;
               this.dragonBones_internal::_globalTransformMatrix.ty += _loc3_.b * _loc1_ + _loc3_.d * _loc2_;
            }
            dragonBones_internal::_displayBridge.updateTransform(this.dragonBones_internal::_globalTransformMatrix,this.dragonBones_internal::_global);
         }
      }
      
      dragonBones_internal function updateVisible(param1:Boolean) : void
      {
         dragonBones_internal::_displayBridge.visible = this._parent.visible && this._visible && param1;
      }
      
      private function updateChildArmatureAnimation() : void
      {
         var _loc1_:Armature = this.childArmature;
         if(_loc1_)
         {
            if(_isHideDisplay)
            {
               _loc1_.animation.stop();
               _loc1_.animation.dragonBones_internal::_lastAnimationState = null;
            }
            else if(this._armature && this._armature.animation.lastAnimationState && _loc1_.animation.hasAnimation(this._armature.animation.lastAnimationState.name))
            {
               _loc1_.animation.gotoAndPlay(this._armature.animation.lastAnimationState.name);
            }
            else
            {
               _loc1_.animation.play();
            }
         }
      }
      
      public function changeDisplayList(param1:Array) : void
      {
         this.displayList = param1;
      }
   }
}

