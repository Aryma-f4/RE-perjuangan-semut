package com.freshplanet.ane.AirFacebook.functions;

import android.os.Bundle;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirFacebook.AirFacebookExtension;

/* loaded from: classes.dex */
public class WebDialogFunction extends BaseFunction implements FREFunction {
    private String callback;
    private String method;

    @Override // com.freshplanet.ane.AirFacebook.functions.BaseFunction, com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        super.call(fREContext, fREObjectArr);
        this.method = getStringFromFREObject(fREObjectArr[0]);
        Bundle bundleOfStringFromFREArrays = getBundleOfStringFromFREArrays((FREArray) fREObjectArr[1], (FREArray) fREObjectArr[2]);
        this.callback = getStringFromFREObject(fREObjectArr[3]);
        AirFacebookExtension.context.launchDialogActivity(this.method, bundleOfStringFromFREArrays, this.callback);
        return null;
    }
}
