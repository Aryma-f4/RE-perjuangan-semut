package com.boyaa.antwars.view.screen.chatRoom
{
   import com.boyaa.antwars.net.server.BattleServer;
   import flash.geom.Point;
   import org.osflash.signals.Signal;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class Emoticon extends Sprite
   {
      
      public var faceBorad:Sprite;
      
      public var faceSingal:Signal = new Signal();
      
      public function Emoticon()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc4_:Button = null;
         var _loc10_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc5_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:Image = null;
         faceBorad = new Sprite();
         faceBorad.visible = false;
         addChild(faceBorad);
         var _loc13_:Image = new Image(Assets.sAsset.getTexture("bq1"));
         _loc13_.touchable = false;
         _loc13_.width = 612;
         _loc13_.height = 364;
         faceBorad.addChild(_loc13_);
         var _loc15_:int = 0;
         var _loc12_:int = 7;
         var _loc8_:int = 4;
         var _loc3_:int = 15;
         var _loc2_:int = 15;
         var _loc11_:Array = [];
         var _loc14_:Sprite = new Sprite();
         faceBorad.addChild(_loc14_);
         _loc6_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc12_)
            {
               _loc4_ = new Button(Assets.sAsset.getTexture("bq2"),"",Assets.sAsset.getTexture("bq3"));
               _loc4_.width = _loc4_.height = 83;
               _loc4_.addEventListener("triggered",onPlayFace);
               _loc4_.x = _loc15_ + _loc4_.width * _loc7_ + _loc3_;
               _loc4_.y = _loc15_ + _loc4_.height * _loc6_ + _loc2_;
               _loc10_ = new Point(_loc4_.x,_loc4_.y);
               _loc11_.push(_loc10_);
               _loc14_.addChild(_loc4_);
               _loc7_++;
            }
            _loc6_++;
         }
         _loc14_.removeChildAt(27);
         _loc14_.removeChildAt(26);
         _loc5_ = 0;
         while(_loc5_ < 26)
         {
            _loc14_.getChildAt(_loc5_).name = _loc5_ + 1 + "";
            _loc5_++;
         }
         _loc9_ = 0;
         while(_loc9_ < 26)
         {
            _loc1_ = new Image(Assets.sAsset.getTexture((_loc9_ + 1).toString()));
            _loc1_.touchable = false;
            _loc1_.x = _loc11_[_loc9_].x;
            _loc1_.y = _loc11_[_loc9_].y;
            faceBorad.addChild(_loc1_);
            _loc9_++;
         }
      }
      
      private function onPlayFace(param1:Event) : void
      {
         faceBorad.visible = false;
         var _loc2_:int = int((param1.target as Button).name);
         trace("发送表情:id为" + _loc2_);
         BattleServer.instance.sendFace(_loc2_);
      }
      
      override public function dispose() : void
      {
         faceSingal.removeAll();
         super.dispose();
      }
   }
}

