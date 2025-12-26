package com.freshplanet.ane.AirFacebook;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/* loaded from: classes.dex */
public class AirFacebookExtension implements FREExtension {
    public static AirFacebookExtensionContext context;
    public static String TAG = "AirFacebook";
    private static Boolean PRINT_LOG = true;

    public static int getResourceId(String str) {
        if (context != null) {
            return context.getResourceId(str);
        }
        return 0;
    }

    public static int[] getResourceIds(String str) {
        return new int[0];
    }

    public static void log(String str) {
        if (PRINT_LOG.booleanValue()) {
            Log.d(TAG, str);
        }
        if (context == null || str == null) {
            return;
        }
        context.dispatchStatusEventAsync("LOGGING", str);
    }

    @Override // com.adobe.fre.FREExtension
    public FREContext createContext(String str) {
        AirFacebookExtensionContext airFacebookExtensionContext = new AirFacebookExtensionContext();
        context = airFacebookExtensionContext;
        return airFacebookExtensionContext;
    }

    @Override // com.adobe.fre.FREExtension
    public void dispose() {
        context = null;
    }

    @Override // com.adobe.fre.FREExtension
    public void initialize() {
    }
}
