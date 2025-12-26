package com.freshplanet.alert;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/* loaded from: classes.dex */
public class Extension implements FREExtension {
    public static ExtensionContext context;

    public static void log(String str) {
        context.dispatchStatusEventAsync("LOGGING", str);
    }

    @Override // com.adobe.fre.FREExtension
    public FREContext createContext(String str) {
        context = new ExtensionContext();
        return context;
    }

    @Override // com.adobe.fre.FREExtension
    public void dispose() {
        context = null;
    }

    @Override // com.adobe.fre.FREExtension
    public void initialize() {
    }
}
