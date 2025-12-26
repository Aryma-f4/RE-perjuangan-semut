package com.boyaa.antwars.helper
{
   import com.boyaa.antwars.data.CopyMonsterRoleList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.CopyMonsterRole;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.monster.Monster;
   import com.boyaa.antwars.view.monster.MonsterData;
   import com.boyaa.antwars.view.monster.MonsterFactory;
   import dragonBones.Armature;
   import dragonBones.animation.WorldClock;
   import feathers.layout.ILayout;
   import feathers.layout.TiledColumnsLayout;
   import feathers.layout.TiledRowsLayout;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.textures.Texture;
   
   public class SmallCodeTools
   {
      
      private static var _instance:SmallCodeTools = null;
      
      public function SmallCodeTools(param1:Single)
      {
         super();
      }
      
      public static function get instance() : SmallCodeTools
      {
         if(_instance == null)
         {
            _instance = new SmallCodeTools(new Single());
         }
         return _instance;
      }
      
      public function getCharcterByData(param1:PlayerData, param2:DisplayObject) : Character
      {
         var _loc3_:Character = CharacterFactory.instance.checkOutCharacter(param1.babySex);
         _loc3_.initData(param1.getPropData());
         setDisplayObjectInSame(param2,_loc3_);
         _loc3_.x += param2.width >> 1;
         _loc3_.y += param2.height;
         _loc3_.scaleX = _loc3_.scaleY;
         return _loc3_;
      }
      
      public function setDisplayObjectInStageMiddle(param1:DisplayObject) : void
      {
         param1.x = (1365 - param1.width) / 2;
         param1.y = (768 - param1.height) / 2;
      }
      
      public function setDisplayObjectVisible(param1:Array, param2:Boolean) : void
      {
         for each(var _loc3_ in param1)
         {
            _loc3_.visible = param2;
         }
      }
      
      public function setDisplayObjectToCenter(param1:DisplayObject, param2:DisplayObject) : void
      {
         param2.x = (param1.width - param2.width) / 2 + param1.x;
         param2.y = (param1.height - param2.height) / 2 + param1.y;
      }
      
      public function setDisplayObjectInSamePos(param1:DisplayObject, param2:DisplayObject) : void
      {
         param2.x = param1.x;
         param2.y = param1.y;
      }
      
      public function setDisplayObjectInSameScale(param1:DisplayObject, param2:DisplayObject, param3:int = 0) : void
      {
         param2.x = param1.x;
         param2.y = param1.y;
         if(param3 == 0)
         {
            param2.width = param1.width;
            param2.scaleY = param2.scaleX;
         }
         else
         {
            param2.height = param1.height;
            param2.scaleX = param2.scaleY;
         }
      }
      
      public function setDisplayObjectInSame(param1:DisplayObject, param2:DisplayObject) : void
      {
         param2.x = param1.x;
         param2.y = param1.y;
         param2.width = param1.width;
         param2.height = param1.height;
      }
      
      public function getTitleTextField(param1:int, param2:String, param3:uint = 14463242, param4:uint = 3677194) : TextField
      {
         var _loc5_:TextField = new TextField(300,50,param2,"Verdana",param1,param3);
         _loc5_.nativeFilters = [new GlowFilter(param4,1,5,5,15)];
         _loc5_.hAlign = "left";
         return _loc5_;
      }
      
      public function getMonsterSpieceType(param1:int) : Monster
      {
         var _loc2_:CopyMonsterRole = CopyMonsterRoleList.instance.getRoleBySpieceType(param1);
         var _loc4_:MonsterData = new MonsterData(_loc2_);
         var _loc3_:Monster = MonsterFactory.instance.create(_loc2_.remake,_loc4_);
         _loc3_.setStatus("stand");
         return _loc3_;
      }
      
      public function getRandItemInArr(param1:Array) : Object
      {
         return param1[Math.floor(Math.random() * param1.length)];
      }
      
      public function createArmature(param1:String, param2:String = "tmp") : Armature
      {
         var _loc3_:Armature = Assets.sAsset.buildArmature(param1);
         _loc3_.animation.gotoAndPlay(param2);
         WorldClock.clock.add(_loc3_);
         return _loc3_;
      }
      
      public function checkEquipWeapon() : Boolean
      {
         var _loc2_:PlayerData = PlayerDataList.instance.selfData;
         var _loc1_:GoodsData = _loc2_.getWeapon();
         if(!_loc1_ || _loc1_.place != 1)
         {
            TextTip.instance.show(LangManager.t("noWeapon"));
            return false;
         }
         return true;
      }
      
      public function getFormatTimeFromDate(param1:Date, param2:String = "-") : String
      {
         var _loc3_:String = "";
         return param1.getFullYear() + param2 + (String(param1.getMonth() + 1 + 100)).substr(1) + param2 + (String(param1.getDate() + 100)).substr(1) + " " + (String(param1.getHours() + 100)).substr(1) + ":" + (String(param1.getMinutes() + 100)).substr(1);
      }
      
      public function getWeaponImage(param1:ShopData, param2:Rectangle) : Image
      {
         var _loc5_:String = ShopDataList.instance.getWeaponImageString(param1);
         var _loc3_:Texture = Assets.sAsset.getTextureAtlas("wqSpritesheet").getTexture(_loc5_);
         var _loc4_:Image = new Image(_loc3_);
         _loc4_.width = param2.width;
         _loc4_.height = param2.height;
         return _loc4_;
      }
      
      public function getListColumnsLayout(param1:int = 0, param2:int = 5, param3:int = 5, param4:String = "left", param5:String = "top") : ILayout
      {
         var _loc6_:TiledColumnsLayout = new TiledColumnsLayout();
         _loc6_.useSquareTiles = false;
         _loc6_.verticalGap = param1;
         _loc6_.horizontalGap = param2;
         _loc6_.paddingTop = param3;
         _loc6_.horizontalAlign = param4;
         _loc6_.verticalAlign = param5;
         return _loc6_;
      }
      
      public function getListRowsLayout(param1:int = 5, param2:int = 0, param3:int = 5, param4:String = "left", param5:String = "top") : ILayout
      {
         var _loc6_:TiledRowsLayout = new TiledRowsLayout();
         _loc6_.useSquareTiles = false;
         _loc6_.verticalGap = param1;
         _loc6_.horizontalGap = param2;
         _loc6_.paddingTop = param3;
         _loc6_.horizontalAlign = param4;
         _loc6_.verticalAlign = param5;
         return _loc6_;
      }
      
      public function setDisplayObjectInWidthScreen(param1:String, param2:DisplayObject) : void
      {
         switch(param1)
         {
            case "left":
               param2.x = Assets.leftTop.x + 5;
               break;
            case "right":
               param2.x = Assets.rightTop.x - param2.width - 10;
         }
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
