package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.ITextEditor;
   import feathers.utils.geom.matrixToRotation;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.events.Event;
   import starling.textures.ConcreteTexture;
   import starling.textures.Texture;
   import starling.utils.MatrixUtil;
   import starling.utils.getNextPowerOfTwo;
   
   public class TextFieldTextEditor extends FeathersControl implements ITextEditor
   {
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_POINT:Point = new Point();
      
      protected var textField:TextField;
      
      protected var textSnapshot:Image;
      
      protected var measureTextField:TextField;
      
      protected var _snapshotWidth:int = 0;
      
      protected var _snapshotHeight:int = 0;
      
      protected var _textFieldClipRect:Rectangle = new Rectangle();
      
      protected var _textFieldOffsetX:Number = 0;
      
      protected var _textFieldOffsetY:Number = 0;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _previousTextFormat:TextFormat;
      
      protected var _textFormat:TextFormat;
      
      protected var _disabledTextFormat:TextFormat;
      
      protected var _embedFonts:Boolean = false;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _multiline:Boolean = false;
      
      protected var _isHTML:Boolean = false;
      
      protected var _alwaysShowSelection:Boolean = false;
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _maxChars:int = 0;
      
      protected var _restrict:String;
      
      protected var _isEditable:Boolean = true;
      
      protected var _useGutter:Boolean = false;
      
      protected var _textFieldHasFocus:Boolean = false;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionBeginIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var resetScrollOnFocusOut:Boolean = true;
      
      public function TextFieldTextEditor()
      {
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener("addedToStage",textEditor_addedToStageHandler);
         this.addEventListener("removedFromStage",textEditor_removedFromStageHandler);
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(!param1)
         {
            param1 = "";
         }
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate("data");
         this.dispatchEventWith("change");
      }
      
      public function get baseline() : Number
      {
         if(!this.textField)
         {
            return 0;
         }
         var _loc1_:Number = 0;
         if(this._useGutter)
         {
            _loc1_ = 2;
         }
         return _loc1_ + this.textField.getLineMetrics(0).ascent;
      }
      
      public function get textFormat() : TextFormat
      {
         return this._textFormat;
      }
      
      public function set textFormat(param1:TextFormat) : void
      {
         if(this._textFormat == param1)
         {
            return;
         }
         this._textFormat = param1;
         this._previousTextFormat = null;
         this.invalidate("styles");
      }
      
      public function get disabledTextFormat() : TextFormat
      {
         return this._disabledTextFormat;
      }
      
      public function set disabledTextFormat(param1:TextFormat) : void
      {
         if(this._disabledTextFormat == param1)
         {
            return;
         }
         this._disabledTextFormat = param1;
         this.invalidate("styles");
      }
      
      public function get embedFonts() : Boolean
      {
         return this._embedFonts;
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         if(this._embedFonts == param1)
         {
            return;
         }
         this._embedFonts = param1;
         this.invalidate("styles");
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this._wordWrap == param1)
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate("styles");
      }
      
      public function get multiline() : Boolean
      {
         return this._multiline;
      }
      
      public function set multiline(param1:Boolean) : void
      {
         if(this._multiline == param1)
         {
            return;
         }
         this._multiline = param1;
         this.invalidate("styles");
      }
      
      public function get isHTML() : Boolean
      {
         return this._isHTML;
      }
      
      public function set isHTML(param1:Boolean) : void
      {
         if(this._isHTML == param1)
         {
            return;
         }
         this._isHTML = param1;
         this.invalidate("data");
      }
      
      public function get alwaysShowSelection() : Boolean
      {
         return this._alwaysShowSelection;
      }
      
      public function set alwaysShowSelection(param1:Boolean) : void
      {
         if(this._alwaysShowSelection == param1)
         {
            return;
         }
         this._alwaysShowSelection = param1;
         this.invalidate("styles");
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(this._displayAsPassword == param1)
         {
            return;
         }
         this._displayAsPassword = param1;
         this.invalidate("styles");
      }
      
      public function get maxChars() : int
      {
         return this._maxChars;
      }
      
      public function set maxChars(param1:int) : void
      {
         if(this._maxChars == param1)
         {
            return;
         }
         this._maxChars = param1;
         this.invalidate("styles");
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         if(this._restrict == param1)
         {
            return;
         }
         this._restrict = param1;
         this.invalidate("styles");
      }
      
      public function get isEditable() : Boolean
      {
         return this._isEditable;
      }
      
      public function set isEditable(param1:Boolean) : void
      {
         if(this._isEditable == param1)
         {
            return;
         }
         this._isEditable = param1;
         this.invalidate("styles");
      }
      
      public function get useGutter() : Boolean
      {
         return this._useGutter;
      }
      
      public function set useGutter(param1:Boolean) : void
      {
         if(this._useGutter == param1)
         {
            return;
         }
         this._useGutter = param1;
         this.invalidate("styles");
      }
      
      public function get setTouchFocusOnEndedPhase() : Boolean
      {
         return false;
      }
      
      public function get selectionBeginIndex() : int
      {
         if(this._pendingSelectionBeginIndex >= 0)
         {
            return this._pendingSelectionBeginIndex;
         }
         if(this.textField)
         {
            return this.textField.selectionBeginIndex;
         }
         return 0;
      }
      
      public function get selectionEndIndex() : int
      {
         if(this._pendingSelectionEndIndex >= 0)
         {
            return this._pendingSelectionEndIndex;
         }
         if(this.textField)
         {
            return this.textField.selectionEndIndex;
         }
         return 0;
      }
      
      override public function dispose() : void
      {
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
         if(this.textField && this.textField.parent)
         {
            this.textField.parent.removeChild(this.textField);
         }
         this.textField = null;
         this.measureTextField = null;
         super.dispose();
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         var _loc3_:Boolean = this.textSnapshot ? !this.textSnapshot.visible : this._textFieldHasFocus;
         this.textField.visible = _loc3_;
         this.transformTextField();
         this.positionSnapshot();
         super.render(param1,param2);
      }
      
      public function setFocus(param1:Point = null) : void
      {
         var _loc7_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc2_:Rectangle = null;
         var _loc4_:Number = NaN;
         if(this.textField)
         {
            if(!this.textField.parent)
            {
               Starling.current.nativeStage.addChild(this.textField);
            }
            if(param1)
            {
               _loc7_ = 2;
               if(this._useGutter)
               {
                  _loc7_ = 0;
               }
               _loc3_ = param1.x + _loc7_;
               _loc5_ = param1.y + _loc7_;
               if(_loc3_ < 0)
               {
                  this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = 0;
               }
               else
               {
                  this._pendingSelectionBeginIndex = this.textField.getCharIndexAtPoint(_loc3_,_loc5_);
                  if(this._pendingSelectionBeginIndex < 0)
                  {
                     if(this._multiline)
                     {
                        _loc6_ = int(_loc5_ / this.textField.getLineMetrics(0).height) + (this.textField.scrollV - 1);
                        try
                        {
                           this._pendingSelectionBeginIndex = this.textField.getLineOffset(_loc6_) + this.textField.getLineLength(_loc6_);
                           if(this._pendingSelectionBeginIndex != this._text.length)
                           {
                              this._pendingSelectionBeginIndex--;
                           }
                        }
                        catch(error:Error)
                        {
                           this._pendingSelectionBeginIndex = this._text.length;
                        }
                     }
                     else
                     {
                        this._pendingSelectionBeginIndex = this.textField.getCharIndexAtPoint(_loc3_,this.textField.getLineMetrics(0).ascent / 2);
                        if(this._pendingSelectionBeginIndex < 0)
                        {
                           this._pendingSelectionBeginIndex = this._text.length;
                        }
                     }
                  }
                  else
                  {
                     _loc2_ = this.textField.getCharBoundaries(this._pendingSelectionBeginIndex);
                     if(_loc2_)
                     {
                        _loc4_ = _loc2_.x;
                        if(_loc2_ && _loc4_ + _loc2_.width - _loc3_ < _loc3_ - _loc4_)
                        {
                           this._pendingSelectionBeginIndex++;
                        }
                     }
                  }
                  this._pendingSelectionEndIndex = this._pendingSelectionBeginIndex;
               }
            }
            else
            {
               this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = -1;
            }
            if(!this._focusManager)
            {
               Starling.current.nativeStage.focus = this.textField;
            }
            this.textField.requestSoftKeyboard();
            if(this._textFieldHasFocus)
            {
               this.invalidate("selected");
            }
         }
         else
         {
            this._isWaitingToSetFocus = true;
         }
      }
      
      public function clearFocus() : void
      {
         if(!this._textFieldHasFocus || this._focusManager)
         {
            return;
         }
         Starling.current.nativeStage.focus = Starling.current.nativeStage;
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         if(this.textField)
         {
            if(!this._isValidating)
            {
               this.validate();
            }
            this.textField.setSelection(param1,param2);
         }
         else
         {
            this._pendingSelectionBeginIndex = param1;
            this._pendingSelectionEndIndex = param2;
         }
      }
      
      public function measureText(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:* = this.explicitWidth !== this.explicitWidth;
         var _loc3_:* = this.explicitHeight !== this.explicitHeight;
         if(!_loc2_ && !_loc3_)
         {
            param1.x = this.explicitWidth;
            param1.y = this.explicitHeight;
            return param1;
         }
         if(!this._isInitialized)
         {
            this.initializeInternal();
         }
         this.commit();
         return this.measure(param1);
      }
      
      override protected function initialize() : void
      {
         this.textField = new TextField();
         this.textField.needsSoftKeyboard = true;
         this.textField.addEventListener("change",textField_changeHandler);
         this.textField.addEventListener("focusIn",textField_focusInHandler);
         this.textField.addEventListener("focusOut",textField_focusOutHandler);
         this.textField.addEventListener("keyDown",textField_keyDownHandler);
         this.textField.addEventListener("softKeyboardActivate",textField_softKeyboardActivateHandler);
         this.textField.addEventListener("softKeyboardDeactivate",textField_softKeyboardDeactivateHandler);
         this.measureTextField = new TextField();
         this.measureTextField.autoSize = "left";
         this.measureTextField.selectable = false;
         this.measureTextField.mouseWheelEnabled = false;
         this.measureTextField.mouseEnabled = false;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("size");
         this.commit();
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layout(_loc1_);
      }
      
      protected function commit() : void
      {
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("state");
         if(_loc1_ || _loc3_ || _loc2_)
         {
            this.commitStylesAndData(this.textField);
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:* = this.explicitWidth !== this.explicitWidth;
         var _loc2_:* = this.explicitHeight !== this.explicitHeight;
         if(!_loc1_ && !_loc2_)
         {
            return false;
         }
         this.measure(HELPER_POINT);
         return this.setSizeInternal(HELPER_POINT.x,HELPER_POINT.y,false);
      }
      
      protected function measure(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc3_:* = this.explicitWidth !== this.explicitWidth;
         var _loc6_:* = this.explicitHeight !== this.explicitHeight;
         if(!_loc3_ && !_loc6_)
         {
            param1.x = this.explicitWidth;
            param1.y = this.explicitHeight;
            return param1;
         }
         this.commitStylesAndData(this.measureTextField);
         var _loc4_:Number = 4;
         if(this._useGutter)
         {
            _loc4_ = 0;
         }
         var _loc5_:Number = this.explicitWidth;
         if(_loc3_)
         {
            this.measureTextField.wordWrap = false;
            _loc5_ = this.measureTextField.width - _loc4_;
            if(_loc5_ < this._minWidth)
            {
               _loc5_ = this._minWidth;
            }
            else if(_loc5_ > this._maxWidth)
            {
               _loc5_ = this._maxWidth;
            }
         }
         var _loc2_:Number = this.explicitHeight;
         if(_loc6_)
         {
            this.measureTextField.wordWrap = this._wordWrap;
            this.measureTextField.width = _loc5_ + _loc4_;
            _loc2_ = this.measureTextField.height - _loc4_;
            if(this._useGutter)
            {
               _loc2_ += 4;
            }
            if(_loc2_ < this._minHeight)
            {
               _loc2_ = this._minHeight;
            }
            else if(_loc2_ > this._maxHeight)
            {
               _loc2_ = this._maxHeight;
            }
         }
         param1.x = _loc5_;
         param1.y = _loc2_;
         return param1;
      }
      
      protected function commitStylesAndData(param1:TextField) : void
      {
         var _loc2_:TextFormat = null;
         param1.maxChars = this._maxChars;
         param1.restrict = this._restrict;
         param1.alwaysShowSelection = this._alwaysShowSelection;
         param1.displayAsPassword = this._displayAsPassword;
         param1.wordWrap = this._wordWrap;
         param1.multiline = this._multiline;
         param1.embedFonts = this._embedFonts;
         param1.type = this._isEditable ? "input" : "dynamic";
         param1.selectable = this._isEnabled;
         var _loc3_:* = false;
         if(!this._isEnabled && this._disabledTextFormat)
         {
            _loc2_ = this._disabledTextFormat;
         }
         else
         {
            _loc2_ = this._textFormat;
         }
         if(_loc2_)
         {
            _loc3_ = this._previousTextFormat != _loc2_;
            this._previousTextFormat = _loc2_;
            param1.defaultTextFormat = _loc2_;
         }
         if(this._isHTML)
         {
            if(_loc3_ || param1.htmlText != this._text)
            {
               if(param1 == this.textField && this._pendingSelectionBeginIndex < 0)
               {
                  this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
                  this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
               }
               param1.htmlText = this._text;
            }
         }
         else if(_loc3_ || param1.text != this._text)
         {
            if(param1 == this.textField && this._pendingSelectionBeginIndex < 0)
            {
               this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
               this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
            }
            param1.text = this._text;
         }
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc4_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc3_:Boolean = this.isInvalid("state");
         if(param1)
         {
            this.refreshSnapshotParameters();
            this.refreshTextFieldSize();
            this.transformTextField();
            this.positionSnapshot();
         }
         this.checkIfNewSnapshotIsNeeded();
         if(!this._textFieldHasFocus && (_loc4_ || _loc2_ || _loc3_ || this._needsNewTexture))
         {
            this.addEventListener("enterFrame",textEditor_enterFrameHandler);
         }
         this.doPendingActions();
      }
      
      protected function refreshTextFieldSize() : void
      {
         var _loc1_:Number = 4;
         if(this._useGutter)
         {
            _loc1_ = 0;
         }
         this.textField.width = this.actualWidth + _loc1_;
         this.textField.height = this.actualHeight + _loc1_;
      }
      
      protected function refreshSnapshotParameters() : void
      {
         this._textFieldOffsetX = 0;
         this._textFieldOffsetY = 0;
         this._textFieldClipRect.x = 0;
         this._textFieldClipRect.y = 0;
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         var _loc2_:Number = this.actualWidth * Starling.contentScaleFactor * matrixToScaleX(HELPER_MATRIX);
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         var _loc1_:Number = this.actualHeight * Starling.contentScaleFactor * matrixToScaleY(HELPER_MATRIX);
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         this._textFieldClipRect.width = _loc2_;
         this._textFieldClipRect.height = _loc1_;
      }
      
      protected function transformTextField() : void
      {
         if(!this.textField.visible)
         {
            return;
         }
         HELPER_POINT.x = HELPER_POINT.y = 0;
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         MatrixUtil.transformCoords(HELPER_MATRIX,0,0,HELPER_POINT);
         var _loc1_:Rectangle = Starling.current.viewPort;
         var _loc2_:Number = 1;
         if(Starling.current.supportHighResolutions)
         {
            _loc2_ = Starling.current.nativeStage.contentsScaleFactor;
         }
         var _loc3_:Number = Starling.contentScaleFactor / _loc2_;
         var _loc4_:Number = 2;
         if(this._useGutter)
         {
            _loc4_ = 0;
         }
         this.textField.x = Math.round(_loc1_.x + HELPER_POINT.x * _loc3_ - _loc4_);
         this.textField.y = Math.round(_loc1_.y + HELPER_POINT.y * _loc3_ - _loc4_);
         this.textField.rotation = matrixToRotation(HELPER_MATRIX) * 180 / 3.141592653589793;
         this.textField.scaleX = matrixToScaleX(HELPER_MATRIX) * _loc3_;
         this.textField.scaleY = matrixToScaleY(HELPER_MATRIX) * _loc3_;
      }
      
      protected function positionSnapshot() : void
      {
         if(!this.textSnapshot)
         {
            return;
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
         this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
      }
      
      protected function checkIfNewSnapshotIsNeeded() : void
      {
         var _loc2_:* = Starling.current.profile != "baselineConstrained";
         if(_loc2_)
         {
            this._snapshotWidth = this._textFieldClipRect.width;
            this._snapshotHeight = this._textFieldClipRect.height;
         }
         else
         {
            this._snapshotWidth = getNextPowerOfTwo(this._textFieldClipRect.width);
            this._snapshotHeight = getNextPowerOfTwo(this._textFieldClipRect.height);
         }
         var _loc1_:ConcreteTexture = this.textSnapshot ? this.textSnapshot.texture.root : null;
         this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || this._snapshotWidth != _loc1_.width || this._snapshotHeight != _loc1_.height;
      }
      
      protected function doPendingActions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._isWaitingToSetFocus)
         {
            this._isWaitingToSetFocus = false;
            this.setFocus();
         }
         if(this._pendingSelectionBeginIndex >= 0)
         {
            _loc1_ = this._pendingSelectionBeginIndex;
            _loc2_ = this._pendingSelectionEndIndex;
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.selectRange(_loc1_,_loc2_);
         }
      }
      
      protected function texture_onRestore() : void
      {
         this.refreshSnapshot();
      }
      
      protected function refreshSnapshot() : void
      {
         var _loc6_:Texture = null;
         var _loc5_:Texture = null;
         if(this._snapshotWidth <= 0 || this._snapshotHeight <= 0)
         {
            return;
         }
         var _loc7_:Number = 2;
         if(this._useGutter)
         {
            _loc7_ = 0;
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         var _loc2_:Number = matrixToScaleX(HELPER_MATRIX);
         var _loc1_:Number = matrixToScaleY(HELPER_MATRIX);
         var _loc4_:Number = Starling.contentScaleFactor;
         HELPER_MATRIX.identity();
         HELPER_MATRIX.translate(this._textFieldOffsetX - _loc7_,this._textFieldOffsetY - _loc7_);
         HELPER_MATRIX.scale(_loc4_ * _loc2_,_loc4_ * _loc1_);
         var _loc3_:BitmapData = new BitmapData(this._snapshotWidth,this._snapshotHeight,true,16711935);
         _loc3_.draw(this.textField,HELPER_MATRIX,null,null,this._textFieldClipRect);
         if(!this.textSnapshot || this._needsNewTexture)
         {
            _loc6_ = Texture.fromBitmapData(_loc3_,false,false,Starling.contentScaleFactor);
            _loc6_.root.onRestore = texture_onRestore;
         }
         if(!this.textSnapshot)
         {
            this.textSnapshot = new Image(_loc6_);
            this.addChild(this.textSnapshot);
         }
         else if(this._needsNewTexture)
         {
            this.textSnapshot.texture.dispose();
            this.textSnapshot.texture = _loc6_;
            this.textSnapshot.readjustSize();
         }
         else
         {
            _loc5_ = this.textSnapshot.texture;
            _loc5_.root.uploadBitmapData(_loc3_);
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         this.textSnapshot.scaleX = 1 / matrixToScaleX(HELPER_MATRIX);
         this.textSnapshot.scaleY = 1 / matrixToScaleY(HELPER_MATRIX);
         _loc3_.dispose();
         this._needsNewTexture = false;
      }
      
      protected function textEditor_addedToStageHandler(param1:starling.events.Event) : void
      {
         if(!this.textField.parent)
         {
            Starling.current.nativeStage.addChild(this.textField);
         }
      }
      
      protected function textEditor_removedFromStageHandler(param1:starling.events.Event) : void
      {
         if(this.textField.parent)
         {
            this.textField.parent.removeChild(this.textField);
         }
      }
      
      protected function textEditor_enterFrameHandler(param1:starling.events.Event) : void
      {
         this.removeEventListener("enterFrame",textEditor_enterFrameHandler);
         this.refreshSnapshot();
         if(this.textSnapshot)
         {
            this.textSnapshot.visible = !this._textFieldHasFocus;
            this.textSnapshot.alpha = this._text.length > 0 ? 1 : 0;
         }
      }
      
      protected function textField_changeHandler(param1:flash.events.Event) : void
      {
         this.text = this.textField.text;
      }
      
      protected function textField_focusInHandler(param1:FocusEvent) : void
      {
         this._textFieldHasFocus = true;
         if(this.textSnapshot)
         {
            this.textSnapshot.visible = false;
         }
         this.invalidate("skin");
         this.dispatchEventWith("focusIn");
      }
      
      protected function textField_focusOutHandler(param1:FocusEvent) : void
      {
         this._textFieldHasFocus = false;
         if(this.resetScrollOnFocusOut)
         {
            this.textField.scrollH = this.textField.scrollV = 0;
         }
         this.invalidate("data");
         this.invalidate("skin");
         this.dispatchEventWith("focusOut");
      }
      
      protected function textField_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.dispatchEventWith("enter");
         }
      }
      
      protected function textField_softKeyboardActivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith("softKeyboardActivate",true);
      }
      
      protected function textField_softKeyboardDeactivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith("softKeyboardDeactivate",true);
      }
   }
}

