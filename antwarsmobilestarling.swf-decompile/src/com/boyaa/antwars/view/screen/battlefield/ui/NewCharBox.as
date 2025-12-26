package com.boyaa.antwars.view.screen.battlefield.ui
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.ui.layout.EasyFunctions;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.filters.ColorMatrixFilter;
   
   public class NewCharBox extends EasyFunctions
   {
      
      private var _hpBar:NewHpBar;
      
      private var _siteID:int = -1;
      
      private var _team:int = 0;
      
      private var _char:Character;
      
      private var _headPositionObj:DisplayObject;
      
      private var _headButton:FashionStarlingButton;
      
      private var _isSelect:Boolean = false;
      
      private var _isHaveData:Boolean = false;
      
      private var _boxIndex:int;
      
      private var _monster:Image;
      
      public function NewCharBox(param1:Sprite)
      {
         super(param1);
      }
      
      override protected function initialization() : void
      {
         super.initialization();
         _headButton = new FashionStarlingButton(getButtonByName("btnHead"));
         _headPositionObj = getDisplayObjectByName("pos_headIcon");
         _boxIndex = int(_displayObj.name.charAt(_displayObj.name.length - 1));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         _displayObj.removeFromParent(true);
      }
      
      public function showBox(param1:Boolean) : void
      {
         _displayObj.visible = param1;
      }
      
      public function setData(param1:int, param2:int, param3:Character, param4:int) : void
      {
         _siteID = param1;
         _team = param2;
         _char = param3;
         _hpBar = new NewHpBar(getSpriteByName("blood"),param4);
         _char = param3.avatar();
         _char.touchable = false;
         _char.y = 115;
         _char.x = 40;
         if(boxIndex >= 2)
         {
            _char.scaleX *= -1;
         }
         _displayObj.addChild(_char);
         _isHaveData = true;
         showBox(true);
         _displayObj.filter = null;
      }
      
      public function setMonsterData(param1:int, param2:int, param3:int, param4:int) : void
      {
         _siteID = param1;
         _team = param3;
         _hpBar = new NewHpBar(getSpriteByName("blood"),param2);
         if(_monster)
         {
            _monster.removeFromParent(true);
         }
         _monster = new Image(Assets.sAsset.getTexture("img_monster" + param4));
         SmallCodeTools.instance.setDisplayObjectInSame(_headPositionObj,_monster);
         _monster.scaleX = _monster.scaleY;
         _displayObj.addChild(_monster);
         if(param2 == -1)
         {
            _hpBar.displayObj.visible = false;
         }
         _isHaveData = true;
         showBox(true);
         _displayObj.filter = null;
      }
      
      public function updateHp(param1:int) : void
      {
         if(!_hpBar.displayObj.visible)
         {
            return;
         }
         _hpBar.hp = param1;
         if(param1 <= 0)
         {
            setGrayFitlers();
         }
         else
         {
            _displayObj.filter = null;
         }
      }
      
      protected function setGrayFitlers() : void
      {
         var _loc1_:ColorMatrixFilter = new ColorMatrixFilter();
         _loc1_.adjustSaturation(-1);
         _displayObj.filter = _loc1_;
      }
      
      public function get isSelect() : Boolean
      {
         return _isSelect;
      }
      
      public function set isSelect(param1:Boolean) : void
      {
         _isSelect = param1;
         _headButton.isSelect = _isSelect;
      }
      
      public function get siteID() : int
      {
         return _siteID;
      }
      
      public function get team() : int
      {
         return _team;
      }
      
      public function get isHaveData() : Boolean
      {
         return _isHaveData;
      }
      
      public function get boxIndex() : int
      {
         return _boxIndex;
      }
   }
}

