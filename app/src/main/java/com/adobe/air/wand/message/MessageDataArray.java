package com.adobe.air.wand.message;

/* loaded from: classes.dex */
public interface MessageDataArray {
    MessageDataArray getArray(int i) throws Exception;

    boolean getBoolean(int i) throws Exception;

    double getDouble(int i) throws Exception;

    int getInt(int i) throws Exception;

    long getLong(int i) throws Exception;

    MessageDataObject getObject(int i) throws Exception;

    String getString(int i) throws Exception;

    int length();

    MessageDataArray put(double d) throws Exception;

    MessageDataArray put(int i) throws Exception;

    MessageDataArray put(int i, double d) throws Exception;

    MessageDataArray put(int i, int i2) throws Exception;

    MessageDataArray put(int i, long j) throws Exception;

    MessageDataArray put(int i, MessageDataArray messageDataArray) throws Exception;

    MessageDataArray put(int i, MessageDataObject messageDataObject) throws Exception;

    MessageDataArray put(int i, String str) throws Exception;

    MessageDataArray put(int i, boolean z) throws Exception;

    MessageDataArray put(long j) throws Exception;

    MessageDataArray put(MessageDataArray messageDataArray) throws Exception;

    MessageDataArray put(MessageDataObject messageDataObject) throws Exception;

    MessageDataArray put(String str) throws Exception;

    MessageDataArray put(boolean z) throws Exception;

    boolean remove(int i);
}
