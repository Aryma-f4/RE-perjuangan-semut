package com.google.android.gms.plus;

import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.r;

/* loaded from: classes.dex */
public class a implements SafeParcelable {
    public static final b CREATOR = new b();
    private final int ab;
    private final String g;
    private final String[] hY;
    private final String hZ;
    private final String ia;
    private final String ib;
    private final String[] ik;
    private final String[] il;

    public a(int i, String str, String[] strArr, String[] strArr2, String[] strArr3, String str2, String str3, String str4) {
        this.ab = i;
        this.g = str;
        this.ik = strArr;
        this.il = strArr2;
        this.hY = strArr3;
        this.hZ = str2;
        this.ia = str3;
        this.ib = str4;
    }

    public a(String str, String[] strArr, String[] strArr2, String[] strArr3, String str2, String str3, String str4) {
        this.ab = 1;
        this.g = str;
        this.ik = strArr;
        this.il = strArr2;
        this.hY = strArr3;
        this.hZ = str2;
        this.ia = str3;
        this.ib = str4;
    }

    public String[] bA() {
        return this.hY;
    }

    public String bB() {
        return this.hZ;
    }

    public String bC() {
        return this.ia;
    }

    public String bD() {
        return this.ib;
    }

    public String[] by() {
        return this.ik;
    }

    public String[] bz() {
        return this.il;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof a)) {
            return false;
        }
        a aVar = (a) obj;
        return this.ab == aVar.ab && r.a(this.g, aVar.g) && r.a(this.ik, aVar.ik) && r.a(this.il, aVar.il) && r.a(this.hY, aVar.hY) && r.a(this.hZ, aVar.hZ) && r.a(this.ia, aVar.ia) && r.a(this.ib, aVar.ib);
    }

    public String getAccountName() {
        return this.g;
    }

    public int hashCode() {
        return r.hashCode(Integer.valueOf(this.ab), this.g, this.ik, this.il, this.hY, this.hZ, this.ia, this.ib);
    }

    public int i() {
        return this.ab;
    }

    public String toString() {
        return r.c(this).a("versionCode", Integer.valueOf(this.ab)).a("accountName", this.g).a("requestedScopes", this.ik).a("visibleActivities", this.il).a("requiredFeatures", this.hY).a("packageNameForAuth", this.hZ).a("callingPackageName", this.ia).a("applicationName", this.ib).toString();
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        b.a(this, out, flags);
    }
}
