package com.boyaa.antwars.helper.tools
{
   import starling.display.Button;
   import starling.events.Event;
   import starling.filters.ColorMatrixFilter;
   import starling.textures.Texture;
   
   public class FashionStarlingButton
   {
      
      private var _starlingBtn:Button;
      
      private var _triggerFunction:Function = null;
      
      private var _grayState:Texture;
      
      private var _isGray:Boolean = false;
      
      private var _isSelect:Boolean = false;
      
      private var _buttonStateArr:Array = [];
      
      private var _groupTag:String = "";
      
      private var _name:String;
      
      private var _numCircle:TipNumCircle;
      
      private var _tipNum:int;
      
      public function FashionStarlingButton(param1:Button)
      {
         super();
         _starlingBtn = param1;
         init();
      }
      
      private function init() : void
      {
         _grayState = _starlingBtn.upState;
         _buttonStateArr = [_starlingBtn.upState,_starlingBtn.downState,grayState];
         _starlingBtn.addEventListener("triggered",onButtonTrigger);
         name = _starlingBtn.name;
         initNumCircle();
      }
      
      private function initNumCircle() : void
      {
         _numCircle = new TipNumCircle();
         tipNum = 0;
      }
      
      private function onButtonTrigger(param1:Event) : void
      {
         if(groupTag != "")
         {
            FashionStarlingButtonGroup.changeSignal.dispatch(this);
         }
         if(_triggerFunction != null)
         {
            _triggerFunction(param1);
         }
      }
      
      protected function setGrayFitlers() : void
      {
         var _loc1_:ColorMatrixFilter = new ColorMatrixFilter();
         _loc1_.adjustSaturation(-1);
         _starlingBtn.filter = _loc1_;
      }
      
      public function resetTexturesState() : void
      {
         _starlingBtn.upState = _buttonStateArr[0];
         _starlingBtn.downState = _buttonStateArr[1];
         grayState = _buttonStateArr[2];
      }
      
      public function remove() : void
      {
         _starlingBtn.removeEventListener("triggered",onButtonTrigger);
         triggerFunction = null;
         _starlingBtn.removeFromParent(true);
      }
      
      public function get grayState() : Texture
      {
         return _grayState;
      }
      
      public function set grayState(param1:Texture) : void
      {
         _grayState = param1;
      }
      
      public function get triggerFunction() : Function
      {
         return _triggerFunction;
      }
      
      public function set triggerFunction(param1:Function) : void
      {
         _triggerFunction = param1;
      }
      
      public function get isGray() : Boolean
      {
         return _isGray;
      }
      
      public function set isGray(param1:Boolean) : void
      {
         _isGray = param1;
         _starlingBtn.touchable = true;
         if(_isGray)
         {
            setGrayFitlers();
            _starlingBtn.touchable = false;
         }
         else
         {
            _starlingBtn.filter = null;
         }
      }
      
      public function get isSelect() : Boolean
      {
         return _isSelect;
      }
      
      public function set isSelect(param1:Boolean) : void
      {
         _isSelect = param1;
         resetTexturesState();
         if(_isSelect)
         {
            _starlingBtn.upState = _starlingBtn.downState;
            _starlingBtn.touchable = false;
         }
         else
         {
            _starlingBtn.touchable = true;
         }
      }
      
      public function get groupTag() : String
      {
         return _groupTag;
      }
      
      public function set groupTag(param1:String) : void
      {
         _groupTag = param1;
         FashionStarlingButtonGroup.addButtonToGroup(_groupTag,this);
      }
      
      public function get starlingBtn() : Button
      {
         return _starlingBtn;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function get tipNum() : int
      {
         return _tipNum;
      }
      
      public function set tipNum(param1:int) : void
      {
         _tipNum = param1;
         _numCircle.setNum(_tipNum);
         if(_tipNum != 0)
         {
            _numCircle.setParent(_starlingBtn);
         }
         else
         {
            _numCircle.removeFromParent();
         }
      }
   }
}

