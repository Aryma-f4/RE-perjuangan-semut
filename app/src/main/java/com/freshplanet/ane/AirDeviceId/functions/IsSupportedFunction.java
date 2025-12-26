package com.freshplanet.ane.AirDeviceId.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

/* loaded from: classes.dex */
public class IsSupportedFunction implements FREFunction {
    private static String TAG = "[AirDeviceId] IsSupported -";

    @Override // com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        Log.d(TAG, "true");
        try {
            return FREObject.newObject(true);
        } catch (FREWrongThreadException e) {
            Log.d(TAG, e.getLocalizedMessage());
            return null;
        }
    }
}
