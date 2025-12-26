package com.boyaa.antwars.view.screen.battlefield
{
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class SkillItemRenderer extends ListItemRenderer
   {
      
      private var box:Image;
      
      private var title:TextField;
      
      private var info:TextField;
      
      public function SkillItemRenderer()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         var _loc1_:Rectangle = null;
         if(!this.bg)
         {
            this.bgFocusTexture = Assets.sAsset.getTexture("jndj02");
            this.bgNormalTexture = Assets.sAsset.getTexture("jndj03");
            this.bg = new Image(this.bgNormalTexture);
            addChild(this.bg);
            this.box = new Image(Assets.emptyTexture());
            Assets.positionDisplay(box,"skillitem","box");
            addChild(this.box);
            this.box.touchable = false;
            _loc1_ = Assets.getPosition("skillitem","title");
            this.title = new TextField(_loc1_.width,_loc1_.height,"","Verdana",30,4660230,true);
            this.title.hAlign = "left";
            this.title.x = _loc1_.x;
            this.title.y = _loc1_.y;
            this.title.autoScale = true;
            addChild(this.title);
            this.title.touchable = false;
            _loc1_ = Assets.getPosition("skillitem","desc");
            this.info = new TextField(_loc1_.width,_loc1_.height,"","Verdana",20,4660230);
            this.info.hAlign = "left";
            this.info.vAlign = "top";
            this.info.x = _loc1_.x;
            this.info.y = _loc1_.y;
            addChild(this.info);
            this.info.touchable = false;
         }
      }
      
      override protected function commitData() : void
      {
         if(!this._data)
         {
            return;
         }
         this.box.texture = Assets.sAsset.getTexture("fightgoods" + this._data.frame);
         this.title.text = this._data.name;
         if(this._data.price <= 0)
         {
            this.info.text = LangManager.t("free") + this._data.info;
         }
         else
         {
            this.info.text = LangManager.t("gold") + ":" + this._data.price + "，" + this._data.info;
         }
      }
   }
}

