package com.codapayments.sdk.model;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.Map;

/* loaded from: classes.dex */
public final class d implements Serializable {
    private static final long a = 201203024;
    private short b;
    private String c;
    private String d;
    private long e;
    private BigInteger f;
    private String g;
    private Map h;
    private String i;
    private boolean j;
    private boolean k;
    private String l;
    private String m;
    private String n;

    public d() {
        this.b = (short) 0;
        this.c = null;
        this.d = null;
        this.e = 0L;
        this.f = null;
        this.g = null;
        this.i = null;
        this.j = false;
        this.k = false;
        this.l = null;
        this.n = null;
    }

    public d(long j, short s, String str, String str2, Map map) {
        this.b = (short) 0;
        this.c = null;
        this.d = null;
        this.e = 0L;
        this.f = null;
        this.g = null;
        this.i = null;
        this.j = false;
        this.k = false;
        this.l = null;
        this.n = null;
        this.b = (short) 999;
        this.c = str;
        this.d = str2;
        this.e = 0L;
        this.h = null;
    }

    private BigInteger j() {
        return this.f;
    }

    private Map k() {
        return this.h;
    }

    private boolean l() {
        return this.k;
    }

    private String m() {
        return this.n;
    }

    public final long a() {
        return this.e;
    }

    public final void a(long j) {
        this.e = j;
    }

    public final void a(String str) {
        this.c = str;
    }

    public final void a(BigInteger bigInteger) {
        this.f = bigInteger;
    }

    public final void a(Map map) {
        this.h = map;
    }

    public final void a(short s) {
        this.b = s;
    }

    public final void a(boolean z) {
        this.j = z;
    }

    public final short b() {
        return this.b;
    }

    public final void b(String str) {
        this.g = str;
    }

    public final void b(boolean z) {
        this.k = z;
    }

    public final String c() {
        return this.c;
    }

    public final void c(String str) {
        this.i = str;
    }

    public final String d() {
        return this.g;
    }

    public final void d(String str) {
        this.l = str;
    }

    public final String e() {
        return this.i;
    }

    public final void e(String str) {
        this.m = str;
    }

    public final void f(String str) {
        this.d = str;
    }

    public final boolean f() {
        return this.j;
    }

    public final String g() {
        return this.l;
    }

    public final void g(String str) {
        this.n = str;
    }

    public final String h() {
        return this.m;
    }

    public final String i() {
        return this.d;
    }

    public final String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("txnId : ").append(this.e).append("\n");
        stringBuffer.append("msisdn : ").append(this.f).append("\n");
        stringBuffer.append("resultCode : ").append((int) this.b).append("\n");
        stringBuffer.append("encryptKey : ").append(this.i).append("\n");
        stringBuffer.append("crowlSms : ").append(this.j).append("\n");
        stringBuffer.append("sendSms : ").append(this.k).append("\n");
        stringBuffer.append("shortCode : ").append(this.m).append("\n");
        stringBuffer.append("merchantName : ").append(this.n).append("\n");
        stringBuffer.append("resultHeader : ").append(this.d).append("\n");
        stringBuffer.append("resultDesc : ").append(this.c).append("\n");
        stringBuffer.append("webViewURL : ").append(this.g).append("\n");
        stringBuffer.append("smsMessage : ").append(this.l).append("\n");
        return stringBuffer.toString();
    }
}
