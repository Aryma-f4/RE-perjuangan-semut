package com.boyaa.antwars.view.screen.battlefield.element
{
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.filters.ColorMatrixFilter;
   import starling.textures.Texture;
   
   public class SkillBox extends Sprite
   {
      
      private var bg:Button;
      
      private var lockbg:Image;
      
      public var lock:Boolean;
      
      private var skillImage:Image = null;
      
      private var _skillId:int = -1;
      
      private var textTures:Vector.<Texture>;
      
      private var grayscaleFilter:ColorMatrixFilter;
      
      public function SkillBox(param1:Boolean, param2:Vector.<Texture>)
      {
         super();
         this.textTures = param2;
         if(!param1)
         {
            bg = new Button(this.textTures[0],"",this.textTures[1]);
            addChild(bg);
         }
         else
         {
            lockbg = new Image(this.textTures[2]);
            addChild(lockbg);
         }
         this.lock = param1;
         canClick = false;
         grayscaleFilter = new ColorMatrixFilter();
         grayscaleFilter.adjustSaturation(-1);
      }
      
      override public function dispose() : void
      {
         this.removeEventListeners("triggered");
         grayscaleFilter.dispose();
         super.dispose();
      }
      
      public function setSkill(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.lock)
         {
            throw new Error("此技能框没有解锁,不能添加道具");
         }
         _skillId = param1;
         if(param1 <= -1)
         {
            skillImage && skillImage.removeFromParent();
            canClick = false;
         }
         else
         {
            if(skillImage)
            {
               skillImage.texture = Assets.sAsset.getTexture("fightgoods" + param1);
               addChild(skillImage);
            }
            else
            {
               skillImage = new Image(Assets.sAsset.getTexture("fightgoods" + param1));
               _loc2_ = bg.width * 0.3;
               skillImage.width = bg.width - _loc2_;
               skillImage.scaleY = skillImage.scaleX;
               skillImage.x = _loc2_ >> 1;
               skillImage.y = _loc2_ >> 1;
               addChild(skillImage);
               skillImage.touchable = false;
            }
            canClick = true;
         }
      }
      
      public function get skillId() : int
      {
         return _skillId;
      }
      
      public function set disabled(param1:Boolean) : void
      {
         if(this.lock)
         {
            return;
         }
         if(bg.enabled == !param1)
         {
            return;
         }
         if(param1 == true)
         {
            canClick = false;
            skillImage.filter = grayscaleFilter;
         }
         else
         {
            canClick = true;
            skillImage.filter = null;
         }
      }
      
      public function set canClick(param1:Boolean) : void
      {
         if(this.lock)
         {
            return;
         }
         if(bg.enabled == param1)
         {
            return;
         }
         if(_skillId == -1)
         {
            if(bg.enabled)
            {
               bg.enabled = false;
            }
            return;
         }
         bg.enabled = param1;
      }
   }
}

