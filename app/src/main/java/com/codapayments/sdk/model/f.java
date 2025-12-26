package com.codapayments.sdk.model;

import java.io.Serializable;

/* loaded from: classes.dex */
public final class f implements Serializable {
    private static final long a = 201203024;
    private short b;
    private String c;
    private String d;
    private long e;
    private String f;
    private String g;

    public f() {
        this.b = (short) 0;
        this.c = null;
        this.d = null;
        this.e = 0L;
        this.f = null;
        this.g = null;
    }

    public f(long j, short s, String str, String str2, String str3, String str4) {
        this.b = (short) 0;
        this.c = null;
        this.d = null;
        this.e = 0L;
        this.f = null;
        this.g = null;
        this.b = (short) 999;
        this.c = str;
        this.d = str2;
        this.e = j;
        this.f = null;
        this.g = null;
    }

    private String d() {
        return this.f;
    }

    private String e() {
        return this.c;
    }

    private String f() {
        return this.d;
    }

    public final long a() {
        return this.e;
    }

    public final void a(long j) {
        this.e = j;
    }

    public final void a(String str) {
        this.f = str;
    }

    public final void a(short s) {
        this.b = s;
    }

    public final short b() {
        return this.b;
    }

    public final void b(String str) {
        this.c = str;
    }

    public final String c() {
        return this.g;
    }

    public final void c(String str) {
        this.g = str;
    }

    public final void d(String str) {
        this.d = str;
    }
}
