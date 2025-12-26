package com.boyaa.antwars.view.screen.union
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
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
   import starling.text.TextField;
   
   public class UnionMessageSendDlg extends BaseDlg
   {
      
      private var _asset:ResAssetManager;
      
      private var _layout:LayoutUitl;
      
      private var _sendBtn:Button;
      
      private var _closeBtn:Button;
      
      private var _callBack:Function;
      
      private var _inputContentTF:TextInput;
      
      private var _inputTitleTF:TextInput;
      
      public function UnionMessageSendDlg(param1:Function)
      {
         super(true);
         _callBack = param1;
         _asset = Assets.sAsset;
         _layout = new LayoutUitl(_asset.getOther("UnionMessage"),_asset);
         _layout.buildLayout("unionSendMessageLayOut",_displayObj);
         _sendBtn = _displayObj.getChildByName("btnS_unionSendMessageBtn") as Button;
         _sendBtn.addEventListener("triggered",messageSendBtnHandel);
         _closeBtn = _displayObj.getChildByName("btnS_close") as Button;
         _closeBtn.addEventListener("triggered",closeHandel);
         (_displayObj.getChildByName("titleTF") as TextField).text = "";
         (_displayObj.getChildByName("contentTF") as TextField).text = "";
         _inputTitleTF = DisplayUtil.createInputTextByTextField(_displayObj.getChildByName("titleTF") as TextField);
         this._displayObj.addChild(_inputTitleTF);
         _inputContentTF = DisplayUtil.createInputTextByTextField(_displayObj.getChildByName("contentTF") as TextField);
         this._displayObj.addChild(_inputContentTF);
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
      }
      
      private function closeHandel(param1:Event) : void
      {
         this.deactive();
         _callBack();
      }
      
      private function messageSendBtnHandel(param1:Event) : void
      {
         var _loc3_:String = Trim.trim(_inputTitleTF.text);
         _loc3_ = new RegExpFilter().expectSpace(_loc3_)[0];
         var _loc2_:String = Trim.trim(_inputContentTF.text);
         _loc2_ = new RegExpFilter().expectSpace(_loc2_)[0];
         if(_loc2_ != "" && _loc3_ != "")
         {
            LoadData.show(this);
            Remoting.instance.gameTable.leaveUnionMsg({
               "title":_loc3_,
               "content":_loc2_
            });
            EventCenter.PHPEvent.addEventListener("leaveUnionMessageDone",getLeaveUnionMessageDone);
         }
         else
         {
            TextTip.instance.showByLang("unionMessageTip0");
         }
      }
      
      private function getLeaveUnionMessageDone(param1:PHPEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         LoadData.hide();
         if(_loc3_.ret == 0)
         {
            this.deactive();
            _callBack();
         }
         else
         {
            if(_loc3_.ret != 102)
            {
               throw new Error(_loc3_.msg);
            }
            TextTip.instance.show(LangManager.replace("unionmessageFull",5));
         }
      }
   }
}

