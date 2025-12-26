package com.freshplanet.ane.AirFacebook.functions;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirFacebook.AirFacebookExtension;

/* loaded from: classes.dex */
public class OpenSessionWithPermissionsFunction extends BaseFunction {
    @Override // com.freshplanet.ane.AirFacebook.functions.BaseFunction, com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        super.call(fREContext, fREObjectArr);
        AirFacebookExtension.context.launchLoginActivity(getListOfStringFromFREArray((FREArray) fREObjectArr[0]), getStringFromFREObject(fREObjectArr[1]), false);
        return null;
    }
}
