package com.freshplanet.ane.AirDeviceId;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/* loaded from: classes.dex */
public class AirDeviceIdExtension implements FREExtension {
    private static String TAG = "[AirDeviceId]";
    public static FREContext context;

    @Override // com.adobe.fre.FREExtension
    public FREContext createContext(String str) {
        Log.d(TAG, "Extension.createContext extId: " + str);
        AirDeviceIdExtensionContext airDeviceIdExtensionContext = new AirDeviceIdExtensionContext();
        context = airDeviceIdExtensionContext;
        return airDeviceIdExtensionContext;
    }

    @Override // com.adobe.fre.FREExtension
    public void dispose() {
        Log.d(TAG, "Extension.dispose");
        context = null;
    }

    @Override // com.adobe.fre.FREExtension
    public void initialize() {
        Log.d(TAG, "Extension.initialize");
    }
}
