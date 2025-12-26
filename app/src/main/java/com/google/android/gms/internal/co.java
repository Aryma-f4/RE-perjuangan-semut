package com.google.android.gms.internal;

import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import java.util.List;

/* loaded from: classes.dex */
public class co implements SafeParcelable {
    public static final cp CREATOR = new cp();
    private final int ab;
    private final String jh;
    private final List<x> kq;
    private final List<Uri> kr;
    private final Uri ks;
    private final String kt;
    private final String ku;
    private final String kv;
    private final Bundle kw;
    private final Bundle kx;
    private final int ky;

    public co(int i, String str, List<x> list, List<Uri> list2, Uri uri, String str2, String str3, String str4, Bundle bundle, Bundle bundle2, int i2) {
        this.ab = i;
        this.jh = str;
        this.kq = list;
        this.kr = list2;
        this.ks = uri;
        this.kt = str2;
        this.ku = str3;
        this.kv = str4;
        this.kw = bundle;
        this.kx = bundle2;
        this.ky = i2;
    }

    public List<x> cB() {
        return this.kq;
    }

    public List<Uri> cC() {
        return this.kr;
    }

    public Uri cD() {
        return this.ks;
    }

    public String cE() {
        return this.kt;
    }

    public String cF() {
        return this.ku;
    }

    public String cG() {
        return this.kv;
    }

    public Bundle cH() {
        return this.kw;
    }

    public Bundle cI() {
        return this.kx;
    }

    public int cJ() {
        return this.ky;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof co)) {
            return false;
        }
        co coVar = (co) obj;
        return this.ab == coVar.ab && r.a(this.kq, coVar.kq) && r.a(this.kr, coVar.kr) && r.a(this.ks, coVar.ks) && r.a(this.kt, coVar.kt) && r.a(this.ku, coVar.ku) && r.a(this.kv, coVar.kv);
    }

    public String getId() {
        return this.jh;
    }

    public int hashCode() {
        return r.hashCode(Integer.valueOf(this.ab), this.kq, this.kr, this.ks, this.kt, this.ku, this.kv);
    }

    public int i() {
        return this.ab;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        cp.a(this, out, flags);
    }
}
