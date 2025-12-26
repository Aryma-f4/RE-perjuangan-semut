package com.codapayments.sdk.model;

import java.io.Serializable;

/* loaded from: classes.dex */
public class ItemInfo implements Serializable {
    private static final long a = 201203021;
    private String b;
    private String c;
    private double d;
    private short e;

    public ItemInfo(String str, String str2, double d, short s) {
        this.d = 0.0d;
        this.e = (short) 0;
        this.b = str;
        this.c = str2;
        this.d = d;
        this.e = s;
    }

    public String getCode() {
        return this.b;
    }

    public String getName() {
        return this.c;
    }

    public double getPrice() {
        return this.d;
    }

    public short getType() {
        return this.e;
    }

    public void setCode(String str) {
        this.b = str;
    }

    public void setName(String str) {
        this.c = str;
    }

    public void setPrice(double d) {
        this.d = d;
    }

    public void setType(short s) {
        this.e = s;
    }

    public String toString() {
        return new StringBuffer("code : ").append(this.b).append("\tname : ").append(this.c).append("\tprice : ").append(this.d).append("\ttype : ").append((int) this.e).append("\n").toString();
    }
}
