package com.codapayments.sdk.model;

import java.io.Serializable;
import java.util.ArrayList;

/* loaded from: classes.dex */
public final class b implements Serializable {
    private static final long a = 201203024;
    private short b;
    private String c;
    private String d;
    private long e;
    private String f;
    private double g;
    private boolean h;
    private String i;
    private ArrayList j;
    private boolean k;
    private String l;
    private boolean m;
    private String n;

    public b() {
        this.b = (short) 0;
        this.c = null;
        this.d = null;
        this.e = 0L;
        this.f = null;
        this.g = 0.0d;
        this.h = false;
        this.i = null;
        this.j = null;
        this.k = false;
        this.l = null;
        this.m = false;
        this.n = null;
    }

    public b(long j, String str, double d, String str2, short s, String str3, String str4, ArrayList arrayList) {
        this.b = (short) 0;
        this.c = null;
        this.d = null;
        this.e = 0L;
        this.f = null;
        this.g = 0.0d;
        this.h = false;
        this.i = null;
        this.j = null;
        this.k = false;
        this.l = null;
        this.m = false;
        this.n = null;
        this.b = (short) 999;
        this.c = str3;
        this.d = str4;
        this.e = j;
        this.f = null;
        this.g = 0.0d;
        this.i = null;
        this.j = null;
    }

    private ArrayList f() {
        return this.j;
    }

    private String g() {
        return this.i;
    }

    private long h() {
        return this.e;
    }

    private String i() {
        return this.f;
    }

    private short j() {
        return this.b;
    }

    private String k() {
        return this.c;
    }

    private double l() {
        return this.g;
    }

    private String m() {
        return this.d;
    }

    private boolean n() {
        return this.h;
    }

    public final PayResult a() {
        return new PayResult(this.b, this.i, this.c, this.d, this.e, this.f, this.g, this.h, this.j);
    }

    public final void a(double d) {
        this.g = d;
    }

    public final void a(long j) {
        this.e = j;
    }

    public final void a(String str) {
        this.i = str;
    }

    public final void a(ArrayList arrayList) {
        this.j = arrayList;
    }

    public final void a(short s) {
        this.b = s;
    }

    public final void a(boolean z) {
        this.h = z;
    }

    public final void b(String str) {
        this.f = str;
    }

    public final void b(boolean z) {
        this.k = z;
    }

    public final boolean b() {
        return this.k;
    }

    public final void c(String str) {
        this.c = str;
    }

    public final void c(boolean z) {
        this.m = z;
    }

    public final boolean c() {
        return this.m;
    }

    public final String d() {
        return this.l;
    }

    public final void d(String str) {
        this.d = str;
    }

    public final String e() {
        return this.n;
    }

    public final void e(String str) {
        this.l = str;
    }

    public final void f(String str) {
        this.n = str;
    }
}
