package com.adobe.fre;

/* loaded from: classes.dex */
public interface FREExtension {
    FREContext createContext(String str);

    void dispose();

    void initialize();
}
