package com.adobe.air.wand.message.json;

import com.adobe.air.wand.message.MessageDataArray;
import com.adobe.air.wand.message.MessageDataObject;
import org.json.JSONArray;

/* loaded from: classes.dex */
public class JSONMessageDataArray implements MessageDataArray {
    final JSONArray mJSONArray;

    public JSONMessageDataArray() {
        this.mJSONArray = new JSONArray();
    }

    public JSONMessageDataArray(JSONArray jSONArray) {
        this.mJSONArray = jSONArray;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public boolean getBoolean(int i) throws Exception {
        return this.mJSONArray.getBoolean(i);
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public int getInt(int i) throws Exception {
        return this.mJSONArray.getInt(i);
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public long getLong(int i) throws Exception {
        return this.mJSONArray.getLong(i);
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public double getDouble(int i) throws Exception {
        return this.mJSONArray.getDouble(i);
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public String getString(int i) throws Exception {
        return this.mJSONArray.getString(i);
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataObject getObject(int i) throws Exception {
        return new JSONMessageDataObject(this.mJSONArray.getJSONObject(i));
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray getArray(int i) throws Exception {
        return new JSONMessageDataArray(this.mJSONArray.getJSONArray(i));
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(boolean z) throws Exception {
        this.mJSONArray.put(z);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(int i) throws Exception {
        this.mJSONArray.put(i);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(long j) throws Exception {
        this.mJSONArray.put(j);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(double d) throws Exception {
        this.mJSONArray.put(d);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(String str) throws Exception {
        this.mJSONArray.put(str);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(MessageDataObject messageDataObject) throws Exception {
        this.mJSONArray.put(((JSONMessageDataObject) messageDataObject).mJSONObject);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(MessageDataArray messageDataArray) throws Exception {
        this.mJSONArray.put(((JSONMessageDataArray) messageDataArray).mJSONArray);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(int i, boolean z) throws Exception {
        this.mJSONArray.put(i, z);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(int i, int i2) throws Exception {
        this.mJSONArray.put(i, i2);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(int i, long j) throws Exception {
        this.mJSONArray.put(i, j);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(int i, double d) throws Exception {
        this.mJSONArray.put(i, d);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(int i, String str) throws Exception {
        this.mJSONArray.put(i, str);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(int i, MessageDataObject messageDataObject) throws Exception {
        this.mJSONArray.put(i, ((JSONMessageDataObject) messageDataObject).mJSONObject);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public MessageDataArray put(int i, MessageDataArray messageDataArray) throws Exception {
        this.mJSONArray.put(i, ((JSONMessageDataArray) messageDataArray).mJSONArray);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public boolean remove(int i) {
        return false;
    }

    @Override // com.adobe.air.wand.message.MessageDataArray
    public int length() {
        return this.mJSONArray.length();
    }
}
