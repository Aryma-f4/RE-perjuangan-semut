package com.freshplanet.ane.AirFacebook.functions;

import android.content.Intent;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirFacebook.ShareDialogActivity;

/* loaded from: classes.dex */
public class ShareLinkDialogFunction extends BaseFunction implements FREFunction {
    @Override // com.freshplanet.ane.AirFacebook.functions.BaseFunction, com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        super.call(fREContext, fREObjectArr);
        String stringFromFREObject = getStringFromFREObject(fREObjectArr[7]);
        String stringFromFREObject2 = getStringFromFREObject(fREObjectArr[0]);
        String stringFromFREObject3 = getStringFromFREObject(fREObjectArr[1]);
        String stringFromFREObject4 = getStringFromFREObject(fREObjectArr[2]);
        String stringFromFREObject5 = getStringFromFREObject(fREObjectArr[3]);
        String stringFromFREObject6 = getStringFromFREObject(fREObjectArr[4]);
        Intent intent = new Intent(fREContext.getActivity().getApplicationContext(), (Class<?>) ShareDialogActivity.class);
        intent.putExtra(ShareDialogActivity.extraPrefix + ".link", stringFromFREObject2);
        intent.putExtra(ShareDialogActivity.extraPrefix + ".name", stringFromFREObject3);
        intent.putExtra(ShareDialogActivity.extraPrefix + ".caption", stringFromFREObject4);
        intent.putExtra(ShareDialogActivity.extraPrefix + ".description", stringFromFREObject5);
        intent.putExtra(ShareDialogActivity.extraPrefix + ".pictureUrl", stringFromFREObject6);
        intent.putExtra(ShareDialogActivity.extraPrefix + ".callback", stringFromFREObject);
        fREContext.getActivity().startActivity(intent);
        return null;
    }
}
