package com.freshplanet.ane.AirDeviceId;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.freshplanet.ane.AirDeviceId.functions.IsSupportedFunction;
import com.freshplanet.ane.AirDeviceId.functions.getIDFAFunction;
import com.freshplanet.ane.AirDeviceId.functions.getIDFVFunction;
import com.freshplanet.ane.AirDeviceId.functions.getIDFunction;
import java.util.HashMap;
import java.util.Map;

/* loaded from: classes.dex */
public class AirDeviceIdExtensionContext extends FREContext {
    private static String TAG = "[AirDeviceId]";

    public AirDeviceIdExtensionContext() {
        Log.d(TAG, "Creating Extension Context");
    }

    @Override // com.adobe.fre.FREContext
    public void dispose() {
        Log.d(TAG, "Disposing Extension Context");
        AirDeviceIdExtension.context = null;
    }

    @Override // com.adobe.fre.FREContext
    public Map<String, FREFunction> getFunctions() {
        Log.d(TAG, "Registering Extension Functions");
        HashMap map = new HashMap();
        map.put("isSupported", new IsSupportedFunction());
        map.put("getID", new getIDFunction());
        map.put("getIDFV", new getIDFVFunction());
        map.put("getIDFA", new getIDFAFunction());
        return map;
    }
}
