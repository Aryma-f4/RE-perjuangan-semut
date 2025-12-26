package com.adobe.air.wand.message;

/* loaded from: classes.dex */
public interface MessageDataObject {
    MessageDataArray getArray(String str) throws Exception;

    boolean getBoolean(String str) throws Exception;

    double getDouble(String str) throws Exception;

    int getInt(String str) throws Exception;

    long getLong(String str) throws Exception;

    String[] getNames();

    MessageDataObject getObject(String str) throws Exception;

    String getString(String str) throws Exception;

    boolean has(String str);

    int length();

    MessageDataObject put(String str, double d) throws Exception;

    MessageDataObject put(String str, int i) throws Exception;

    MessageDataObject put(String str, long j) throws Exception;

    MessageDataObject put(String str, MessageDataArray messageDataArray) throws Exception;

    MessageDataObject put(String str, MessageDataObject messageDataObject) throws Exception;

    MessageDataObject put(String str, String str2) throws Exception;

    MessageDataObject put(String str, boolean z) throws Exception;

    boolean remove(String str);
}
