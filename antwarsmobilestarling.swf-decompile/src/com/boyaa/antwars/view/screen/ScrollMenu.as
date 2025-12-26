package com.boyaa.antwars.view.screen
{
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.screen.menu.VerticalMenu;
   import feathers.controls.ScrollContainer;
   
   public class ScrollMenu extends UIExportSprite
   {
      
      private var _scrollContainer:ScrollContainer;
      
      private var _verticalMenu:VerticalMenu;
      
      public function ScrollMenu()
      {
         super();
      }
      
      override protected function initialization() : void
      {
         super.initialization();
         _scrollContainer = new ScrollContainer();
         _verticalMenu = new VerticalMenu();
         _scrollContainer.width = _verticalMenu.width;
         _scrollContainer.height = 420;
         _scrollContainer.addChild(_verticalMenu);
         addChild(_scrollContainer);
      }
   }
}

