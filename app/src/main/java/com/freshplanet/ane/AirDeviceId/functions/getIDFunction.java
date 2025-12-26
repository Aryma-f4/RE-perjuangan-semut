package com.freshplanet.ane.AirDeviceId.functions;

import android.provider.Settings;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

/* loaded from: classes.dex */
public class getIDFunction implements FREFunction {
    @Override // com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        try {
            return FREObject.newObject(Settings.Secure.getString(fREContext.getActivity().getContentResolver(), "android_id"));
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
            return null;
        }
    }
}
