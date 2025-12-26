package com.google.android.gms.internal;

import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;

/* loaded from: classes.dex */
public final class x implements SafeParcelable {
    public static final y CREATOR = new y();
    private final int aJ;
    private final int ab;
    private final int ci;
    private final String cj;
    private final String ck;
    private final String cl;
    private final String cm;

    public x(int i, int i2, int i3, String str, String str2, String str3, String str4) {
        this.ab = i;
        this.aJ = i2;
        this.ci = i3;
        this.cj = str;
        this.ck = str2;
        this.cl = str3;
        this.cm = str4;
    }

    public int I() {
        return this.ci;
    }

    public String J() {
        return this.cj;
    }

    public String K() {
        return this.ck;
    }

    public String L() {
        return this.cm;
    }

    public boolean M() {
        return this.aJ == 1 && this.ci == -1;
    }

    public boolean N() {
        return this.aJ == 2;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof x)) {
            return false;
        }
        x xVar = (x) obj;
        return this.ab == xVar.ab && this.aJ == xVar.aJ && this.ci == xVar.ci && r.a(this.cj, xVar.cj) && r.a(this.ck, xVar.ck);
    }

    public String getDisplayName() {
        return this.cl;
    }

    public int getType() {
        return this.aJ;
    }

    public int hashCode() {
        return r.hashCode(Integer.valueOf(this.ab), Integer.valueOf(this.aJ), Integer.valueOf(this.ci), this.cj, this.ck);
    }

    public int i() {
        return this.ab;
    }

    public String toString() {
        return N() ? String.format("Person [%s] %s", K(), getDisplayName()) : M() ? String.format("Circle [%s] %s", J(), getDisplayName()) : String.format("Group [%s] %s", J(), getDisplayName());
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        y.a(this, out, flags);
    }
}
