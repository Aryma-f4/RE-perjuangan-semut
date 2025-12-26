package com.boyaa.antwars.sound
{
   import com.boyaa.antwars.data.LocalData;
   import com.boyaa.antwars.helper.Timepiece;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class SoundManager
   {
      
      private static var _soundSwitch:Boolean = true;
      
      private static var _bgSoundSwitch:Boolean = true;
      
      public static var bgChannel:SoundChannel = null;
      
      public static var actChannel:SoundChannel = null;
      
      public static var actChannel2:SoundChannel = null;
      
      private static var _bgVol:Number = 1;
      
      private static var _actSoundVol:Number = 1;
      
      private static var bgMusicName:String = "bgGame";
      
      private static var _range:Number = 0.05;
      
      private static var _transForm:SoundTransform = new SoundTransform();
      
      private static var _transForm1:SoundTransform = new SoundTransform();
      
      public function SoundManager()
      {
         super();
      }
      
      public static function playSound(param1:String, param2:int = 0) : void
      {
         if(!soundSwitch)
         {
            return;
         }
         var _loc3_:Sound = Assets.sAsset.getSound(param1);
         if(!_loc3_ || !_loc3_ is Sound)
         {
            return;
         }
         actChannel = _loc3_.play(0,param2);
         _transForm1.volume = 0.5;
         if(actChannel != null)
         {
            actChannel.soundTransform = _transForm1;
         }
      }
      
      public static function init() : void
      {
         if(LocalData.instance.getData("bgSoundSwitch"))
         {
            _bgSoundSwitch = LocalData.instance.getData("bgSoundSwitch") == "false" ? false : true;
         }
         if(LocalData.instance.getData("actSoundSwitch"))
         {
            _soundSwitch = LocalData.instance.getData("actSoundSwitch") == "false" ? false : true;
         }
      }
      
      public static function playBgSound(param1:String = "bgGame", param2:int = 1) : void
      {
         var sound:Sound;
         var str:String = param1;
         var isFade:int = param2;
         bgMusicName = str;
         if(!bgSoundSwitch)
         {
            return;
         }
         if(!Assets.sAsset)
         {
            return;
         }
         sound = Assets.sAsset.getSound(str);
         if(!sound)
         {
            return;
         }
         if(bgChannel != null && isFade)
         {
            bgChannel.stop();
         }
         _transForm.volume = 0;
         bgChannel = sound.play(0,999999);
         Timepiece.instance.addFun((function():*
         {
            var fadeIn:Function;
            return fadeIn = function():void
            {
               _transForm.volume += _range;
               if(_transForm.volume >= 1)
               {
                  _transForm.volume = 1;
                  Timepiece.instance.removeFun(fadeIn);
                  return;
               }
               if(bgChannel)
               {
                  bgChannel.soundTransform = _transForm;
               }
            };
         })());
      }
      
      public static function stopBgSound() : void
      {
         if(bgChannel != null)
         {
            _transForm.volume = _bgVol;
            Timepiece.instance.addFun((function():*
            {
               var fadeOut:Function;
               return fadeOut = function():void
               {
                  _transForm.volume -= _range;
                  if(_transForm.volume <= 0)
                  {
                     _transForm.volume = 0;
                     Timepiece.instance.removeFun(fadeOut);
                     bgChannel.stop();
                     return;
                  }
                  bgChannel.soundTransform = _transForm;
               };
            })());
         }
      }
      
      public static function stopBgSoundInstantly() : void
      {
         if(!bgChannel)
         {
            return;
         }
         bgChannel.stop();
      }
      
      public static function stopActSoundInstantly() : void
      {
         _soundSwitch = false;
      }
      
      public static function stopActSound() : void
      {
         actChannel && actChannel.stop();
      }
      
      public static function set bgVol(param1:Number) : void
      {
         param1 = Math.max(0,Math.min(1,param1));
         _bgVol = param1;
         var _loc2_:SoundTransform = new SoundTransform(param1);
         if(bgChannel != null)
         {
            bgChannel.soundTransform = _loc2_;
         }
      }
      
      public static function get bgSoundSwitch() : Boolean
      {
         return _bgSoundSwitch;
      }
      
      public static function set bgSoundSwitch(param1:Boolean) : void
      {
         _bgSoundSwitch = param1;
         if(_bgSoundSwitch)
         {
            SoundManager.playBgSound(bgMusicName);
         }
         else
         {
            SoundManager.stopBgSound();
         }
         LocalData.instance.setData("bgSoundSwitch",String(_bgSoundSwitch));
      }
      
      public static function set actSoundVol(param1:Number) : void
      {
         _actSoundVol = param1;
         var _loc2_:SoundTransform = new SoundTransform(_actSoundVol);
         if(actChannel != null)
         {
            actChannel.soundTransform = _loc2_;
         }
      }
      
      public static function get actSoundVol() : Number
      {
         return _actSoundVol;
      }
      
      public static function get soundSwitch() : Boolean
      {
         return _soundSwitch;
      }
      
      public static function set soundSwitch(param1:Boolean) : void
      {
         _soundSwitch = param1;
         LocalData.instance.setData("actSoundSwitch",String(_soundSwitch));
      }
   }
}

