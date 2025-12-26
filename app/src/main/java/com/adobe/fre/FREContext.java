package com.adobe.fre;

import android.app.Activity;
import android.content.res.Resources;
import java.util.Map;

/* loaded from: classes.dex */
public abstract class FREContext {
    private long m_objectPointer;

    private native void registerFunction(long j, String str, FREFunction fREFunction);

    private native void registerFunctionCount(long j, int i);

    public native void dispatchStatusEventAsync(String str, String str2) throws IllegalStateException, IllegalArgumentException;

    public abstract void dispose();

    public native FREObject getActionScriptData() throws IllegalStateException, FREWrongThreadException;

    public native Activity getActivity() throws IllegalStateException;

    public abstract Map<String, FREFunction> getFunctions();

    public native int getResourceId(String str) throws IllegalStateException, Resources.NotFoundException, IllegalArgumentException;

    public native void setActionScriptData(FREObject fREObject) throws IllegalStateException, FREWrongThreadException, IllegalArgumentException;

    protected void VisitFunctions(long clientID) {
        Map<String, FREFunction> m = getFunctions();
        registerFunctionCount(clientID, m.size());
        for (Map.Entry<String, FREFunction> e : m.entrySet()) {
            registerFunction(clientID, e.getKey(), e.getValue());
        }
    }
}
