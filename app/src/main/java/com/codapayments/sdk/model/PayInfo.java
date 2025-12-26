package com.codapayments.sdk.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

/* loaded from: classes.dex */
public class PayInfo {
    private String a;
    private String b;
    private short c;
    private short d;
    private String e;
    private ArrayList f;
    private HashMap g;

    public PayInfo(String str, String str2, short s, short s2, String str3, ArrayList arrayList) {
        this.a = null;
        this.b = null;
        this.c = (short) 0;
        this.d = (short) 0;
        this.e = null;
        this.f = null;
        this.g = null;
        this.a = str;
        this.b = str2;
        this.c = s;
        this.d = s2;
        this.e = str3;
        this.f = arrayList;
    }

    public PayInfo(String str, String str2, short s, short s2, String str3, ArrayList arrayList, HashMap map) {
        this.a = null;
        this.b = null;
        this.c = (short) 0;
        this.d = (short) 0;
        this.e = null;
        this.f = null;
        this.g = null;
        this.a = str;
        this.b = str2;
        this.c = s;
        this.d = s2;
        this.e = str3;
        this.f = arrayList;
        this.g = map;
    }

    public String getApiKey() {
        return this.a;
    }

    public short getCountry() {
        return this.c;
    }

    public short getCurrency() {
        return this.d;
    }

    public String getEnvironment() {
        return this.e;
    }

    public ArrayList getItems() {
        return this.f;
    }

    public String getOrderId() {
        return this.b;
    }

    public HashMap getProfile() {
        return this.g;
    }

    public void setApiKey(String str) {
        this.a = str;
    }

    public void setCountry(short s) {
        this.c = s;
    }

    public void setCurrency(short s) {
        this.d = s;
    }

    public void setEnvironment(String str) {
        this.e = str;
    }

    public void setItems(ArrayList arrayList) {
        this.f = arrayList;
    }

    public void setOrderId(String str) {
        this.b = str;
    }

    public void setProfile(HashMap map) {
        this.g = map;
    }

    public String toString() {
        StringBuffer stringBufferAppend = new StringBuffer("orderId : ").append(this.b).append("\tapiKey : ").append(this.a).append("\tcountry : ").append((int) this.c).append("\tcurrency : ").append((int) this.d).append("\tenvironment : ").append(this.e).append("\n");
        if (this.f != null && this.f.size() > 0) {
            Iterator it = this.f.iterator();
            while (it.hasNext()) {
                stringBufferAppend.append(((ItemInfo) it.next()).toString());
            }
        }
        return stringBufferAppend.toString();
    }
}
