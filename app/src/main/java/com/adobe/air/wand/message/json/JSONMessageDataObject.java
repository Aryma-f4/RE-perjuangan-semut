package com.adobe.air.wand.message.json;

import com.adobe.air.wand.message.MessageDataArray;
import com.adobe.air.wand.message.MessageDataObject;
import org.json.JSONArray;
import org.json.JSONObject;

/* loaded from: classes.dex */
public class JSONMessageDataObject implements MessageDataObject {
    final JSONObject mJSONObject;

    public JSONMessageDataObject() {
        this.mJSONObject = new JSONObject();
    }

    public JSONMessageDataObject(JSONObject jSONObject) {
        this.mJSONObject = jSONObject;
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public boolean getBoolean(String str) throws Exception {
        return this.mJSONObject.getBoolean(str);
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public int getInt(String str) throws Exception {
        return this.mJSONObject.getInt(str);
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public long getLong(String str) throws Exception {
        return this.mJSONObject.getLong(str);
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public double getDouble(String str) throws Exception {
        return this.mJSONObject.getDouble(str);
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public String getString(String str) throws Exception {
        return this.mJSONObject.getString(str);
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public MessageDataObject getObject(String str) throws Exception {
        return new JSONMessageDataObject(this.mJSONObject.getJSONObject(str));
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public MessageDataArray getArray(String str) throws Exception {
        return new JSONMessageDataArray(this.mJSONObject.getJSONArray(str));
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public MessageDataObject put(String str, boolean z) throws Exception {
        this.mJSONObject.put(str, z);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public MessageDataObject put(String str, int i) throws Exception {
        this.mJSONObject.put(str, i);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public MessageDataObject put(String str, long j) throws Exception {
        this.mJSONObject.put(str, j);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public MessageDataObject put(String str, double d) throws Exception {
        this.mJSONObject.put(str, d);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public MessageDataObject put(String str, String str2) throws Exception {
        this.mJSONObject.put(str, str2);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public MessageDataObject put(String str, MessageDataObject messageDataObject) throws Exception {
        this.mJSONObject.put(str, ((JSONMessageDataObject) messageDataObject).mJSONObject);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public MessageDataObject put(String str, MessageDataArray messageDataArray) throws Exception {
        this.mJSONObject.put(str, ((JSONMessageDataArray) messageDataArray).mJSONArray);
        return this;
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public boolean has(String str) {
        return this.mJSONObject.has(str);
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public String[] getNames() {
        JSONArray jSONArrayNames = this.mJSONObject.names();
        if (jSONArrayNames == null) {
            return null;
        }
        String[] strArr = new String[this.mJSONObject.length()];
        for (int i = 0; i < strArr.length; i++) {
            try {
                strArr[i] = jSONArrayNames.getString(i);
            } catch (Exception e) {
                strArr[i] = "";
            }
        }
        return strArr;
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public boolean remove(String str) {
        return this.mJSONObject.remove(str) != null;
    }

    @Override // com.adobe.air.wand.message.MessageDataObject
    public int length() {
        return this.mJSONObject.length();
    }
}
