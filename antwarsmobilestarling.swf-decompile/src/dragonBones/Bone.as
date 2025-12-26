package dragonBones
{
   import dragonBones.animation.AnimationState;
   import dragonBones.animation.TimelineState;
   import dragonBones.core.DBObject;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.events.FrameEvent;
   import dragonBones.events.SoundEvent;
   import dragonBones.events.SoundEventManager;
   import dragonBones.objects.Frame;
   import dragonBones.objects.TransformFrame;
   import flash.geom.Point;
   
   use namespace dragonBones_internal;
   
   public class Bone extends DBObject
   {
      
      private static const _soundManager:SoundEventManager = SoundEventManager.getInstance();
      
      public var scaleMode:int;
      
      dragonBones_internal var _tweenPivot:Point;
      
      private var _children:Vector.<DBObject>;
      
      private var _slot:Slot;
      
      private var _displayController:String;
      
      public function Bone()
      {
         super();
         _children = new Vector.<DBObject>(0,true);
         _scaleType = 2;
         dragonBones_internal::_tweenPivot = new Point();
         scaleMode = 1;
      }
      
      public function get slot() : Slot
      {
         return _slot;
      }
      
      public function get childArmature() : Armature
      {
         return _slot ? _slot.childArmature : null;
      }
      
      public function get display() : Object
      {
         return _slot ? _slot.display : null;
      }
      
      public function set display(param1:Object) : void
      {
         if(_slot)
         {
            _slot.display = param1;
         }
      }
      
      public function get displayController() : String
      {
         return _displayController;
      }
      
      public function set displayController(param1:String) : void
      {
         _displayController = param1;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Slot = null;
         if(this._visible != param1)
         {
            this._visible = param1;
            _loc3_ = int(_children.length);
            while(_loc3_--)
            {
               _loc2_ = _children[_loc3_] as Slot;
               if(_loc2_)
               {
                  _loc2_.dragonBones_internal::updateVisible(this._visible);
               }
            }
         }
      }
      
      override dragonBones_internal function setArmature(param1:Armature) : void
      {
         super.dragonBones_internal::setArmature(param1);
         var _loc2_:int = int(_children.length);
         while(_loc2_--)
         {
            _children[_loc2_].dragonBones_internal::setArmature(this._armature);
         }
      }
      
      override public function dispose() : void
      {
         if(!_children)
         {
            return;
         }
         super.dispose();
         var _loc1_:int = int(_children.length);
         while(_loc1_--)
         {
            _children[_loc1_].dispose();
         }
         _children.fixed = false;
         _children.length = 0;
         _children = null;
         _slot = null;
         dragonBones_internal::_tweenPivot = null;
      }
      
      public function contains(param1:DBObject) : Boolean
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         if(param1 == this)
         {
            return false;
         }
         var _loc2_:* = param1;
         while(!(_loc2_ == this || _loc2_ == null))
         {
            _loc2_ = _loc2_.parent;
         }
         return _loc2_ == this;
      }
      
      public function addChild(param1:DBObject) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         var _loc2_:Bone = param1 as Bone;
         if(param1 == this || _loc2_ && _loc2_.contains(this))
         {
            throw new ArgumentError("An Bone cannot be added as a child to itself or one of its children (or children\'s children, etc.)");
         }
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         _children.fixed = false;
         _children[_children.length] = param1;
         _children.fixed = true;
         param1.dragonBones_internal::setParent(this);
         param1.dragonBones_internal::setArmature(this._armature);
         if(!_slot && param1 is Slot)
         {
            _slot = param1 as Slot;
         }
      }
      
      public function removeChild(param1:DBObject) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         var _loc2_:int = int(_children.indexOf(param1));
         if(_loc2_ >= 0)
         {
            _children.fixed = false;
            _children.splice(_loc2_,1);
            _children.fixed = true;
            param1.dragonBones_internal::setParent(null);
            param1.dragonBones_internal::setArmature(null);
            if(_slot && param1 == _slot)
            {
               _slot = null;
            }
            return;
         }
         throw new ArgumentError();
      }
      
      public function getSlots() : Vector.<Slot>
      {
         var _loc1_:Vector.<Slot> = new Vector.<Slot>();
         var _loc2_:int = int(_children.length);
         while(_loc2_--)
         {
            if(_children[_loc2_] is Slot)
            {
               _loc1_.unshift(_children[_loc2_]);
            }
         }
         return _loc1_;
      }
      
      dragonBones_internal function arriveAtFrame(param1:Frame, param2:TimelineState, param3:AnimationState, param4:Boolean) : void
      {
         var _loc9_:int = 0;
         var _loc8_:TransformFrame = null;
         var _loc10_:int = 0;
         var _loc5_:FrameEvent = null;
         var _loc7_:SoundEvent = null;
         var _loc6_:Armature = null;
         if(param1)
         {
            _loc9_ = param3.getMixingTransform(name);
            if(param3.displayControl && (_loc9_ == 2 || _loc9_ == -1))
            {
               if(!_displayController || _displayController == param3.name)
               {
                  _loc8_ = param1 as TransformFrame;
                  if(_slot)
                  {
                     _loc10_ = _loc8_.displayIndex;
                     if(_loc10_ >= 0)
                     {
                        if(!isNaN(_loc8_.zOrder) && _loc8_.zOrder != _slot.dragonBones_internal::_tweenZorder)
                        {
                           _slot.dragonBones_internal::_tweenZorder = _loc8_.zOrder;
                           this._armature.dragonBones_internal::_slotsZOrderChanged = true;
                        }
                     }
                     _slot.dragonBones_internal::changeDisplay(_loc10_);
                     _slot.dragonBones_internal::updateVisible(_loc8_.visible);
                  }
               }
            }
            if(param1.event && this._armature.hasEventListener("boneFrameEvent"))
            {
               _loc5_ = new FrameEvent("boneFrameEvent");
               _loc5_.bone = this;
               _loc5_.animationState = param3;
               _loc5_.frameLabel = param1.event;
               this._armature.dragonBones_internal::_eventList.push(_loc5_);
            }
            if(param1.sound && _soundManager.hasEventListener("sound"))
            {
               _loc7_ = new SoundEvent("sound");
               _loc7_.armature = this._armature;
               _loc7_.animationState = param3;
               _loc7_.sound = param1.sound;
               _soundManager.dispatchEvent(_loc7_);
            }
            if(param1.action)
            {
               _loc6_ = this.childArmature;
               if(_loc6_)
               {
                  _loc6_.animation.gotoAndPlay(param1.action);
               }
            }
         }
         else if(_slot)
         {
            _slot.dragonBones_internal::changeDisplay(-1);
         }
      }
      
      dragonBones_internal function updateColor(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Boolean) : void
      {
         if(param9 || Boolean(dragonBones_internal::_isColorChanged))
         {
            _slot.dragonBones_internal::_displayBridge.updateColor(param1,param2,param3,param4,param5,param6,param7,param8);
         }
         dragonBones_internal::_isColorChanged = param9;
      }
   }
}

