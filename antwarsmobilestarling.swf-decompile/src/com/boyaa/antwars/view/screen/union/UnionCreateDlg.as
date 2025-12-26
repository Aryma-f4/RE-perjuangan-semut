package com.boyaa.antwars.view.screen.union
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.DisplayUtil;
   import com.boyaa.tool.LoadData;
   import com.boyaa.tool.Trim;
   import com.boyaa.tool.filter.RegExpFilter;
   import feathers.controls.TextInput;
   import starling.display.Button;
   import starling.events.Event;
   
   public class UnionCreateDlg extends BaseDlg
   {
      
      private var _layout:LayoutUitl;
      
      private var _asset:ResAssetManager;
      
      private var _closeBtn:Button;
      
      private var _currenceBtn:Button;
      
      private var _byCurrenceBtn:Button;
      
      private var _closeUnionListBtn:Button;
      
      private var _unionNameInput:TextInput;
      
      private var _cname:String;
      
      private var _consume:int;
      
      private var _pay:int;
      
      private var _creatObj:Object;
      
      private const BY_COIN:int = 200;
      
      private const COIN:int = 200000;
      
      private const JOIN_LEVEL:int = 15;
      
      public function UnionCreateDlg()
      {
         super(true);
         _asset = Assets.sAsset;
         _layout = new LayoutUitl(_asset.getOther("unionApply"),_asset);
         _layout.buildLayout("createUnionLayOut",_displayObj);
         _currenceBtn = _displayObj.getChildByName("btnS_createByCoinBtn") as Button;
         _currenceBtn.addEventListener("triggered",coinCreateHandle);
         _byCurrenceBtn = _displayObj.getChildByName("btnS_createByBYCoinBtn") as Button;
         _byCurrenceBtn.addEventListener("triggered",cashCreateHandle);
         _closeUnionListBtn = _displayObj.getChildByName("btnS_close") as Button;
         _closeUnionListBtn.addEventListener("triggered",closeUnionHandel);
         getTextFieldByName("unionNameTF").visible = false;
         _unionNameInput = DisplayUtil.createInputTextByTextField(getTextFieldByName("unionNameTF"));
         _unionNameInput.text = getTextFieldByName("unionNameTF").text;
         _unionNameInput.addEventListener("focusIn",onFocusIn);
         _unionNameInput.addEventListener("focusOut",onFocusIn);
         this._displayObj.addChild(_unionNameInput);
         setDisplayObjectInMiddle();
      }
      
      private function onFocusIn(param1:Event) : void
      {
         if(param1.type == "focusIn")
         {
            if(_unionNameInput.text == getTextFieldByName("unionNameTF").text)
            {
               _unionNameInput.text = "";
            }
         }
         else if(_unionNameInput.text == "")
         {
            _unionNameInput.text = getTextFieldByName("unionNameTF").text;
         }
      }
      
      private function cashCreateHandle(param1:Event) : void
      {
         _pay = 1;
         createHandler();
      }
      
      private function coinCreateHandle(param1:Event) : void
      {
         _pay = 0;
         createHandler();
      }
      
      private function createHandler() : void
      {
         var _loc1_:String = null;
         if(_unionNameInput.text == getTextFieldByName("unionNameTF").text)
         {
            TextTip.instance.showByLang("unionNameCon");
            return;
         }
         _loc1_ = Trim.trim(_unionNameInput.text);
         _cname = new RegExpFilter().filter(_loc1_)[0];
         if(_loc1_ != _cname)
         {
            TextTip.instance.showByLang("unionCreateErrorTip2");
            return;
         }
         if(_cname != "")
         {
            if(PlayerDataList.instance.selfData.level < 15)
            {
               TextTip.instance.showByLang("joinUnionCon");
               return;
            }
            if(_pay == 0)
            {
               _consume = 200000;
               if(AccountData.instance.gameGold < _consume)
               {
                  TextTip.instance.show(LangManager.replace("unionCreateErrorTip0",_consume));
                  return;
               }
            }
            else if(_pay == 1)
            {
               _consume = 200;
               if(AccountData.instance.boyaaCoin < _consume)
               {
                  TextTip.instance.show(LangManager.replace("unionCreateErrorTip1",_consume));
                  return;
               }
            }
            LoadData.show(this);
            _creatObj = {
               "payfortype":_pay,
               "cname":_cname
            };
            EventCenter.PHPEvent.addEventListener("createUnion",createUnionHandler);
            Remoting.instance.gameTable.createUnion(_creatObj);
         }
         else
         {
            TextTip.instance.showByLang("unionNameCon");
         }
      }
      
      private function createUnionHandler(param1:PHPEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         LoadData.hide();
         if(_loc3_.ret == 1033)
         {
            TextTip.instance.showByLang("joinUnionCon");
         }
         else if(_loc3_.ret == 100)
         {
            TextTip.instance.showByLang("UnionCreateErrorCoinNotEnough");
         }
         else if(_loc3_.ret == 101)
         {
            TextTip.instance.showByLang("UnionCreateErrorPayTypeIsNull");
         }
         else if(_loc3_.ret == 203)
         {
            TextTip.instance.showByLang("UnionNameIsWrong");
         }
         else
         {
            TextTip.instance.showByLang("createUnionOK");
            closeUnionHandel(null);
            if(_pay == 1)
            {
               AccountData.instance.boyaaCoin -= _consume;
            }
            else
            {
               AccountData.instance.gameGold -= _consume;
            }
            UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.UNION_VIEW_CHANGE));
         }
      }
      
      private function closeUnionHandel(param1:Event) : void
      {
         this.deactive();
      }
   }
}

