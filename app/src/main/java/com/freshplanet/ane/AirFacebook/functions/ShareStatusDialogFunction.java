package com.freshplanet.ane.AirFacebook.functions;

import android.content.Intent;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirFacebook.ShareDialogActivity;

/* loaded from: classes.dex */
public class ShareStatusDialogFunction extends BaseFunction implements FREFunction {
    @Override // com.freshplanet.ane.AirFacebook.functions.BaseFunction, com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        super.call(fREContext, fREObjectArr);
        String stringFromFREObject = getStringFromFREObject(fREObjectArr[0]);
        Intent intent = new Intent(fREContext.getActivity().getApplicationContext(), (Class<?>) ShareDialogActivity.class);
        intent.putExtra(ShareDialogActivity.extraPrefix + ".callback", stringFromFREObject);
        fREContext.getActivity().startActivity(intent);
        return null;
    }
}
