package com.boyaa.tool
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.BaseDlg;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class LoadData extends BaseDlg
   {
      
      private static var _loading:LoadData;
      
      private static var _num:int = 0;
      
      private var _loadBg:Quad;
      
      public function LoadData()
      {
         super(true);
         var _loc1_:TextField = new TextField(200,40,LangManager.getLang.getreplaceLang("dataIsLoading"),"Verdana",30,16777215);
         _loc1_.autoScale = true;
         _loadBg = new Quad(200,40,0);
         this.addChild(_loadBg);
         this.addChild(_loc1_);
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_loadBg);
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_loc1_);
         _markBg.alpha = 0.01;
      }
      
      public static function show(param1:Sprite = null) : void
      {
         if(!_loading)
         {
            _loading = new LoadData();
         }
         Application.instance.currentGame.stage.addChild(_loading);
         _num = _num + 1;
      }
      
      public static function hide() : void
      {
         if(_loading)
         {
            _num = _num - 1;
            if(_num == 0)
            {
               _loading.removeFromParent();
               _loading = null;
            }
         }
      }
   }
}

