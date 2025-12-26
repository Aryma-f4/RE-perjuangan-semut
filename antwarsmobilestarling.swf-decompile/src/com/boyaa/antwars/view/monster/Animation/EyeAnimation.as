package com.boyaa.antwars.view.monster.Animation
{
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.view.monster.Animation;
   import com.boyaa.antwars.view.monster.Monster;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class EyeAnimation extends Animation
   {
      
      public function EyeAnimation()
      {
         super();
         _display = new Sprite();
         _stand = new MovieClip(Assets.sAsset.getTextures("eye1000"),6);
         _stand.stop();
         _stand.addEventListener("complete",onComplete);
         _attack = new MovieClip(Assets.sAsset.getTextures("eye2000"),6);
         _attack.stop();
         _attack.addEventListener("complete",onAttackComplete);
         _move = _stand;
         _dizzy = _stand;
         _angel = _stand;
         _stand.pivotX = (_stand.width >> 1) - 10;
         _stand.pivotY = _stand.height >> 1;
         _attack.pivotX = (_attack.width >> 1) - 10;
         _attack.pivotY = _attack.height >> 1;
         Starling.juggler.add(_stand);
         _stand.play();
         _display.addChild(_stand);
         _status = "stand";
      }
      
      private function onAttackComplete(param1:Event) : void
      {
         _attack.stop();
         var _loc3_:Monster = _display.parent as Monster;
         var _loc7_:EyeBullet = new EyeBullet(_loc3_.icharacterCtrl);
         var _loc2_:Number = _loc3_.monsterCtrl.attackTarget.x - _loc3_.x;
         var _loc4_:Number = _loc3_.y - _loc3_.monsterCtrl.attackTarget.y;
         var _loc6_:Number = _loc3_.monsterCtrl.direction ? 70 : 110;
         var _loc5_:Number = MathHelper.getVelocity(_loc2_,_loc4_,_loc6_);
         _loc7_.init(new Point(_loc3_.x,_loc3_.y),_loc6_,_loc5_);
         _loc3_.icharacterCtrl.gameworld.getGameLayer().addChild(_loc7_);
         _loc7_.start();
         _loc7_.blowoutCompleteSignal.addOnce(shootComplete);
         _loc3_.icharacterCtrl.gameworld.cameraFocusCtrlByTouch(false);
         _loc3_.icharacterCtrl.gameworld.camera.swapFocus(_loc7_);
      }
      
      private function shootComplete() : void
      {
         onComplete();
      }
      
      override public function get display() : Object
      {
         return _display;
      }
      
      override public function update() : void
      {
      }
      
      override public function dispose() : void
      {
         Starling.juggler.remove(_stand);
         Starling.juggler.remove(_attack);
         super.dispose();
      }
      
      override public function gotoAndPlay(param1:String) : void
      {
         trace("EyeAnimation",param1);
         changeStatus(_status,param1);
         _status = param1;
      }
   }
}

