package com.freshplanet.ane.AirFacebook.functions;

import android.content.Intent;
import android.os.Bundle;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirFacebook.ShareOGActivity;

/* loaded from: classes.dex */
public class ShareOpenGraphDialogFunction extends BaseFunction implements FREFunction {
    @Override // com.freshplanet.ane.AirFacebook.functions.BaseFunction, com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        super.call(fREContext, fREObjectArr);
        String stringFromFREObject = getStringFromFREObject(fREObjectArr[6]);
        String stringFromFREObject2 = getStringFromFREObject(fREObjectArr[0]);
        Bundle bundleOfStringFromFREArrays = getBundleOfStringFromFREArrays((FREArray) fREObjectArr[1], (FREArray) fREObjectArr[2]);
        String stringFromFREObject3 = getStringFromFREObject(fREObjectArr[3]);
        Intent intent = new Intent(fREContext.getActivity().getApplicationContext(), (Class<?>) ShareOGActivity.class);
        intent.putExtra(ShareOGActivity.extraPrefix + ".actionType", stringFromFREObject2);
        intent.putExtra(ShareOGActivity.extraPrefix + ".actionParams", bundleOfStringFromFREArrays);
        intent.putExtra(ShareOGActivity.extraPrefix + ".previewProperty", stringFromFREObject3);
        intent.putExtra(ShareOGActivity.extraPrefix + ".callback", stringFromFREObject);
        fREContext.getActivity().startActivity(intent);
        return null;
    }
}
