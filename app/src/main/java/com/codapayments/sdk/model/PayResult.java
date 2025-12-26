package com.codapayments.sdk.model;

import java.util.ArrayList;
import java.util.Iterator;

/* loaded from: classes.dex */
public class PayResult {
    private short a;
    private String b;
    private String c;
    private long d;
    private String e;
    private double f;
    private boolean g;
    private String h;
    private ArrayList i;

    public PayResult(short s, String str, String str2, String str3, long j, String str4, double d, boolean z, ArrayList arrayList) {
        this.a = (short) 0;
        this.b = null;
        this.c = null;
        this.d = 0L;
        this.e = null;
        this.f = 0.0d;
        this.g = false;
        this.h = null;
        this.i = null;
        this.a = s;
        this.b = str2;
        this.c = str3;
        this.d = j;
        this.e = str4;
        this.f = d;
        this.g = z;
        this.h = str;
        this.i = arrayList;
    }

    public ArrayList getItems() {
        return this.i;
    }

    public String getMsisdn() {
        return this.e;
    }

    public String getOrderId() {
        return this.h;
    }

    public short getResultCode() {
        return this.a;
    }

    public String getResultDesc() {
        return this.b;
    }

    public String getResultHeader() {
        return this.c;
    }

    public double getTotalPrice() {
        return this.f;
    }

    public long getTxnId() {
        return this.d;
    }

    public boolean isInProgress() {
        return this.g;
    }

    public void setInProgress(boolean z) {
        this.g = z;
    }

    public void setItems(ArrayList arrayList) {
        this.i = arrayList;
    }

    public void setMsisdn(String str) {
        this.e = str;
    }

    public void setOrderId(String str) {
        this.h = str;
    }

    public void setResultCode(short s) {
        this.a = s;
    }

    public void setResultDesc(String str) {
        this.b = str;
    }

    public void setResultHeader(String str) {
        this.c = str;
    }

    public void setTotalPrice(double d) {
        this.f = d;
    }

    public void setTxnId(long j) {
        this.d = j;
    }

    public String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("txnId : ").append(this.d).append("\n");
        stringBuffer.append("msisdn : ").append(this.e).append("\n");
        stringBuffer.append("resultCode : ").append((int) this.a).append("\n");
        stringBuffer.append("resultDesc : ").append(this.b).append("\n");
        stringBuffer.append("totalPrice : ").append(this.f).append("\n");
        stringBuffer.append("orderId : ").append(this.h).append("\n");
        stringBuffer.append("inProgress : ").append(this.g).append("\n");
        if (this.i != null && this.i.size() > 0) {
            Iterator it = this.i.iterator();
            while (it.hasNext()) {
                stringBuffer.append(((ItemInfo) it.next()).toString());
            }
        }
        return stringBuffer.toString();
    }
}
