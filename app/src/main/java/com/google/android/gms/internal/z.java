package com.google.android.gms.internal;

import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.ae;

/* loaded from: classes.dex */
public class z implements SafeParcelable {
    public static final aa CREATOR = new aa();
    private final int ab;
    private final ab cn;

    z(int i, ab abVar) {
        this.ab = i;
        this.cn = abVar;
    }

    private z(ab abVar) {
        this.ab = 1;
        this.cn = abVar;
    }

    public static z a(ae.b<?, ?> bVar) {
        if (bVar instanceof ab) {
            return new z((ab) bVar);
        }
        throw new IllegalArgumentException("Unsupported safe parcelable field converter class.");
    }

    ab O() {
        return this.cn;
    }

    public ae.b<?, ?> P() {
        if (this.cn != null) {
            return this.cn;
        }
        throw new IllegalStateException("There was no converter wrapped in this ConverterWrapper.");
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        aa aaVar = CREATOR;
        return 0;
    }

    int i() {
        return this.ab;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        aa aaVar = CREATOR;
        aa.a(this, out, flags);
    }
}
