package com.google.android.gms.internal;

import android.os.Bundle;
import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import java.util.ArrayList;

/* loaded from: classes.dex */
public class cq implements SafeParcelable {
    public static final cr CREATOR = new cr();
    private final int ab;
    private final ArrayList<x> kA;
    private final Bundle kB;
    private final boolean kC;
    private final int ky;
    private final ArrayList<x> kz;

    public cq(int i, ArrayList<x> arrayList, ArrayList<x> arrayList2, Bundle bundle, boolean z, int i2) {
        this.ab = i;
        this.kz = arrayList;
        this.kA = arrayList2;
        this.kB = bundle;
        this.kC = z;
        this.ky = i2;
    }

    public int cJ() {
        return this.ky;
    }

    public ArrayList<x> cK() {
        return this.kz;
    }

    public ArrayList<x> cL() {
        return this.kA;
    }

    public Bundle cM() {
        return this.kB;
    }

    public boolean cN() {
        return this.kC;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof cq)) {
            return false;
        }
        cq cqVar = (cq) obj;
        return this.ab == cqVar.ab && r.a(this.kz, cqVar.kz) && r.a(this.kA, cqVar.kA) && r.a(this.kB, cqVar.kB) && r.a(Integer.valueOf(this.ky), Integer.valueOf(cqVar.ky));
    }

    public int hashCode() {
        return r.hashCode(Integer.valueOf(this.ab), this.kz, this.kA, this.kB, Integer.valueOf(this.ky));
    }

    public int i() {
        return this.ab;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        cr.a(this, out, flags);
    }
}
