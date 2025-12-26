package com.google.android.gms.internal;

import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import java.util.ArrayList;

/* loaded from: classes.dex */
public class bv implements SafeParcelable {
    public static final bw CREATOR = new bw();
    private final int ab;
    private final String di;
    private final ArrayList<x> iA;
    private final boolean iB;
    private final ArrayList<x> iz;

    public bv(int i, String str, ArrayList<x> arrayList, ArrayList<x> arrayList2, boolean z) {
        this.ab = i;
        this.di = str;
        this.iz = arrayList;
        this.iA = arrayList2;
        this.iB = z;
    }

    public ArrayList<x> bE() {
        return this.iz;
    }

    public ArrayList<x> bF() {
        return this.iA;
    }

    public boolean bG() {
        return this.iB;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public String getDescription() {
        return this.di;
    }

    public int i() {
        return this.ab;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        bw.a(this, out, flags);
    }
}
