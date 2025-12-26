package com.codapayments.sdk.model;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

/* loaded from: classes.dex */
public final class c implements Serializable {
    private static final long a = 201203024;
    private String b = null;
    private short c = 0;
    private short d = 0;
    private BigInteger e = null;
    private short f = 2;
    private ArrayList g = null;
    private HashMap h = null;
    private a i = null;

    private void a(BigInteger bigInteger) {
        this.e = bigInteger;
    }

    private void a(HashMap map) {
        this.h = map;
    }

    public final short a() {
        return this.c;
    }

    public final void a(a aVar) {
        this.i = aVar;
    }

    public final void a(String str) {
        this.b = str;
    }

    public final void a(ArrayList arrayList) {
        this.g = arrayList;
    }

    public final void a(short s) {
        this.c = s;
    }

    public final short b() {
        return this.d;
    }

    public final void b(short s) {
        this.d = s;
    }

    public final BigInteger c() {
        return this.e;
    }

    public final void c(short s) {
        this.f = (short) 2;
    }

    public final String d() {
        return this.b;
    }

    public final short e() {
        return this.f;
    }

    public final ArrayList f() {
        return this.g;
    }

    public final HashMap g() {
        return this.h;
    }

    public final a h() {
        return this.i;
    }

    public final String toString() {
        StringBuffer stringBufferAppend = new StringBuffer("orderId : ").append(this.b).append("\tcountry : ").append((int) this.c).append("\tcurrency : ").append((int) this.d).append("\tpayType : ").append((int) this.f).append("\n");
        if (this.g != null && this.g.size() > 0) {
            Iterator it = this.g.iterator();
            while (it.hasNext()) {
                stringBufferAppend.append(((ItemInfo) it.next()).toString());
            }
        }
        return stringBufferAppend.toString();
    }
}
