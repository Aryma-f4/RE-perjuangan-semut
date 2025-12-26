package com.boyaa.antwars.view.mission
{
   import com.boyaa.antwars.data.model.mission.MissionData;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.textures.Texture;
   
   public class SingleMissionRender extends ListItemRenderer
   {
      
      private static var _frame:int = 0;
      
      private var _missionName:TextField;
      
      private var _pos:Rectangle;
      
      private var _isReward:Boolean = true;
      
      private var _rewardArr:Array;
      
      private var _finish:Boolean = false;
      
      private var _isNew:Boolean = false;
      
      private var bgDisableTexture:Texture;
      
      private var _flag:Image;
      
      private var _flagNewMissionTexture:Texture;
      
      private var _flagFinishMissionTexture:Texture;
      
      private var _currentData:MissionData;
      
      public function SingleMissionRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.bgFocusTexture = Assets.sAsset.getTexture("rw17");
         this.bgDisableTexture = Assets.sAsset.getTexture("rw18");
         this.bgNormalTexture = Assets.sAsset.getTexture("rw16");
         this.bg = new Image(Assets.sAsset.getTexture("rw16"));
         this.addChild(this.bg);
         this._flagNewMissionTexture = Assets.sAsset.getTexture("rw7");
         this._flagFinishMissionTexture = Assets.sAsset.getTexture("rw19");
         this._flag = new Image(Assets.sAsset.getTexture("rw7"));
         this.addChild(_flag);
         _pos = Assets.getPosition("missionDlg","textPos");
         this._missionName = new TextField(_pos.width,_pos.height,"","Verdana",22,16777215,true);
         this._missionName.nativeFilters = [new DropShadowFilter(0,45,0,1,1.2,1.2,20)];
         this._missionName.hAlign = "center";
         this._missionName.vAlign = "bottom";
         this._missionName.x = _pos.x;
         this._missionName.y = _pos.y;
         this._missionName.autoScale = true;
         addChild(this._missionName);
         this._missionName.touchable = false;
      }
      
      override protected function commitData() : void
      {
         if(!this._data)
         {
            return;
         }
         var _loc1_:MissionData = this._data as MissionData;
         _currentData = _loc1_;
         _missionName.text = _loc1_.msname;
         this._isReward = _loc1_.isRewarded;
         this._isNew = _loc1_.isNew;
         if(this._isReward)
         {
            this._finish = false;
         }
         else
         {
            this._finish = _loc1_.isFinished;
         }
         if(_isNew && !_finish)
         {
            _flag.texture = _flagNewMissionTexture;
            addChild(_flag);
         }
         else if(_finish)
         {
            _flag.texture = _flagFinishMissionTexture;
            addChild(_flag);
         }
         else
         {
            _flag && _flag.parent && _flag.removeFromParent(true);
         }
         if(_isReward)
         {
            this.bg.texture = this.bgDisableTexture;
         }
         else if(this.isSelected)
         {
            this.bg.texture = this.bgFocusTexture;
         }
         else
         {
            this.bg.texture = this.bgNormalTexture;
         }
      }
      
      override protected function selectDraw() : void
      {
         if(this.isSelected)
         {
            this.bg.texture = this.bgFocusTexture;
         }
         else if(this._isReward)
         {
            this.bg.texture = this.bgDisableTexture;
         }
         else
         {
            this.bg.texture = this.bgNormalTexture;
         }
      }
      
      override protected function set touchPointID(param1:int) : void
      {
         if(_touchPointID != param1)
         {
            _touchPointID = param1;
            if(_touchPointID != -1)
            {
            }
         }
      }
   }
}

