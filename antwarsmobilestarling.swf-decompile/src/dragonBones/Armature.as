package dragonBones
{
   import dragonBones.animation.Animation;
   import dragonBones.animation.AnimationState;
   import dragonBones.animation.IAnimatable;
   import dragonBones.animation.TimelineState;
   import dragonBones.core.DBObject;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.events.ArmatureEvent;
   import dragonBones.events.FrameEvent;
   import dragonBones.events.SoundEvent;
   import dragonBones.events.SoundEventManager;
   import dragonBones.objects.Frame;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   use namespace dragonBones_internal;
   
   public class Armature extends EventDispatcher implements IAnimatable
   {
      
      private static const _soundManager:SoundEventManager = SoundEventManager.getInstance();
      
      private const _helpArray:Array = [];
      
      public var name:String;
      
      public var userData:Object;
      
      dragonBones_internal var _slotsZOrderChanged:Boolean;
      
      dragonBones_internal var _slotList:Vector.<Slot>;
      
      dragonBones_internal var _boneList:Vector.<Bone>;
      
      dragonBones_internal var _eventList:Vector.<Event>;
      
      protected var _display:Object;
      
      protected var _animation:Animation;
      
      public function Armature(param1:Object)
      {
         super(this);
         _display = param1;
         _animation = new Animation(this);
         dragonBones_internal::_slotsZOrderChanged = false;
         dragonBones_internal::_slotList = new Vector.<Slot>();
         dragonBones_internal::_slotList.fixed = true;
         dragonBones_internal::_boneList = new Vector.<Bone>();
         dragonBones_internal::_boneList.fixed = true;
         dragonBones_internal::_eventList = new Vector.<Event>();
      }
      
      public function get display() : Object
      {
         return _display;
      }
      
      public function get animation() : Animation
      {
         return _animation;
      }
      
      public function dispose() : void
      {
         if(!_animation)
         {
            return;
         }
         userData = null;
         _animation.dispose();
         for each(var _loc2_ in dragonBones_internal::_slotList)
         {
            _loc2_.dispose();
         }
         for each(var _loc1_ in dragonBones_internal::_boneList)
         {
            _loc1_.dispose();
         }
         dragonBones_internal::_slotList.fixed = false;
         dragonBones_internal::_slotList.length = 0;
         dragonBones_internal::_boneList.fixed = false;
         dragonBones_internal::_boneList.length = 0;
         dragonBones_internal::_eventList.length = 0;
         _animation = null;
         dragonBones_internal::_slotList = null;
         dragonBones_internal::_boneList = null;
         dragonBones_internal::_eventList = null;
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc4_:Slot = null;
         var _loc3_:Armature = null;
         _animation.advanceTime(param1);
         var _loc5_:int = int(dragonBones_internal::_boneList.length);
         while(_loc5_--)
         {
            dragonBones_internal::_boneList[_loc5_].dragonBones_internal::update();
         }
         _loc5_ = int(dragonBones_internal::_slotList.length);
         while(_loc5_--)
         {
            _loc4_ = dragonBones_internal::_slotList[_loc5_];
            _loc4_.dragonBones_internal::update();
            if(_loc4_.dragonBones_internal::_isDisplayOnStage)
            {
               _loc3_ = _loc4_.childArmature;
               if(_loc3_)
               {
                  _loc3_.advanceTime(param1);
               }
            }
         }
         if(dragonBones_internal::_slotsZOrderChanged)
         {
            updateSlotsZOrder();
            if(this.hasEventListener("zOrderUpdated"))
            {
               this.dispatchEvent(new ArmatureEvent("zOrderUpdated"));
            }
         }
         if(dragonBones_internal::_eventList.length)
         {
            for each(var _loc2_ in dragonBones_internal::_eventList)
            {
               this.dispatchEvent(_loc2_);
            }
            dragonBones_internal::_eventList.length = 0;
         }
      }
      
      public function getSlots(param1:Boolean = true) : Vector.<Slot>
      {
         return param1 ? dragonBones_internal::_slotList.concat() : dragonBones_internal::_slotList;
      }
      
      public function getBones(param1:Boolean = true) : Vector.<Bone>
      {
         return param1 ? dragonBones_internal::_boneList.concat() : dragonBones_internal::_boneList;
      }
      
      public function getSlot(param1:String) : Slot
      {
         var _loc2_:int = int(dragonBones_internal::_slotList.length);
         while(_loc2_--)
         {
            if(dragonBones_internal::_slotList[_loc2_].name == param1)
            {
               return dragonBones_internal::_slotList[_loc2_];
            }
         }
         return null;
      }
      
      public function getSlotByDisplay(param1:Object) : Slot
      {
         var _loc2_:int = 0;
         if(param1)
         {
            _loc2_ = int(dragonBones_internal::_slotList.length);
            while(_loc2_--)
            {
               if(dragonBones_internal::_slotList[_loc2_].display == param1)
               {
                  return dragonBones_internal::_slotList[_loc2_];
               }
            }
         }
         return null;
      }
      
      public function removeSlot(param1:Slot) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         if(dragonBones_internal::_slotList.indexOf(param1) >= 0)
         {
            param1.parent.removeChild(param1);
            return;
         }
         throw new ArgumentError();
      }
      
      public function removeSlotByName(param1:String) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:Slot = getSlot(param1);
         if(_loc2_)
         {
            removeSlot(_loc2_);
         }
      }
      
      public function getBone(param1:String) : Bone
      {
         var _loc2_:int = int(dragonBones_internal::_boneList.length);
         while(_loc2_--)
         {
            if(dragonBones_internal::_boneList[_loc2_].name == param1)
            {
               return dragonBones_internal::_boneList[_loc2_];
            }
         }
         return null;
      }
      
      public function getBoneByDisplay(param1:Object) : Bone
      {
         var _loc2_:Slot = getSlotByDisplay(param1);
         return _loc2_ ? _loc2_.parent : null;
      }
      
      public function removeBone(param1:Bone) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         if(dragonBones_internal::_boneList.indexOf(param1) >= 0)
         {
            if(param1.parent)
            {
               param1.parent.removeChild(param1);
            }
            else
            {
               param1.dragonBones_internal::setArmature(null);
            }
            return;
         }
         throw new ArgumentError();
      }
      
      public function removeBoneByName(param1:String) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:Bone = getBone(param1);
         if(_loc2_)
         {
            removeBone(_loc2_);
         }
      }
      
      public function addChild(param1:DBObject, param2:String = null) : void
      {
         var _loc3_:Bone = null;
         if(!param1)
         {
            throw new ArgumentError();
         }
         if(param2)
         {
            _loc3_ = getBone(param2);
            if(!_loc3_)
            {
               throw new ArgumentError();
            }
            _loc3_.addChild(param1);
         }
         else
         {
            if(param1.parent)
            {
               param1.parent.removeChild(param1);
            }
            param1.dragonBones_internal::setArmature(this);
         }
      }
      
      public function addBone(param1:Bone, param2:String = null) : void
      {
         addChild(param1,param2);
      }
      
      public function updateSlotsZOrder() : void
      {
         var _loc1_:Slot = null;
         dragonBones_internal::_slotList.fixed = false;
         dragonBones_internal::_slotList.sort(sortSlot);
         dragonBones_internal::_slotList.fixed = true;
         var _loc2_:int = int(dragonBones_internal::_slotList.length);
         while(_loc2_--)
         {
            _loc1_ = dragonBones_internal::_slotList[_loc2_];
            if(_loc1_.dragonBones_internal::_isDisplayOnStage)
            {
               _loc1_.dragonBones_internal::_displayBridge.addDisplay(display);
            }
         }
         dragonBones_internal::_slotsZOrderChanged = false;
      }
      
      dragonBones_internal function addDBObject(param1:DBObject) : void
      {
         var _loc3_:Slot = null;
         var _loc2_:Bone = null;
         if(param1 is Slot)
         {
            _loc3_ = param1 as Slot;
            if(dragonBones_internal::_slotList.indexOf(_loc3_) < 0)
            {
               dragonBones_internal::_slotList.fixed = false;
               dragonBones_internal::_slotList[dragonBones_internal::_slotList.length] = _loc3_;
               dragonBones_internal::_slotList.fixed = true;
            }
         }
         else if(param1 is Bone)
         {
            _loc2_ = param1 as Bone;
            if(dragonBones_internal::_boneList.indexOf(_loc2_) < 0)
            {
               dragonBones_internal::_boneList.fixed = false;
               dragonBones_internal::_boneList[dragonBones_internal::_boneList.length] = _loc2_;
               dragonBones_internal::sortBoneList();
               dragonBones_internal::_boneList.fixed = true;
            }
         }
      }
      
      dragonBones_internal function removeDBObject(param1:DBObject) : void
      {
         var _loc4_:Slot = null;
         var _loc2_:int = 0;
         var _loc3_:Bone = null;
         if(param1 is Slot)
         {
            _loc4_ = param1 as Slot;
            _loc2_ = int(dragonBones_internal::_slotList.indexOf(_loc4_));
            if(_loc2_ >= 0)
            {
               dragonBones_internal::_slotList.fixed = false;
               dragonBones_internal::_slotList.splice(_loc2_,1);
               dragonBones_internal::_slotList.fixed = true;
            }
         }
         else if(param1 is Bone)
         {
            _loc3_ = param1 as Bone;
            _loc2_ = int(dragonBones_internal::_boneList.indexOf(_loc3_));
            if(_loc2_ >= 0)
            {
               dragonBones_internal::_boneList.fixed = false;
               dragonBones_internal::_boneList.splice(_loc2_,1);
               dragonBones_internal::_boneList.fixed = true;
            }
         }
      }
      
      dragonBones_internal function sortBoneList() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Bone = null;
         var _loc1_:* = null;
         var _loc4_:int = int(dragonBones_internal::_boneList.length);
         if(_loc4_ == 0)
         {
            return;
         }
         _helpArray.length = 0;
         while(_loc4_--)
         {
            _loc2_ = 0;
            _loc3_ = dragonBones_internal::_boneList[_loc4_];
            _loc1_ = _loc3_;
            while(_loc1_)
            {
               _loc2_++;
               _loc1_ = _loc1_.parent;
            }
            _helpArray[_loc4_] = {
               "level":_loc2_,
               "bone":_loc3_
            };
         }
         _helpArray.sortOn("level",0x10 | 2);
         _loc4_ = int(_helpArray.length);
         while(_loc4_--)
         {
            dragonBones_internal::_boneList[_loc4_] = _helpArray[_loc4_].bone;
         }
         _helpArray.length = 0;
      }
      
      dragonBones_internal function arriveAtFrame(param1:Frame, param2:TimelineState, param3:AnimationState, param4:Boolean) : void
      {
         var _loc5_:FrameEvent = null;
         var _loc6_:SoundEvent = null;
         if(param1.event && this.hasEventListener("animationFrameEvent"))
         {
            _loc5_ = new FrameEvent("animationFrameEvent");
            _loc5_.animationState = param3;
            _loc5_.frameLabel = param1.event;
            dragonBones_internal::_eventList.push(_loc5_);
         }
         if(param1.sound && _soundManager.hasEventListener("sound"))
         {
            _loc6_ = new SoundEvent("sound");
            _loc6_.armature = this;
            _loc6_.animationState = param3;
            _loc6_.sound = param1.sound;
            _soundManager.dispatchEvent(_loc6_);
         }
         if(param1.action)
         {
            if(param3.isPlaying)
            {
               animation.gotoAndPlay(param1.action);
            }
         }
      }
      
      private function sortSlot(param1:Slot, param2:Slot) : int
      {
         return param1.zOrder < param2.zOrder ? 1 : -1;
      }
   }
}

